//
//  DeleteWorkDataRequest.m
//  DV
//
//  Created by Zhao Zhicheng on 3/8/14.
//
//

#import "DeleteWorkDataRequest.h"

@implementation DeleteWorkDataRequest

- (NSString*)getRequestUrl{
    //作品id
    NSString *wrokId=@"";
    return [REQUEST_DOMAIN stringByAppendingFormat:@"/portfolio/delete/%@",wrokId];
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

