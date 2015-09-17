//
//  MockingBirdRequestFactory.h
//  EntryScan
//
//  Created by Giuseppe Bruno on 27/08/15.
//  Copyright (c) 2015 Vendini, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MockingBirdRequestModel.h"

@interface MockingBirdRequestFactory : NSObject

- (MockingBirdRequestModel *)createRequest;

@end
