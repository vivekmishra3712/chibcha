//
//  CBService.h
//  Chibcha
//
//  Created by PH on 7.2.10.
//  Copyright 2010 Codesign. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CBSession.h"

@class CBServiceCenter;

@interface CBService : NSObject {
	NSString* name;
	//CBServiceCenter* serviceCenter;
}

@property (nonatomic, retain) NSString* name;
//@property (nonatomic, assign) CBServiceCenter* serviceCenter;

- (NSDictionary*)parametersWithParamString:(NSString*)paramString;
- (NSData*)processRequestWithParamString:(NSString*)paramString data:(NSData*)data session:(CBSession*)session;
- (NSData*)processRequestWithParameters:(NSDictionary*)parameters data:(NSData*)data session:(CBSession*)session;
- (NSString*)MIMEType;
- (BOOL)isThreadSafe;
- (NSTimeInterval)timeout;

@end
