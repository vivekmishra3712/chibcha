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
@synthesize messageCenter;

- (id)initWithMessageCenterName:(NSString*)_messageCenterName host:(NSString*)_host peer:(CBPeer*)_peer {
	if ((self = [super init])) {
		messageCenterName = [_messageCenterName retain];
		host = [_host retain];
		peer = [_peer retain];
		valid = YES;
		[NSThread detachNewThreadSelector: @selector(fetchMessages) toTarget: self withObject: nil];
	}
	return self;
}

- (void)initializeMessageCenter {
	@try {
		NSSocketPortNameServer* nameServer = [NSSocketPortNameServer sharedInstance];
		self.messageCenter = (CBMessageCenter*) [NSConnection rootProxyForConnectionWithRegisteredName: messageCenterName
																							 host: host
																				  usingNameServer: nameServer];
		if (self.messageCenter != nil) {
			[[(NSDistantObject*) self.messageCenter connectionForProxy] setRequestTimeout: REQUEST_TIMEOUT];
			[[(NSDistantObject*) self.messageCenter connectionForProxy] setReplyTimeout: RESPONSE_TIMEOUT];
			[[NSNotificationCenter defaultCenter] addObserver: self
																				selector: @selector(connectionDidDie:)
																					name: NSConnectionDidDieNotification
																				  object: self.messageCenter];
		}
	} @catch (NSException* exception) {
		//NSLog(@"Error obtaining messaging provider: %@", exception);
	}
}

- (void)connectionDidDie:(NSNotification*)notification {
	NSLog(@"Connection died");
}

- (void)fetchMessages {
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	while (self.valid == YES) {
		NSAutoreleasePool* pool2 = [[NSAutoreleasePool alloc] init];
		@try {
			if (delegate != nil) {
				if (self.messageCenter == nil) [self initializeMessageCenter];
				if (self.messageCenter != nil) {
					NSArray* messages = [self.messageCenter fetchMessagesForPeer: peer];
					if (messages != nil) {
						for (CBMessage* message in messages) {
							if ([delegate respondsToSelector: @selector(messageQueue:didReceiveMessage:)]) {
								[NSThread detachNewThreadSelector: @selector(processIncomingMessage:)
														 toTarget: self
													   withObject: message];
							} else {
								NSLog(@"Message queue delegate doesn't respond to the required method");
							}
						}
					}
				}
			}
		} @catch (NSException* exception) {
			//[[(NSDistantObject*) self.messageCenter connectionForProxy] invalidate];
			self.messageCenter = nil;
			//NSLog(@"Error fetching messages: %@", exception);
		}
		[NSThread sleepForTimeInterval: FETCHER_SLEEP_INTERVAL];
		[pool2 drain];
	}
	NSLog(@"Exiting MQ listener");
	[pool drain];
}

- (void)processIncomingMessage:(CBMessage*)message {
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	@try {
		[delegate performSelector: @selector(messageQueue:didReceiveMessage:)
					   withObject: self
					   withObject: message];
		[self.messageCenter discardMessage: message.UID];
	} @catch (NSException* exception) {
		NSLog(@"Error processing incoming message: %@", exception);
	} @finally {
		[pool drain];
	}
}

- (BOOL)postMessage:(CBMessage*)message toPeer:(CBPeer*)consumer {
	if (self.messageCenter == nil) [self initializeMessageCenter];
	if (self.messageCenter != nil) {
		@try {
			BOOL retVal = [self.messageCenter postMessage: message toPeer: consumer];
			return retVal;
		} @catch (NSException* exception) {
			//[[(NSDistantObject*) self.messageCenter connectionForProxy] invalidate];
			self.messageCenter = nil;
			//NSLog(@"Error posting message: %@ %d", exception, [[(NSDistantObject*) self.messageCenter connectionForProxy] isValid]);
		}
	}
	return NO;
}

- (void)setDelegate:(NSObject<CBMessageQueueDelegate>*)_delegate {
	delegate = _delegate;
}

- (void)close {
	self.valid = NO;
	[self.messageCenter close];
}

- (void)dealloc {
	[self close];
	[messageCenter release];
	[peer release];
	[messageCenterName release];
	[host release];
	[super dealloc];
}

@end
