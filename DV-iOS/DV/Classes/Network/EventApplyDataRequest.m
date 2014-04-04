//
//  EventApplyDataRequest.m
//  DV
//
//  Created by Zhao Zhicheng on 2/27/14.
//
//

#import "EventApplyDataRequest.h"

@implementation EventApplyDataRequest

- (NSString*)getRequestUrl{
    return [REQUEST_DOMAIN stringByAppendingString:@"event/b6576a5f-c2a3-46ee-ac7a-c4e4502e1847/test_token/apply"];//event/{uuid}/{token}/apply
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

