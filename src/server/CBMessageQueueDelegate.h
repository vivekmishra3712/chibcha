//
//  CBMessageQueueDelegate.h
//  Chibcha
//
//  Created by PH on 9.2.10.
//  Copyright 2010 Codesign. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CBMessage;
@class CBMessageQueue;

@protocol CBMessageQueueDelegate

- (void)messageQueue:(CBMessageQueue*)messageQueue didReceiveMessage:(CBMessage*)message;

@end
