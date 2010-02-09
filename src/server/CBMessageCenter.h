//
//  CBMessageCenter.h
//  Chibcha
//
//  Created by PH on 9.2.10.
//  Copyright 2010 Codesign. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CBMessage.h"
#import "CBPeer.h"
#import "CBMessagingProvider.h"

@class EXObjectStore;

@interface CBMessageCenter : NSObject <CBMessagingProvider> {
	EXObjectStore* objectStore;
	NSConnection* connection;
}

- (id)initWithPath:(NSString*)path;
- (BOOL)startServing;
- (void)close;

@end
