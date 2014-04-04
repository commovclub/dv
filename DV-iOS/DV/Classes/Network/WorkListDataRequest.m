//
//  WorkListDataRequest.m
//  DV
//
//  Created by Zhao Zhicheng on 3/8/14.
//
//

#import "WorkListDataRequest.h"

@implementation WorkListDataRequest

- (NSString*)getRequestUrl{
    NSString *userId=[[NSUserDefaults standardUserDefaults] stringForKey:@"USER_ID"];
    return [REQUEST_DOMAIN stringByAppendingFormat:@"portfolio/list/%@?",userId];
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