//
//  EditTagViewController.m
//  DV
//
//  Created by Zhao Zhicheng on 2/11/14.
//
//

#import "EditTagViewController.h"
#import "NSUserDefaults+RMSaveCustomObject.h"

@interface EditTagViewController ()

{
    ProfileInfoSelectType _selectType;
    NSArray *_valueArray;
    Contact *_contact;
}

@property (retain, nonatomic) IBOutlet UILabel *headerTitleLabel;
@property (nonatomic, retain) IBOutlet THContactPickerView *contactPickerView;
@property (nonatomic, strong) NSArray *contacts;
@property (nonatomic, strong) NSMutableArray *selectedContacts;
@property (nonatomic, strong) NSArray *filteredContacts;

@end

@implementation EditTagViewController

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
    self.contactPickerView.delegate = self;
    switch (_selectType) {
        case ProfileInfoSelectTypeTags:
            [self.contactPickerView setPlaceholderString:@"输入标签"];
            self.headerTitleLabel.text = @"标签";
            if ([_contact.tags count]==1&&[[_contact.tags objectAtIndex:0] length]==0) {
                _contact.tags = [[NSArray alloc] init];
            }
            for (int i=0; i<[_contact.tags count]; i++) {
                NSString *tag=[_contact.tags objectAtIndex:i];
                [self.contactPickerView addContact:tag withName:tag];
            }
            break;
        case ProfileInfoSelectTypeTel:
            [self.contactPickerView setPlaceholderString:@"输入电话"];
            self.headerTitleLabel.text = @"电话";
            self.contactPickerView.textView.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            if ([_contact.tels count]==1&&[[_contact.tels objectAtIndex:0] length]==0) {
                _contact.tels = [[NSArray alloc] init];
            }
            for (int i=0; i<[_contact.tels count]; i++) {
                NSString *tel=[_contact.tels objectAtIndex:i];
                [self.contactPickerView addContact:tel withName:tel];
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
    if (_selectType == ProfileInfoSelectTypeTags) {
        _contact.tags = self.contactPickerView.contactKeys;
        NSString *tagsString = [[NSString alloc] init];
        for (int i=0 ; i<[_contact.tags count]; i++) {
            tagsString = [tagsString stringByAppendingString:[_contact.tags objectAtIndex:i]];
            if (i<([_contact.tags count]-1)) {
                tagsString = [tagsString stringByAppendingString:@","];
            }
        }
        _contact.tag = tagsString;
    }else{
        _contact.tels = self.contactPickerView.contactKeys;
        NSString *telsString = [[NSString alloc] init];
        for (int i=0 ; i<[_contact.tels count]; i++) {
            telsString = [telsString stringByAppendingString:[_contact.tels objectAtIndex:i]];
            if (i<([_contact.tels count]-1)) {
                telsString = [telsString stringByAppendingString:@","];
            }
        }
        _contact.phone = telsString;

    }
    [self uploadProfile];
}

#pragma mark - THContactPickerTextViewDelegate

- (void)contactPickerTextViewDidChange:(NSString *)textViewText {
//    if ([textViewText isEqualToString:@""]){
//        self.filteredContacts = self.contacts;
//    } else {
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self contains[cd] %@", textViewText];
//        self.filteredContacts = [self.contacts filteredArrayUsingPredicate:predicate];
//    }
}

- (void)contactPickerDidResize:(THContactPickerView *)contactPickerView {
    //[self adjustTableViewFrame];
}

- (void)contactPickerDidRemoveContact:(id)contact {
    //[self.selectedContacts removeObject:contact];
   
}

- (void)uploadProfile{
    NSString *userId=[[NSUserDefaults standardUserDefaults] stringForKey:@"USER_ID"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    switch (_selectType) {
        case ProfileInfoSelectTypeTags:
        {
            NSString *tags=[[NSString alloc] init];
            for (int i=0; i<[_contact.tags count]; i++) {
                tags=[tags stringByAppendingString:[_contact.tags objectAtIndex:i]];
                if(i!=([_contact.tags count]-1)){
                    tags=[tags stringByAppendingString:@","];
                }
            }
            [params setObject:tags forKey:@"tags"];
            [UpdateProfileDataRequest requestWithDelegate:self withParameters:params withUrl:[REQUEST_DOMAIN stringByAppendingString:[NSString stringWithFormat:@"member/%@/updateTags", userId]]];
        }
            break;
        case ProfileInfoSelectTypeTel:
        {
            NSString *tels=[[NSString alloc] init];
            for (int i=0; i<[_contact.tels count]; i++) {
                tels=[tels stringByAppendingString:[_contact.tels objectAtIndex:i]];
                if(i!=([_contact.tels count]-1)){
                    tels=[tels stringByAppendingString:@","];
                }
            }

            [params setObject:tels forKey:@"phone"];
            [UpdateProfileDataRequest requestWithDelegate:self withParameters:params withUrl:[REQUEST_DOMAIN stringByAppendingString:[NSString stringWithFormat:@"member/%@/updatePhone", userId]]];
            
        }
            break;
        default:
            break;
    }
    
    [[HTActivityIndicator currentIndicator] displayActivity:@"提交中..."];
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
