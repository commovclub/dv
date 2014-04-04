//
//  Friend.m
//  HotWord
//
//  Created by Jack on 13-6-6.
//
//

#import "Friend.h"

@implementation Friend
- (NSDictionary*)attributeMapDictionary{
	return @{@"userId": @"userId"
          ,@"uid": @"uid"
          ,@"email": @"email"
          ,@"nickname": @"nickName"
          ,@"gender": @"gender"
          ,@"birthday": @"birthday"
          ,@"exam": @"exam"
          ,@"applyYear": @"applyYear"
          ,@"city": @"city"
          ,@"school": @"school"
          ,@"company": @"company"
          ,@"status": @"status"
          ,@"identity": @"role"
          ,@"distance": @"distance"
          ,@"testSection": @"major"
          ,@"avater": @"avatar"
          ,@"avater1": @"avatar1"
          ,@"avater2": @"avatar2"
          ,@"isWatched": @"watched"};
}



@end
