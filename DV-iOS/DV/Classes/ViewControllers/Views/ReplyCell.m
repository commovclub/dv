//
//  ReplyCell.m
//  
//
//  Created by zzc on 10/29/13.
//
//

#import "ReplyCell.h"

@interface ReplyCell()

@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UIView *hintView;
@property (strong, nonatomic) IBOutlet ITTImageView *imageView;
@property (strong, nonatomic) IBOutlet UIView *viewBg;

@end

@implementation ReplyCell

- (void)awakeFromNib
{
    UIView* backgroundView = [ [ UIView alloc ] initWithFrame:CGRectZero ];
    backgroundView.backgroundColor = [ UIColor whiteColor ];
    self.backgroundView = backgroundView;
    self.hintView.layer.masksToBounds = YES;
    self.hintView.layer.cornerRadius = 3.0f;
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = 25.0f;
    self.viewBg.layer.masksToBounds = YES;
    self.viewBg.layer.cornerRadius = 3.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setReplyData:(DVMessage*)message
{
    
    NSString *currentUserId = [[NSUserDefaults standardUserDefaults] stringForKey:@"USER_ID"];
    if ([currentUserId isEqualToString:message.fromMemberId]) {
        _nameLabel.text=message.toMemberName;
        [self.imageView loadImage:message.toMemberAvatar placeHolder:[UIImage imageNamed:@"head_boy_50.png"]];
    }else{
        _nameLabel.text=message.fromMemberName;
        [self.imageView loadImage:message.fromMemberAvatar placeHolder:[UIImage imageNamed:@"head_boy_50.png"]];
    }
    _contentLabel.text=message.message;
    _timeLabel.text = [UIUtil getShortStringWithDoubleDate:[message.createdAt doubleValue]];
   
    if([message.status isEqualToString:@"new"]){
        _hintView.hidden = NO;
    }else{
        _hintView.hidden = YES;
    }
    UIView* backgroundView = [ [ UIView alloc ] initWithFrame:CGRectZero ];
    backgroundView.backgroundColor = [ UIColor  clearColor];
    self.backgroundView = backgroundView;
    
}


@end
