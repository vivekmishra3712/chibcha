//
//  CBMessageDataObject.m
//  Chibcha
//
//  Created by PH on 9.2.10.
//  Copyright 2010 Codesign. All rights reserved.
//

#import "CBMessageDataObject.h"

@implementation CBMessageDataObject

@synthesize consumerUID;
@synthesize message;

- (id)initWithConsumer:(CBPeer*)_consumer message:(CBMessage*)_message {
	if ((self = [super init])) {
		consumerUID = [_consumer.UID retain];
		message = [_message retain];
	}
	return self;
}

- (void)dealloc {
	[consumerUID release];
	[message release];
	[super dealloc];
}

@end
