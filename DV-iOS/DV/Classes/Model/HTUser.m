//
//  User.m
//  HotWord
//
//  Created by Jack Liu on 7/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HTUser.h"

@implementation HTUser

- (NSDictionary*)attributeMapDictionary{
	return @{@"userId": @"uid"
          ,@"email": @"email"
          ,@"nickname": @"nickname"
          ,@"gender": @"gender"
          ,@"birthday": @"birthday"
          ,@"exam": @"exam"
          ,@"applyYear": @"applyYear"
          ,@"city": @"city"
          ,@"school": @"school"
          ,@"company": @"company"
          ,@"status": @"status"
          ,@"identity": @"role"
          ,@"testSection": @"major"
          ,@"lastGetMessageTime": @"lastGetMessageTime"
          ,@"avater": @"DUMP"
          ,@"avater1": @"DUMP"
          ,@"avater2": @"DUMP"
          ,@"vendor": @"DUMP"};
}

- (void)copyFromUser:(HTUser *)user
{
    self.userId = user.userId;
    self.email = user.email;
    self.password = user.password;
    self.nickname = user.nickname;
    self.gender = user.gender;
    self.birthday = user.birthday;
    self.longitude = user.longitude;
    self.latitude = user.latitude;
    self.avater = user.avater;
    self.avater1 = user.avater1;
    self.avater2 = user.avater2;
    self.lastLogin = user.lastLogin;
    self.lastMsg = user.lastMsg;
    self.exam = user.exam;
    self.year = user.year;
    self.applyYear = user.applyYear;
    self.major = user.major;
    self.country = user.country;
    self.city = user.city;
    self.school = user.school;
    self.company = user.company;
    self.status = user.status;
    self.dreamSchool = user.dreamSchool;
    self.dreamSchoolEN = user.dreamSchoolEN;
    self.dreamSchoolCN = user.dreamSchoolCN;
    
    self.identity = user.identity;
    self.testSection = user.testSection;
    
    self.vendor = user.vendor;
    self.lastGetMessageTime = user.lastGetMessageTime;
}

- (BOOL)isEqualToUser:(HTUser *)user
{
    NSDictionary *attrMapDic = [self attributeMapDictionary];
	NSEnumerator *keyEnum = [attrMapDic keyEnumerator];
	id attributeName;
	while ((attributeName = [keyEnum nextObject])) {
		SEL getSel = NSSelectorFromString(attributeName);
		if ([self respondsToSelector:getSel] && [user respondsToSelector:getSel]) {
			NSMethodSignature *signature = [self methodSignatureForSelector:getSel];
			NSInvocation *invocationSelf = [NSInvocation invocationWithMethodSignature:signature];
			[invocationSelf setTarget:self];
			[invocationSelf setSelector:getSel];
			NSObject *valueObjSelf = nil;
			[invocationSelf invoke];
			[invocationSelf getReturnValue:&valueObjSelf];
            
            NSInvocation *invocationCompare = [NSInvocation invocationWithMethodSignature:signature];
			[invocationCompare setTarget:user];
			[invocationCompare setSelector:getSel];
			NSObject *valueObjCompare = nil;
			[invocationCompare invoke];
			[invocationCompare getReturnValue:&valueObjCompare];
            
			if (![valueObjSelf isEqual:valueObjCompare]) {
                if (!(!valueObjSelf && !valueObjCompare)) {
                    return NO;
                }
			}
		}
	}
    return YES;
}

-(void)dealloc
{
    [_lastGetMessageTime release];
    [_userId release];
    [_email release];
    [_password release];
    [_nickname release];
    [_gender release];
    [_birthday release];
    [_longitude release];
    [_latitude release];
    [_avater release];
    [_avater1 release];
    [_avater2 release];
    [_lastLogin release];
    [_lastMsg release];
    [_exam release];
    [_year release];
    [_applyYear release];
    [_major release];
    [_country release];
    [_city release];
    [_school release];
    [_company release];
    [_status release];
    [_dreamSchool release];
    [_dreamSchoolCN release];
    [_dreamSchoolEN release];
    [_distance release];
    
    [_identity release];
    [_testSection release];
    [_vendor release];
    [super dealloc];
}

@end
