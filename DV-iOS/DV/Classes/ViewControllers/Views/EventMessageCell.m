//
//  TeachKnowledgeCell.m
//  Grammar
//
//  Created by Rick on 6/29/13.
//
//

#import "EventMessageCell.h"

@implementation EventMessageCell

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
- (void)awakeFromNib
{
    [super awakeFromNib];
    [_contentWebView setBackgroundColor:[UIColor clearColor]];
    [_contentWebView setOpaque:NO];

    _contentWebView.scrollView.showsHorizontalScrollIndicator = TRUE;
    _contentWebView.scrollView.showsVerticalScrollIndicator = TRUE;
//    _contentWebView.scrollView.scrollEnabled = FALSE;
    
}

- (void)setCellWithEventDetail:(EventDetail*)eventDetail WithRefresh:(BOOL)isRefrsh
{
//    if (isRefrsh) {
        
//    }
    _eventDetail = eventDetail;

//    _titleLabel.text = _currentExplain.title;
//    
//    NSDate * updateDate = [NSDate dateWithTimeIntervalSince1970:[[_currentExplain.lastUpdateTimeStamp substringToIndex:_currentExplain.lastUpdateTimeStamp.length -3]  doubleValue]] ;
//    NSString *updateString = [updateDate description];
//    _updateTimeLabel.text = [NSString stringWithFormat:@"%@最后编辑", [updateString substringToIndex:11]];
//    
//    if ([_currentExplain.content length] == 0) {
//        _contentWebView.height = 0;
//        [_contentWebView loadHTMLString:_currentExplain.content baseURL:nil];
//    }else {
//        [_contentWebView loadHTMLString:_currentExplain.content baseURL:nil];
//    }
    
//    [_contentWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:knowledge.url]]];
    _isFinishDownloaded = isRefrsh;
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {

    CGRect frame = webView.frame;
    frame.size.height = 1;
    webView.frame = frame;
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    webView.frame = frame;

    self.height = _contentWebView.bottom;
    if (_delegate && [_delegate respondsToSelector:@selector(loadIsDoneWitHeight:)] && _isFinishDownloaded) {
        [_delegate loadIsDoneWitHeight:self.height];
    }
    webView.scrollView.scrollEnabled = NO;
}

- (CGFloat)getCellHeight
{
    if (_isFinishDownloaded) {
        return self.height;
    }else {
        return 0;
    }
    
}

- (void)generateImageView
{
    CGFloat origientX = 0.0;
    
//    for (NSString *imageUrl in _currentExplain.imageArray) {
//        origientX += 10;
//        CGRect imageViewRect = CGRectMake(origientX, 10, 40, 40);
//        ITTImageView *imageView = [[ITTImageView alloc] initWithFrame:imageViewRect];
//        imageView.delegate = self;
//        [imageView setEnableTapEvent:YES];
//        imageView.contentMode = UIViewContentModeScaleAspectFit;
//        [imageView loadImage:imageUrl];
//        origientX += 40;
//        [_contentImageView addSubview:imageView];
//    }
}

- (void)imageClicked:(ITTImageView *)imageView
{
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectImageView:)]) {
        [_delegate didSelectImageView:imageView.imageUrl];
    }
}

@end
