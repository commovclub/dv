//
//  LoginDataRequest.m
//  DV
//
//  Created by Zhao Zhicheng on 2/26/14.
//
//

#import "LoginDataRequest.h"

@implementation LoginDataRequest

- (NSString*)getRequestUrl{
    return [REQUEST_DOMAIN stringByAppendingString:@"member/login?"];
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
