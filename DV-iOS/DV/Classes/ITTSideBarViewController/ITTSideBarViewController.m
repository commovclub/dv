//
//  ITTSideBarViewController.m
//  ChangBaiShanDemo
//
//  Created by Jack Liu on 13-5-13.
//
//

#import "ITTSideBarViewController.h"
#import "ITTObjectSingleton.h"

#define CONTENT_OFFSET  200
#define CONTENT_MIN_OFFSET  60
#define MOVE_ANIMATION_DURATION 0.3f

@interface ITTSideBarViewController ()
{
    UIViewController  *_currentMainController;
    UITapGestureRecognizer *_tapGestureRecognizer;
    UIPanGestureRecognizer *_panGestureReconginzer;
    UIPanGestureRecognizer *_backViewPanGestureReconginzer;
    BOOL _sideBarShowing;
    CGFloat _currentTranslate;
}

@property (strong,nonatomic)ITTLeftSideBarViewController *leftSideBarViewController;
@property (strong,nonatomic)UIViewController *rightSideBarViewController;
@end

@implementation ITTSideBarViewController
static ITTSideBarViewController *sideBarViewController;

- (id)initWithLeftSideBarViewController:(ITTLeftSideBarViewController *)leftViewController rightSideBarViewController:(UIViewController *)rightViewController
{
    self = [super init];
	if (self) {
        self.leftSideBarViewController = leftViewController;
        self.rightSideBarViewController = rightViewController;
        
	}
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (sideBarViewController) {
        sideBarViewController = nil;
    }
	sideBarViewController = self;
    _sideBarShowing = NO;
    _currentTranslate = 0;
    
    self.contentView.layer.shadowOffset = CGSizeMake(0, 0);
    self.contentView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.contentView.layer.shadowOpacity = 1;
    
    
    if (self.leftSideBarViewController) {
        
        self.leftSideBarViewController.delegate = self;
        [self addChildViewController:self.leftSideBarViewController];
        self.leftSideBarViewController.view.frame = self.navBackView.bounds;
        [self.navBackView addSubview:self.leftSideBarViewController.view];
    }
    if (self.rightSideBarViewController) {
        
        [self addChildViewController:self.rightSideBarViewController];
        self.rightSideBarViewController.view.frame = self.navBackView.bounds;
        [self.navBackView addSubview:self.rightSideBarViewController.view];
    }
    
    _panGestureReconginzer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panInContentView:)];
    [self.contentView addGestureRecognizer:_panGestureReconginzer];
    _backViewPanGestureReconginzer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panInContentView:)];
    [self.navBackView addGestureRecognizer:_backViewPanGestureReconginzer];

}

- (void)contentViewAddTapGestures
{
    if (_tapGestureRecognizer) {
        [self.navBackView   removeGestureRecognizer:_tapGestureRecognizer];
        _tapGestureRecognizer = nil;
    }
    
    _tapGestureRecognizer = [[UITapGestureRecognizer  alloc] initWithTarget:self action:@selector(tapOnContentView:)];
    _tapGestureRecognizer.delegate = self;
    [self.navBackView addGestureRecognizer:_tapGestureRecognizer];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (([touch.view isKindOfClass:[UIButton class]])) {
        return NO;
    }
    return YES;
}


- (void)tapOnContentView:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [self moveAnimationWithDirection:SideBarShowDirectionNone duration:MOVE_ANIMATION_DURATION];
}

- (void)panInContentView:(UIPanGestureRecognizer *)panGestureReconginzer
{
    
	if (panGestureReconginzer.state == UIGestureRecognizerStateChanged){
        
        CGFloat translation = [panGestureReconginzer translationInView:self.contentView].x;
        if (translation + _currentTranslate < 0 || translation + _currentTranslate > CONTENT_OFFSET) {
            return;
        }
        self.contentView.transform = CGAffineTransformMakeTranslation(translation+_currentTranslate, 0);
        UIView *view ;
        if (translation+_currentTranslate>0)
        {
            view = self.leftSideBarViewController.view;
        }else
        {
            view = self.rightSideBarViewController.view;
        }
        [self.navBackView bringSubviewToFront:view];
        
	}else if (panGestureReconginzer.state == UIGestureRecognizerStateEnded){
        
		_currentTranslate = self.contentView.transform.tx;
        if (!_sideBarShowing) {
            if (fabs(_currentTranslate) < CONTENT_MIN_OFFSET) {
                [self moveAnimationWithDirection:SideBarShowDirectionNone duration:MOVE_ANIMATION_DURATION];
            }else if(_currentTranslate > CONTENT_MIN_OFFSET)
            {
                [self moveAnimationWithDirection:SideBarShowDirectionLeft duration:MOVE_ANIMATION_DURATION];
            }else
            {
                [self moveAnimationWithDirection:SideBarShowDirectionRight duration:MOVE_ANIMATION_DURATION];
            }
        }else
        {
            if (fabs(_currentTranslate) < CONTENT_OFFSET-CONTENT_MIN_OFFSET) {
                [self moveAnimationWithDirection:SideBarShowDirectionNone duration:MOVE_ANIMATION_DURATION];
                
            }else if(_currentTranslate > CONTENT_OFFSET-CONTENT_MIN_OFFSET)
            {
                
                [self moveAnimationWithDirection:SideBarShowDirectionLeft duration:MOVE_ANIMATION_DURATION];
                
            }else
            {
                [self moveAnimationWithDirection:SideBarShowDirectionRight duration:MOVE_ANIMATION_DURATION];
            }
        }
	}
}

