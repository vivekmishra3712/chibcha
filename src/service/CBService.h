//
//  CBService.h
//  Chibcha
//
//  Created by PH on 7.2.10.
//  Copyright 2010 Codesign. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBService : NSObject {
	NSString* name;
}

@property (nonatomic, retain) NSString* name;

- (NSDictionary*)parametersWithParamString:(NSString*)paramString;
- (NSData*)processRequestWithParamString:(NSString*)paramString data:(NSData*)data;
- (NSData*)processRequestWithParameters:(NSDictionary*)parameters data:(NSData*)data;
- (NSString*)MIMEType;

@end
