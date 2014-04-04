//
//  NewMessage.m
//  HotWord
//
//  Created by Jack on 13-5-26.
//
//

#import "DVMessage.h"

@implementation DVMessage
- (NSDictionary*)attributeMapDictionary{
	return @{@"uuid": @"uuid"
          ,@"title": @"title"
          ,@"message": @"message"
          ,@"status": @"status"
          ,@"createdAt": @"createdAt"
          ,@"fromMemberId": @"fromMemberId"
          ,@"fromMemberName": @"fromMemberName"
          ,@"fromMemberAvatar": @"fromMemberAvatar"
          ,@"toMemberId": @"toMemberId"
          ,@"toMemberName": @"toMemberName"
             ,@"toMemberAvatar": @"toMemberAvatar"
             };
}
+ (NSArray *)getDumpData
    {
        NSMutableArray *messageArray = [NSMutableArray array];
        for (int i = 0; i < 12; i++) {
            DVMessage *message = [[DVMessage alloc] init];
            message.title = [NSString stringWithFormat:@"Digital Village 于1月17日举行了声势浩大的Opening Party ： %i",i];
            message.createdAt = [NSString stringWithFormat:@"2013年%i月15日 14:30",i+1];
            //message.messageCount = [NSString stringWithFormat:@"%i",i%2];
            [messageArray addObject:message];
        }
        return messageArray;
    }
    
@end
