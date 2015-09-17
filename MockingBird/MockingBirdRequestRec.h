//
//  MockingBirdRequestRec.h
//
//  Created by Giuseppe Bruno on 15/09/15.
//  Copyright (c) 2015 Vendini, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MockingBirdRequestRec: NSObject

+ (void)setPathForRecording:(NSString *)path;
+ (void)setRecordingOn:(BOOL)record;

@end
