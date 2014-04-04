//
//  EditTextViewViewController.m
//  DV
//
//  Created by Zhao Zhicheng on 2/11/14.
//
//

#import "EditTextViewViewController.h"
#import "NSUserDefaults+RMSaveCustomObject.h"

@interface EditTextViewViewController ()
{
    ProfileInfoSelectType _selectType;
    NSArray *_valueArray;
    Contact *_contact;
}

@property (retain, nonatomic) IBOutlet UILabel *headerTitleLabel;
@property (retain, nonatomic) IBOutlet UITextView *valueTextView;

@end

@implementation EditTextViewViewController

- (id)initWithSelectType:(ProfileInfoSelectType)selectType contact:(Contact*)contact
{
    self = [super init];
    if (self) {
        _selectType = selectType;
        _contact = contact;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    switch (_selectType) {
        case ProfileInfoSelectTypeDesc:
            [self.valueTextView becomeFirstResponder];
            self.valueTextView.text = _contact.desc;
            self.headerTitleLabel.text = @"一句话简介";
            break;
            
        case ProfileInfoSelectTypeHistory:
        {
            [self.valueTextView becomeFirstResponder];
            self.valueTextView.text = _contact.desc;
            self.headerTitleLabel.text = @"工作经历";
        }
            break;
            
        default:
            break;
    }
}

- (IBAction)tapOnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)tapOnFinish:(id)sender {
    switch (_selectType) {
        case ProfileInfoSelectTypeDesc:
            _contact.desc=self.valueTextView.text;
            break;
            
        case ProfileInfoSelectTypeHistory:
        {
            //_contact.desc=self.valueTextView.text;
        }
            break;
            
        default:
            break;
    }
    [self uploadProfile];
}

- (void)uploadProfile{
    NSString *userId=[[NSUserDefaults standardUserDefaults] stringForKey:@"USER_ID"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    switch (_selectType) {
            
        case ProfileInfoSelectTypeDesc:
        {
            [params setObject:_contact.desc forKey:@"description"];
            [UpdateProfileDataRequest requestWithDelegate:self withParameters:params withUrl:[REQUEST_DOMAIN stringByAppendingString:[NSString stringWithFormat:@"member/%@/updateDescription", userId]]];
        }
            break;
        default:
            break;
    }
    
    [[HTActivityIndicator currentIndicator] displayActivity:@"提交中"];
}

- (void)requestDidFinishLoad:(ITTBaseDataRequest*)request
{
    if ([request isSuccess]) {
        [[HTActivityIndicator currentIndicator] hide];
        [[HTActivityIndicator currentIndicator] displayMessage:@"提交成功!"];
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        [defaults rm_setCustomObject:_contact forKey:@"MYSELF"];
        [defaults synchronize];
        if (self.delegate && [self.delegate respondsToSelector:@selector(contactConfirmed:type:)]) {
            [self.delegate contactConfirmed:_contact type:_selectType];
            [self.navigationController popViewControllerAnimated:NO];
        }
    }else{
        [[HTActivityIndicator currentIndicator] displayMessage:request.result.message];
    }
}


- (void)request:(ITTBaseDataRequest*)request didFailLoadWithError:(NSError*)error
{
    [[HTActivityIndicator currentIndicator] displayMessage:@"网络不佳，请检查网络!"];
}


@end
