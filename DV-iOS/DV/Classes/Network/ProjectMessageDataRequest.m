//
//  ProjectMessageDataRequest.m
//  DV
//
//  Created by Zhao Zhicheng on 3/11/14.
//
//

#import "ProjectMessageDataRequest.h"

@implementation ProjectMessageDataRequest

- (NSString*)getRequestUrl{
    NSString *userId=[[NSUserDefaults standardUserDefaults] stringForKey:@"USER_ID"];
    return [REQUEST_DOMAIN stringByAppendingFormat:@"message/lead/%@?",userId];
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