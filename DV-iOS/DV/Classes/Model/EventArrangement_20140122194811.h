//
//  EventArrangement.h
//  DV
//
//  Created by Zhao Zhicheng on 1/20/14.
//
//

#import <Foundation/Foundation.h>
#import "ITTBaseModelObject.h"
#import "EventArrangementDetail.h"

@interface EventArrangement : ITTBaseModelObject
@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)NSString *topText;
@property (nonatomic, strong)NSString *bottomText;
@property (nonatomic, strong)NSString *eventArrangementId;
@property (nonatomic, strong)NSMutableArray *eventArrangemntDetailArray;


@end
