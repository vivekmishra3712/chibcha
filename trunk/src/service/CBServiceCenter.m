//
//  CBServiceCenter.m
//  Chibcha
//
//  Created by PH on 7.2.10.
//  Copyright 2010 Codesign. All rights reserved.
//

#import "CBServiceCenter.h"
#import "CBService.h"
#import "CBReturnValue.h"

#define NUMBER_OF_THREADS	10
#define SLEEP_INTERVAL		0.01

@implementation CBServiceCenter

@synthesize name;
@synthesize services;
@synthesize sessions;

- (id)init {
	if ((self = [super init])) {
		services = [[NSMutableDictionary alloc] init];
		sessions = [[NSMutableDictionary alloc] init];
		Class DBClass = NSClassFromString(@"EXObjectStore");
		if ([self dataPath] != nil) {
			if (DBClass == Nil) NSLog(@"No database (class not found)");
			else {
				objectStore = [[EXObjectStore alloc] initWithPath: [self dataPath]];
				NSLog(@"Database opened at path %@", [self dataPath]);
			}
		}
	}
	return self;
}

- (NSString*)dataPath {
	return nil; //[@"~/Library/Application Support/Chibcha App Server/default.db" stringByExpandingTildeInPath];
}

- (EXObjectStore*)objectStore {
	return objectStore;
}

- (void)registerService:(Class)serviceClass {
	CBService* service = [[serviceClass alloc] init];
	[services setObject: service forKey: service.name];
	[service release];
}

- (void)discardSessionWithSessionID:(NSString*)sessionID {
	//NSLog(@"Discarding session (exists: %d)", [sessions objectForKey: sessionID] != nil);
	[sessions removeObjectForKey: sessionID];
}

- (NSMutableDictionary*)processRequestWithServiceName:(NSString*)serviceName paramString:(NSString*)paramString data:(NSData*)_data sessionID:(NSString*)sessionID {
	@try {
		CBService* service = [self.services objectForKey: serviceName]; // thread-safe thanks to "self." (it's not "nonatomic")
		if (service == nil) {
			NSLog(@"Could not find service '%@'", serviceName);
		} else {
			CBSession* session = [sessions objectForKey: sessionID];
			if (session == nil) {
				session = [[CBSession alloc] init];
				[sessions setObject: session forKey: sessionID];
				[session release];
			}
			NSString* MIMEType = [service MIMEType];
			CBReturnValue* retVal = [[[CBReturnValue alloc] init] autorelease];
			[NSThread detachNewThreadSelector: @selector(processBlock:)
									 toTarget: self
								   withObject: [[^void() {
				if ([service isThreadSafe])
					retVal.value = [service processRequestWithParamString: paramString data: _data session: session serviceCenter: self];
				else @synchronized (service) {
					retVal.value = [service processRequestWithParamString: paramString data: _data session: session serviceCenter: self];
				}
			} copy] autorelease]];
			NSDate* expires = [NSDate dateWithTimeIntervalSinceNow: [service timeout]];
			while (retVal.value == nil) {
				if ([expires timeIntervalSinceNow] < 0) {
					NSLog(@"Timeout: %@", serviceName);
					break;
				}
				[NSThread sleepForTimeInterval: SLEEP_INTERVAL];
			}
			NSData* data = retVal.value;
			return [NSMutableDictionary dictionaryWithObjectsAndKeys: MIMEType, @"MIMEType", data, @"Data", nil];
		}
	} @catch (NSException* exception) {
		NSLog(@"Exception serving request: %@", exception);
	}
	return nil;
}

- (void)processBlock:(void(^)())block {
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	@try {
		block();
	} @catch (NSException* exception) {
		NSLog(@"Exception in block: %@", exception);
	} @finally {
		[pool drain];
	}
}

- (BOOL)startServing {
	id connection = [NSConnection serviceConnectionWithName: name rootObject: self];
	[[NSNotificationCenter defaultCenter] addObserver: self
											 selector: @selector(connectionDidDie:)
												 name: NSConnectionDidDieNotification
											   object: connection];
	if (connection != nil) {
		[connection enableMultipleThreads];
		for (int i = 1; i < [self numberOfThreads]; i++) {
			[connection runInNewThread];
		}
		[connection run];
		//while (YES) [NSThread sleepForTimeInterval: 1];
	}
	return connection != nil;
}

- (NSUInteger)numberOfThreads {
	return NUMBER_OF_THREADS;
}

- (void)connectionDidDie:(NSNotification*)notofication {
	NSLog(@"Connection died");
}

- (void)dealloc {
	[name release];
	[services release];
	[sessions release];
	[objectStore release];
	[super dealloc];
}

@end
