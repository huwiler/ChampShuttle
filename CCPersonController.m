//
//  CCPersonController.m
//  ChampShuttle
//
//  Created by Matt Huwiler on 6/20/14.
//  Copyright (c) 2014 Champlain College. All rights reserved.
//

#import "CCPersonController.h"
#import "CCPerson.h"

@implementation CCPersonController

- (void)addPerson:(CCPerson *)person {
    [self.personList addObject:person];
}

- (void)addPersonFromDictionary:(NSDictionary *)person {
    
    NSString *name = [NSString stringWithFormat:@"%@ %@", [person objectForKey:@"firstName"], [person objectForKey:@"lastName"]];
    NSString *title = [person objectForKey:@"title"];
    NSString *department = [person objectForKey:@"department"];
    NSString *email = [person objectForKey:@"email"];
    NSString *phone = [person objectForKey:@"phone"];
    NSString *building = [person objectForKey:@"office"];
    
    [self addPersonWithName:name title:title department:department email:email phone:phone building:building];
}

- (void)addPersonWithName:(NSString *)name title:(NSString *)title department:(NSString *)department email:(NSString *)email phone:(NSString *)phone building:(NSString *)building {
    
    NSString *trimmedName = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    CCPerson *person = [[CCPerson alloc] initWithName:trimmedName title:title department:department email:email phone:phone building:building];
    
    // add new course to courseList
    [self addPerson:person];
}


- (CCPerson *)objectInListAtIndex:(unsigned)index {
    return [self.personList objectAtIndex:index];
}

- (unsigned)countOfList {
    return (unsigned int)[self.personList count];
}

- (void)setPersonList:(NSMutableArray *)personList {
    if (_personList != personList) {
        _personList = [personList mutableCopy];
    }
}

// set courseList to empty array when initialized
-(id)init {
    if (self = [super init]) {
        _personList = [NSMutableArray array];
        return self;
    }
    return nil;
}

@end
