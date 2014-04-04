//
//  UploadWorkViewController.h
//  DV
//
//  Created by Zhao Zhicheng on 3/8/14.
//
//

#import <UIKit/UIKit.h>
#import "DoImagePickerController.h"

@interface UploadWorkViewController : UIViewController<DoImagePickerControllerDelegate, UITextViewDelegate,DataRequestDelegate>

@property (weak, nonatomic) IBOutlet UIImageView    *iv1;
@property (weak, nonatomic) IBOutlet UIImageView    *iv2;
@property (weak, nonatomic) IBOutlet UIImageView    *iv3;
@property (weak, nonatomic) IBOutlet UIImageView    *iv4;
@property (weak, nonatomic) IBOutlet UIImageView    *iv5;
@property (weak, nonatomic) IBOutlet UIImageView    *iv6;
@property (weak, nonatomic) IBOutlet UIImageView    *iv7;
@property (weak, nonatomic) IBOutlet UIImageView    *iv8;
@property (weak, nonatomic) IBOutlet UIImageView    *iv9;
@property (weak, nonatomic) IBOutlet UITextView    *textView;
@property (strong, nonatomic)   NSArray             *aIVs;
@property (strong, nonatomic)   NSString             *hint;

@end
