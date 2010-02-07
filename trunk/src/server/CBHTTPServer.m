//
//  CBHTTPServer.m
//  Chibcha
//
//  Created by PH on 7.2.10.
//  Copyright 2010 Codesign. All rights reserved.
//

#import "CBHTTPServer.h"
#import "CBServiceCenter.h"
#import "MyHTTPConnection.h"

@implementation CBHTTPServer

- (NSDictionary*)handleGetRequestWithURI:(NSString*)URIString data:(NSData*)data {
	@try {
		NSLog(@"Serving request: %@", URIString);
		//NSLog(@"Data: %@ %u", data, [data length]);
		//NSLog(@"Main thread: %d", [NSThread currentThread] == [NSThread mainThread]);
		if ([URIString rangeOfString: @"/service:"].location == 0) {
			NSString* serviceName = [URIString substringFromIndex: 9];
			NSString* paramString = nil;
			NSRange range = [serviceName rangeOfString: @"?"];
			if (range.location != NSNotFound) {
				paramString = [serviceName substringFromIndex: range.location + 1];
				serviceName = [serviceName substringToIndex: range.location];
			}
			range = [serviceName rangeOfString: @":"];
			if (range.location == NSNotFound) NSLog(@"Incorrect URI format");
			else {
				NSString* serviceCenterName = [NSString stringWithFormat: @"CBService:%@", [serviceName substringToIndex: range.location]];
				serviceName = [serviceName substringFromIndex: range.location + 1];
				id serviceCenter = [NSConnection rootProxyForConnectionWithRegisteredName: serviceCenterName host: nil];
				if (serviceCenter == nil) NSLog(@"Could not find service center '%@'", serviceCenterName);
				return [serviceCenter processRequestWithServiceName: serviceName paramString: paramString data: data];
			}
		}
	} @catch (NSException* exception) {
		NSLog(@"Exception serving request: %@", exception);
	}
	return nil;
}

- (void)run {
    server = SECURE_SERVER ? [[HTTPServer alloc] init] : [[ThreadPoolServer alloc] init];
    [server setType: @"_http._tcp."];
    [server setName: @"Chibcha HTTP Server"];
	[server setPort: 8765];
    [server setDocumentRoot: [NSURL fileURLWithPath: [@"~/tmp" stringByExpandingTildeInPath]]];
	[server setDelegate: self];
	[server setConnectionClass: [MyHTTPConnection class]];
	
    NSError* startError = nil;
    if (![server start: &startError]) {
        NSLog(@"Error starting server: %@", startError);
    } else {
        //NSLog(@"Starting server on port %d", [server port]);
    }
}

- (void)dealloc {
	[server release];
	[super dealloc];
}

@end
