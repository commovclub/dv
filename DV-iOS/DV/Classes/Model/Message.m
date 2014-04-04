//
//  Message.m
//  HotWord
//
//  Created by Jack Liu on 7/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Message.h"

@implementation Message

- (NSDictionary*)attributeMapDictionary{
	return @{@"messageId": @"messageId"
          ,@"senderUserId": @"sendid"
          ,@"recevierUserId": @"recvUid"
          ,@"content": @"text"
          ,@"timestamp": @"timestamp"
          ,@"dialogNickname": @"nickname"
          ,@"dialogAvator": @"avator"
          ,@"gender": @"gender"};
}

@end
