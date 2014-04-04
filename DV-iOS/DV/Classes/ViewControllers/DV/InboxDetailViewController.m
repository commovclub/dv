//
//  InboxDetailViewController.m
//  DV
//
//  Created by Zhao Zhicheng on 2/19/14.
//
//

#import "InboxDetailViewController.h"
#import "Util.h"
@interface InboxDetailViewController (){
    
}
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) DVMessage *message;

@end

@implementation InboxDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithMessage:(DVMessage *)message{
    self = [super init];
    if (self) {
        self.message = message;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.titleLabel.text = _message.title;
    self.timeLabel.text =[UIUtil getStringWithDoubleDate:[_message.createdAt doubleValue] ] ;
    self.textView.text = _message.message;
    if ([self.message.status isEqualToString:@"new"]) {
        [self sendGetMessages];
    }
}


- (void)viewWillDisappear:(BOOL)animated{
    [[HTActivityIndicator currentIndicator] hide];
}

- (void)sendGetMessages
{
    
    [ReadMessageDataRequest requestWithDelegate:self withParameters:nil withUrl:[[REQUEST_DOMAIN stringByAppendingString:@"message/read/"] stringByAppendingFormat:@"%@",self.message.uuid]];

}

- (void)requestDidFinishLoad:(ITTBaseDataRequest*)request
{
    if ([request isSuccess]) {
    }
}

- (void)request:(ITTBaseDataRequest*)request didFailLoadWithError:(NSError*)error
{
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[AppDelegate shareAppdelegate].homeTabbarController hideTabBarAnimated:YES];
}

- (IBAction)tapOnBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
