//
//  GetContactListDataRequest.m
//  DV
//
//  Created by Zhao Zhicheng on 2/25/14.
//
//

#import "GetContactListDataRequest.h"

@implementation GetContactListDataRequest

- (NSString*)getRequestUrl{
    NSString *userId=[[NSUserDefaults standardUserDefaults] stringForKey:@"USER_ID"];
    return [REQUEST_DOMAIN stringByAppendingFormat:@"%@%@?",@"member/list/",userId];
}

- (void)processResult
{
    [super processResult];
}
- (ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodGet;
}

@end

