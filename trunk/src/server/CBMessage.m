//
//  CBMessage.m
//  Chibcha
//
//  Created by PH on 9.2.10.
//  Copyright 2010 Codesign. All rights reserved.
//

#import "CBMessage.h"

@implementation CBMessage

@synthesize producer;
@synthesize consumer;
@synthesize content;

- (id)initWithProducer:(CBPeer*)_producer content:(NSObject<NSCoding>*)_content {
	if ((self = [super init])) {
		producer = [_producer retain];
		content = [_content retain];
	}
	return self;
}

- (id)replacementObjectForPortCoder:(NSPortCoder*)coder {
	NSAssert([coder isBycopy], @"Byref not supported");
	return self;
}

+ (CBMessage*)messageWithContent:(id)content producer:(CBPeer*)producer {
	return [[[self alloc] initWithProducer: producer content: content] autorelease];
}

- (id)initWithCoder:(NSCoder*)coder {
	if ((self = [super init])) {
		consumer = [[NSKeyedUnarchiver unarchiveObjectWithData: [coder decodeDataObject]] retain];
		producer = [[NSKeyedUnarchiver unarchiveObjectWithData: [coder decodeDataObject]] retain];
		content = [[coder decodeObject] retain];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder*)coder {
	[coder encodeDataObject: [NSKeyedArchiver archivedDataWithRootObject: consumer]];
	[coder encodeDataObject: [NSKeyedArchiver archivedDataWithRootObject: producer]];
	[coder encodeObject: content];
	
}

- (NSString*)description {
	return [NSString stringWithFormat: @"(Message) %@ -> %@ %@", producer, consumer, content];
}

- (void)dealloc {
	[producer release];
	[consumer release];
	[content release];
	[super dealloc];
}

@end
