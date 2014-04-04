//
//  HTFeedbackDataRequest.m
//  HotWord
//
//  Created by Jack on 13-6-17.
//
//

#import "HTFeedbackDataRequest.h"

@implementation HTFeedbackDataRequest
- (NSString*)getRequestUrl{
    return [[self getRequestHost] stringByAppendingString:@"soft/feedback.intf?"];
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
