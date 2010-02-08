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

- (NSData*)processRequestWithParameters:(NSDictionary*)parameters data:(NSData*)data {
	NSString* string = [parameters objectForKey: @"string"];
	NSLog(@"Input string & data: %@", string);
	NSString* strippedString = [[[NSString alloc] initWithData: [string dataUsingEncoding: NSASCIIStringEncoding allowLossyConversion: YES] encoding: NSASCIIStringEncoding] autorelease];
	NSString* result = [NSString stringWithFormat: @"%@ -> %@", string, strippedString];
	return [result dataUsingEncoding: NSUTF8StringEncoding];
}

@end
