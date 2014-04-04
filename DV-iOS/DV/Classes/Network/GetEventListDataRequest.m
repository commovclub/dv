//
//  GetEventListDataRequest.m
//  DV
//
//  Created by Zhao Zhicheng on 2/24/14.
//
//

#import "GetEventListDataRequest.h"

@implementation GetEventListDataRequest
- (NSString*)getRequestUrl{
    NSString *userId=[[NSUserDefaults standardUserDefaults] stringForKey:@"USER_ID"];
    return [REQUEST_DOMAIN stringByAppendingFormat:@"%@%@?",@"event/list/",userId];
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
