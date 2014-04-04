//
//  EventTimeCell.m


#import "EventTimeCell.h"
#import "ITTImageView.h"


@interface EventTimeCell()

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UIView *colorLineView;
@property (strong, nonatomic) IBOutlet UIView *bottomLineView;

@property (strong, nonatomic) IBOutlet UIButton *moreButton;

@end


@implementation EventTimeCell

- (void)awakeFromNib
{
    
}

- (void)setEventData:(EventArrangementDetail *)eventArrangementDetail index:(NSInteger)index
{
    self.eventArrangementDetail = eventArrangementDetail;
    self.timeLabel.text = self.eventArrangementDetail.time;
    self.titleLabel.text = self.eventArrangementDetail.title;
    self.subTitleLabel.text = self.eventArrangementDetail.subTitle;
    self.bottomLineView.bottom = self.height;
    switch (index%4) {
        case 0:
            self.colorLineView.backgroundColor = [UIColor colorWithRed:236.0/255.0 green:86.0/255.0 blue:74.0/255.0 alpha:0.75];
            break;
        case 1:
            self.colorLineView.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:155.0/255.0 blue:63.0/255.0 alpha:0.75];
            break;
        case 2:
            self.colorLineView.backgroundColor = [UIColor colorWithRed:143.0/255.0 green:119.0/255.0 blue:177.0/255.0 alpha:0.75];
            break;
        case 3:
            self.colorLineView.backgroundColor = [UIColor colorWithRed:115.0/255.0 green:173.0/255.0 blue:97.0/255.0 alpha:0.75];
            break;
        default:
            break;
    }
    NSString *speaker = self.eventArrangementDetail.speaker;
    if (speaker&&[speaker length]>0) {
        self.moreButton.hidden = NO;
        self.titleLabel.frame = CGRectMake(self.titleLabel.origin.x, self.titleLabel.origin.y, self.titleLabel.size.width-50, self.titleLabel.size.height);
        self.subTitleLabel.frame = CGRectMake(self.subTitleLabel.origin.x, self.subTitleLabel.origin.y, self.subTitleLabel.size.width-50, self.subTitleLabel.size.height);
    }else{
        self.moreButton.hidden = YES;
    }

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)tapOnMoreBtn:(id)sender 
{
    if([self.delegate respondsToSelector:@selector(moreDidSelected:)]) {
        [self.delegate moreDidSelected:self.eventArrangementDetail];
    }
}
    
@end
