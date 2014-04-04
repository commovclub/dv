//
//  ContactCell.m


#import "ContactCell.h"
#import "ITTImageView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ContactCell()

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *descLabel;
@property (strong, nonatomic) IBOutlet ITTImageView *imageViewAvatar;
@property (strong, nonatomic) IBOutlet UIView *bottomLineView;
@end


@implementation ContactCell

- (void)awakeFromNib
{
    
}

- (void)setContactData:(Contact *)contact
{
    self.contact = contact;
    //self.descLabel.text = self.contact.career;
     self.descLabel.text = self.contact.desc;
    if (self.contact.career&&[self.contact.career length]>0) {
        self.nameLabel.text =[NSString stringWithFormat:@"%@ ( %@ )",self.contact.name,self.contact.career] ;
    }else{
        self.nameLabel.text = self.contact.name;
    }
    self.imageViewAvatar.layer.masksToBounds = YES;
    self.imageViewAvatar.layer.cornerRadius = 33.0f;
    [self.imageViewAvatar loadImage:self.contact.avatar placeHolder:[UIImage imageNamed:@"head_boy_50.png"]];
    self.imageViewAvatar.delegate = self;
    self.imageViewAvatar.enableTapEvent = YES;

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
        [self.delegate imageDidSelected:self.contact];
    }
}

@end
