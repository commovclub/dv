//
//  SendMessageDataRequest.m
//  DV
//
//  Created by Zhao Zhicheng on 3/5/14.
//
//

#import "SendMessageDataRequest.h"

@implementation SendMessageDataRequest
- (NSString*)getRequestUrl{
    return [REQUEST_DOMAIN stringByAppendingString:@"message/send/{token}/{memberId}"];
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

