//
//  GetNewsDataRequest.m
//  DV
//
//  Created by Zhao Zhicheng on 2/24/14.
//
//

#import "GetNewsDataRequest.h"

@implementation GetNewsDataRequest
- (NSString*)getRequestUrl{
    return [REQUEST_DOMAIN stringByAppendingString:@"info/"];
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
