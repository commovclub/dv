//
//  AppDelegate.m

#import "AppDelegate.h"
#import "ITTSideBarViewController.h"
#import "HTLoginDataRequest.h"
#import "MessageManager.h"
#import "ICETutorialController.h"
#import "MessageCount.h"

#import "BPush.h"
#import "MobClick.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"

@implementation AppDelegate
static AppDelegate *appDelegate = nil;

+ (AppDelegate *)shareAppdelegate
{
    return appDelegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    appDelegate = self;
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    _homeTabbarController = [[HomeTabBarController alloc] init];
    self.window.rootViewController = _homeTabbarController;
    [self.window makeKeyAndVisible];
    
    [self sendGetMessageCount];
    [self uploadToken];
    
    //UMeng
    [self configureUMeng];
    //push by baidu
    [BPush setupChannel:launchOptions];
    [BPush setDelegate:self];
    [application setApplicationIconBadgeNumber:0];
    [application registerForRemoteNotificationTypes:
     UIRemoteNotificationTypeAlert
     | UIRemoteNotificationTypeBadge
     | UIRemoteNotificationTypeSound];
    
    //白色状态条 need to set at plish
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    return YES;
}

- (void)configureUMeng{
    //统计
    [MobClick startWithAppkey:@"53323c7056240bb27f08bfb2" reportPolicy:SEND_INTERVAL   channelId:@""];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    [MobClick setLogEnabled:YES];
    //社会化分享
    [UMSocialData setAppKey:@"53323c7056240bb27f08bfb2"];
    [UMSocialWechatHandler setWXAppId:@"wxc4fa0aa3dee9488d" url:nil];
    [UMSocialData defaultData].extConfig.wechatSessionData.url = @"http://www.danaaa.com";
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = @"http://www.danaaa.com";
    [UMSocialData defaultData].extConfig.title = @"大拿俱乐部";
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    //send to baidu
    [BPush registerDeviceToken: deviceToken];
    [BPush bindChannel];
    
    //send to DV server
    NSString *str = [[[NSString stringWithFormat:@"%@", deviceToken]
                      stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]]
                     stringByReplacingOccurrencesOfString:@" " withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
	[[NSUserDefaults standardUserDefaults] setObject:str forKey:@"APNS_TOKEN"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [BPush handleNotification:userInfo];
}

- (void) onMethod:(NSString*)method response:(NSDictionary*)data {
    NSLog(@"On method:%@", method);
    NSLog(@"data:%@", [data description]);
    NSDictionary* res = [[NSDictionary alloc] initWithDictionary:data];
    if ([BPushRequestMethod_Bind isEqualToString:method]) {
        NSString *appid = [res valueForKey:BPushRequestAppIdKey];
        NSString *baiduUserid = [res valueForKey:BPushRequestUserIdKey];
        NSString *channelid = [res valueForKey:BPushRequestChannelIdKey];
        NSString *requestid = [res valueForKey:BPushRequestRequestIdKey];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@#%@",channelid,baiduUserid] forKey:@"BAIDU_USERID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self uploadToken];
        
        int returnCode = [[res valueForKey:BPushRequestErrorCodeKey] intValue];
        
        if (returnCode == BPushErrorCode_Success) {
            // 在内存中备份，以便短时间内进入可以看到这些值，而不需要重新bind
            self.appId = appid;
            self.channelId = channelid;
            self.userId = baiduUserid;
        }
    } else if ([BPushRequestMethod_Unbind isEqualToString:method]) {
        int returnCode = [[res valueForKey:BPushRequestErrorCodeKey] intValue];
        if (returnCode == BPushErrorCode_Success) {
            
        }
    }
}

- (void)uploadToken
{
    NSString *userId=[[NSUserDefaults standardUserDefaults] stringForKey:@"USER_ID"];
    NSString *apnsToken=[[NSUserDefaults standardUserDefaults] stringForKey:@"APNS_TOKEN"];
    NSString *baiduUserId=[[NSUserDefaults standardUserDefaults] stringForKey:@"BAIDU_USERID"];
    if (userId&&apnsToken&&baiduUserId) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:@"iOS" forKey:@"deviceType"];
        [params setObject:apnsToken forKey:@"deviceToken"];
        [params setObject:baiduUserId forKey:@"uuid"];
        [params setObject:userId forKey:@"token"];
        [HTGetTokenDataRequest requestWithDelegate:self withParameters:params];
    }
}

- (void)sendGetMessageCount
{
    NSString *userId=[[NSUserDefaults standardUserDefaults] stringForKey:@"USER_ID"];
    if (userId) {
        [CountOfMessageDataRequest requestWithDelegate:self withParameters:nil withUrl:[REQUEST_DOMAIN stringByAppendingFormat:@"message/count/%@",userId]];
    }
}

- (void)checkUpdate
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"iphone" forKey:@"platform"];
    [params setObject:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] forKey:@"version"];
    //[HTCheckUpdateDataRequest requestWithDelegate:self withParameters:params];
}


- (void)requestDidFinishLoad:(ITTBaseDataRequest*)request
{
    if ([request isSuccess]) {
        if([request isKindOfClass:[HTGetTokenDataRequest class]]){
            _updateDic = request.resultDic;
            [[NSUserDefaults standardUserDefaults]  setObject:[_updateDic objectForKey:@"token"] forKey:@"TOKEN"];
            [[NSUserDefaults standardUserDefaults]  synchronize];
        }
        else if([request isKindOfClass:[CountOfMessageDataRequest class]]){
            MessageCount *messageCount =[[MessageCount alloc] initWithDataDic:request.resultDic];
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            [defaults rm_setCustomObject:messageCount forKey:@"MESSAGE_COUNT"];
            [defaults synchronize];
            int count = ([messageCount.systemCount integerValue]+[messageCount.privateCount integerValue]+[messageCount.leadCount integerValue]);
            if (count>0){
                //update the red hint
                [_homeTabbarController updateUpdateHintView];
                [[UIApplication sharedApplication] setApplicationIconBadgeNumber:count];

            }
        }
    }else{
        [[HTActivityIndicator currentIndicator] displayMessage:request.result.message];
//        if([request isKindOfClass:[HTGetTokenDataRequest class]]){
//            
//            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"APNS_TOKEN"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//        }
    }
}

- (void)request:(ITTBaseDataRequest*)request didFailLoadWithError:(NSError*)error
{
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[_updateDic objectForKey:@"downloadUrl"]]];
    }
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [UMSocialSnsService  applicationDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}

@end
