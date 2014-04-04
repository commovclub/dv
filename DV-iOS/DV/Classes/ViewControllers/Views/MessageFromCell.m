//
//  MessageFromCell.m
//  HotWord
//
//  Created by Jack Liu on 8/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MessageFromCell.h"

#define MESSAGE_FROM_CONTENT_LABEL_WIDTH   175
#define MESSAGE_FROM_CONTENT_LABEL_MIN_HEIGHT   21
#define MESSAGE_FROM_CELL_MIN_HEIGHT   45

@interface MessageFromCell()

@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet UIImageView *talkBgView;
@property (strong, nonatomic) IBOutlet ITTImageView *headImageView;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@end

@implementation MessageFromCell

- (void)setMessage:(DVMessage *)message
{
    CGSize labelSize = [MessageFromCell getContentHeightByContent:message.message];
    self.contentLabel.height = labelSize.height;
    self.contentLabel.width = labelSize.width;
    self.talkBgView.width = labelSize.width + 50;
    self.talkBgView.height =self.contentLabel.height + 24;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[message.createdAt doubleValue]/1000];
    self.timeLabel.text = [date stringWithFormat:@"yyyy-MM-dd HH:mm"];
    self.contentLabel.text = message.message;
    [self.headImageView loadImage:message.fromMemberAvatar placeHolder:[UIImage imageNamed:@"head_boy_50.png"]];
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = 15.0f;
}


+ (CGSize)getContentHeightByContent:(NSString *)content
{
    CGSize labelSize = [content sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(MESSAGE_FROM_CONTENT_LABEL_WIDTH, 1000) lineBreakMode:UILineBreakModeWordWrap];
    if (labelSize.width < 45) {
        labelSize.width = 45;
    }
    if (labelSize.height < MESSAGE_FROM_CONTENT_LABEL_MIN_HEIGHT) {
        return CGSizeMake(labelSize.width, MESSAGE_FROM_CONTENT_LABEL_MIN_HEIGHT) ;
    }
    else {
        return labelSize;
    }
}

+ (CGFloat)getCellHeightByContent:(NSString *)content
{
    return MESSAGE_FROM_CELL_MIN_HEIGHT + [MessageFromCell getCellHeightByContent:content] - MESSAGE_FROM_CONTENT_LABEL_MIN_HEIGHT;
}

@end
