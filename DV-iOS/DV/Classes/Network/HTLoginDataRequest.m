//
//  HTLoginDataRequest.m
//  HotWord
//
//  Created by Jack Liu on 13-5-25.
//
//

#import "HTLoginDataRequest.h"
#import "MessageManager.h"

@implementation HTLoginDataRequest

- (NSString*)getRequestUrl{
    return [[self getRequestHost] stringByAppendingString:@"user/login.intf?"];
}

- (void)processResult
{
    [super processResult];
}
@end
