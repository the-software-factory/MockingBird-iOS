//
//  MockingBirdRequestStub.m
//
//  Created by Giuseppe Bruno on 27/08/15.
//  Copyright (c) 2015 Vendini, Inc. All rights reserved.
//

#import "MockingBirdRequestStub.h"
#import "OHHTTPStubs.h"

@implementation MockingBirdRequestStub

+ (void)startStubWebRequestsFromObject:(id)object
{
    NSMutableArray *listOfPairs = object;

    __block NSDictionary *dictionaryJSONResponse;
    __block NSDictionary *dictionaryHeaderResponse;

    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        NSString *urlRealRequest = [request.URL.host stringByAppendingString:request.URL.path];
        NSString *methodRealRequest = request.HTTPMethod;

        NSString *paramsRealRequest = [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding];

        //Return an array that contains at the first position a NSDictionary with these KEYS:url, method, params, with the same value of the current real request
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(url == %@) AND (method == %@) AND (params == %@)", urlRealRequest, methodRealRequest, paramsRealRequest];

        NSArray *arrayPair = [listOfPairs filteredArrayUsingPredicate:predicate];

        //If this request has been stored in past
        if (arrayPair.count) {

            NSDictionary *dictionaryPair = arrayPair[0];

            dictionaryJSONResponse = [dictionaryPair valueForKey:@"responseBody"][0];
            dictionaryHeaderResponse = [dictionaryPair valueForKey:@"responseHeader"][0];

        } else {
            //If the request hasn't been stored in past return a fake response
            dictionaryJSONResponse   = @{
                                         @"NoHeaderKey" : @"NoHeaderValue"
                                         };
            dictionaryHeaderResponse = @{
                                         @"NoBodyKey" : @"NoBodyValue"
                                         };

            // Usefull log if the request is not stubbed
            NSLog(@"urlRealRequest Not Catched %@", urlRealRequest);
            NSLog(@"methodRealRequest Not Catched %@", methodRealRequest);
            NSLog(@"paramsRealRequest Not Catched %@", paramsRealRequest);
        }

        return YES;
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {

        OHHTTPStubsResponse *response = [OHHTTPStubsResponse responseWithJSONObject:dictionaryJSONResponse statusCode:200 headers:dictionaryHeaderResponse];
        return response;
    }];
}

@end
