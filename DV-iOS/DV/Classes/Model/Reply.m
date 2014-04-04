//
//  Reply.m
//  
//
//  Created by zzc on 10/25/13.
//
//

#import "Reply.h"

@implementation Reply


- (NSDictionary*)attributeMapDictionary{
	return @{@"title": @"title"
          ,@"content": @"content"
          ,@"type": @"type"
          ,@"replyId": @"id"
          ,@"isRead": @"isRead"
          ,@"messageId": @"messageId"};
}

@end
