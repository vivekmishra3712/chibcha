//
//  CBServiceCenter.m
//  Chibcha
//
//  Created by PH on 7.2.10.
//  Copyright 2010 Codesign. All rights reserved.
//

#import "CBServiceCenter.h"
#import "CBService.h"

@implementation CBServiceCenter

@synthesize name;

- (id)init {
	if ((self = [super init])) {
		services = [[NSMutableDictionary alloc] init];
		Class DBClass = NSClassFromString(@"EXObjectStore");
		if (DBClass == Nil) NSLog(@"No database (class not found)");
	}
	return self;
}

- (void)registerService:(Class)serviceClass {
	CBService* service = [[serviceClass alloc] init];
	[services setObject: service forKey: service.name];
	[service release];
}

- (NSDictionary*)processRequestWithServiceName:(NSString*)serviceName paramString:(NSString*)paramString data:(NSData*)_data {
	CBService* service = [services objectForKey: serviceName];
	if (service == nil) {
		NSLog(@"Could not find service '%@'", serviceName);
	} else {
		NSString* MIMEType = [service MIMEType];
		NSData* data = [service processRequestWithParamString: paramString data: _data];
		return [NSDictionary dictionaryWithObjectsAndKeys: MIMEType, @"MIMEType", data, @"Data", nil];
	}
	return nil;
}

- (BOOL)startServing {
	id connection = [NSConnection serviceConnectionWithName: name rootObject: self];
	if (connection != nil) [connection run];
	return connection != nil;
}

- (void)dealloc {
	[name release];
	[services release];
	[super dealloc];
}

@end
