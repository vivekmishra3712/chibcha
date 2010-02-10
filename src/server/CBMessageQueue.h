//
//  CBMessageQueue.h
//  Chibcha
//
//  Created by PH on 9.2.10.
//  Copyright 2010 Codesign. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CBMessageQueueDelegate.h"

@class CBPeer;
@class CBMessage;
@class CBMessageCenter;

@interface CBMessageQueue : NSObject {
	CBPeer* peer;
	CBMessageCenter* messageCenter;
	NSObject<CBMessageQueueDelegate>* delegate;
	BOOL valid;
	NSString* messageCenterName;
	NSString* host;
}

@property BOOL valid;
@property (retain) CBMessageCenter* messageCenter;

- (id)initWithMessageCenterName:(NSString*)_messageCenterName host:(NSString*)_host peer:(CBPeer*)_peer;
- (void)setDelegate:(NSObject<CBMessageQueueDelegate>*)_delegate;
- (BOOL)postMessage:(CBMessage*)message toPeer:(CBPeer*)consumer;
- (void)initializeMessageCenter;
- (void)close;

@end
