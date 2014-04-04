//
//  SwitchViewController.m
//  DV
//
//  Created by Zhao Zhicheng on 2/14/14.
//
//

#import "SwitchViewController.h"
#import "NSUserDefaults+RMSaveCustomObject.h"

@interface SwitchViewController ()

{
    ProfileInfoSelectType _selectType;
    NSArray *_valueArray;
    Contact *_contact;
    NSMutableArray *_baseInfoArray;
}

@property (retain, nonatomic) IBOutlet UILabel *headerTitleLabel;
@property (retain, nonatomic) IBOutlet UISwitch *switchDigital;
@property (retain, nonatomic) IBOutlet UISwitch *switchScience;

@end


@implementation SwitchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithSelectType:(ProfileInfoSelectType)selectType contact:(Contact*)contact
{
    self = [super init];
    if (self) {
        _selectType = selectType;
        _contact = contact;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _baseInfoArray = [NSMutableArray array];
    [_baseInfoArray addObject:@"数字"];
    [_baseInfoArray addObject:@"科技"];

    
    if ([_contact.category rangeOfString:
         [_baseInfoArray objectAtIndex:0]].location != NSNotFound) {
        self.switchDigital.on = YES;
    }
    if ([_contact.category rangeOfString:[_baseInfoArray objectAtIndex:1]].location != NSNotFound) {
        self.switchScience.on = YES;
    }
}
- (IBAction)tapOnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)tapOnFinish:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(contactConfirmed:type:)]) {
        NSString *tempFilter = [[NSString alloc] init];
        if (self.switchDigital.on) {
            tempFilter = [tempFilter stringByAppendingFormat:@"%@,",[_baseInfoArray objectAtIndex:0]];
        }
        if (self.switchScience.on) {
            tempFilter = [tempFilter stringByAppendingFormat:@"%@,",[_baseInfoArray objectAtIndex:1]];
        }
        if ([tempFilter hasSuffix:@","]) {
            tempFilter = [tempFilter substringToIndex:([tempFilter length]-1)];
        }
        _contact.category = tempFilter;
        [self uploadProfile];
	}
}

- (IBAction)tapOnSwitch:(id)sender {
    //do nothing now
}

- (void)uploadProfile{
    NSString *userId=[[NSUserDefaults standardUserDefaults] stringForKey:@"USER_ID"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_contact.category forKey:@"category"];
    [UpdateProfileDataRequest requestWithDelegate:self withParameters:params withUrl:[REQUEST_DOMAIN stringByAppendingString:[NSString stringWithFormat:@"member/%@/updateCategory", userId]]];
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
