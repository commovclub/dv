//
//  EditViewController.h
//  DV
//
//  Created by Zhao Zhicheng on 2/12/14.
//
//

#import <UIKit/UIKit.h>
@protocol EditViewControllerDelegate;
@interface EditViewController : UIViewController
@property(nonatomic) id<EditViewControllerDelegate> delegate;
@end

// Delegate Protocol
@protocol EditViewControllerDelegate <NSObject>

// Called when the user clicks the confirm button
-(void)contactConfirmed:(Contact *)contact type:(ProfileInfoSelectType)selectType;

@end
