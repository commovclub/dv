//
//  ITSActivityIndicator.m

#import "HTActivityIndicator.h"
#import <QuartzCore/QuartzCore.h>

#define SHKdegreesToRadians(x) (M_PI * x / 180.0)
#define TOP_DISPLAY_Y   67.0f

@implementation HTActivityIndicator

@synthesize centerMessageLabel, subMessageLabel;
@synthesize spinner;

static HTActivityIndicator *currentIndicator = nil;

+ (HTActivityIndicator *)currentIndicator
{
	if (currentIndicator == nil)
	{
        
		UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];		
		CGFloat width = 180;
		CGFloat height = 120;
        
		CGRect centeredFrame = CGRectMake(round(keyWindow.bounds.size.width/2 - width/2),
                                          round(keyWindow.bounds.size.height/2 - height/2),
                                                          width,
                                                          height);
        
        currentIndicator = [[HTActivityIndicator alloc] initWithFrame:centeredFrame];		
		currentIndicator.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
		currentIndicator.opaque = NO;
		currentIndicator.alpha = 0;
		
		currentIndicator.layer.cornerRadius = 10;
		
		currentIndicator.userInteractionEnabled = NO;
		currentIndicator.autoresizesSubviews = YES;
		currentIndicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |  UIViewAutoresizingFlexibleTopMargin |  UIViewAutoresizingFlexibleBottomMargin;
		
		[currentIndicator setProperRotation:NO];
		
		[[NSNotificationCenter defaultCenter] addObserver:currentIndicator
												 selector:@selector(setProperRotation)
													 name:UIDeviceOrientationDidChangeNotification
												   object:nil];
	}
	
	return currentIndicator;
}

+ (void)isTopDisplay:(BOOL)ifTopDisPlay;
{
    if (ifTopDisPlay)
    {
        CGFloat width = 180;
		CGFloat height = 120;
        UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];		

        currentIndicator.frame = CGRectMake(round(keyWindow.bounds.size.width/2 - width/2),
                                            TOP_DISPLAY_Y,
                                            width,
                                            height);
    }
}




#pragma mark -

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
	
	
}

#pragma mark Creating Message

- (void)show
{	
    [self setProperRotation:NO];
	if ([self superview] != [[UIApplication sharedApplication] keyWindow]) 
		[[[UIApplication sharedApplication] keyWindow] addSubview:self];
	
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hide) object:nil];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	
	self.alpha = 1;
	
	[UIView commitAnimations];
}

- (void)hideAfterDelay:(CGFloat)delayTime
{
	[self performSelector:@selector(hide) withObject:nil afterDelay:delayTime];
}

- (void)hide
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.4];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(hidden)];
	
	self.alpha = 0;
	
	[UIView commitAnimations];
}

- (void)persist
{	
    [self setProperRotation:NO];
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hide) object:nil];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:0.1];
	
	self.alpha = 1;
	
	[UIView commitAnimations];
}

- (void)hidden
{
	if (currentIndicator.alpha > 0)
		return;
	
	[currentIndicator removeFromSuperview];
	currentIndicator = nil;
}


- (void)displayMessage:(NSString *)m
{
	[self setCenterMessage:m];
	
	[spinner removeFromSuperview];
	spinner = nil;
    
    [subMessageLabel removeFromSuperview];
    subMessageLabel = nil;
	
	if ([self superview] == nil)
		[self show];
	else
		[self persist];
    
	[self hideAfterDelay:2.0];
}


- (void)displayMessage:(NSString *)m afterDelay:(CGFloat)delayTime
{
    [self performSelector:@selector(displayMessage:) withObject:m afterDelay:delayTime];
}

- (void)displayActivity:(NSString *)m
{		
	[self setSubMessage:m];
	[self showSpinner];	
	
	[centerMessageLabel removeFromSuperview];
	centerMessageLabel = nil;
	
	if ([self superview] == nil)
		[self show];
	else
		[self persist];
}

