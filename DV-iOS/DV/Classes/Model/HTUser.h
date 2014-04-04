//
//  User.h
//  HotWord
//
//  Created by Jack Liu on 7/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ITTBaseModelObject.h"

@interface HTUser : ITTBaseModelObject

@property (nonatomic, retain) NSString *userId;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSString *nickname;
@property (nonatomic, retain) NSString *gender;
@property (nonatomic, retain) NSString *birthday;
@property (nonatomic, retain) NSString *longitude;
@property (nonatomic, retain) NSString *latitude;
@property (nonatomic, retain) NSString *avater;
@property (nonatomic, retain) NSString *avater1;
@property (nonatomic, retain) NSString *avater2;
@property (nonatomic, retain) NSString *lastLogin;
@property (nonatomic, retain) NSString *lastMsg;
@property (nonatomic, retain) NSString *exam;
@property (nonatomic, retain) NSString *year;
@property (nonatomic, retain) NSString *applyYear;
@property (nonatomic, retain) NSString *major;
@property (nonatomic, retain) NSString *country;
@property (nonatomic, retain) NSString *city;
@property (nonatomic, retain) NSString *school;
@property (nonatomic, retain) NSString *company;
@property (nonatomic, retain) NSString *status;
@property (nonatomic, retain) NSString *dreamSchool;
@property (nonatomic, retain) NSString *dreamSchoolCN;
@property (nonatomic, retain) NSString *dreamSchoolEN;

@property (nonatomic, retain) NSString *distance;

@property (nonatomic, retain) NSString *identity;
@property (nonatomic, retain) NSString *testSection;
@property (nonatomic, retain) NSString *vendor;
@property (nonatomic, retain) NSString *lastGetMessageTime;

- (void)copyFromUser:(HTUser *)user;
- (BOOL)isEqualToUser:(HTUser *)user;

@end
