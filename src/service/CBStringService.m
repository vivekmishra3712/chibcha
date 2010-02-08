//
//  CBStringService.h
//  Chibcha
//
//  Created by PH on 7.2.10.
//  Copyright 2010 Codesign. All rights reserved.
//

#import "CBStringService.h"

@implementation CBStringService

- (id)init {
	if ((self = [super init])) {
		name = @"strip";
	}
	return self;
}

- (NSData*)processRequestWithParameters:(NSDictionary*)parameters data:(NSData*)data sessionID:(NSString*)sessionID {
	NSString* string = [parameters objectForKey: @"string"];
	NSLog(@"Input string: %@ (session ID: %@)", string, sessionID);
	NSString* strippedString = [[[NSString alloc] initWithData: [string dataUsingEncoding: NSASCIIStringEncoding allowLossyConversion: YES] encoding: NSASCIIStringEncoding] autorelease];
	NSString* result = [NSString stringWithFormat: @"%@ -> %@", string, strippedString];
	return [result dataUsingEncoding: NSUTF8StringEncoding];
}

@end