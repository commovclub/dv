//
//  GetNewsListDataRequest.m
//  DV
//
//  Created by Zhao Zhicheng on 2/14/14.
//
//

#import "GetNewsListDataRequest.h"

@implementation GetNewsListDataRequest
- (NSString*)getRequestUrl{
    NSString *userId=[[NSUserDefaults standardUserDefaults] stringForKey:@"USER_ID"];
    return [REQUEST_DOMAIN stringByAppendingFormat:@"%@%@?",@"info/list/",userId];
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
