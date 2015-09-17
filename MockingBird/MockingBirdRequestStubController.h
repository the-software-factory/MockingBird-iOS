//
//  RequestStubbingController.h
//
//  Created by Giuseppe Bruno on 27/08/15.
//  Copyright (c) 2015 Vendini, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MockingBirdRequestStubController : NSObject

+ (void)startStubRequestsWithStubResponseIntoFile:(NSString *)fileName;

@end
