//
//  ContactCell.h
//

#import <UIKit/UIKit.h>
#import "Contact.h"
#import "ITTImageView.h"

@protocol ContactCellDelegate;

@interface ContactCell : UITableViewCell<ITTImageViewDelegate>

@property (nonatomic, strong) Contact *contact;

- (void)setContactData:(Contact *)contact;

@property (nonatomic, weak)id <ContactCellDelegate> delegate;

@end

@protocol ContactCellDelegate <NSObject>

- (void)imageDidSelected:(Contact *)contact;

@end