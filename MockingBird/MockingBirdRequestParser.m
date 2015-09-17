//
//  MockingBirdRequestParser.m
//
//  Created by Giuseppe Bruno on 27/08/15.
//  Copyright (c) 2015 Vendini, Inc. All rights reserved.
//

#import "MockingBirdRequestParser.h"

@implementation MockingBirdRequestParser

- (id)initWithRequest:(MockingBirdRequestFactory *)requestFactory
{
    self = [super init];
    if(!self) {
        return nil;
    }

    _requestFactory = requestFactory;

    return self;
}

- (NSArray *)parseString:(NSString *)string andParentPath:(NSString *)parentPath
{
    NSError *error;
    NSMutableArray *arrayOutput = [[NSMutableArray alloc] init];

    // Convert the input string in a instance of NSDictionary
    NSData *dataToParse = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dictionaryToParse = [NSJSONSerialization JSONObjectWithData:dataToParse options:NSJSONReadingAllowFragments error:&error];

    // itemsToParse contains the items contained in parentPath
    NSArray *itemsToParse = [dictionaryToParse valueForKeyPath:parentPath];

    // Each parsed item is copied in a instance of the Model
    for (NSDictionary *itemToParse in itemsToParse) {

        // Create an istance of the request
        id model = [_requestFactory createRequest];

        for (NSString *key in [itemToParse allKeys]) {

            // If the model contains the same key presents in the input string
            if ([model respondsToSelector:NSSelectorFromString(key)]) {
                [model setValue:[itemToParse valueForKey:key] forKey:key];
            }
        }
        [arrayOutput addObject:model];
    }

    // Return an array of istances of classModel, valued with the appropriate values present in the input string
    return arrayOutput;
}

@end
