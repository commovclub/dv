//
//  MessageToCell.m
//  HotWord
//
//  Created by Jack Liu on 8/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MessageToCell.h"

#define MESSAGE_TO_CONTENT_LABEL_WIDTH   175
#define MESSAGE_TO_CONTENT_LABEL_MIN_HEIGHT   21
#define MESSAGE_TO_CELL_MIN_HEIGHT   45

@interface MessageToCell()

@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet UIImageView *talkBgView;
@property (strong, nonatomic) IBOutlet ITTImageView *headImageView;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UIButton *failedBtn;
@property (strong, nonatomic) DVMessage *currentMessage;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *sendingActivity;

- (IBAction)tapOnResendBtn:(id)sender;

@end

@implementation MessageToCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMessage:(DVMessage *)message
{
    self.currentMessage = message;
    CGSize labelSize = [MessageToCell getContentHeightByContent:message.message];
    self.contentLabel.height = labelSize.height;
    self.contentLabel.width = labelSize.width;
    self.talkBgView.width = labelSize.width + 50;
    self.contentLabel.right = 246;
    self.talkBgView.right = 279;
    self.talkBgView.height = self.contentLabel.height + 24;
    self.failedBtn.right = self.contentLabel.left - 20;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[message.createdAt doubleValue]/1000];
    self.timeLabel.text = [date stringWithFormat:@"yyyy-MM-dd HH:mm"];
    self.contentLabel.text = message.message;
    [self.headImageView loadImage:message.fromMemberAvatar placeHolder:[UIImage imageNamed:@"head_boy_50.png"]];
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = 15.0f;
    if (message.isSentFailed) {
        self.failedBtn.hidden = NO;
    }
    else{
        self.failedBtn.hidden = YES;
    }
    if (message.isSending) {
        self.sendingActivity.hidden = NO;
        [self.sendingActivity startAnimating];
    }else{
        self.sendingActivity.hidden = YES;
        [self.sendingActivity stopAnimating];
    }
}


+ (CGSize)getContentHeightByContent:(NSString *)content
{
    CGSize labelSize = [content sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(MESSAGE_TO_CONTENT_LABEL_WIDTH, 1000) lineBreakMode:UILineBreakModeWordWrap];
    if (labelSize.width < 45) {
        labelSize.width = 45;
    }
    if (labelSize.height < MESSAGE_TO_CONTENT_LABEL_MIN_HEIGHT) {
        return CGSizeMake(labelSize.width, MESSAGE_TO_CONTENT_LABEL_MIN_HEIGHT);
    }
    else {
        return labelSize;
    }
}

+ (CGFloat)getCellHeightByContent:(NSString *)content
{
    return MESSAGE_TO_CELL_MIN_HEIGHT + [MessageToCell getContentHeightByContent:content].height - MESSAGE_TO_CONTENT_LABEL_MIN_HEIGHT;
}

- (IBAction)tapOnResendBtn:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(resendMessage:)]) {
        [self.delegate resendMessage:_currentMessage];
    }
}

@end
