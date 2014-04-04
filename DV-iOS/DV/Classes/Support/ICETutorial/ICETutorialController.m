//
//  ICETutorialController.m
//
//
//  Created by Patrick Trillsam on 25/03/13.
//  Copyright (c) 2013 Patrick Trillsam. All rights reserved.
//

#import "ICETutorialController.h"
#import "AboutViewController.h"
#import "LKDBHelper.h"
#import "News.h"
#import "Event.h"
@interface ICETutorialController (){
    IBOutlet UITextField *usernameTextField;
    IBOutlet UITextField *passwordTextField;
    IBOutlet UIButton *loginButton;
    IBOutlet UIButton *gotoLoginButton;
    IBOutlet UIView *loginView;
}

@end

@implementation ICETutorialController
@synthesize autoScrollEnabled = _autoScrollEnabled;
@synthesize autoScrollLooping = _autoScrollLooping;
@synthesize autoScrollDurationOnPage = _autoScrollDurationOnPage;
@synthesize commonPageSubTitleStyle = _commonPageSubTitleStyle;
@synthesize commonPageDescriptionStyle = _commonPageDescriptionStyle;

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
        _autoScrollEnabled = YES;
        _autoScrollLooping = YES;
        _autoScrollDurationOnPage = TUTORIAL_DEFAULT_DURATION_ON_PAGE;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
             andPages:(NSArray *)pages{
    self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
        _pages = [[NSMutableArray alloc] init];
        // Init the pages texts, and pictures.
        ICETutorialPage *layer1 = [[ICETutorialPage alloc] initWithSubTitle:@""
                                                                description:@""
                                                                pictureName:@"intro1@2x.png"];
        [_pages addObject:layer1];
        
        ICETutorialPage *layer2 = [[ICETutorialPage alloc] initWithSubTitle:@""
                                                                description:@""
                                                                pictureName:@"intro2@2x.png"];
        [_pages addObject:layer2];
        ICETutorialPage *layer3 = [[ICETutorialPage alloc] initWithSubTitle:@""
                                                                description:@""
                                                                pictureName:@"intro3@2x.png"];
        [_pages addObject:layer3];
        
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
                pages:(NSArray *)pages
         button1Block:(ButtonBlock)block1
         button2Block:(ButtonBlock)block2{
    self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil andPages:pages];
    if (self){
        _button1Block = block1;
        _button2Block = block2;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self view] setBackgroundColor:[UIColor blackColor]];
    
    _windowSize = [[UIScreen mainScreen] bounds].size;
    
    // ScrollView configuration.
    [_scrollView setContentSize:CGSizeMake([self numberOfPages] * _windowSize.width,
                                           _scrollView.contentSize.height)];
    [_scrollView setPagingEnabled:YES];
    
    // PageControl configuration.
    [_pageControl setNumberOfPages:[self numberOfPages]];
    [_pageControl setCurrentPage:0];
    
    // Overlays.
    [self setOverlayTexts];
    
    // Preset the origin state.
    [self setOriginLayersState];
    
    // Run the auto-scrolling.
    //[self autoScrollToNextPage];
    
    //TODO will remove
    loginButton.enabled = YES;
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[AppDelegate shareAppdelegate].homeTabbarController hideTabBarAnimated:YES];
}

#pragma mark - Actions
- (void)setButton1Block:(ButtonBlock)block{
    _button1Block = block;
    
}

- (void)setButton2Block:(ButtonBlock)block{
    _button2Block = block;
}

- (IBAction)didClickOnButton1:(id)sender{
    //usernameTextField.text = @"dana500@danaaa.com";
    //passwordTextField.text = @"123456";
    gotoLoginButton.hidden = YES;
    loginView.hidden = NO;
    [usernameTextField becomeFirstResponder];
}

- (IBAction)didClickOnButton2:(id)sender{
    if (_button2Block)
        _button2Block(sender);
}

