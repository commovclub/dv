//
//  Work.m
//  DV
//
//  Created by Zhao Zhicheng on 3/8/14.
//
//

#import "Work.h"

@implementation Work

- (NSDictionary*)attributeMapDictionary{
	return @{ @"title": @"title"
              ,@"uuid": @"uuid"
              ,@"memberId": @"memberId"
              ,@"createdAt": @"createdAt"
              ,@"description": @"description"
              };
}

@end
