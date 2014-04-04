//
//  SwitchViewController.h
//  DV
//
//  Created by Zhao Zhicheng on 2/14/14.
//
//

#import <UIKit/UIKit.h>
#import "EditViewController.h"

@interface SwitchViewController : EditViewController<DataRequestDelegate>

- (id)initWithSelectType:(ProfileInfoSelectType)selectType contact:(Contact*)contact;

@end