- (IBAction)didClickOnPageControl:(UIPageControl *)sender {
    _currentState = ScrollingStateManual;
    
    // Make the scrollView animation.
    [_scrollView setContentOffset:CGPointMake(sender.currentPage * _windowSize.width,0)
                         animated:YES];
    
    // Set the PageControl on the right page.
    [_pageControl setCurrentPage:sender.currentPage];
}

#pragma mark - Pages
// Set the list of pages (ICETutorialPage)
- (void)setPages:(NSArray *)pages{
    _pages = pages;
}

- (NSUInteger)numberOfPages{
    if (_pages)
        return [_pages count];
    
    return 0;
}

#pragma mark - Animations
- (void)animateScrolling{
    if (_currentState & ScrollingStateManual)
        return;
    
    // Jump to the next page...
    int nextPage = _currentPageIndex + 1;
    if (nextPage == [self numberOfPages]){
        // ...stop the auto-scrolling or...
        if (!_autoScrollLooping){
            _currentState = ScrollingStateManual;
            return;
        }
        
        // ...jump to the first page.
        nextPage = 0;
        _currentState = ScrollingStateLooping;
        
        // Set alpha on layers.
        [self setLayersPrimaryAlphaWithPageIndex:0];
        [self setBackLayerPictureWithPageIndex:-1];
    } else {
        _currentState = ScrollingStateAuto;
    }
    
    // Make the scrollView animation.
    [_scrollView setContentOffset:CGPointMake(nextPage * _windowSize.width,0)
                         animated:YES];
    
    // Set the PageControl on the right page.
    [_pageControl setCurrentPage:nextPage];
    
    // Call the next animation after X seconds.
    [self autoScrollToNextPage];
}

// Call the next animation after X seconds.
- (void)autoScrollToNextPage{
    if (_autoScrollEnabled)
        [self performSelector:@selector(animateScrolling)
                   withObject:nil
                   afterDelay:_autoScrollDurationOnPage];
}

#pragma mark - Scrolling management
// Run it.
- (void)startScrolling{
    [self autoScrollToNextPage];
}

// Manually stop the scrolling
- (void)stopScrolling{
    _currentState = ScrollingStateManual;
}

#pragma mark - State management
// State.
- (ScrollingState)getCurrentState{
    return _currentState;
}

#pragma mark - Overlay management
// Setup the Title Label.
- (void)setOverlayTitle{
    // ...or change by an UIImageView if you need it.
    [_overlayTitle setText:@"Welcome"];
}

// Setup the SubTitle/Description style/text.
- (void)setOverlayTexts{
    int index = 0;
    for(ICETutorialPage *page in _pages){
        // SubTitles.
        if ([[[page subTitle] text] length]){
            UILabel *subTitle = [self overlayLabelWithText:[[page subTitle] text]
                                                     layer:[page subTitle]
                                               commonStyle:_commonPageSubTitleStyle
                                                     index:index];
            [_scrollView addSubview:subTitle];
        }
        // Description.
        if ([[[page description] text] length]){
            UILabel *description = [self overlayLabelWithText:[[page description] text]
                                                        layer:[page description]
                                                  commonStyle:_commonPageDescriptionStyle
                                                        index:index];
            [_scrollView addSubview:description];
        }
        
        index++;
    }
}

