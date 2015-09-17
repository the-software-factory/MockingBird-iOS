//
//  MockingBirdRequestParser.h
//
//  Created by Giuseppe Bruno on 27/08/15.
//  Copyright (c) 2015 Vendini, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MockingBirdRequestFactory.h"

@interface MockingBirdRequestParser : NSObject

@property(nonatomic, strong) MockingBirdRequestFactory *requestFactory;

- (id)initWithRequest:(MockingBirdRequestFactory *)requestFactory;

/**
 * Parse a string input like a JSON file that contains a root directory and return an array of instances of MockingBirdRequestFactory
 * For example give a string input @"{"root": [ {"Value":"item1"}, {"Value":"item2"} ]}"
 * and a parentPath @"root", the method will return an NSArray with two items and with these values
 * arrayOutput[0].Value == @"item1", arrayOutput[1].Value == @"item2"
 *
 * @param string     The string to parse
 * @param parentPath The root directory where to find the items to return
 */
- (NSArray *)parseString:(NSString *)string andParentPath:(NSString *)parentPath;

@end
