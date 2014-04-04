//
//  TeachKnowledgeCell.h
//  Grammar
//
//  Created by Rick on 6/29/13.
//
//

#import <UIKit/UIKit.h>
#import "ITTImageView.h"
#import "EventDetail.h"

@protocol TeachKnowledgeCellDelegate <NSObject>

- (void)loadIsDoneWitHeight:(CGFloat)height;
- (void)didSelectImageView:(NSString*)imageUrl;

@end
@interface EventMessageCell : UITableViewCell<ITTImageViewDelegate>
{
    EventDetail *_eventDetail;
}
@property (retain, nonatomic) IBOutlet UIView *contentImageView;
@property (assign, nonatomic) id<TeachKnowledgeCellDelegate>delegate;
@property (retain, nonatomic) IBOutlet UIWebView *contentWebView;
@property (nonatomic) BOOL isFinishDownloaded;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UILabel *updateTimeLabel;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

- (void)setCellWithEventDetail:(EventDetail*)eventDetail WithRefresh:(BOOL)isRefrsh;
- (CGFloat)getCellHeight;
@end