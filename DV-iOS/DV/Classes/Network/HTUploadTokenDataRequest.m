//
//  HTUploadTokenDataRequest.m
//  HotWord
//
//  Created by Jack on 13-6-19.
//
//

#import "HTUploadTokenDataRequest.h"

@implementation HTUploadTokenDataRequest
- (NSString*)getRequestUrl{
    return [[self getRequestHost] stringByAppendingString:@"user/updateUserIOSToken.intf?"];
}

- (void)processResult
{
    [super processResult];
}
@end
