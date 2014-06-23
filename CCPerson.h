//
//  CCPerson.h
//  ChampShuttle
//
//  Created by Matt Huwiler on 6/20/14.
//  Copyright (c) 2014 Champlain College. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCPerson : NSObject <NSCoding>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *department;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *building;

- (id)initWithName:(NSString *)name title:(NSString *)title department:(NSString *)department email:(NSString *)email phone:(NSString *)phone building:(NSString *)building;

@end
