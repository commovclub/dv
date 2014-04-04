//
//  InboxCell.m
//  HotWord
//
//  Created by Jack Liu on 13-5-25.
//
//

#import "InboxCell.h"

@interface InboxCell()

@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *isNewLabel;
@property (strong, nonatomic) IBOutlet UIView *viewBg;

@end

@implementation InboxCell

- (void)awakeFromNib
{
    UIView* backgroundView = [ [ UIView alloc ] initWithFrame:CGRectZero ];
    backgroundView.backgroundColor = [ UIColor clearColor ];
    self.backgroundView = backgroundView;
    self.viewBg.layer.masksToBounds = YES;
    self.viewBg.layer.cornerRadius = 3.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMessageData:(DVMessage *)message
{
    
    self.contentLabel.text = message.message;
    self.timeLabel.text = [UIUtil getStringWithDoubleDate:[message.createdAt doubleValue]];
    if ([message.status isEqualToString:@"new"]) {
        self.isNewLabel.hidden = NO;
    }else{
        self.isNewLabel.hidden = YES;
    }
}

@end