- (UILabel *)overlayLabelWithText:(NSString *)text
                            layer:(ICETutorialLabelStyle *)style
                      commonStyle:(ICETutorialLabelStyle *)commonStyle
                            index:(NSUInteger)index{
    // SubTitles.
    UILabel *overlayLabel = [[UILabel alloc] initWithFrame:CGRectMake((index  * _windowSize.width),
                                                                      _windowSize.height - [commonStyle offset],
                                                                      _windowSize.width,
                                                                      TUTORIAL_LABEL_HEIGHT)];
    [overlayLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [overlayLabel setNumberOfLines:[commonStyle linesNumber]];
    [overlayLabel setBackgroundColor:[UIColor clearColor]];
    [overlayLabel setTextAlignment:NSTextAlignmentCenter];
    
    // Datas and style.
    [overlayLabel setText:text];
    [style font] ? [overlayLabel setFont:[style font]] :
    [overlayLabel setFont:[commonStyle font]];
    if ([style textColor])
        [overlayLabel setTextColor:[style textColor]];
    else
        [overlayLabel setTextColor:[commonStyle textColor]];
    
    [_scrollView addSubview:overlayLabel];
    return overlayLabel;
}

#pragma mark - Layers management
// Handle the background layer image switch.
- (void)setBackLayerPictureWithPageIndex:(NSInteger)index{
    [self setBackgroundImage:_backLayerView withIndex:index + 1];
}

// Handle the front layer image switch.
- (void)setFrontLayerPictureWithPageIndex:(NSInteger)index{
    [self setBackgroundImage:_frontLayerView withIndex:index];
}

// Handle page image's loading
- (void)setBackgroundImage:(UIImageView *)imageView withIndex:(NSInteger)index{
    if (index >= [_pages count]){
        [imageView setImage:nil];
        return;
    }
    
    NSString *imageName = [NSString stringWithFormat:@"%@",[[_pages objectAtIndex:index] pictureName]];
    [imageView setImage:[UIImage imageNamed:imageName]];
}

// Setup layer's alpha.
- (void)setLayersPrimaryAlphaWithPageIndex:(NSInteger)index{
    [_frontLayerView setAlpha:1];
    [_backLayerView setAlpha:0];
}

// Preset the origin state.
- (void)setOriginLayersState{
    _currentState = ScrollingStateAuto;
    [_backLayerView setBackgroundColor:[UIColor blackColor]];
    [_frontLayerView setBackgroundColor:[UIColor blackColor]];
    [self setLayersPicturesWithIndex:0];
}

// Setup the layers with the page index.
- (void)setLayersPicturesWithIndex:(NSInteger)index{
    _currentPageIndex = index;
    [self setLayersPrimaryAlphaWithPageIndex:index];
    [self setFrontLayerPictureWithPageIndex:index];
    [self setBackLayerPictureWithPageIndex:index];
}

// Animate the fade-in/out (Cross-disolve) with the scrollView translation.
- (void)disolveBackgroundWithContentOffset:(float)offset{
    if (_currentState & ScrollingStateLooping){
        // Jump from the last page to the first.
        [self scrollingToFirstPageWithOffset:offset];
    } else {
        // Or just scroll to the next/previous page.
        [self scrollingToNextPageWithOffset:offset];
    }
}

// Handle alpha on layers when the auto-scrolling is looping to the first page.
- (void)scrollingToFirstPageWithOffset:(float)offset{
    // Compute the scrolling percentage on all the page.
    offset = (offset * _windowSize.width) / (_windowSize.width * [self numberOfPages]);
    
    // Scrolling finished...
    if (offset == 0){
        // ...reset to the origin state.
        [self setOriginLayersState];
        return;
    }
    
    // Invert alpha for the back picture.
    float backLayerAlpha = (1 - offset);
    float frontLayerAlpha = offset;
    
    // Set alpha.
    [_backLayerView setAlpha:backLayerAlpha];
    [_frontLayerView setAlpha:frontLayerAlpha];
}

// Handle alpha on layers when we are scrolling to the next/previous page.
- (void)scrollingToNextPageWithOffset:(float)offset{
    // Current page index in scrolling.
    NSInteger page = (int)(offset);
    
    // Keep only the float value.
    float alphaValue = offset - (int)offset;
    
    // This is only when you scroll to the right on the first page.
    // That will fade-in black the first picture.
    if (alphaValue < 0 && _currentPageIndex == 0){
        [_backLayerView setImage:nil];
        [_frontLayerView setAlpha:(1 + alphaValue)];
        return;
    }
    
    // Switch pictures, and imageView alpha.
    if (page != _currentPageIndex)
        [self setLayersPicturesWithIndex:page];
    
    // Invert alpha for the front picture.
    float backLayerAlpha = alphaValue;
    float frontLayerAlpha = (1 - alphaValue);
    
    // Set alpha.
    [_backLayerView setAlpha:backLayerAlpha];
    [_frontLayerView setAlpha:frontLayerAlpha];
}

#pragma mark - ScrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // Get scrolling position, and send the alpha values.
    float scrollingPosition = scrollView.contentOffset.x / _windowSize.width;
    [self disolveBackgroundWithContentOffset:scrollingPosition];
    
    if (_scrollView.isTracking)
        _currentState = ScrollingStateManual;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    // Update the page index.
    [_pageControl setCurrentPage:_currentPageIndex];
}

