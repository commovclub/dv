//
//  SpeechCell.h
//

#import <UIKit/UIKit.h>
#import "EventDetail.h"
#import "ITTImageView.h"

@protocol SpeechCellDelegate;

@interface SpeechCell : UITableViewCell<ITTImageViewDelegate>

@property (nonatomic, strong) EventDetail *eventDetail;

- (void)setEventDetailData:(EventDetail *)eventDetail;

@property (nonatomic, weak)id <SpeechCellDelegate> delegate;

@end

@protocol SpeechCellDelegate <NSObject>

- (void)imageDidSelected:(EventDetail *)eventDetail;

@end