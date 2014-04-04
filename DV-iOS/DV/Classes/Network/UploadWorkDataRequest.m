//
//  UploadWorkDataRequest.m
//  DV
//
//  Created by Zhao Zhicheng on 3/8/14.
//
//

#import "UploadWorkDataRequest.h"

@implementation UploadWorkDataRequest

- (NSString*)getRequestUrl{
    NSString *userId=[[NSUserDefaults standardUserDefaults] stringForKey:@"USER_ID"];
    return [REQUEST_DOMAIN stringByAppendingFormat:@"portfolio/upload/%@",userId];
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
