//
//  RequestStubbingController.m
//
//  Created by Giuseppe Bruno on 27/08/15.
//  Copyright (c) 2015 Vendini, Inc. All rights reserved.
//

#import "MockingBirdRequestStubController.h"
#import "MockingBirdRequestFactory.h"
#import "MockingBirdRequestParser.h"
#import "MockingBirdRequestStub.h"

@implementation MockingBirdRequestStubController

+ (void)startStubRequestsWithStubResponseIntoFile:(NSString *)fileName
{
    NSError *error;
    NSString *pathJSONPairing = [[NSBundle bundleForClass:[self class]] pathForResource:[NSString stringWithFormat:@"%@", fileName] ofType:@"json"];
    NSString *contentJSONPairing = [NSString stringWithContentsOfFile:pathJSONPairing encoding:NSDataReadingMapped error:&error];

    MockingBirdRequestFactory *request = [[MockingBirdRequestFactory alloc] init];
    MockingBirdRequestParser *parser = [[MockingBirdRequestParser alloc] initWithRequest:request];

    [MockingBirdRequestStub startStubWebRequestsFromObject:[parser parseString:contentJSONPairing andParentPath:@"requestStubs"]];
}

@end
