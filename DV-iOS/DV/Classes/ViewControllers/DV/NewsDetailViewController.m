//
//  NewsDetailViewController.m
//  DV
//
//  Created by Zhao Zhicheng on 1/3/14.
//
//

#import "NewsDetailViewController.h"
#import "AppDelegate.h"
#import "News.h"
#import "ITTDataRequestManager.h"
#import "DVImage.h"
#import "UMSocial.h"
#import "UMSocialScreenShoter.h"

@interface NewsDetailViewController (){
    NSMutableArray *_favoriteArray;
}
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UIButton *favoriteButton;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) News *news;
@property (nonatomic) BOOL favorite;

@property (strong, nonatomic) NSMutableArray *_contactArray;
@property (nonatomic) NSInteger index;
@end

@implementation NewsDetailViewController

- (id)initWithNews:(NSMutableArray *)contactArray index:(NSInteger)index
{
    self = [super init];
    if (self) {
        self.index = index;
        self._contactArray = contactArray;
        self.news = [self._contactArray objectAtIndex:self.index];
    }
    return self;
}

- (id)initWithNews:(News *)news favorite:(BOOL)favorite{
    self = [super init];
    if (self) {
        self.news = news;
        self.favorite = favorite;
    }
    return self;
}

- (id)initWithNews:(News *)news{
    self = [super init];
    if (self) {
        self.news = news;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.titleLabel.text = self.news.title;
    self.timeLabel.text = self.news.time;
    //初始化收藏状态，对比本地已经收藏的数据
    _favoriteArray = [News searchWithWhere:nil orderBy:nil offset:0 count:200];
    if (_favoriteArray&&[_favoriteArray count]>0) {
        for (News* obj in _favoriteArray) {
            if ([self.news.newsId isEqualToString:obj.newsId]) {
                self.news.isFavorite = YES;
                break;
            }
        }
    }
    if (self.news.isFavorite&&self.news.isFavorite) {
        [self.favoriteButton setImage:[UIImage imageNamed:@"favorite_selected.png"] forState:UIControlStateNormal];
    }else{
        [self.favoriteButton setImage:[UIImage imageNamed:@"favorite_unselected.png"] forState:UIControlStateNormal];
    }
    self.webView.dataDetectorTypes = UIDataDetectorTypeAll;
    //有时会显示不全两行，估计是html代码问题，暂时解决办法
    [self.webView loadHTMLString:[self.news.content stringByAppendingString:@"<br><br>"] baseURL:nil];
    if (!self.favorite) {
        [self sendGetNews];
    }
}

- (void)sendGetNews
{
    [GetNewsDataRequest requestWithDelegate:self withParameters:nil withUrl:[[REQUEST_DOMAIN stringByAppendingString:@"info/"] stringByAppendingFormat:@"%@",self.news.newsId]];
    
    [[HTActivityIndicator currentIndicator] displayActivity:@"加载中..."];
}

- (void)requestDidFinishLoad:(ITTBaseDataRequest*)request
{
    if ([request isSuccess]) {
        News *tempNews = self.news;
        self.news =[[News alloc] initWithDataDic:request.resultDic];
        self.news.type = tempNews.type;
        self.news.time = tempNews.time;
        self.news.isFavorite = tempNews.isFavorite;
        if ([tempNews.images count]>0) {
            DVImage *dvImage = [tempNews.images objectAtIndex:0];
            self.news.path1 = dvImage.filePath;
        }
        if ([tempNews.images count]>2) {
            DVImage *dvImage = [tempNews.images objectAtIndex:1];
            self.news.path2 = dvImage.filePath;
            dvImage = [tempNews.images objectAtIndex:2];
            self.news.path3 = dvImage.filePath;
        }
        [self.webView loadHTMLString:[self.news.content stringByAppendingString:@"<br><br><br><br><br>"] baseURL:nil];
        if (self.news.isFavorite) {
            [self.favoriteButton setImage:[UIImage imageNamed:@"favorite_selected.png"] forState:UIControlStateNormal];
        }else{
            [self.favoriteButton setImage:[UIImage imageNamed:@"favorite_unselected.png"] forState:UIControlStateNormal];
        }
        
        [[HTActivityIndicator currentIndicator] hide];
    }else{
        [[HTActivityIndicator currentIndicator] displayMessage:request.result.message];
    }
}


- (void)request:(ITTBaseDataRequest*)request didFailLoadWithError:(NSError*)error
{
    [[HTActivityIndicator currentIndicator] displayMessage:@"网络不佳，请检查网络!"];
}


// Add this method
- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[AppDelegate shareAppdelegate].homeTabbarController hideTabBarAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [[HTActivityIndicator currentIndicator] hide];
}

- (IBAction)tapOnBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)tapOnRefreshBtn:(id)sender {
    [self sendGetNews];
}

- (IBAction)tapOnShareBtn:(id)sender {
    NSString *content = self.news.content;
    if (content) {
        NSRange r;
        while ((r = [content rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
            content = [content stringByReplacingCharactersInRange:r withString:@""];
    }
    //got the screenshot as the share image
    UIImage *image = [[UMSocialScreenShoterDefault screenShoter] getScreenShot];

    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"53323c7056240bb27f08bfb2"
                                      shareText:[NSString stringWithFormat:@"大拿俱乐部：\n%@",self.news.title]
                                     shareImage:image
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToTencent,UMShareToRenren,UMShareToDouban,UMShareToEmail,UMShareToSms,nil]
                                       delegate:nil];

}

- (IBAction)tapOnFavoriteBtn:(id)sender {
    LKDBHelper* globalHelper = [LKDBHelper getUsingLKDBHelper];
    if (self.news.isFavorite) {
        self.news.isFavorite = NO;
        [[HTActivityIndicator currentIndicator] displayMessage:@"已经取消收藏!"];
        [self.favoriteButton setImage:[UIImage imageNamed:@"favorite_unselected.png"] forState:UIControlStateNormal];
        [globalHelper deleteToDB:self.news];
    }else{
        self.news.isFavorite = YES;
        [[HTActivityIndicator currentIndicator] displayMessage:@"收藏成功!"];
        [self.favoriteButton setImage:[UIImage imageNamed:@"favorite_selected.png"] forState:UIControlStateNormal];
        [globalHelper insertWhenNotExists:self.news];
    }
    
}

#pragma mark- UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGRect frame = self.webView.frame;
    frame.size.height = 1;
    self.webView.frame = frame;
    CGSize fittingSize = [self.webView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    self.webView.frame = frame;
    [self.scrollView setContentSize:CGSizeMake(self.webView.width, self.webView.height+76)];
    self.webView.scrollView.scrollEnabled = NO;
}

@end
