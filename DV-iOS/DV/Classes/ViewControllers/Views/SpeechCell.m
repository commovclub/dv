//
//  SpeechCell.m


#import "SpeechCell.h"
#import "ITTImageView.h"

@interface SpeechCell()

// one pic
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *descLabel;
@property (strong, nonatomic) IBOutlet ITTImageView *imageView;
@property (strong, nonatomic) IBOutlet UIView *avatarBg;
@property (strong, nonatomic) IBOutlet UIView *bottomLineView;
@end


@implementation SpeechCell

- (void)awakeFromNib
{
    
}

- (void)setEventDetailData:(EventDetail *)eventDetail
{
    self.eventDetail = eventDetail;
    self.descLabel.text = @"软件工程师，曾就职于xxx";
    self.nameLabel.text = self.eventDetail.name;
    
    self.avatarBg.layer.masksToBounds = YES;
    self.avatarBg.layer.cornerRadius = 30.0f;
    
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = 25.0f;
    
    //[self.imageView loadImage:self.contact.path placeHolder:[UIImage imageNamed:@"head_boy_50.png"]];
    self.imageView.delegate = self;
    self.imageView.enableTapEvent = YES;
    self.bottomLineView.bottom = self.height;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)imageClicked:(ITTImageView *)imageView
{
    if([self.delegate respondsToSelector:@selector(imageDidSelected:)]) {
        [self.delegate imageDidSelected:self.eventDetail];
    }
}

@end
