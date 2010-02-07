//
//  CBHTTPServer.m
//  Chibcha
//
//  Created by PH on 7.2.10.
//  Copyright 2010 Codesign. All rights reserved.
//

#import "CBHTTPServer.h"
#import "CBService.h"

@implementation CBHTTPServer

- (NSDictionary*)handleGetRequestWithURI:(NSURL*)URI URL:(NSURL*)URL {
	@try {
		NSLog(@"Serving request: %@", URI);
		NSString* URIString = [URI absoluteString];
		if ([URIString rangeOfString: @"/service:"].location == 0) {
			NSString* serviceName = [URIString substringFromIndex: 9];
			NSString* paramString = nil;
			NSRange range = [serviceName rangeOfString: @"?"];
			if (range.location != NSNotFound) {
				paramString = [serviceName substringFromIndex: range.location + 1];
				serviceName = [serviceName substringToIndex: range.location];
			}
			serviceName = [@"CBService:" stringByAppendingString: serviceName];
			id service = [NSConnection rootProxyForConnectionWithRegisteredName: serviceName host: nil];
			if (service == nil) NSLog(@"Could not find service '%@'", serviceName);
			else {
				NSString* MIMEType = [service MIMEType];
				NSData* data = [service processRequestWithParamString: paramString];
				return [NSDictionary dictionaryWithObjectsAndKeys: MIMEType, @"MIMEType", data, @"Data", nil];
			}
		} else {
			return [NSData dataWithContentsOfURL: URL];
		}
	} @catch (NSException* exception) {
		NSLog(@"Exception serving request: %@", exception);
	}
	return nil;
}

- (void)run {
    server = [[HTTPServer alloc] init];
    [server setType: @"_http._tcp."];
    [server setName: @"Chibcha HTTP Server"];
	[server setPort: 8765];
    [server setDocumentRoot: [NSURL fileURLWithPath: [@"~/tmp" stringByExpandingTildeInPath]]];
	[server setRequestDelegate: self];
	
    NSError* startError = nil;
    if (![server start: &startError]) {
        NSLog(@"Error starting server: %@", startError);
    } else {
        NSLog(@"Starting server on port %d", [server port]);
    }
}

- (void)dealloc {
	[server release];
	[super dealloc];
}

@end
