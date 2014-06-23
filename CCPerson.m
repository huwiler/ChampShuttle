//
//  CCPerson.m
//  ChampShuttle
//
//  Created by Matt Huwiler on 6/20/14.
//  Copyright (c) 2014 Champlain College. All rights reserved.
//

#import "CCPerson.h"

@implementation CCPerson

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.department forKey:@"department"];
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:self.phone forKey:@"phone"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.building forKey:@"building"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.department = [aDecoder decodeObjectForKey:@"department"];
        self.email = [aDecoder decodeObjectForKey:@"email"];
        self.phone = [aDecoder decodeObjectForKey:@"phone"];
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.building = [aDecoder decodeObjectForKey:@"building"];
    }
    return self;
}

- (id)initWithName:(NSString *)name title:(NSString *)title department:(NSString *)department email:(NSString *)email phone:(NSString *)phone building:(NSString *)building {
    
    self = [super init];
    
    if (self) {
        _name = name;
        _title = title;
        _department = department;
        _email = email;
        _phone = phone;
        _building = building;
        
        return self;
    }
    
    return nil;
}

@end
