//
//  GetEventDataRequest.m
//  DV
//
//  Created by Zhao Zhicheng on 2/25/14.
//
//

#import "GetEventDataRequest.h"

@implementation GetEventDataRequest
- (NSString*)getRequestUrl{
    return [REQUEST_DOMAIN stringByAppendingString:@"event/"];
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
