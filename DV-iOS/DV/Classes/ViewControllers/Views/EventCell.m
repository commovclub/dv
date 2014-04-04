//
//  EventCell.m


#import "EventCell.h"
#import "ITTImageView.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface EventCell()

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet ITTImageView *imageViewEvent;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewTick;

@property (strong, nonatomic) IBOutlet UIView *bottomLineView;
@end


@implementation EventCell

- (void)awakeFromNib
{
    
}

- (void)setEventData:(Event *)event
{
    self.event = event;
    self.timeLabel.text = self.event.time;
    self.titleLabel.text = self.event.title;
    self.subTitleLabel.text = [NSString stringWithFormat:@"报名人数：%@",self.event.subTitle];
    [self.imageViewEvent loadImage:self.event.path placeHolder:[UIImage imageNamed:@"placeholder.png"]];
    self.imageViewEvent.delegate = self;
    self.imageViewEvent.enableTapEvent = YES;
    self.bottomLineView.bottom = self.height;
//    if ([event hasApplied]) {
//        self.imageViewTick.hidden = NO;
//    }else{
//        self.imageViewTick.hidden = YES;
//    }
    self.imageViewTick.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)imageClicked:(ITTImageView *)imageView
{
    if([self.delegate respondsToSelector:@selector(imageDidSelected:)]) {
        [self.delegate imageDidSelected:self.event];
    }
}

@end
