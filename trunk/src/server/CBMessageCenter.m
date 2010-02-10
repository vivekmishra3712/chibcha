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
	@try {
		NSSocketPort* port = [[[NSSocketPort alloc] init] autorelease];
		connection = [NSConnection connectionWithReceivePort: port sendPort: port];
		[connection setRootObject: self];
		NSSocketPortNameServer* nameServer = [NSSocketPortNameServer sharedInstance];
		[connection registerName: @"Entropy:Messaging" withNameServer: nameServer];
		//connection = [NSConnection serviceConnectionWithName: @"Entropy:Messaging" rootObject: self];
		if (connection != nil) {
			[connection setRequestTimeout: REQUEST_TIMEOUT];
			[connection setReplyTimeout: RESPONSE_TIMEOUT];
			[connection enableMultipleThreads];
			for (int i = 0; i < NUMBER_OF_MESSAGE_THREADS; i++) [connection runInNewThread];
			return YES;
		}
	} @catch (NSException* exception) {
		NSLog(@"Error starting message server: %@", exception);
	}
	return NO;
}

- (BOOL)postMessage:(CBMessage*)message toPeer:(CBPeer*)consumer {
	@try {
		message.consumer = consumer;
		message.sent = [NSDate date];
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
			messageDataObject.message.relayed = [NSDate date];
			messageDataObject.message.UID = [objectStore IDOfObject: messageDataObject];
			[messages addObject: messageDataObject.message];
		}
		return messages;
	} @catch (NSException* exception) {
		NSLog(@"Error fetching messages: %@", exception);
	}
	return nil;
}

- (void)discardMessage:(NSString*)UID {
	@try {
		CBMessageDataObject* messageDataObject = [objectStore objectWithObjectID: UID];
		if (messageDataObject != nil) [objectStore removeObject: messageDataObject];
	} @catch (NSException* exception) {
		NSLog(@"Error discarding message: %@", exception);
	}
}

- (void)close {
	//[connection invalidate];
	[objectStore autorelease];
	objectStore = nil;
	NSLog(@"Messaging server closed");
}

- (void)dealloc {
	[self close];
	[super dealloc];
}

@end
