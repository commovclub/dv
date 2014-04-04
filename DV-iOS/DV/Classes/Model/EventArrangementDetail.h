//
//  EventArrangementDetail.h
//  DV
//
//  Created by Zhao Zhicheng on 1/20/14.
//
//

#import <Foundation/Foundation.h>
#import "ITTBaseModelObject.h"

@interface EventArrangementDetail : ITTBaseModelObject

@property (nonatomic, strong)NSString *date;
@property (nonatomic, strong)NSString *time;
@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)NSString *subTitle;
@property (nonatomic, strong)NSString *enclosure;
@property (nonatomic, strong)NSString *eventArrangementDetailId;
@property (nonatomic, strong)NSString *description;
@property (nonatomic, strong)NSString *speaker;
@property (nonatomic, strong)NSString *speakerIntro;
@property (nonatomic, strong)NSString *image;
//section3
@property (nonatomic, retain)NSMutableArray *fileArray;
//section4
@property (nonatomic, retain)NSMutableArray *videoArray;
//section5
@property (nonatomic, retain)NSMutableArray *picArray;
@end
