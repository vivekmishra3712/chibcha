//
//  CBServiceCenter.h
//  Chibcha
//
//  Created by PH on 7.2.10.
//  Copyright 2010 Codesign. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBServiceCenter : NSObject {
	NSString* name;
	NSMutableDictionary* services;
}

@property (nonatomic, retain) NSString* name;

- (void)registerService:(Class)serviceClass;
- (NSMutableDictionary*)processRequestWithServiceName:(NSString*)serviceName paramString:(NSString*)paramString data:(NSData*)data sessionID:(NSString*)sessionID;
- (BOOL)startServing;

@end