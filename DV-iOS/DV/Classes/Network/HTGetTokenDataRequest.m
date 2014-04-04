//
//  HTGetTokenDataRequest.m
//  HHU MBA
//
//  Created by zzc on 9/23/13.
//
//

#import "HTGetTokenDataRequest.h"

@implementation HTGetTokenDataRequest
- (NSString*)getRequestUrl{
    return [REQUEST_DOMAIN stringByAppendingString:@"device/register?"];
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
