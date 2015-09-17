//
//  RequestRecordingStubbing.h
//
//  Created by Giuseppe Bruno on 16/09/15.
//  Copyright (c) 2015 Vendini, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MockingBird : NSObject

+ (void)setPathForRecording:(NSString *)path;
+ (void)setRecordingOn:(BOOL)record;
+ (void)startStubRequestsWithStubResponseIntoFile:(NSString *)fileName;

@end
