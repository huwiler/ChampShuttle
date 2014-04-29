//
//  CCTweet.h
//  ChampShuttle
//
//  Created by Matt Huwiler on 4/25/14.
//  Copyright (c) 2014 Champlain College. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCTweet : NSObject

@property (nonatomic, copy) NSString *champlainID;
@property (nonatomic, copy) NSString *twitterID;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, copy) NSString *screenName;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *createdAt;
@property (nonatomic, strong) UIImage *image;

- (id)initWithID:(NSString *)champlainID twitterID:(NSString *)twitterID link:(NSString *)link screenName:(NSString *)screenName text:(NSString *)text createdAt:(NSString *)createdAt image:(UIImage *)image;

@end
