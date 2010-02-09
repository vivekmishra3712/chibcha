//
//  CBPeer.m
//  Chibcha
//
//  Created by PH on 9.2.10.
//  Copyright 2010 Codesign. All rights reserved.
//

#import "CBPeer.h"

@implementation CBPeer

@synthesize UID;

- (id)initWithUID:(NSString*)_UID {
	if ((self = [super init])) {
		UID = [_UID retain];
	}
	return self;
}

- (id)replacementObjectForPortCoder:(NSPortCoder*)coder {
	NSAssert([coder isBycopy], @"Byref not supported");
	return self;
}

- (id)initWithCoder:(NSCoder*)coder {
	if ((self = [super init])) {
		UID = [[coder decodeObject] retain];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder*)coder {
	[coder encodeObject: UID];
}

- (NSString*)description {
	return [NSString stringWithFormat: @"(Peer) %@", UID];
}

- (void)dealloc {
	[UID release];
	[super dealloc];
}

@end
