//
//  CBService.h
//  Chibcha
//
//  Created by PH on 7.2.10.
//  Copyright 2010 Codesign. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CBSession.h"
#import "CBServiceCenter.h"

@interface CBService : NSObject {
	NSString* name;
}

@property (nonatomic, retain) NSString* name;

- (NSDictionary*)parametersWithParamString:(NSString*)paramString;
- (NSData*)processRequestWithParamString:(NSString*)paramString data:(NSData*)data session:(CBSession*)session serviceCenter:(CBServiceCenter*)serviceCenter;
- (NSData*)processRequestWithParameters:(NSDictionary*)parameters data:(NSData*)data session:(CBSession*)session serviceCenter:(CBServiceCenter*)serviceCenter;
- (NSString*)MIMEType;
- (BOOL)isThreadSafe;
- (NSTimeInterval)timeout;

@end
