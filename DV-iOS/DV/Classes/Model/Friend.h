//
//  Friend.h
//  HotWord
//
//  Created by Jack on 13-6-6.
//
//

#import "ITTBaseModelObject.h"

@interface Friend : ITTBaseModelObject
@property (nonatomic, strong) NSString *userId;
//used by HTGetUserInfoNewDataRequest
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *avater;
@property (nonatomic, strong) NSString *avater1;
@property (nonatomic, strong) NSString *avater2;
@property (nonatomic, strong) NSString *lastLogin;
@property (nonatomic, strong) NSString *lastMsg;
@property (nonatomic, strong) NSString *exam;
@property (nonatomic, strong) NSString *year;
@property (nonatomic, strong) NSString *applyYear;
@property (nonatomic, strong) NSString *major;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *school;
@property (nonatomic, strong) NSString *company;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *dreamSchool;
@property (nonatomic, strong) NSString *dreamSchoolCN;
@property (nonatomic, strong) NSString *dreamSchoolEN;

@property (nonatomic, strong) NSString *distance;

@property (nonatomic, strong) NSString *identity;
@property (nonatomic, strong) NSString *testSection;
//是否被关注(0:否 1 是)
@property (nonatomic, strong) NSString *isWatched;

@end
