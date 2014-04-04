//
//  HomeTabBar.h

//

#import <UIKit/UIKit.h>

@protocol HomeTabBarDelegate;

@interface HomeTabBar : UIView

@property (strong, nonatomic) IBOutlet UIButton *t1Button;
@property (strong, nonatomic) IBOutlet UIButton *t2Button;
@property (strong, nonatomic) IBOutlet UIButton *t3Button;
@property (strong, nonatomic) IBOutlet UIButton *t4Button;
@property (strong, nonatomic) IBOutlet UIButton *t5Button;

@property (weak, nonatomic) id<HomeTabBarDelegate>delegate;
@property (strong, nonatomic) IBOutlet UIImageView *selectImageView;
@property (strong, nonatomic) IBOutlet UIView *updateHintView;

- (IBAction)tapOnT1Button:(id)sender;
- (IBAction)tapOnT2Button:(id)sender;
- (IBAction)tapOnT3Button:(id)sender;
- (IBAction)tapOnT4Button:(id)sender;
- (IBAction)tapOnT5Button:(id)sender;


+ (HomeTabBar *)viewFromNib;
- (void)selectTabBarAtIndex:(int)index;
- (void)updateUpdateHintView;

@end

@protocol HomeTabBarDelegate <NSObject>

- (void)homeTabBar:(HomeTabBar*)homeTabBar didSelectTabAtIndex:(int)index;

@end





