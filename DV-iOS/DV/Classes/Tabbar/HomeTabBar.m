//
//  HomeTabBar.m

//

#import "HomeTabBar.h"
#import "DataCacheManager.h"
#import "MessageCount.h"

@implementation HomeTabBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

+ (HomeTabBar *)viewFromNib
{
    HomeTabBar *view = [[[NSBundle mainBundle] loadNibNamed:@"HomeTabBar" owner:self options:nil] objectAtIndex:0];
    return view;
}

- (void)updateUpdateHintView{
    MessageCount *messageCount =[[NSUserDefaults standardUserDefaults] rm_customObjectForKey:@"MESSAGE_COUNT"];
    if (([messageCount.systemCount integerValue]+[messageCount.privateCount integerValue]+[messageCount.leadCount integerValue])>0){
        _updateHintView.hidden=NO;
        self.updateHintView.layer.masksToBounds = YES;
        self.updateHintView.layer.cornerRadius = 3.0f;
    }else{
        _updateHintView.hidden=YES;
    }
}

- (void)selectTabBarAtIndex:(int)index
{
    
    UIButton *selectButton;
    [self.t1Button setImage:[UIImage imageNamed:@"icon1_normal.png"] forState:UIControlStateNormal];
    [self.t2Button setImage:[UIImage imageNamed:@"icon2_normal.png"] forState:UIControlStateNormal];
    [self.t3Button setImage:[UIImage imageNamed:@"icon3_normal.png"] forState:UIControlStateNormal];
    [self.t4Button setImage:[UIImage imageNamed:@"icon4_normal.png"] forState:UIControlStateNormal];
    [self.t5Button setImage:[UIImage imageNamed:@"icon5_normal.png"] forState:UIControlStateNormal];
    self.t1Button.highlighted = NO;
    self.t1Button.selected = NO;
    self.t2Button.selected = NO;
    self.t3Button.selected = NO;
    self.t4Button.selected = NO;
    self.t5Button.selected = NO;
    switch (index) {
        case 0:
            
            self.t1Button.selected = YES;
            [self.t1Button setImage:[UIImage imageNamed:@"icon1_selected.png"] forState:UIControlStateNormal];
            selectButton = _t1Button;
            break;
            
            
        case 1:
            
            self.t2Button.selected = YES;
            [self.t2Button setImage:[UIImage imageNamed:@"icon2_selected.png"] forState:UIControlStateNormal];
            selectButton = _t2Button;
            
            break;
        case 2:
            
            self.t3Button.selected = YES;
            [self.t3Button setImage:[UIImage imageNamed:@"icon3_selected.png"] forState:UIControlStateNormal];
            selectButton = _t3Button;
            break;
            
        case 3:
            
            self.t4Button.selected = YES;
            [self.t4Button setImage:[UIImage imageNamed:@"icon4_selected.png"] forState:UIControlStateNormal];
            selectButton = _t4Button;
            _updateHintView.hidden=YES;
            break;
            
        case 4:
            
            self.t5Button.selected = YES;
            [self.t5Button setImage:[UIImage imageNamed:@"icon5_selected.png"] forState:UIControlStateNormal];
            selectButton = _t5Button;
            break;
            
        default:
            selectButton = _t1Button;
            break;
    }
    [UIView animateWithDuration:0.3 animations:^{
        _selectImageView.center = selectButton.center;
    }];
}


- (void)tapOnButtonIndex:(int)index
{
    [self selectTabBarAtIndex:index];
    if(_delegate && [_delegate respondsToSelector:@selector(homeTabBar:didSelectTabAtIndex:)]){
        [_delegate homeTabBar:self didSelectTabAtIndex:index];
    }
}

- (IBAction)tapOnT1Button:(id)sender
{
    [self tapOnButtonIndex:0];
}

- (IBAction)tapOnT2Button:(id)sender
{
    [self tapOnButtonIndex:1];
}

- (IBAction)tapOnT3Button:(id)sender
{
    [self tapOnButtonIndex:2];
}

- (IBAction)tapOnT4Button:(id)sender
{
    [self tapOnButtonIndex:3];
}

- (IBAction)tapOnT5Button:(id)sender
{
    [self tapOnButtonIndex:4];
}

@end






