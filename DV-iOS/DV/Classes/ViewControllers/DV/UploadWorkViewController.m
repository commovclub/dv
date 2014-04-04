//
//  UploadWorkViewController.m
//  DV
//
//  Created by Zhao Zhicheng on 3/8/14.
//
//

#import "UploadWorkViewController.h"
#import "TPKeyboardAvoidingScrollView.h"

@interface UploadWorkViewController (){
    
}
@property (strong, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *scrollView;

@end

@implementation UploadWorkViewController

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
    _hint = @"请在这里输入您对作品的描述";
    _aIVs = @[_iv1, _iv2, _iv3, _iv4, _iv5, _iv6, _iv7, _iv8, _iv9];
    _scrollView.contentSize =  CGSizeMake(320, 660);
    if ([_textView.text isEqualToString:@""]) {
        _textView.text = _hint;
        _textView.textColor = [UIColor lightGrayColor];
    }
}

- (IBAction)tapOnImagePicker:(id)sender{
    for (UIImageView *iv in _aIVs)
		iv.image = nil;
    DoImagePickerController *cont = [[DoImagePickerController alloc] initWithNibName:@"DoImagePickerController" bundle:nil];
    cont.delegate = self;
    cont.nResultType = DO_PICKER_RESULT_UIIMAGE;
    cont.nMaxCount = 9;
    cont.nColumnCount = 4;
    [self presentViewController:cont animated:YES completion:nil];
}

- (IBAction)tapOnBackPicker:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)tapOnUploadPicker:(id)sender{
    [_textView resignFirstResponder];
    if ([_textView.text length]==0||[_textView.text isEqualToString:@"请在这里输入您对作品的描述"]) {
        [[HTActivityIndicator currentIndicator] displayMessage:@"请输入作品描述!"];
        return;
    }
    if (_iv1.image == nil) {
        [[HTActivityIndicator currentIndicator] displayMessage:@"请先点击'去相册选作品'添加作品!"];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_textView.text forKey:@"description"];
    [params setObject:@"" forKey:@"title"];
    for (int i = 0; i < _aIVs.count; i++)
    {
        UIImageView *iv = _aIVs[i];
        if (iv.image) {
            NSData* imageData = UIImageJPEGRepresentation(iv.image, 0.8);
            [params setObject:imageData forKey:[NSString stringWithFormat:@"qqfile%i",i+1]];
        }
    }
    
    [UploadWorkDataRequest requestWithDelegate:self withParameters:params];
    [[HTActivityIndicator currentIndicator] displayActivity:@"上传作品中..."];
    
}


- (void)requestDidFinishLoad:(ITTBaseDataRequest*)request
{
    if ([request isSuccess]) {
        if ([request isKindOfClass:[UploadWorkDataRequest class]]) {
            [[HTActivityIndicator currentIndicator] displayMessage:@"作品提交成功!"];
            [self.navigationController popViewControllerAnimated:YES];
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



#pragma mark - DoImagePickerControllerDelegate
- (void)didCancelDoImagePickerController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didSelectPhotosFromDoImagePickerController:(DoImagePickerController *)picker result:(NSArray *)aSelected
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (picker.nResultType == DO_PICKER_RESULT_UIIMAGE)
    {
        for (int i = 0; i < MIN(9, aSelected.count); i++)
        {
            UIImageView *iv = _aIVs[i];
            iv.image = aSelected[i];
        }
    }
}

#pragma mark -
#pragma mark UITextViewDelegate,UITextFieldDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:_hint]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@""]) {
        textView.text = _hint;
        textView.textColor = [UIColor lightGrayColor];
    }
    return YES;
}


@end