- (IBAction)tapOnLoginBtn:(id)sender {
    if ([usernameTextField.text length]==0) {
        [[HTActivityIndicator currentIndicator] displayMessage:@"用户名不能为空!"];
        return;
    }
    if ([passwordTextField.text length]==0) {
        [[HTActivityIndicator currentIndicator] displayMessage:@"密码不能为空!"];
        return;
    }
    //login
    [usernameTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];

    [self sendLogin];
}
- (void)sendLogin
{
    //[self.navigationController popViewControllerAnimated:YES];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:usernameTextField.text forKey:@"username"];
    [params setObject:passwordTextField.text forKey:@"password"];
    [LoginDataRequest requestWithDelegate:self withParameters:params];

    [[HTActivityIndicator currentIndicator] displayActivity:@"登陆中..."];
}

- (void)requestDidFinishLoad:(ITTBaseDataRequest*)request
{
    if ([request isSuccess]) {
        NSString *userId = [request.resultDic objectForKey:@"userId"];
        if (!userId) {
            [[HTActivityIndicator currentIndicator] displayMessage:[request.resultDic objectForKey:@"message"]];
            return;
        }
        [[NSUserDefaults standardUserDefaults]  setObject:userId forKey:@"USER_ID"];
        [[NSUserDefaults standardUserDefaults]  synchronize];
        //清空数据库
        LKDBHelper* globalHelper = [LKDBHelper getUsingLKDBHelper];
        [globalHelper dropAllTable];
        
        //创建表  会根据表的版本号  来判断具体的操作 . create table need to manually call
        [globalHelper createTableWithModelClass:[News class]];
        [globalHelper createTableWithModelClass:[Event class]];
        [[HTActivityIndicator currentIndicator] hide];
        [[HTActivityIndicator currentIndicator] displayMessage:@"登陆成功!"];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [[HTActivityIndicator currentIndicator] displayMessage:request.result.message];
    }
}


- (void)request:(ITTBaseDataRequest*)request didFailLoadWithError:(NSError*)error
{
    [[HTActivityIndicator currentIndicator] displayMessage:@"网络不佳，请检查网络!"];
    
//    [[NSUserDefaults standardUserDefaults]  setObject:@"74bd412debd448418ac89fe554300623" forKey:@"USER_ID"];
//    [[NSUserDefaults standardUserDefaults]  synchronize];
//    [self.navigationController popViewControllerAnimated:YES];

}


- (IBAction)tapOnAboutBtn:(id)sender {
    AboutViewController *viewController = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:NO];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSInteger strLength = textField.text.length - range.length + string.length;
    if (textField.tag ==1) {
        if (strLength>0&&passwordTextField.text.length>0) {
            loginButton.enabled = YES;
        }else{
            loginButton.enabled = YES;//NO;
        }
    }else if (textField.tag ==2) {
        if (strLength>0&&usernameTextField.text.length>0) {
            loginButton.enabled = YES;
        }else{
            loginButton.enabled = YES;//NO;
        }
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self tapOnLoginBtn:nil];
    return  YES;
}

@end
