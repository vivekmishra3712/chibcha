//
//  CBPeer.h
//  Chibcha
//
//  Created by PH on 9.2.10.
//  Copyright 2010 Codesign. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBPeer : NSObject <NSCoding> {
	NSString* UID;
}

@property (nonatomic, retain) NSString* UID;

- (id)initWithUID:(NSString*)_UID;

@end
