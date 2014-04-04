//
//  RemoveFollowDataRequest.m
//  DV
//
//  Created by Zhao Zhicheng on 3/6/14.
//
//

#import "RemoveFollowDataRequest.h"

@implementation RemoveFollowDataRequest

- (NSString*)getRequestUrl{
    return [REQUEST_DOMAIN stringByAppendingString:@"member/"];
}

- (void)processResult
{
    [super processResult];
}

- (ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodPost;
}

@end

