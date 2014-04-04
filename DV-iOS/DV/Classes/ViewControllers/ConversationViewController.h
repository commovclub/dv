//
//  ConversationViewController.h
//  HotWord
//
//  Created by Jack Liu on 13-5-25.
//
//

#import <UIKit/UIKit.h>
#import "ITTPullTableView.h"
#import "MessageFromCell.h"
#import "MessageToCell.h"
#import "Contact.h"
#import "ITTDataRequest.h"

@interface ConversationViewController : UIViewController<ITTPullTableViewDelegate, DataRequestDelegate, UITextFieldDelegate, MessageToCellDelegate>

- (id)initWithContact:(Contact *)contact;

@end
