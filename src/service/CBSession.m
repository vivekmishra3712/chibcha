//
//  CBSession.m
//  Chibcha
//
//  Created by PH on 9.2.10.
//  Copyright 2010 Codesign. All rights reserved.
//

#import "CBSession.h"

@implementation CBSession

@synthesize params;

- (id)init {
	if ((self = [super init])) {
		params = [[NSMutableDictionary alloc] init];
	}
	return self;
}

- (id)parameterForKey:(id)key {
	return [params objectForKey: key];
}

- (void)setParameter:(id)param forKey:(id)key {
	[params setObject: param forKey: key];
}

- (void)dealloc {
	[params release];
	[super dealloc];
}

@end
