//
//  CBServiceCenter.m
//  Chibcha
//
//  Created by PH on 7.2.10.
//  Copyright 2010 Codesign. All rights reserved.
//

#import "CBServiceCenter.h"
#import "CBService.h"

#define NUMBER_OF_THREADS	10

@implementation CBServiceCenter

@synthesize name;
@synthesize services;

- (id)init {
	if ((self = [super init])) {
		services = [[NSMutableDictionary alloc] init];
		//Class DBClass = NSClassFromString(@"EXObjectStore");
		//if (DBClass == Nil) NSLog(@"No database (class not found)");
	}
	return self;
}

- (void)registerService:(Class)serviceClass {
	CBService* service = [[serviceClass alloc] init];
	[services setObject: service forKey: service.name];
	[service release];
}

- (NSMutableDictionary*)processRequestWithServiceName:(NSString*)serviceName paramString:(NSString*)paramString data:(NSData*)_data sessionID:(NSString*)sessionID {
	CBService* service = [self.services objectForKey: serviceName];
	if (service == nil) {
		NSLog(@"Could not find service '%@'", serviceName);
	} else {
		NSString* MIMEType = [service MIMEType];
		NSData* data = [service processRequestWithParamString: paramString data: _data sessionID: sessionID];
		return [NSMutableDictionary dictionaryWithObjectsAndKeys: MIMEType, @"MIMEType", data, @"Data", nil];
	}
	return nil;
}

- (BOOL)startServing {
	id connection = [NSConnection serviceConnectionWithName: name rootObject: self];
	if (connection != nil) {
		[connection enableMultipleThreads];
		for (int i = 1; i < NUMBER_OF_THREADS; i++) {
			[connection runInNewThread];
		}
		[connection run];
		//while (YES) [NSThread sleepForTimeInterval: 1];
	}
	return connection != nil;
}

- (void)dealloc {
	[name release];
	[services release];
	[super dealloc];
}

@end
