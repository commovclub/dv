//
//  NewsCell.h
//

#import <UIKit/UIKit.h>
#import "News.h"
#import "ITTImageView.h"

@protocol NewsCellDelegate;

@interface NewsCell : UITableViewCell<ITTImageViewDelegate>

@property (nonatomic, strong) News *news;

- (void)setNewsData:(News *)news;
+ (CGFloat)getCellHeightWithNews:(News *)news;
@property (nonatomic, weak)id <NewsCellDelegate> delegate;

@end

@protocol NewsCellDelegate <NSObject>

- (void)imageDidSelected:(News *)news;

@end