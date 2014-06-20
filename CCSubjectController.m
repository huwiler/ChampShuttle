//
//  CCSubjectController.m
//  ChampShuttle
//
//  Created by Matt Huwiler on 6/15/14.
//  Copyright (c) 2014 Champlain College. All rights reserved.
//

#import "CCSubjectController.h"
#import "CCSubject.h"

@implementation CCSubjectController

- (void) addSubject:(CCSubject *)subject {
    [self.subjectList addObject:subject];
}

- (void) addSubjectWithTitle:(NSString *)title code:(NSString *)code {
    CCSubject *subject = [[CCSubject alloc] initWithTitle:title code:code];
    [self addSubject:subject];
}

- (CCSubject *)objectInListAtIndex:(unsigned)index {
    return [self.subjectList objectAtIndex:index];
}

- (unsigned)countOfList {
    return [self.subjectList count];
}

- (void)setSubjectList:(NSMutableArray *)subjectList {
    if (_subjectList != subjectList) {
        _subjectList = [subjectList mutableCopy];
    }
}

-(id)init {
    if (self = [super init]) {
        _subjectList = [NSMutableArray array];
        return self;
    }
    return nil;
}

@end
