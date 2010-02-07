//
//  CBService.m
//  Chibcha
//
//  Created by PH on 7.2.10.
//  Copyright 2010 Codesign. All rights reserved.
//

#import "CBService.h"

@implementation CBService

@synthesize name;

- (BOOL)startServing {
	id connection = [NSConnection serviceConnectionWithName: name rootObject: self];
	if (connection != nil) [connection run];
	return connection != nil;
}

- (NSData*)processRequestWithParamString:(NSString*)paramString {
	NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
	if (paramString != nil) {
		NSArray* comps = [paramString componentsSeparatedByString: @"&"];
		for (NSString* pair in comps) {
			NSArray* comps2 = [pair componentsSeparatedByString: @"="];
			NSString* key = [comps2 objectAtIndex: 0];
			NSString* value = [[comps2 objectAtIndex: 1] stringByReplacingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
			[parameters setObject: value forKey: key];
		}
	}
	//NSLog(@"Parameters: %@", parameters);
	return [self processRequestWithParameters: parameters];
}

- (NSData*)processRequestWithParameters:(NSDictionary*)parameters {
	[NSException raise: NSInternalInconsistencyException format: @"CBService cannot serve, it's an abstract class"];
	return nil;
}

- (NSString*)MIMEType {
	return @"text/html;charset=UTF-8";
}

- (void)dealloc {
	[name release];
	[super dealloc];
}

@end
