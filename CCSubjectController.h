//
//  CCSubjectController.h
//  ChampShuttle
//
//  Created by Matt Huwiler on 6/15/14.
//  Copyright (c) 2014 Champlain College. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCSubject.h"

@interface CCSubjectController : NSObject

@property (nonatomic, strong) NSMutableArray *subjectList;
- (unsigned)countOfList;
- (CCSubject *)objectInListAtIndex:(unsigned)index;

- (void)addSubject:(CCSubject *)subject;

- (void)addSubjectWithTitle:(NSString *)title
                       code:(NSString *)code;
                                             
@end
