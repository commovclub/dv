//
//  ITTImageInfo.h

#import "ITTBaseModelObject.h"

@interface ITTImageInfo : ITTBaseModelObject

@property (nonatomic,strong)NSString *title;
@property (nonatomic,strong)NSString *url;
@property (nonatomic,strong)NSString *smallUrl;

+ (NSString*)getImageUrlWithSourceUrl:(NSString*)url;

@end