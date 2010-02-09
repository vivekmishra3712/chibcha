//
//  CBMessage.h
//  Chibcha
//
//  Created by PH on 9.2.10.
//  Copyright 2010 Codesign. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CBPeer.h"

@interface CBMessage : NSObject <NSCoding> {
	CBPeer* producer;
	CBPeer* consumer;
	NSObject<NSCoding>* content;
}

@property (nonatomic, retain) CBPeer* producer;
@property (nonatomic, retain) CBPeer* consumer;
@property (nonatomic, retain) NSObject<NSCoding>* content;

- (id)initWithProducer:(CBPeer*)_producer content:(NSObject<NSCoding>*)_content;
+ (CBMessage*)messageWithContent:(id)content producer:(CBPeer*)producer;

@end
