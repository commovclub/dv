//
//  FollowedDataRequest.m
//  DV
//
//  Created by Zhao Zhicheng on 3/5/14.
//
//

#import "FollowedDataRequest.h"

@implementation FollowedDataRequest
- (NSString*)getRequestUrl{
    return [REQUEST_DOMAIN stringByAppendingString:@"member/"];
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

