//
//  ITTXibView.m

#import "ITTXibView.h"
#import "ITTXibViewUtils.h"


@implementation ITTXibView

+ (id)loadFromXib {
    return [ITTXibViewUtils loadViewFromXibNamed:NSStringFromClass([self class])];
}
@end
