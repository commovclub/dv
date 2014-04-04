//
//  EditTextFieldViewController.h
//  DV
//
//  Created by Zhao Zhicheng on 2/11/14.
//
//

#import <UIKit/UIKit.h>
#import "Contact.h"
#import "HZAreaPickerView.h"
#import "EditViewController.h"

@interface EditTextFieldViewController : EditViewController<UIPickerViewDataSource, UIPickerViewDelegate,HZAreaPickerDelegate,DataRequestDelegate>
    
- (id)initWithSelectType:(ProfileInfoSelectType)selectType contact:(Contact*)contact;

@end
