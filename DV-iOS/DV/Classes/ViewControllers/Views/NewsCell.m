//
//  NewsCell.m


#import "NewsCell.h"
#import "ITTImageView.h"
#import "DVImage.h"

#define ANSWER_CONTENT_LABEL_WIDTH 230
#define ANSWER_CELL_BASE_HEIGHT 41
#define ZERO_PIC @"0"
#define ONE_PIC @"1"
#define THREE_PIC @"3"


@interface NewsCell()

// no pic
@property (strong, nonatomic) IBOutlet UIView *view0;
@property (strong, nonatomic) IBOutlet UILabel *title0Label;
@property (strong, nonatomic) IBOutlet UILabel *content0Label;

@property (strong, nonatomic) IBOutlet UILabel *time0Label;
// one pic
@property (strong, nonatomic) IBOutlet UIView *view1;
@property (strong, nonatomic) IBOutlet UILabel *title1Label;
@property (strong, nonatomic) IBOutlet UILabel *time1Label;
@property (strong, nonatomic) IBOutlet ITTImageView *imageView11;
// threee pic
@property (strong, nonatomic) IBOutlet UIView *view3;
@property (strong, nonatomic) IBOutlet UILabel *title3Label;
@property (strong, nonatomic) IBOutlet UILabel *time3Label;
@property (strong, nonatomic) IBOutlet ITTImageView *imageView31;
@property (strong, nonatomic) IBOutlet ITTImageView *imageView32;
@property (strong, nonatomic) IBOutlet ITTImageView *imageView33;

@property (strong, nonatomic) IBOutlet UIView *bottomLineView;
@end


@implementation NewsCell

- (void)awakeFromNib
{

    
}

- (void)setNewsData:(News *)news
{
    self.news = news;
    if ([self.news.type isEqualToString:ZERO_PIC]) {
        self.view0.hidden = NO;
        self.view1.hidden = YES;
        self.view3.hidden = YES;
        self.time0Label.text = self.news.time;
        self.title0Label.text = self.news.title;
        self.content0Label.text = self.news.summary;
        /*
        NSString *content = self.news.content;
        if (content) {
            NSRange r;
            while ((r = [content rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
                content = [content stringByReplacingCharactersInRange:r withString:@""];
            self.content0Label.text = content;
        }
         */
        
    }else if ([self.news.type isEqualToString:ONE_PIC]) {
        self.view0.hidden = YES;
        self.view1.hidden = NO;
        self.view3.hidden = YES;
        self.time1Label.text = self.news.time;
        self.title1Label.text = self.news.title;
        if (self.news.path1) {
            [self.imageView11 loadImage:self.news.path1 placeHolder:[UIImage imageNamed:@"placeholder.png"]];
        }else{
            DVImage *dvImage = [self.news.images objectAtIndex:0];
            [self.imageView11 loadImage:dvImage.filePath placeHolder:[UIImage imageNamed:@"placeholder.png"]];
        }
        //TODO will remove 当前缩略图不能用
        //[self.imageView11 loadImage:news.image placeHolder:nil];
        self.imageView11.delegate = self;
        self.imageView11.enableTapEvent = YES;

    }else if ([self.news.type isEqualToString:THREE_PIC]) {
        self.view0.hidden = YES;
        self.view1.hidden = YES;
        self.view3.hidden = NO;
        self.time3Label.text = self.news.time;
        self.title3Label.text = self.news.title;
        if (self.news.path1) {
            [self.imageView31 loadImage:self.news.path1 placeHolder:[UIImage imageNamed:@"placeholder.png"]];
        }else{
            DVImage *dvImage = [self.news.images objectAtIndex:0];
            [self.imageView31 loadImage:dvImage.filePath placeHolder:[UIImage imageNamed:@"placeholder.png"]];
        }
        
        self.imageView31.delegate = self;
        self.imageView31.enableTapEvent = YES;
        if (self.news.path2) {
            [self.imageView32 loadImage:self.news.path2 placeHolder:[UIImage imageNamed:@"placeholder.png"]];
        }else{
            DVImage *dvImage = [self.news.images objectAtIndex:1];
            [self.imageView32 loadImage:dvImage.filePath placeHolder:[UIImage imageNamed:@"placeholder.png"]];
        }
        self.imageView32.delegate = self;
        self.imageView32.enableTapEvent = YES;
        if (self.news.path3) {
            [self.imageView33 loadImage:self.news.path3 placeHolder:[UIImage imageNamed:@"placeholder.png"]];
        }else{
            DVImage *dvImage = [self.news.images objectAtIndex:2];
            [self.imageView33 loadImage:dvImage.filePath placeHolder:[UIImage imageNamed:@"placeholder.png"]];
        }
        self.imageView33.delegate = self;
        self.imageView33.enableTapEvent = YES;
    }
    self.bottomLineView.bottom = self.height;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//+ (CGFloat)getCellHeightWithNews:(News *)news
//{
//    CGFloat height = [NewsCell getContentHeightWithNews:news];
//   
//    return height + ANSWER_CELL_BASE_HEIGHT;
//}

//+ (CGFloat)getContentHeightWithNews:(News *)news
//{
//    CGSize contentSize = [news.title sizeWithFont:13 constrainedToSize:CGSizeMake(ANSWER_CONTENT_LABEL_WIDTH, 70) lineBreakMode:UILineBreakModeWordWrap];
//    return contentSize.height;
//}

- (void)imageClicked:(ITTImageView *)imageView
{
    if([self.delegate respondsToSelector:@selector(imageDidSelected:)]) {
        [self.delegate imageDidSelected:self.news];
    }
}

@end
