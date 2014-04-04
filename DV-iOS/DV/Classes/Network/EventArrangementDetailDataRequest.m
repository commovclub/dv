//
//  EventArrangementDetailDataRequest.m
//  DV
//
//  Created by Zhao Zhicheng on 3/5/14.
//
//

#import "EventArrangementDetailDataRequest.h"

@implementation EventArrangementDetailDataRequest
- (NSString*)getRequestUrl{
    return [REQUEST_DOMAIN stringByAppendingString:@"event/"];///event/b6576a5f-c2a3-46ee-ac7a-c4e4502e1847/schedule/
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

