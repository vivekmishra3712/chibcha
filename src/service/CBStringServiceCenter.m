//
//  CBStringServiceCenter.m
//  Chibcha
//
//  Created by PH on 7.2.10.
//  Copyright 2010 Codesign. All rights reserved.
//

#import "CBStringServiceCenter.h"
#import "CBStringService.h"

@implementation CBStringServiceCenter

- (id)initWithName:(NSString*)_name {
	if ((self = [super init])) {
		name = [_name retain];
		[self registerService: [CBStringService class]];
	}
	return self;
}

@end
