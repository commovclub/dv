//
//  ReadMessageDataRequest.m
//  DV
//
//  Created by Zhao Zhicheng on 3/6/14.
//
//

#import "ReadMessageDataRequest.h"

@implementation ReadMessageDataRequest

- (NSString*)getRequestUrl{
    return [REQUEST_DOMAIN stringByAppendingString:@"message/read/"];
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
