//
//  CBHTTPServer.h
//  Chibcha
//
//  Created by PH on 7.2.10.
//  Copyright 2010 Codesign. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ThreadPoolServer.h"

#define kCBPrefsKeyPath				@"Path"
#define kCBPrefsKeyPort				@"Port"
#define kCBPrefsKeyMaxConn			@"MaxConn"
#define kCBPrefsKeySessionDuration	@"SessionDuration"
#define kCBPrefsKeyDocRoot			@"DocRoot"
#define kCBPrefsKeyPostLimit		@"PostLimit"
#define kCBPrefsKeyMultithreaded	@"Multithreaded"
#define kCBPrefsKeySecure			@"Secure"
#define kCBPrefsKeyServeAtLaunch	@"ServeAtLaunch"
#define kCBPrefsKeyServiceTimeout	@"ServiceTimeout"

@interface CBHTTPServer : NSObject {
	HTTPServer* server;
	NSDictionary* prefs;
	NSMutableDictionary* sessionIDs;
}

- (id)initWithPreferences:(NSDictionary*)_prefs;
- (BOOL)start;
- (void)stop;
- (NSDictionary*)preferences;
- (NSString*)uniqueKey;

@end
