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
#import "EXNSAdditions.h"

@implementation CBHTTPServer

- (id)initWithPreferences:(NSDictionary*)_prefs {
	if ((self = [super init])) {
		prefs = [_prefs retain];
		sessionIDs = [[NSMutableDictionary alloc] init];
	}
	return self;
}

- (NSDictionary*)handleRequestWithURI:(NSString*)URIString params:(NSDictionary*)params {
	@try {
		NSDictionary* header = [params objectForKey: @"Header"];
		NSString* cookies = [header objectForKey: @"Cookie"];
		NSString* sessionID = nil;
		NSString* discardedSessionID = nil;
		if (cookies != nil) {
			NSRange range = [cookies rangeOfString: @"chibchaSID="];
			if (range.location != NSNotFound) {
				NSRange range2 = [cookies rangeOfString: @"@" options: 0 range: NSMakeRange(range.location, [cookies length] - range.location)];
				if (range2.location != NSNotFound) {
					sessionID = [cookies substringWithRange: NSMakeRange(range.location + 11, range2.location - range.location - 11)];
					NSDate* date = [sessionIDs objectForKey: sessionID];
					if (date == nil || -[date timeIntervalSinceNow] > [[prefs objectForKey: kCBPrefsKeySessionDuration] integerValue] * 60) {
						[sessionIDs removeObjectForKey: sessionID];
						discardedSessionID = [[sessionID retain] autorelease];
						sessionID = nil;
						NSLog(@"Session absent or expired");
					} //else NSLog(@"Session ID & creation date: %@ %@", sessionID, date);
				}
			}
		}
		NSData* data = [params objectForKey: @"Data"];
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
				else {
					if (discardedSessionID != nil) [serviceCenter discardSessionWithSessionID: discardedSessionID];
					if (sessionID == nil) {
						sessionID = [self uniqueKey];
						//NSLog(@"New session ID: %@", sessionID);
					}
					[sessionIDs setObject: [NSDate date] forKey: sessionID];
					[NSThread detachNewThreadSelector: @selector(checkTimeout:)
											 toTarget: self
										   withObject: serviceCenter];
					NSMutableDictionary* retVal = [serviceCenter processRequestWithServiceName: serviceName
																				   paramString: paramString
																						  data: data
																					 sessionID: sessionID];
					[retVal setObject: [NSString stringWithFormat: @"chibchaSID=%@@;path=/;Version=\"1\"", sessionID] forKey: @"Cookie"];
					return retVal;
				}
			}
		}
	} @catch (NSException* exception) {
		NSLog(@"Exception serving request: %@", exception);
	}
	return nil;
}

- (void)checkTimeout:(id)serviceCenter {
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	NSDate* expires = [NSDate dateWithTimeIntervalSinceNow: [[prefs objectForKey: kCBPrefsKeyServiceTimeout] integerValue]];
	NSConnection* connection = [serviceCenter connectionForProxy];
	while ([connection isValid]) {
		//NSLog(@"# %u %u", [serviceCenter retainCount], [connection retainCount]);
		if ([expires timeIntervalSinceNow] < 0) {
			NSLog(@"Invalidating connection");
			[connection invalidate];
			break;
		}
		[NSThread sleepForTimeInterval: 1];
	}
	//NSLog(@"Done");
	[pool drain];
}

- (NSString*)uniqueKey {
	NSString* uniqueString = [NSString stringWithFormat: @"%@:%ld", [NSDate date], random()];
	return [[uniqueString base64String]
			stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (void)stop {
	[server stop];
}

- (BOOL)start {
	[server release];
	//NSLog(@"%@", prefs);
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
	[sessionIDs release];
	[super dealloc];
}

@end
