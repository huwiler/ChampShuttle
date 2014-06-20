//
//  CCSection.h
//  ChampShuttle
//
//  Created by Matt Huwiler on 6/15/14.
//  Copyright (c) 2014 Champlain College. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCSection : NSObject

@property (nonatomic, copy) NSString *instructorFirstName;
@property (nonatomic, copy) NSString *instructorLastName;
@property (nonatomic, copy) NSString *days;
@property (nonatomic, copy) NSString *times;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, copy) NSString *number;
@property (nonatomic, copy) NSString *semester;
@property (nonatomic) unsigned seats;

- (id)initWithNumber:(NSString *)number instructorFirstName:(NSString *)instructorFirstName instructorLastName:(NSString *)instructorLastName days:(NSString *)days times:(NSString *)times startDate:(NSDate *)startDate endDate:(NSDate *)endDate semester:(NSString *)semester seats:(unsigned)seats;

@end
