//
//  CBHTTPServer.h
//  Chibcha
//
//  Created by PH on 7.2.10.
//  Copyright 2010 Codesign. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ThreadPoolServer.h"

@interface CBHTTPServer : NSObject {
	HTTPServer* server;
}

- (void)run;

@end
