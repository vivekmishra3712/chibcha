//
//  CBReturnValue.m
//  Chibcha
//
//  Created by PH on 9.2.10.
//  Copyright 2010 Codesign. All rights reserved.
//

#import "CBReturnValue.h"

@implementation CBReturnValue

@synthesize value;

- (void)dealloc {
	[value release];
	[super dealloc];
}

@end
