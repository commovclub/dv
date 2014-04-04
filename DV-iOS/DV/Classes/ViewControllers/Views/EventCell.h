//
//  EventCell.h
//

#import <UIKit/UIKit.h>
#import "Event.h"
#import "ITTImageView.h"

@protocol EventCellDelegate;

@interface EventCell : UITableViewCell<ITTImageViewDelegate>

@property (nonatomic, retain) Event *event;

- (void)setEventData:(Event *)event;
@property (nonatomic, assign)id <EventCellDelegate> delegate;

@end

@protocol EventCellDelegate <NSObject>

- (void)imageDidSelected:(Event *)event;

@end