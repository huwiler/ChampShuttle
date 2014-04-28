//
//  CCBlog.h
//  ChampShuttle
//
//  Created by Matthew Huwiler on 4/15/14.
//  Copyright (c) 2014 Champlain College. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCBlog : NSObject

@property (nonatomic, copy) NSString *blogID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *published;
@property (nonatomic, strong) UIImage *image;

- (id)initWithID:(NSString *)blogID title:(NSString *)title type:(NSString *)type link:(NSString *)link author:(NSString *)author description:(NSString *)description published:(NSString *)published image:(UIImage *)image;

@end