- (void)displayCompleted:(NSString *)m
{	
	[self setCenterMessage:@"✓"];
	[self setSubMessage:m];
	
	[spinner removeFromSuperview];
	spinner = nil;
	
	if ([self superview] == nil)
		[self show];
	else
		[self persist];
    
	[self hideAfterDelay:2.0];
}

- (void)displayFailed:(NSString *)m
{
    [self setCenterMessage:@"×"];
	[self setSubMessage:m];
	
	[spinner removeFromSuperview];
	spinner = nil;
	
	if ([self superview] == nil)
		[self show];
	else
		[self persist];
    
	[self hideAfterDelay:2.0];
}

- (void)setCenterMessage:(NSString *)message
{	
	if (message == nil && centerMessageLabel != nil)
		self.centerMessageLabel = nil;
    
	else if (message != nil)
	{
		if (centerMessageLabel == nil)
		{
			self.centerMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(12,25,self.bounds.size.width-24,70)];
			centerMessageLabel.backgroundColor = [UIColor clearColor];
			centerMessageLabel.opaque = NO;
			centerMessageLabel.textColor = [UIColor whiteColor];
			centerMessageLabel.font = [UIFont boldSystemFontOfSize:15];
			centerMessageLabel.textAlignment = UITextAlignmentCenter;
			centerMessageLabel.shadowColor = [UIColor darkGrayColor];
			centerMessageLabel.shadowOffset = CGSizeMake(1,1);
            centerMessageLabel.numberOfLines = 0;
            centerMessageLabel.lineBreakMode = UILineBreakModeWordWrap;
			
			[self addSubview:centerMessageLabel];
		}
		
		centerMessageLabel.text = message;
	}
}

- (void)setSubMessage:(NSString *)message
{	
	if (message == nil && subMessageLabel != nil)
		self.subMessageLabel = nil;
	
	else if (message != nil)
	{
		if (subMessageLabel == nil)
		{
			self.subMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(12,self.bounds.size.height - 60,self.bounds.size.width-24,40)];
			subMessageLabel.backgroundColor = [UIColor clearColor];
			subMessageLabel.opaque = NO;
            subMessageLabel.numberOfLines = 2;
			subMessageLabel.textColor = [UIColor whiteColor];
			subMessageLabel.font = [UIFont boldSystemFontOfSize:15];
			subMessageLabel.textAlignment = UITextAlignmentCenter;
			subMessageLabel.shadowColor = [UIColor darkGrayColor];
			subMessageLabel.shadowOffset = CGSizeMake(1,1);
			//subMessageLabel.adjustsFontSizeToFitWidth = YES;
			
			[self addSubview:subMessageLabel];
		}
		
		subMessageLabel.text = message;
	}
}

- (void)showSpinner
{	
	if (spinner == nil)
	{
		self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        
		spinner.frame = CGRectMake(round(self.bounds.size.width/2 - self.spinner.size.width/2),
                                   round(self.bounds.size.height/2 - self.spinner.size.height/2 - 10),self.spinner.size.width,self.spinner.size.height);		
	}
	
	[self addSubview:spinner];
	[spinner startAnimating];
}

#pragma mark -
#pragma mark Rotation

- (void)setProperRotation
{
	[self setProperRotation:YES];
}

- (void)setProperRotation:(BOOL)animated
{
	UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
	
	if (animated)
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3];
	}
	
	if (orientation == UIInterfaceOrientationPortraitUpsideDown)
		self.transform = CGAffineTransformRotate(CGAffineTransformIdentity, SHKdegreesToRadians(180));	
	
	else if (orientation == UIInterfaceOrientationLandscapeLeft)
		self.transform = CGAffineTransformRotate(CGAffineTransformIdentity, SHKdegreesToRadians(-90));	
	
	else if (orientation == UIInterfaceOrientationLandscapeRight)
		self.transform = CGAffineTransformRotate(CGAffineTransformIdentity, SHKdegreesToRadians(90));
	else
        
		self.transform = CGAffineTransformRotate(CGAffineTransformIdentity, SHKdegreesToRadians(0));
	if (animated)
		[UIView commitAnimations];
}


@end
