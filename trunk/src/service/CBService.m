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

- (NSDictionary*)parametersWithParamString:(NSString*)paramString {
	NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
	if (paramString != nil && [paramString length] > 0) {
		NSArray* comps = [paramString componentsSeparatedByString: @"&"];
		for (NSString* pair in comps) {
			NSArray* comps2 = [pair componentsSeparatedByString: @"="];
			NSString* key = [comps2 objectAtIndex: 0];
			NSString* value = [[comps2 objectAtIndex: 1] stringByReplacingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
			[parameters setObject: value forKey: key];
		}
	}
	//NSLog(@"Parameters: %@", parameters);
	return parameters;
}

- (NSData*)processRequestWithParamString:(NSString*)paramString data:(NSData*)data sessionID:(NSString*)sessionID {
	NSDictionary* parameters = [self parametersWithParamString: paramString];
	return [self processRequestWithParameters: parameters data: data sessionID: sessionID];
}

- (NSData*)processRequestWithParameters:(NSDictionary*)parameters data:(NSData*)data sessionID:(NSString*)sessionID {
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
