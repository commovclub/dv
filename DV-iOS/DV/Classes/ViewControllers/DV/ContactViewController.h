//
//  ContactViewController.h
//  DV
//
//  Created by Zhao Zhicheng on 1/2/14.
//
//

#import <UIKit/UIKit.h>
#import "Contact.h"
#import "ContactCell.h"
#import "ITTPullTableView.h"
#import "SGFocusImageFrame.h"
#import "SGFocusImageItem.h"

@interface ContactViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, DataRequestDelegate, ITTPullTableViewDelegate,ContactCellDelegate,SGFocusImageFrameDelegate>



@end
