//
//  EventArrangement.m
//  DV
//
//  Created by Zhao Zhicheng on 1/20/14.
//
//

#import "EventArrangement.h"
#import "EventArrangementDetail.h"
@implementation EventArrangement
//TODO
- (NSDictionary*)attributeMapDictionary{
	return @{@"topText": @"header"
             ,@"bottomText": @"footer"
             };
}

+ (NSArray *)getDumpData
{
    NSMutableArray *eventArray = [NSMutableArray array];
    for (int i = 0; i < 3; i++) {
        EventArrangement *event = [[EventArrangement alloc] init];
        if (i==0) {
            event.topText = @"2014-01-17 星期五";
            event.bottomText = @"酒水免费，请大家按时到达，谢谢！";
        }
        else if (i==1) {
            event.topText = @"2014-01-18 星期六";
            event.bottomText = @"大家自备干粮，按时到达，谢谢！";
        }
        else{
            event.topText = @"2014-01-19 星期日";
            event.bottomText = @"谢谢！ looooooooooooooooooooooooog   looooooooooooooooog";
        }
       
        
        NSMutableArray *eventArrangemntDetailArray = [NSMutableArray array];
        for (int j=0; j<6; j++) {
            EventArrangementDetail *eventArrangementDetail = [[EventArrangementDetail alloc] init];
            eventArrangementDetail.time =[NSString stringWithFormat:@"%i:00PM",j+2];
           
            if (j%3==1) {
                eventArrangementDetail.enclosure = @"YES";
                eventArrangementDetail.title = @"董事长致辞董事长致辞董事长致辞董事长致辞";
                eventArrangementDetail.subTitle = @"演讲人：张苇演讲人：张苇演讲人：张苇演讲人：张苇";
            }
            else if (j%3==2) {
                eventArrangementDetail.enclosure = @"NO";
                eventArrangementDetail.title = @"董事长致辞董事长致辞董事长致辞董事长致辞";
                eventArrangementDetail.subTitle = @"演讲人：张苇演讲人：张苇演讲人：张苇演讲人：张苇";
            }
            else{
                eventArrangementDetail.enclosure = @"NO";
                eventArrangementDetail.title = @"董事长致辞";
                eventArrangementDetail.subTitle = @"演讲人：张苇";
            }
            [eventArrangemntDetailArray addObject:eventArrangementDetail];
        }
        event.eventArrangemntDetailArray = eventArrangemntDetailArray;
        [eventArray addObject:event];
    }
    return eventArray;
}

@end
