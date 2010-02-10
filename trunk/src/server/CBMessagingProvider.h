//
//  CBMessagingProvider.h
//  Chibcha
//
//  Created by PH on 9.2.10.
//  Copyright 2010 Codesign. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CBMessage;
@class CBPeer;

@protocol CBMessagingProvider

- (BOOL)postMessage:(bycopy CBMessage*)message toPeer:(bycopy CBPeer*)consumer;
- (bycopy NSArray*)fetchMessagesForPeer:(bycopy CBPeer*)consumer;
- (oneway void)discardMessage:(NSString*)UID;

@end
