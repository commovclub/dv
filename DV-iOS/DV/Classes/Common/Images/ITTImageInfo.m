//
//  ITTImageInfo.m

#import "ITTImageInfo.h"

@implementation ITTImageInfo

+ (NSString*)getImageUrlWithSourceUrl:(NSString*)url
{
    NSArray *urlArray = [url componentsSeparatedByString:@"."];
    if ([urlArray count] > 1) {
        NSString *extension = [urlArray lastObject];
        url = [url stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@".%@", extension] withString:[NSString stringWithFormat:@".%@_big", extension]];
    }
    return url;
}

- (NSDictionary*)attributeMapDictionary
{
	return @{@"title": @"script"
            ,@"url": @"img"
            ,@"smallUrl": @"img_small"};
}



@end
