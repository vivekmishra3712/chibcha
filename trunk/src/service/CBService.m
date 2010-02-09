//
//  CBService.m
//  Chibcha
//
//  Created by PH on 7.2.10.
//  Copyright 2010 Codesign. All rights reserved.
//

#import "CBService.h"

@implementation CBService

#define SERVICE_TIMEOUT		60

@synthesize name;
//@synthesize serviceCenter;

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

- (NSData*)processRequestWithParamString:(NSString*)paramString data:(NSData*)data session:(CBSession*)session {
	NSDictionary* parameters = [self parametersWithParamString: paramString];
	return [self processRequestWithParameters: parameters data: data session: session];
}

- (NSData*)processRequestWithParameters:(NSDictionary*)parameters data:(NSData*)data session:(CBSession*)session {
	[NSException raise: NSInternalInconsistencyException format: @"CBService cannot serve, it's an abstract class"];
	return nil;
}

- (NSString*)MIMEType {
	return @"text/html;charset=UTF-8";
}

- (BOOL)isThreadSafe {
	return YES;
}

- (NSTimeInterval)timeout {
	return SERVICE_TIMEOUT;
}

- (void)dealloc {
	[name release];
	[super dealloc];
}

@end
