//
//  CBSession.h
//  Chibcha
//
//  Created by PH on 9.2.10.
//  Copyright 2010 Codesign. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBSession : NSObject {
	NSMutableDictionary* params;
}

@property (retain) NSMutableDictionary* params;

- (id)parameterForKey:(id)key;
- (void)setParameter:(id)param forKey:(id)key;

@end
