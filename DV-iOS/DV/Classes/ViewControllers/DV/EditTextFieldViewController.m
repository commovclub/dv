//
//  EditTextFieldViewController.m
//  DV
//
//  Created by Zhao Zhicheng on 2/11/14.
//
//

#import "EditTextFieldViewController.h"
#import "HZAreaPickerView.h"
#import "NSUserDefaults+RMSaveCustomObject.h"

@interface EditTextFieldViewController ()
{
    ProfileInfoSelectType _selectType;
    NSArray *_valueArray;
    Contact *_contact;
}

@property (retain, nonatomic) IBOutlet UILabel *headerTitleLabel;
@property (retain, nonatomic) IBOutlet UITextField *valueTextField;
@property (retain, nonatomic) IBOutlet UIView *pickContainerView;
@property (retain, nonatomic) IBOutlet UIImageView *avatar;

@property (strong, nonatomic) HZAreaPickerView *locatePicker;

@end

@implementation EditTextFieldViewController

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
    // Do any additional setup after loading the view from its nib.
    switch (_selectType) {
        case ProfileInfoSelectTypeNickname:
            [self.valueTextField setEnabled:YES];
            [self.valueTextField becomeFirstResponder];
            self.valueTextField.placeholder = @"请输入姓名";
            self.valueTextField.text = _contact.name;
            self.headerTitleLabel.text = @"姓名";
            break;
            
        case ProfileInfoSelectTypeSex:
        {
            _valueArray = @[@"", @"男",@"女"];
            [self.valueTextField setEnabled:NO];
            UIPickerView *pickerView = [[UIPickerView alloc] init];
            pickerView.showsSelectionIndicator = YES;
            pickerView.delegate = self;
            pickerView.backgroundColor = [UIColor whiteColor];
            pickerView.alpha = 0.7;
            [self.pickContainerView addSubview:pickerView];
            self.valueTextField.placeholder = @"请选择性别";
            if ([_valueArray containsObject:_contact.gender]) {
                [pickerView selectRow:[_valueArray indexOfObject:_contact.gender] inComponent:0 animated:NO];
                self.valueTextField.text = _contact.gender;
            }
            self.headerTitleLabel.text = @"性别";
        }
            
            break;
        case ProfileInfoSelectTypeAge:
        {
            [self.valueTextField setEnabled:NO];
            UIDatePicker *datePickerView = [[UIDatePicker alloc] init];
            [datePickerView addTarget:self action:@selector(datePickerDidChanged:) forControlEvents:UIControlEventValueChanged];
            datePickerView.datePickerMode = UIDatePickerModeDate;
            datePickerView.maximumDate = [NSDate date];
            datePickerView.backgroundColor = [UIColor whiteColor];
            datePickerView.alpha = 0.7;
            if (!_contact.birthday || [@"" isEqualToString: _contact.birthday]) {
                datePickerView.date = [NSDate dateWithString:@"19800101" formate:@"yyyyMMdd"];
            }
            else{
                datePickerView.date = [NSDate dateWithString:_contact.birthday formate:@"yyyy-MM-dd"];;
                self.valueTextField.text = _contact.birthday;
            }
            [self.pickContainerView addSubview:datePickerView];
            self.valueTextField.placeholder = @"请选择生日";
            self.headerTitleLabel.text = @"生日";
        }
            break;
        case ProfileInfoSelectTypeCity:
        {
            [self.valueTextField setEnabled:NO];
            self.valueTextField.text = _contact.city;
            self.valueTextField.placeholder = @"请选择所在地区";
            self.headerTitleLabel.text = @"所在地区";
            [self cancelLocatePicker];
            self.locatePicker = [[HZAreaPickerView alloc] initWithStyle:HZAreaPickerWithStateAndCityAndDistrict delegate:self];
            //[self.locatePicker showInView:self.view];
            [self.pickContainerView addSubview:self.locatePicker];
            break;
        }
        case ProfileInfoSelectTypeCareer:
            [self.valueTextField becomeFirstResponder];
            self.valueTextField.placeholder = @"请输入职位";
            self.valueTextField.text = _contact.career;
            self.headerTitleLabel.text = @"职位";
            break;
        case ProfileInfoSelectTypeQQ:
            [self.valueTextField becomeFirstResponder];
            self.valueTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            self.valueTextField.placeholder = @"请输入QQ";
            self.valueTextField.text = _contact.qq;
            self.headerTitleLabel.text = @"QQ";
            break;
        case ProfileInfoSelectTypeWeixin:
            [self.valueTextField becomeFirstResponder];
            self.valueTextField.placeholder = @"请输入微信";
            self.valueTextField.text = _contact.weixin;
            self.headerTitleLabel.text = @"微信";
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tapOnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (IBAction)tapOnFinish:(id)sender {
    
    switch (_selectType) {
        case ProfileInfoSelectTypeNickname:
            if ([@"" isEqualToString:self.valueTextField.text]) {
                [[HTActivityIndicator currentIndicator] displayMessage:@"昵称不能为空!"];
                return;
            }
            _contact.name = self.valueTextField.text;
            break;
            
        case ProfileInfoSelectTypeSex:
        {
            _contact.gender = self.valueTextField.text;
        }
            break;
        case ProfileInfoSelectTypeAge:
        {
            _contact.birthday = self.valueTextField.text;
        }
            break;
        case ProfileInfoSelectTypeCity:
        {
            _contact.city = self.valueTextField.text;
        }
            break;
        case ProfileInfoSelectTypeCareer:
        {
            _contact.career = self.valueTextField.text;
        }
            break;
        case ProfileInfoSelectTypeQQ:
        {
            _contact.qq = self.valueTextField.text;
        }
            break;
        case ProfileInfoSelectTypeWeixin:
        {
            _contact.weixin = self.valueTextField.text;
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
        case ProfileInfoSelectTypeAge:
        {
            _contact.birthday = self.valueTextField.text;
        }
            break;
        case ProfileInfoSelectTypeCity:
        {
            [params setObject:[NSString stringWithFormat:@"%@ %@ %@",_contact.province,_contact.city,_contact.address] forKey:@"city"];
            
            [UpdateProfileDataRequest requestWithDelegate:self withParameters:params withUrl:[REQUEST_DOMAIN stringByAppendingString:[NSString stringWithFormat:@"member/%@/updateCity", userId]]];
        }
            break;
        case ProfileInfoSelectTypeCareer:
        {
            [params setObject:_contact.career forKey:@"title"];
            [UpdateProfileDataRequest requestWithDelegate:self withParameters:params withUrl:[REQUEST_DOMAIN stringByAppendingString:[NSString stringWithFormat:@"member/%@/updateTitle", userId]]];
        }
            break;
        case ProfileInfoSelectTypeQQ:
        {
            [params setObject:_contact.qq forKey:@"qq"];
            [UpdateProfileDataRequest requestWithDelegate:self withParameters:params withUrl:[REQUEST_DOMAIN stringByAppendingString:[NSString stringWithFormat:@"member/%@/updateQQ", userId]]];
            
        }
            break;
        case ProfileInfoSelectTypeWeixin:
        {
            [params setObject:_contact.weixin forKey:@"weixin"];
            [UpdateProfileDataRequest requestWithDelegate:self withParameters:params withUrl:[REQUEST_DOMAIN stringByAppendingString:[NSString stringWithFormat:@"member/%@/updateWeixin", userId]]];
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

- (void) datePickerDidChanged:(UIDatePicker *)datePicker{
    self.valueTextField.text = [datePicker.date stringWithFormat:@"yyyy-MM-dd"];
}

#pragma mark - UIPickView DataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_valueArray count];
}

#pragma mark - UIPickView Delegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [_valueArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.valueTextField.text = [_valueArray objectAtIndex:row];
}

- (void)viewDidUnload {
    [self setHeaderTitleLabel:nil];
    [self setValueTextField:nil];
    [self setPickContainerView:nil];
    [super viewDidUnload];
}

#pragma mark - HZAreaPicker delegate
-(void)pickerDidChaneStatus:(HZAreaPickerView *)picker
{
    self.valueTextField.text = [NSString stringWithFormat:@"%@ %@ %@", picker.locate.state, picker.locate.city, picker.locate.district];
}

-(void)cancelLocatePicker
{
    [self.locatePicker cancelPicker];
    self.locatePicker.delegate = nil;
    self.locatePicker = nil;
}

@end