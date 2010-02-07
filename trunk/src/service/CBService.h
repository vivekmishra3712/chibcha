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

- (BOOL)startServing;
- (NSData*)processRequestWithParamString:(NSString*)paramString;
- (NSData*)processRequestWithParameters:(NSDictionary*)parameters;
- (NSString*)MIMEType;

@end
