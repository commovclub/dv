//
//  CountOfMessageDataRequest.m
//  DV
//
//  Created by Zhao Zhicheng on 3/12/14.
//
//

#import "CountOfMessageDataRequest.h"

@implementation CountOfMessageDataRequest

- (NSString*)getRequestUrl{
    NSString *userId=[[NSUserDefaults standardUserDefaults] stringForKey:@"USER_ID"];
    return [REQUEST_DOMAIN stringByAppendingFormat:@"message/count/%@",userId];
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
