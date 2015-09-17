//
//  MockingBirdRequestStub.h
//
//  Created by Giuseppe Bruno on 27/08/15.
//  Copyright (c) 2015 Vendini, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MockingBirdRequestStub : NSObject

/**
 * With this method we can create an automatic stubbing of HTTP requests from an object where the pairing between HTTP requests and the corrispondent responses has been stored
 *
 * @param object  the object that contains the pairing, for example an NSArray with more items, and each item rapresents a pairing
 */
+ (void)startStubWebRequestsFromObject:(id)object;

@end
