//
//  CBServiceCenter.h
//  Chibcha
//
//  Created by PH on 7.2.10.
//  Copyright 2010 Codesign. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EXObjectStore.h"

@interface CBServiceCenter : NSObject {
	NSString* name;
	NSMutableDictionary* services;
	NSMutableDictionary* sessions;
	EXObjectStore* objectStore;
}

@property (nonatomic, retain) NSString* name;
@property (retain) NSMutableDictionary* services;
@property (retain) NSMutableDictionary* sessions;

- (void)registerService:(Class)serviceClass;
- (void)discardSessionWithSessionID:(NSString*)sessionID;
- (NSMutableDictionary*)processRequestWithServiceName:(NSString*)serviceName paramString:(NSString*)paramString data:(NSData*)data sessionID:(NSString*)sessionID;
- (BOOL)startServing;
- (NSUInteger)numberOfThreads;
- (NSString*)dataPath;
- (EXObjectStore*)objectStore;

@end
