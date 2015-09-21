//
//  MockingBird.m
//
//  Created by Giuseppe Bruno on 16/09/15.
//  Copyright (c) 2015 Vendini, Inc. All rights reserved.
//

#import "MockingBird.h"
#import "MockingBirdRequestRec.h"
#import "MockingBirdRequestStubController.h"

@implementation MockingBird

+ (void)setPathForRecording:(NSString *)path{
    [MockingBirdRequestRec setPathForRecording:path];
}

+ (void)setRecordingOn:(BOOL)record {
    [MockingBirdRequestRec setRecordingOn:record];
}

+ (void)startStubRequestsWithStubResponseIntoFile:(NSString *)fileName withExtension:(NSString *)extension{
    [MockingBirdRequestStubController startStubRequestsWithStubResponseIntoFile:fileName withExtension:extension];
}

@end
