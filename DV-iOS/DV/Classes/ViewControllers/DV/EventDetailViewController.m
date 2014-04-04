//
//  EventDetailViewController.m
//  DV
//
//  Created by Zhao Zhicheng on 1/13/14.
//
//

#import "EventDetailViewController.h"
#import "EventArrangementViewController.h"
#import "UMSocial.h"
#import "UMSocialScreenShoter.h"
@interface EventDetailViewController (){
    NSMutableArray *_favoriteArray;
}
@property (strong, nonatomic) Event *event;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UIButton *favoriteButton;
@property (strong, nonatomic) IBOutlet UIButton *applyButton;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation EventDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithEvent:(Event *)event{
    self = [super init];
    if (self) {
        self.event = event;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _favoriteArray = [Event searchWithWhere:nil orderBy:nil offset:0 count:200];
    if (_favoriteArray&&[_favoriteArray count]>0) {
        for (Event* obj in _favoriteArray) {
            if ([self.event.eventId isEqualToString:obj.eventId]) {
                self.event.isFavorite = YES;
                break;
            }
        }
    }
    self.titleLabel.text = self.event.title;
    self.timeLabel.text = self.event.time;
    if (self.event.isFavorite&&self.event.isFavorite) {
        [self.favoriteButton setImage:[UIImage imageNamed:@"favorite_selected.png"] forState:UIControlStateNormal];
    }else{
        [self.favoriteButton setImage:[UIImage imageNamed:@"favorite_unselected.png"] forState:UIControlStateNormal];
    }
    [self.webView loadHTMLString:[self.event.content stringByAppendingString:@"<br><br>"] baseURL:nil];
    self.webView.delegate = self;
    if ([self.event.hasApplied isEqualToString:@"1"]){
        [self.applyButton setTitle:@"已报名" forState:UIControlStateNormal];
    }else{
        [self.applyButton setTitle:@"报名" forState:UIControlStateNormal];
    }
    [self sendGetEvent];
}
- (void)sendGetEvent
{
    NSString *userId=[[NSUserDefaults standardUserDefaults] stringForKey:@"USER_ID"];
    [GetEventDataRequest requestWithDelegate:self withParameters:nil withUrl:[[REQUEST_DOMAIN stringByAppendingString:@"event/"] stringByAppendingFormat:@"%@/%@",self.event.eventId,userId]];//TODO
    
    [[HTActivityIndicator currentIndicator] displayActivity:@"加载中..."];
}

- (void)sendApplyEvent
{
    NSString *userId=[[NSUserDefaults standardUserDefaults] stringForKey:@"USER_ID"];

    [EventApplyDataRequest requestWithDelegate:self withParameters:nil withUrl:[[REQUEST_DOMAIN stringByAppendingString:@"event/"] stringByAppendingFormat:@"%@/%@/apply",self.event.eventId,userId]];
    
    [[HTActivityIndicator currentIndicator] displayActivity:@"报名中..."];
}

- (void)requestDidFinishLoad:(ITTBaseDataRequest*)request
{
    if ([request isSuccess]) {
        if ([request isKindOfClass:[GetEventDataRequest class]]) {
            Event *tempEvent = self.event;
            self.event =[[Event alloc] initWithDataDic:request.resultDic];
            self.event.subTitle = tempEvent.subTitle;
            self.event.path = tempEvent.path;
            self.event.isApply = tempEvent.isApply;
            self.event.isFavorite = tempEvent.isFavorite;
            [self.webView loadHTMLString:[self.event.content stringByAppendingString:@"<br><br><br><br><br>"] baseURL:nil];
            if ([self.event.hasApplied isEqualToString:@"1"]){
                [self.applyButton setTitle:@"已报名" forState:UIControlStateNormal];
            }else{
                [self.applyButton setTitle:@"报名" forState:UIControlStateNormal];
            }
        }else if ([request isKindOfClass:[EventApplyDataRequest class]]) {
            self.event.hasApplied = @"1";
            [self.applyButton setTitle:@"已报名" forState:UIControlStateNormal];
            [[HTActivityIndicator currentIndicator] displayMessage:@"报名成功！"];
        }
        [[HTActivityIndicator currentIndicator] hide];
    }else{
        if ([request isKindOfClass:[EventApplyDataRequest class]]) {
            [[HTActivityIndicator currentIndicator] displayMessage:@"报名失败！"];
        }else{
            [[HTActivityIndicator currentIndicator] displayMessage:request.result.message];
        }
    }
}


- (void)request:(ITTBaseDataRequest*)request didFailLoadWithError:(NSError*)error
{
    [[HTActivityIndicator currentIndicator] displayMessage:@"网络不佳，请检查网络!"];
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
    [self sendGetEvent];
}

- (IBAction)tapOnShareBtn:(id)sender {
    NSString *content = self.event.content;
    if (content) {
        NSRange r;
        while ((r = [content rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
            content = [content stringByReplacingCharactersInRange:r withString:@""];
    }
    UIImage *image = [[UMSocialScreenShoterDefault screenShoter] getScreenShot];
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"53323c7056240bb27f08bfb2"
                                      shareText:[NSString stringWithFormat:@"大拿俱乐部：\n%@",self.event.title]
                                     shareImage:image
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToTencent,UMShareToRenren,UMShareToDouban,UMShareToEmail,UMShareToSms,nil]
                                       delegate:nil];
    /*
    NSArray *activityItems;
    NSString *content = self.event.content;
    if (content) {
        NSRange r;
        while ((r = [content rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
            content = [content stringByReplacingCharactersInRange:r withString:@""];
    }
    activityItems = @[[NSString stringWithFormat:@"%@\n%@",self.event.title,content]];//分享内容
    UIActivityViewController *activityController =
    [[UIActivityViewController alloc] initWithActivityItems:activityItems
                                      applicationActivities:nil];
    
    [self presentViewController:activityController
                       animated:YES completion:nil];
     */
}

- (IBAction)tapOnFavoriteBtn:(id)sender {
    LKDBHelper* globalHelper = [LKDBHelper getUsingLKDBHelper];
    if (self.event.isFavorite) {
        self.event.isFavorite = NO;
        [[HTActivityIndicator currentIndicator] displayMessage:@"已经取消收藏!"];
        [self.favoriteButton setImage:[UIImage imageNamed:@"favorite_unselected.png"] forState:UIControlStateNormal];
        [globalHelper deleteToDB:self.event];
    }else{
        self.event.isFavorite = YES;
        [[HTActivityIndicator currentIndicator] displayMessage:@"收藏成功!"];
        [self.favoriteButton setImage:[UIImage imageNamed:@"favorite_selected.png"] forState:UIControlStateNormal];
        [globalHelper insertWhenNotExists:self.event];
    }
}

- (IBAction)tapOnApplyBtn:(id)sender {
    if (![self.event.hasApplied isEqualToString:@"1"]){
        UIActionSheet *actionSheet=[[UIActionSheet alloc] initWithTitle:@"报名该活动" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles: @"报名",nil];
        [actionSheet showInView:self.view.superview];
    }else{
        [[HTActivityIndicator currentIndicator] displayMessage:@"请不要重复报名"];
    }
}

- (IBAction)tapOnScheduleBtn:(id)sender {
    EventArrangementViewController *viewController = [[EventArrangementViewController alloc] initWithEvent:self.event];
    [self.navigationController pushViewController:viewController animated:YES];
}


- (void)viewDidUnload {
    [self setEvent:nil];
    [self setTimeLabel:nil];
    [self setFavoriteButton:nil];
    [super viewDidUnload];
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


#pragma mark- UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
       //提交报名
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self sendApplyEvent];

        });
    }
}

@end
