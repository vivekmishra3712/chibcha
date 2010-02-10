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
@synthesize created;
@synthesize sent;
@synthesize relayed;
@synthesize UID;

- (id)initWithProducer:(CBPeer*)_producer content:(NSObject<NSCoding>*)_content {
	if ((self = [super init])) {
		created = [[NSDate alloc] init];
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
		created = [[coder decodeObject] retain];
		sent = [[coder decodeObject] retain];
		relayed = [[coder decodeObject] retain];
		consumer = [[NSKeyedUnarchiver unarchiveObjectWithData: [coder decodeDataObject]] retain];
		producer = [[NSKeyedUnarchiver unarchiveObjectWithData: [coder decodeDataObject]] retain];
		content = [[NSKeyedUnarchiver unarchiveObjectWithData: [coder decodeDataObject]] retain];
		UID = [[coder decodeObject] retain];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder*)coder {
	[coder encodeObject: created];
	[coder encodeObject: sent];
	[coder encodeObject: relayed];
	[coder encodeDataObject: [NSKeyedArchiver archivedDataWithRootObject: consumer]];
	[coder encodeDataObject: [NSKeyedArchiver archivedDataWithRootObject: producer]];
	[coder encodeDataObject: [NSKeyedArchiver archivedDataWithRootObject: content]];
	[coder encodeObject: UID];
}

- (NSString*)description {
	return [NSString stringWithFormat: @"(Message) %@ -> %@ %@", producer, consumer, content];
}

- (void)dealloc {
	[created release];
	[sent release];
	[relayed release];
	[producer release];
	[consumer release];
	[content release];
	[UID release];
	[super dealloc];
}

@end
