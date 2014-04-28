//
//  CCBlog.m
//  ChampShuttle
//
//  Created by Matthew Huwiler on 4/15/14.
//  Copyright (c) 2014 Champlain College. All rights reserved.
//

#import "CCBlog.h"

@implementation CCBlog

- (id)initWithID:(NSString *)blogID title:(NSString *)title type:(NSString *)type link:(NSString *)link author:(NSString *)author description:(NSString *)description published:(NSString *)published image:(UIImage *)image {
    
    self = [super init];
    
    if (self) {
        _blogID = blogID;
        _title = title;
        _type = type;
        _link = link;
        _author = author;
        _description = description;
        _published = published;
        _image = image;
        
        return self;
    }
    
    return nil;
    
}

@end
