//
//  PrivateMessageDataRequest.m
//  DV
//
//  Created by Zhao Zhicheng on 3/5/14.
//
//

#import "PrivateMessageDataRequest.h"

@implementation PrivateMessageDataRequest

- (NSString*)getRequestUrl{
    NSString *userId=[[NSUserDefaults standardUserDefaults] stringForKey:@"USER_ID"];
    return [REQUEST_DOMAIN stringByAppendingFormat:@"message/private/%@?",userId];
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

