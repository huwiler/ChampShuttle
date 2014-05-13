//
//  CCSearchResult.h
//  ChampShuttle
//
//  Created by Matt Huwiler on 5/3/14.
//  Copyright (c) 2014 Champlain College. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCSearchResult : NSObject

@property (nonatomic, copy) NSString *searchID;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, strong) NSNumber *score;
@property (nonatomic, strong) NSDictionary *data;

- (id)initWithID:(NSString *)searchID type:(NSString *)type score:(NSNumber *)score data:(NSDictionary *)data;

@end
