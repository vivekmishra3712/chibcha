//
//  CBMessageCenter.m
//  Chibcha
//
//  Created by PH on 9.2.10.
//  Copyright 2010 Codesign. All rights reserved.
//

#import "CBMessageCenter.h"
#import "CBMessageDataObject.h"
#import "EXObjectStore.h"

#define NUMBER_OF_MESSAGE_THREADS	10

@implementation CBMessageCenter

- (id)initWithPath:(NSString*)path {
	if ((self = [super init])) {
		objectStore = [[EXObjectStore alloc] initWithPath: path];
	}
	return self;
}

- (BOOL)startServing {
	connection = [NSConnection serviceConnectionWithName: @"Entropy:Messaging" rootObject: self];
	if (connection != nil) {
		[connection enableMultipleThreads];
		for (int i = 0; i < NUMBER_OF_MESSAGE_THREADS; i++) [connection runInNewThread];
		return YES;
	} else return NO;
}

- (BOOL)postMessage:(CBMessage*)message toPeer:(CBPeer*)consumer {
	@try {
		message.consumer = consumer;
		//NSLog(@"Storing message: %@", message);
		CBMessageDataObject* messageDataObject = [[[CBMessageDataObject alloc] initWithConsumer: consumer
																						message: message] autorelease];
		return [objectStore storeObject: messageDataObject];
	} @catch (NSException* exception) {
		NSLog(@"Error posting message: %@", exception);
	}
	return NO;
}

- (NSArray*)fetchMessagesForPeer:(CBPeer*)consumer {
	@try {
		//NSLog(@"Fetching messages for: %@", consumer);
		EXPredicate* predicate = [objectStore predicateWithClass: [CBMessageDataObject class]];
		[predicate restrictField: @"consumerUID" equalsString: consumer.UID];
		NSArray* messageDataObjects = [objectStore objectsWithPredicate: predicate];
		NSMutableArray* messages = [NSMutableArray arrayWithCapacity: [messageDataObjects count]];
		for (CBMessageDataObject* messageDataObject in messageDataObjects) {
			[messages addObject: messageDataObject.message];
			[objectStore removeObject: messageDataObject];
		}
		return messages;
	} @catch (NSException* exception) {
		NSLog(@"Error fetching messages: %@", exception);
	}
	return nil;
}

- (void)close {
	[connection invalidate];
	[objectStore release];
	NSLog(@"Messaging center closed");
}

- (void)dealloc {
	[self close];
	[super dealloc];
}

@end
