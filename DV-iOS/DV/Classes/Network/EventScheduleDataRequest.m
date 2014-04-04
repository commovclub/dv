//
//  EventScheduleDataRequest.m
//  DV
//
//  Created by Zhao Zhicheng on 2/27/14.
//
//

#import "EventScheduleDataRequest.h"

@implementation EventScheduleDataRequest
- (NSString*)getRequestUrl{
    return [REQUEST_DOMAIN stringByAppendingString:@"event/"];///event/{uuid}/schedule
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
