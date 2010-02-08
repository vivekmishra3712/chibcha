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

- (id)initWithPreferences:(NSDictionary*)_prefs {
	if ((self = [super init])) {
		prefs = [_prefs retain];
	}
	return self;
}

- (NSDictionary*)handleRequestWithURI:(NSString*)URIString data:(NSData*)data {
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

- (void)stop {
	[server stop];
}

- (BOOL)start {
	[server release];
    server = [[prefs objectForKey: kCBPrefsKeyMultithreaded] boolValue] == NO ? [[HTTPServer alloc] initWithPreferences: prefs] : [[ThreadPoolServer alloc] initWithPreferences: prefs];
    [server setType: @"_http._tcp."];
    [server setName: @"Chibcha HTTP Server"];
	[server setPort: [[prefs objectForKey: kCBPrefsKeyPort] integerValue]];
    [server setDocumentRoot: [NSURL fileURLWithPath: [[prefs objectForKey: kCBPrefsKeyDocRoot] stringByExpandingTildeInPath]]];
	[server setDelegate: self];
	[server setConnectionClass: [MyHTTPConnection class]];
	
    NSError* startError = nil;
    if (![server start: &startError]) {
        NSLog(@"Error starting server: %@", startError);
		return NO;
    } else {
        //NSLog(@"Starting server on port %d", [server port]);
		return YES;
    }
}

- (NSDictionary*)preferences {
	return prefs;
}

- (void)dealloc {
	[server release];
	[prefs release];
	[super dealloc];
}

@end
