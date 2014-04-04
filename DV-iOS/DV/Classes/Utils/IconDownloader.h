
@class RecommendApp;


@interface IconDownloader : NSObject

@property (nonatomic, strong) RecommendApp *recommendApp;
@property (nonatomic, copy) void (^completionHandler)(void);

- (void)startDownload;
- (void)cancelDownload;

@end
