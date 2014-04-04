//
//  EventTimeCell.h
//

#import <UIKit/UIKit.h>
#import "Event.h"
#import "ITTImageView.h"
#import "EventArrangementDetail.h"

@protocol EventTimeCellDelegate;

@interface EventTimeCell : UITableViewCell<ITTImageViewDelegate>

@property (nonatomic, strong) EventArrangementDetail *eventArrangementDetail;

- (void)setEventData:(EventArrangementDetail *)eventArrangementDetail index:(NSInteger)index;
@property (nonatomic, weak)id <EventTimeCellDelegate> delegate;

@end

@protocol EventTimeCellDelegate <NSObject>

- (void)moreDidSelected:(EventArrangementDetail *)eventArrangementDetail;

@end