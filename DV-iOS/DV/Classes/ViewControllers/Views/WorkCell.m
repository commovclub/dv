//
//  WorkCell.m


#import "WorkCell.h"
#import "ITTImageView.h"
#import "DoPhotoCell.h"
#import "ITTImageView.h"
#import "SJAvatarBrowser.h"
#import "UIImageView+MJWebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
@interface WorkCell(){
    NSMutableArray *_urls;
}

@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *descLabel;
@property (strong, nonatomic) IBOutlet UIView *bottomLineView;
@property (strong, nonatomic) IBOutlet UIView *view0;//一张图片
@property (strong, nonatomic) IBOutlet UIView *view1;//2-3图片
@property (strong, nonatomic) IBOutlet UIView *view2;//4-6图片
@property (strong, nonatomic) IBOutlet UIView *view3;//7-9图片
@property (strong, nonatomic) IBOutlet UIView *viewBg;
@property (strong, nonatomic) IBOutlet UIView *viewTime;
@property (strong, nonatomic) IBOutlet ITTImageView *iv0;
@property (strong, nonatomic) IBOutlet ITTImageView *iv1;
@property (strong, nonatomic) IBOutlet ITTImageView *iv2;
@property (strong, nonatomic) IBOutlet ITTImageView *iv3;
@property (strong, nonatomic) IBOutlet ITTImageView *iv4;
@property (strong, nonatomic) IBOutlet ITTImageView *iv5;
@property (strong, nonatomic) IBOutlet ITTImageView *iv6;
@property (strong, nonatomic) IBOutlet ITTImageView *iv7;
@property (strong, nonatomic) IBOutlet ITTImageView *iv8;
@property (strong, nonatomic) IBOutlet ITTImageView *iv9;
@property (strong, nonatomic) IBOutlet UIButton *deleteButton;

@end


@implementation WorkCell


- (void)setWorkData:(Work *)work otherUser:(bool)otherUser{
    self.deleteButton.hidden = YES;
    [self setWorkData:work];
}

