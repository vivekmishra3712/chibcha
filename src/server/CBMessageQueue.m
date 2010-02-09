//
//  CBMessageQueue.m
//  Chibcha
//
//  Created by PH on 9.2.10.
//  Copyright 2010 Codesign. All rights reserved.
//

#import "CBMessageQueue.h"
#import "CBMessageCenter.h"

#define FETCHER_SLEEP_INTERVAL	1

@implementation CBMessageQueue

@synthesize valid;

- (id)initWithMessageCenter:(CBMessageCenter*)_messageCenter peer:(CBPeer*)_peer {
	if ((self = [super init])) {
		messageCenter = [_messageCenter retain];
		peer = [_peer retain];
		valid = YES;
		[NSThread detachNewThreadSelector: @selector(fetchMessages) toTarget: self withObject: nil];
	}
	return self;
}

- (void)fetchMessages {
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	while (self.valid == YES) {
		NSAutoreleasePool* pool2 = [[NSAutoreleasePool alloc] init];
		@try {
			NSArray* messages = [messageCenter fetchMessagesForPeer: peer];
			if (messages != nil && self.valid == YES) {
				for (CBMessage* message in messages) {
					if (self.valid == YES && delegate != nil && [delegate respondsToSelector: @selector(messageQueue:didReceiveMessage:)])
						[delegate performSelector: @selector(messageQueue:didReceiveMessage:)
									   withObject: self
									   withObject: message];
				}
			}
		} @catch (NSException* exception) {
			NSLog(@"Error fetching messages: %@", exception);
		}
		[NSThread sleepForTimeInterval: FETCHER_SLEEP_INTERVAL];
		[pool2 drain];
	}
	NSLog(@"Existing MQ listener");
	[pool drain];
}

- (void)setDelegate:(NSObject<CBMessageQueueDelegate>*)_delegate {
	delegate = _delegate;
}

- (BOOL)postMessage:(CBMessage*)message toPeer:(CBPeer*)consumer {
	return [messageCenter postMessage: message toPeer: consumer];
}

- (void)dealloc {
	self.valid = NO;
	[messageCenter release];
	[peer release];
	[super dealloc];
}

@end
