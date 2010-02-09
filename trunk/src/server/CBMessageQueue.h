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
}

@property BOOL valid;

- (id)initWithMessageCenter:(CBMessageCenter*)_messageCenter peer:(CBPeer*)_peer;
- (void)setDelegate:(NSObject<CBMessageQueueDelegate>*)_delegate;
- (BOOL)postMessage:(CBMessage*)message toPeer:(CBPeer*)consumer;

@end
