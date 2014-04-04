//
//  EditTagViewController.h
//  DV
//
//  Created by Zhao Zhicheng on 2/11/14.
//
//

#import <UIKit/UIKit.h>
#import "THContactPickerView.h"
#import "EditViewController.h"

@interface EditTagViewController : EditViewController<THContactPickerDelegate,DataRequestDelegate>

- (id)initWithSelectType:(ProfileInfoSelectType)selectType contact:(Contact*)contact;

@end
