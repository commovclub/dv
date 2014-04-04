//
//  ContactDetailViewController.h
//  DV
//
//  Created by Zhao Zhicheng on 1/7/14.
//
//

#import <UIKit/UIKit.h>
#import "Contact.h"
#import "EditViewController.h"
#import "ITTImageView.h"
#import "Work.h"
#import "WorkCell.h"

@interface ContactDetailViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,EditViewControllerDelegate,DataRequestDelegate,ITTImageViewDelegate>

- (id)initWithContact:(Contact *)contact;

@end