- (void)setWorkData:(Work *)work
{
    //白色背景圆角
    self.viewBg.layer.masksToBounds = YES;
    self.viewBg.layer.cornerRadius = 4.0f;
    
    self.work = work;
    self.iv0.delegate = self;
    self.iv0.enableTapEvent = YES;
    self.iv1.delegate = self;
    self.iv1.enableTapEvent = YES;
    self.iv2.delegate = self;
    self.iv2.enableTapEvent = YES;
    self.iv3.delegate = self;
    self.iv3.enableTapEvent = YES;
    self.iv4.delegate = self;
    self.iv4.enableTapEvent = YES;
    self.iv5.delegate = self;
    self.iv5.enableTapEvent = YES;
    self.iv6.delegate = self;
    self.iv6.enableTapEvent = YES;
    self.iv7.delegate = self;
    self.iv7.enableTapEvent = YES;
    self.iv8.delegate = self;
    self.iv8.enableTapEvent = YES;
    self.iv9.delegate = self;
    self.iv9.enableTapEvent = YES;
    NSMutableArray *files = work.files;
    //描述高度
    CGSize maximumLabelSize = CGSizeMake(290, CGFLOAT_MAX);
    CGRect textRect = [work.description boundingRectWithSize:maximumLabelSize
                                                     options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}
                                                     context:nil];

    
    self.descLabel.frame =CGRectMake(15, 5, 290, textRect.size.height+10);
    self.descLabel.text = self.work.description;
    self.viewTime.frame = (CGRect){ { 15, 14+textRect.size.height }, self.viewTime.size};
    self.timeLabel.text = [UIUtil getShortStringWithDoubleDate:[self.work.createdAt doubleValue]];
    [self.iv0 loadImage:nil];
    [self.iv1 loadImage:nil];
    [self.iv2 loadImage:nil];
    [self.iv3 loadImage:nil];
    [self.iv4 loadImage:nil];
    [self.iv5 loadImage:nil];
    [self.iv6 loadImage:nil];
    [self.iv7 loadImage:nil];
    [self.iv8 loadImage:nil];
    [self.iv9 loadImage:nil];

    if ([files count]==1) {
        self.view0.hidden = NO;
        self.view1.hidden = YES;
        self.view2.hidden = YES;
        self.view3.hidden = YES;
        DVImage *image = [files objectAtIndex:0];
        [self.iv0 loadImage:image.filePath];
        self.view0.frame = (CGRect){ { 10, 40+textRect.size.height }, self.view0.size};
    }else if([files count]<=3){
        self.view0.hidden = YES;
        self.view1.hidden = NO;
        self.view2.hidden = YES;
        self.view3.hidden = YES;
        self.view1.frame = (CGRect){ { 10, 45+textRect.size.height }, self.view1.size};
        for (int i=0; i<[files count]; i++) {
            DVImage *image = [files objectAtIndex:i];
            if (image) {
                switch (i) {
                    case 0:
                        [self.iv1 loadImage:image.filePath];
                        break;
                    case 1:
                        [self.iv2 loadImage:image.filePath];
                        break;
                    case 2:
                        [self.iv3 loadImage:image.filePath];
                        break;
                    default:
                        break;
                }
            }
        }
        
    }else if([files count]<=6){
        self.view0.hidden = YES;
        self.view1.hidden = NO;
        self.view2.hidden = NO;
        self.view3.hidden = YES;
        self.view1.frame = (CGRect){ { 10, 45+textRect.size.height }, self.view1.size};
        self.view2.frame = (CGRect){ { 10, 45+textRect.size.height+66 }, self.view2.size};
        for (int i=0; i<[files count]; i++) {
            DVImage *image = [files objectAtIndex:i];
            if (image) {
                switch (i) {
                    case 0:
                        [self.iv1 loadImage:image.filePath];
                        break;
                    case 1:
                        [self.iv2 loadImage:image.filePath];
                        break;
                    case 2:
                        [self.iv3 loadImage:image.filePath];
                        break;
                    case 3:
                        [self.iv4 loadImage:image.filePath];
                        break;
                    case 4:
                        [self.iv5 loadImage:image.filePath];
                        break;
                    case 5:
                        [self.iv6 loadImage:image.filePath];
                        break;
                    default:
                        break;
                }
            }
        }
        
    }else if([files count]<=9){
        self.view0.hidden = YES;
        self.view1.hidden = NO;
        self.view2.hidden = NO;
        self.view3.hidden = NO;
        self.view1.frame = (CGRect){ { 10, 45+textRect.size.height }, self.view1.size};
        self.view2.frame = (CGRect){ { 10, 45+textRect.size.height+66 }, self.view2.size};
        self.view3.frame = (CGRect){ { 10, 45+textRect.size.height+66+66 }, self.view3.size};
        for (int i=0; i<[files count]; i++) {
            DVImage *image = [files objectAtIndex:i];
            if (image) {
                switch (i) {
                    case 0:
                        [self.iv1 loadImage:image.filePath];
                        break;
                    case 1:
                        [self.iv2 loadImage:image.filePath];
                        break;
                    case 2:
                        [self.iv3 loadImage:image.filePath];
                        break;
                    case 3:
                        [self.iv4 loadImage:image.filePath];
                        break;
                    case 4:
                        [self.iv5 loadImage:image.filePath];
                        break;
                    case 5:
                        [self.iv6 loadImage:image.filePath];
                        break;
                    case 6:
                        [self.iv7 loadImage:image.filePath];
                        break;
                    case 7:
                        [self.iv8 loadImage:image.filePath];
                        break;
                    case 8:
                        [self.iv9 loadImage:image.filePath];
                        break;
                    default:
                        break;
                }
            }
        }
    }
    _urls =[[NSMutableArray alloc] init];
    for (int i=0; i<[work.files count]; i++) {
        DVImage *image = [files objectAtIndex:i];
        [_urls addObject:image.filePath];
    }
}

- (IBAction)tapOnDeleteBtn:(id)sender {
    if([self.delegate respondsToSelector:@selector(deleteWork:)]) {
        [self.delegate deleteWork:self.work];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)imageClicked:(ITTImageView *)imageView
{
    //[SJAvatarBrowser showImage:imageView];
    int count = _urls.count;
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {
        // 替换为中等尺寸图片
        NSString *url = [_urls[i] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:url]; // 图片路径
        photo.srcImageView = imageView; // 来源于哪个UIImageView
        [photos addObject:photo];
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    if (imageView.tag<count) {
        browser.currentPhotoIndex = imageView.tag; // 弹出相册时显示的第一张图片是？
    }else{
        browser.currentPhotoIndex = 0;
    }
    browser.photos = photos; // 设置所有的图片
    [browser show];

}


@end
