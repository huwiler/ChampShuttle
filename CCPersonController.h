//
//  CCPersonController.h
//  ChampShuttle
//
//  Created by Matt Huwiler on 6/20/14.
//  Copyright (c) 2014 Champlain College. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCPerson.h"

@interface CCPersonController : NSObject

@property (nonatomic, strong) NSMutableArray *personList;

- (unsigned)countOfList;
- (CCPerson *)objectInListAtIndex:(unsigned)index;
- (void)addPerson:(CCPerson *)person;
- (void)addPersonFromDictionary:(NSDictionary *)person;
- (void)addPersonWithName:(NSString *)name
                    title:(NSString *)title
               department:(NSString *)department
                    email:(NSString *)email
                    phone:(NSString *)phone
                 building:(NSString *)building;

@end
