//
//  AboutDetailViewController.m
//  DV
//
//  Created by Zhao Zhicheng on 1/11/14.
//
//

#import "AboutDetailViewController.h"

@interface AboutDetailViewController (){
    
}
@property (strong, nonatomic) About *about;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation AboutDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithAbout:(About *)about{
    self = [super init];
    if (self) {
        self.about = about;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.titleLabel.text = self.about.title;
    self.textView.text = self.about.content;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)tapOnBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