#pragma mark - nav con delegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([navigationController.viewControllers count]>1) {
        [self removepanGestureReconginzerWhileNavConPushed:YES];
    }else
    {
        [self removepanGestureReconginzerWhileNavConPushed:NO];
    }
    
}

- (void)removepanGestureReconginzerWhileNavConPushed:(BOOL)push
{
    if (push) {
        if (_panGestureReconginzer) {
            [self.contentView removeGestureRecognizer:_panGestureReconginzer];
            _panGestureReconginzer = nil;
        }
    }else
    {
        if (!_panGestureReconginzer) {
            _panGestureReconginzer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panInContentView:)];
            [self.contentView addGestureRecognizer:_panGestureReconginzer];
            [self.navBackView addGestureRecognizer:_backViewPanGestureReconginzer];
        }
    }
}
#pragma mark - side bar select delegate
- (void)leftSideBarSelectWithController:(UIViewController *)controller
{
    if ([controller isKindOfClass:[UINavigationController class]]) {
        [(UINavigationController *)controller setDelegate:self];
    }
    if (_currentMainController == nil) {
		controller.view.frame = self.contentView.bounds;
		_currentMainController = controller;
		[self addChildViewController:_currentMainController];
		[self.contentView addSubview:_currentMainController.view];
		[_currentMainController didMoveToParentViewController:self];
	} else if (_currentMainController != controller && controller !=nil) {
		controller.view.frame = self.contentView.bounds;
		[_currentMainController willMoveToParentViewController:nil];
		[self addChildViewController:controller];
		self.view.userInteractionEnabled = NO;
		[self transitionFromViewController:_currentMainController
						  toViewController:controller
								  duration:0
								   options:UIViewAnimationOptionTransitionNone
								animations:^{}
								completion:^(BOOL finished){
									self.view.userInteractionEnabled = YES;
									[_currentMainController removeFromParentViewController];
									[controller didMoveToParentViewController:self];
									_currentMainController = controller;
								}
         ];
	}
    
    [self showSideBarControllerWithDirection:SideBarShowDirectionNone];
}


- (void)rightSideBarSelectWithController:(UIViewController *)controller
{
    
}

- (void)showSideBarControllerWithDirection:(SideBarShowDirection)direction
{
    
    if (direction!=SideBarShowDirectionNone) {
        UIView *view ;
        if (direction == SideBarShowDirectionLeft)
        {
            view = self.leftSideBarViewController.view;
        }else
        {
            view = self.rightSideBarViewController.view;
        }
        [self.navBackView bringSubviewToFront:view];
    }
    [self moveAnimationWithDirection:direction duration:MOVE_ANIMATION_DURATION];
}




#pragma animation

- (void)moveAnimationWithDirection:(SideBarShowDirection)direction duration:(float)duration
{
    void (^animations)(void) = ^{
		switch (direction) {
            case SideBarShowDirectionNone:
            {
                self.contentView.transform  = CGAffineTransformMakeTranslation(0, 0);
            }
                break;
            case SideBarShowDirectionLeft:
            {
                self.contentView.transform  = CGAffineTransformMakeTranslation(CONTENT_OFFSET, 0);
            }
                break;
            case SideBarShowDirectionRight:
            {
                self.contentView.transform  = CGAffineTransformMakeTranslation(- CONTENT_OFFSET, 0);
            }
                break;
            default:
                break;
        }
	};
    void (^complete)(BOOL) = ^(BOOL finished) {
        self.navBackView.userInteractionEnabled = YES;
        
        if (direction == SideBarShowDirectionNone) {
            
            if (_tapGestureRecognizer) {
                [self.contentView removeGestureRecognizer:_tapGestureRecognizer];
                _tapGestureRecognizer = nil;
            }
            _sideBarShowing = NO;
            self.contentView.userInteractionEnabled = YES;
            
            
        }else
        {
            [self contentViewAddTapGestures];
            _sideBarShowing = YES;
            self.contentView.userInteractionEnabled = NO;
        }
        _currentTranslate = self.contentView.transform.tx;
	};
    self.contentView.userInteractionEnabled = NO;
    self.navBackView.userInteractionEnabled = NO;
    [UIView animateWithDuration:duration animations:animations completion:complete];
}

- (void)viewDidUnload {
    [self setNavBackView:nil];
    [self setContentView:nil];
    [self setLeftSideBarViewController:nil];
    [self setRightSideBarViewController:nil];
    [super viewDidUnload];
}
@end
