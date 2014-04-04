//
//  DataEnvironment.m

#import "DataEnvironment.h"
#import "DataCacheManager.h"
#import "ITTObjectSingleton.h"
#import "MessageManager.h"
@interface DataEnvironment()
- (void)restore;
- (void)registerMemoryWarningNotification;
@end
@implementation DataEnvironment

ITTOBJECT_SINGLETON_BOILERPLATE(DataEnvironment, sharedDataEnvironment)


#pragma mark - lifecycle methods
- (id)init{
    self = [super init];
	if ( self) {
		[self restore];
        [self registerMemoryWarningNotification];
	}
	return self;
}

- (void)logout
{
    [[DataCacheManager sharedManager] removeObjectInCacheByKey:USERDEFAULT_LOGIN_USER];
    [[DataCacheManager sharedManager] clearAllCache];
    [[MessageManager sharedMessageManager] clearMessages];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:DATA_ENV.currentUser.userId forKey:@"uid"];
    [params setObject:@"" forKey:@"iosToken"];
    //[HTUploadTokenDataRequest requestWithDelegate:nil withParameters:params];
    self.currentUser = nil;
}


-(void)clearNetworkData{
    [[DataCacheManager sharedManager] clearAllCache];
}

#pragma mark - public methods
- (void)clearCacheData{
    //clear cache data if needed
}

#pragma mark - private methods
- (void)restore{
    _urlRequestHost = REQUEST_DOMAIN;
    HTUser *savedUser = (HTUser *)[[DataCacheManager sharedManager] getCachedObjectByKey:USERDEFAULT_LOGIN_USER];
    if (savedUser) {
        _currentUser = savedUser;
    }else{
        _currentUser = [[HTUser alloc] init];
    }
    _editingUser = [[HTUser alloc] init];
}
- (void)registerMemoryWarningNotification{
#if TARGET_OS_IPHONE
    // Subscribe to app events
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(clearCacheData)
                                                 name:UIApplicationDidReceiveMemoryWarningNotification
                                               object:nil];    
#ifdef __IPHONE_4_0
    UIDevice *device = [UIDevice currentDevice];
    if ([device respondsToSelector:@selector(isMultitaskingSupported)] && device.multitaskingSupported){
        // When in background, clean memory in order to have less chance to be killed
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(clearCacheData)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
    }
#endif
#endif        
}

@end