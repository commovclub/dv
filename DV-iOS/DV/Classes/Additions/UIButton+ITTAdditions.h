//
//  UIButton+ITTAdditions.h

#import <UIKit/UIKit.h>

@interface UIButton (ITTAdditions)

+ (UIButton *)buttonWithFrame:(CGRect)frame
                        title:(NSString *)title 
                   titleColor:(UIColor *)titleColor
          titleHighlightColor:(UIColor *)titleHighlightColor
                    titleFont:(UIFont *)titleFont
                        image:(UIImage *)imageName
                  tappedImage:(UIImage *)tappedImageName
                       target:(id)target 
                       action:(SEL)selector 
                          tag:(NSInteger)tag;
@end
