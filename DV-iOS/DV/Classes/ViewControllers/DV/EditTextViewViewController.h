//
//  EditTextViewViewController.h
//  DV
//
//  Created by Zhao Zhicheng on 2/11/14.
//
//

#import <UIKit/UIKit.h>
#import "EditViewController.h"

@interface EditTextViewViewController : EditViewController<DataRequestDelegate>

- (id)initWithSelectType:(ProfileInfoSelectType)selectType contact:(Contact*)contact;

@end
