//
//  MockingBirdRequestModel.h
//
//  Created by Giuseppe Bruno on 27/08/15.
//  Copyright (c) 2015 Vendini, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MockingBirdRequestModel : NSObject

@property(nonatomic,strong) NSString *responseHeader;
@property(nonatomic,strong) NSString *responseBody;
@property(nonatomic,strong) NSString *url;
@property(nonatomic,strong) NSString *method;
@property(nonatomic,strong) NSString *params;

@end
