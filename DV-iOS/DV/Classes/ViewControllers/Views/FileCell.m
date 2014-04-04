//
//  FielCell.m


#import "FileCell.h"
#import "ITTImageView.h"
#import "SJAvatarBrowser.h"

@interface FileCell()

@property (strong, nonatomic) IBOutlet UILabel *fileNameLabel;

@property (strong, nonatomic) IBOutlet UIView *bottomLineView;
@property (strong, nonatomic) IBOutlet UIView *picView;
@property (strong, nonatomic) IBOutlet ITTImageView *picImageView;
@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;
@property ( nonatomic) NSInteger type;
@property (nonatomic, retain) DVFile *file;

@end


@implementation FileCell

- (void)awakeFromNib
{
    
}

- (void)setFileData:(DVFile *)file type:(NSInteger)type
{
    self.fileNameLabel.text = file.name;
    self.type = type;
    self.file = file;
    switch (type) {
        case 1://pdf
            [self.iconImageView setImage:[UIImage imageNamed:@"pdf"]];
            break;
        case 2://video
            [self.iconImageView setImage:[UIImage imageNamed:@"video"]];
            break;
        case 3://pic
            self.iconImageView.hidden = YES;
            self.picView.hidden = NO;
            self.fileNameLabel.hidden = YES;
            [self.picImageView loadImage:self.file.path placeHolder:[UIImage imageNamed:@"p2.png"]];
            self.picImageView.delegate = self;
            self.picImageView.enableTapEvent = YES;
            
            break;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    //[super setSelected:selected animated:animated];
}

- (void)imageClicked:(ITTImageView *)imageView
{
    if (self.type==3) {
        [SJAvatarBrowser showImage:imageView];
    }
}

@end
