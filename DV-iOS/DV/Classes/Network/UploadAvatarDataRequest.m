//
//  UploadAvatarDataRequest.m
//  DV
//
//  Created by Zhao Zhicheng on 3/3/14.
//
//

#import "UploadAvatarDataRequest.h"

@implementation UploadAvatarDataRequest

- (NSString*)getRequestUrl{
    return @"";
}

- (void)processResult
{
    [super processResult];
}

- (ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodMultipartPost;
}

@end
