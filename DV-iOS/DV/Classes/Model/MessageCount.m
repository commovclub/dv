//
//  MessageCount.m
//  DV
//
//  Created by Zhao Zhicheng on 3/12/14.
//
//

#import "MessageCount.h"

@implementation MessageCount
- (NSDictionary*)attributeMapDictionary{
    
	return @{@"systemCount": @"systemCount"
             ,@"leadCount": @"leadCount"
             ,@"privateCount": @"privateCount"
             };
}
@end
