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
@property (nonatomic, retain)NSString *topText;
@property (nonatomic, retain)NSString *bottomText;
@property (nonatomic, retain)NSString *eventArrangementId;
@property (nonatomic, retain)NSMutableArray *eventArrangemntDetailArray;


@end
