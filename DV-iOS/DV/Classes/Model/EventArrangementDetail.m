//
//  EventArrangementDetail.m
//  DV
//
//  Created by Zhao Zhicheng on 1/20/14.
//
//

#import "EventArrangementDetail.h"

@implementation EventArrangementDetail
//TODO
- (NSDictionary*)attributeMapDictionary{
	return @{@"title": @"title"
             ,@"subTitle": @"tagline"
             ,@"time": @"time"
             ,@"eventArrangementDetailId": @"uuid"
             ,@"description": @"description"
             ,@"speaker": @"speaker"
             ,@"speakerIntro": @"speakerIntro"
             ,@"image": @"image"
             };
}

@end
