//
//  WorkCell.h
//

#import <UIKit/UIKit.h>
#import "Work.h"
#import "DVImage.h"
#import "ITTImageView.h"

@protocol WorkCellDelegate;

@interface WorkCell : UITableViewCell<ITTImageViewDelegate>

@property (nonatomic, strong) Work *work;

- (void)setWorkData:(Work *)work;
- (void)setWorkData:(Work *)work  otherUser:(bool)otherUser;

@property (nonatomic, weak)id <WorkCellDelegate> delegate;

@end

@protocol WorkCellDelegate <NSObject>

- (void)deleteWork:(Work *)work;

@end