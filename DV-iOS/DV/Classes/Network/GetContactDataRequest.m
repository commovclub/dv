//
//  GetContactDataRequest.m
//  DV
//
//  Created by Zhao Zhicheng on 2/25/14.
//
//

#import "GetContactDataRequest.h"

@implementation GetContactDataRequest
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

