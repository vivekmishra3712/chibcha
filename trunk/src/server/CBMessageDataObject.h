//
//  CBMessageDataObject.h
//  Chibcha
//
//  Created by PH on 9.2.10.
//  Copyright 2010 Codesign. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EXPersistentObject.h"
#import "CBPeer.h"
#import "CBMessage.h"

@interface CBMessageDataObject : EXPersistentObject {
	NSString* consumerUID;
	CBMessage* message;
}

@property (nonatomic, retain) NSString* consumerUID;
@property (nonatomic, retain) CBMessage* message;

- (id)initWithConsumer:(CBPeer*)_consumer message:(CBMessage*)_message;

@end
