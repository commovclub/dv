//
//  EventFileViewController.m
//  DV
//
//  Created by Zhao Zhicheng on 3/5/14.
//
//

#import "EventFileViewController.h"

@interface EventFileViewController ()
@property (strong, nonatomic) DVFile *file;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation EventFileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithFile:(DVFile *)file{
    self = [super init];
    if (self) {
        self.file = file;
    }
    return self;
}

- (IBAction)tapOnBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.titleLabel.text = self.file.name;
    [[HTActivityIndicator currentIndicator] displayActivity:@"加载中..."];
    NSString *urlToDownload = self.file.path;
    NSURL  *url = [NSURL URLWithString:urlToDownload];
    NSURLRequest *request=[[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLCacheStorageAllowed timeoutInterval:120.0f];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        [[HTActivityIndicator currentIndicator] hide];
        if (!connectionError) {
            
            if ( data )
            {
                NSArray   *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString  *documentsDirectory = [paths objectAtIndex:0];
                
                NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"myfile.pdf"];
                
                //saving is done on main thread
                dispatch_async(dispatch_get_main_queue(), ^{
                    [data
                     writeToFile:filePath atomically:YES];
                    NSLog(@"File Saved !");
                    
                    NSURL *url = [NSURL fileURLWithPath:filePath];
                    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
                    [self.webView setUserInteractionEnabled:YES];
                    //[_rssWebView setDelegate:self];
                    [self.webView loadRequest:requestObj];
                });
            }
        }
    }];
}

@end
