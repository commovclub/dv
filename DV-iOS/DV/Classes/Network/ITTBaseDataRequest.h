//
//  ITTBaseDataRequest.h
//  
//
//  Created by lian jie on 6/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "ITTRequestResult.h"
#import "DataCacheManager.h"
#import "ITTMaskActivityView.h"

typedef enum : NSUInteger{
	ITTRequestMethodGet = 0,
	ITTRequestMethodPost = 1,           // content type = @"application/x-www-form-urlencoded"
	ITTRequestMethodMultipartPost = 2   // content type = @"multipart/form-data"
} ITTRequestMethod;

@class ITTBaseDataRequest;

@protocol DataRequestDelegate <NSObject>

@optional
- (void)requestDidStartLoad:(ITTBaseDataRequest*)request;
- (void)requestDidFinishLoad:(ITTBaseDataRequest*)request;
- (void)requestDidCancelLoad:(ITTBaseDataRequest*)request;
- (void)request:(ITTBaseDataRequest*)request progressChanged:(float)progress;
- (void)request:(ITTBaseDataRequest*)request didFailLoadWithError:(NSError*)error;

@end

@interface ITTBaseDataRequest : NSObject {      
    NSString *_cancelSubject;
    BOOL _useSilentAlert;
    
    NSDate *_requestStartTime;
    BOOL _usingCacheData;
    NSString *_cacheKey;
    DataCacheManagerCacheType _cacheType;
    ITTMaskActivityView *_maskActivityView;
    NSString *_filePath;
    
    void (^_onRequestStartBlock)(ITTBaseDataRequest *);
    void (^_onRequestFinishBlock)(ITTBaseDataRequest *);
    void (^_onRequestCanceled)(ITTBaseDataRequest *);
    void (^_onRequestFailedBlock)(ITTBaseDataRequest *,NSError *);
    void (^_onRequestProgressChangedBlock)(ITTBaseDataRequest *,float);
    
    //progress related
    long long _totalData;
    long long _downloadedData;
    float _currentProgress;
}

@property (nonatomic, strong) id<DataRequestDelegate> delegate;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, strong) NSString *requestUrl;
@property (nonatomic, strong) NSString *loadingMessage;
@property (nonatomic, strong) UIView *indicatorView;
@property (nonatomic, strong) NSMutableDictionary *resultDic;
@property (nonatomic, strong) NSString *resultString;
@property (nonatomic, strong) ITTRequestResult *result;
@property (nonatomic, strong,readonly) NSDictionary *parameters;

#pragma mark - init methods using delegate
+ (id)silentRequestWithDelegate:(id<DataRequestDelegate>)delegate;

+ (id)requestWithDelegate:(id<DataRequestDelegate>)delegate;

+ (id)requestWithDelegate:(id<DataRequestDelegate>)delegate
          withCancelSubject:(NSString*)cancelSubject;

+ (id)silentRequestWithDelegate:(id<DataRequestDelegate>)delegate 
                   withParameters:(NSDictionary*)params;

+ (id)requestWithDelegate:(id<DataRequestDelegate>)delegate 
             withParameters:(NSDictionary*)params;

+ (id)requestWithDelegate:(id<DataRequestDelegate>)delegate 
             withParameters:(NSDictionary*)params
               withCacheKey:(NSString*)cache
              withCacheType:(DataCacheManagerCacheType)cacheType;

+ (id)requestWithDelegate:(id<DataRequestDelegate>)delegate 
             withParameters:(NSDictionary*)params
          withCancelSubject:(NSString*)cancelSubject;

+ (id)requestWithDelegate:(id<DataRequestDelegate>)delegate
          withIndicatorView:(UIView*)indiView;

+ (id)requestWithDelegate:(id<DataRequestDelegate>)delegate
          withIndicatorView:(UIView*)indiView
          withCancelSubject:(NSString*)cancelSubject;

+ (id)requestWithDelegate:(id<DataRequestDelegate>)delegate
             withParameters:(NSDictionary*)params
          withIndicatorView:(UIView*)indiView;

+ (id)requestWithDelegate:(id<DataRequestDelegate>)delegate 
             withParameters:(NSDictionary*)params
          withIndicatorView:(UIView*)indiView
               withCacheKey:(NSString*)cache
              withCacheType:(DataCacheManagerCacheType)cacheType;

+ (id)requestWithDelegate:(id<DataRequestDelegate>)delegate 
             withParameters:(NSDictionary*)params
          withIndicatorView:(UIView*)indiView
          withCancelSubject:(NSString*)cancelSubject;

- (id)initWithDelegate:(id<DataRequestDelegate>)delegate
        withParameters:(NSDictionary*)params
     withIndicatorView:(UIView*)indiView
     withCancelSubject:(NSString*)cancelSubject
       withSilentAlert:(BOOL)silent
          withCacheKey:(NSString*)cache
         withCacheType:(DataCacheManagerCacheType)cacheType
          withFilePath:(NSString*)localFilePath;

- (id)initWithDelegate:(id<DataRequestDelegate>)delegate
        withRequestUrl:(NSString*)url
        withParameters:(NSDictionary*)params
     withIndicatorView:(UIView*)indiView
    withLoadingMessage:(NSString*)loadingMessage
     withCancelSubject:(NSString*)cancelSubject
       withSilentAlert:(BOOL)silent
          withCacheKey:(NSString*)cache
         withCacheType:(DataCacheManagerCacheType)cacheType
          withFilePath:(NSString*)localFilePath;

#pragma mark - init methods using blocks

+ (id)requestWithParameters:(NSDictionary*)params
            withIndicatorView:(UIView*)indiView
            withCancelSubject:(NSString*)cancelSubject
            onRequestFinished:(void(^)(ITTBaseDataRequest *request))onFinishedBlock;

+ (id)requestWithParameters:(NSDictionary*)params
            withIndicatorView:(UIView*)indiView
            withCancelSubject:(NSString*)cancelSubject
               onRequestStart:(void(^)(ITTBaseDataRequest *request))onStartBlock
            onRequestFinished:(void(^)(ITTBaseDataRequest *request))onFinishedBlock
            onRequestCanceled:(void(^)(ITTBaseDataRequest *request))onCanceledBlock
              onRequestFailed:(void(^)(ITTBaseDataRequest *request))onFailedBlock;

- (id)initWithParameters:(NSDictionary*)params
          withRequestUrl:(NSString*)url
       withIndicatorView:(UIView*)indiView
    withLoadingMessage:(NSString*)loadingMessage
       withCancelSubject:(NSString*)cancelSubject
         withSilentAlert:(BOOL)silent
            withCacheKey:(NSString*)cache
           withCacheType:(DataCacheManagerCacheType)cacheType
            withFilePath:(NSString*)localFilePath
          onRequestStart:(void(^)(ITTBaseDataRequest *request))onStartBlock
       onRequestFinished:(void(^)(ITTBaseDataRequest *request))onFinishedBlock
       onRequestCanceled:(void(^)(ITTBaseDataRequest *request))onCanceledBlock
         onRequestFailed:(void(^)(ITTBaseDataRequest *request))onFailedBlock
       onProgressChanged:(void(^)(ITTBaseDataRequest *request,float))onProgressChangedBlock;


#pragma mark - file download related init methods 
+ (void)requestWithDelegate:(id<DataRequestDelegate>)delegate 
             withParameters:(NSDictionary*)params
          withIndicatorView:(UIView*)indiView
          withCancelSubject:(NSString*)cancelSubject
               withFilePath:(NSString*)localFilePath;

+ (void)requestWithParameters:(NSDictionary*)params
            withIndicatorView:(UIView*)indiView
            withCancelSubject:(NSString*)cancelSubject
                 withFilePath:(NSString*)localFilePath
            onRequestFinished:(void(^)(ITTBaseDataRequest *request))onFinishedBlock
            onProgressChanged:(void(^)(ITTBaseDataRequest *request,float progress))onProgressChangedBlock;

+ (id)requestWithDelegate:(id<DataRequestDelegate>)delegate
           withParameters:(NSDictionary*)params withUrl:(NSString *)url;

- (void)doRelease;
- (void)processResult;
- (void)showIndicator:(BOOL)bshow;
- (void)doRequestWithParams:(NSDictionary*)params;
- (void)cancelRequest;
- (void)showNetowrkUnavailableAlertView:(NSString*)message;

- (BOOL)onReceivedCacheData:(NSObject*)cacheData;
- (BOOL)isSuccess;
- (BOOL)handleResultString:(NSString*)resultString;

- (ITTRequestMethod)getRequestMethod;

- (NSStringEncoding)getResponseEncoding;

- (NSString*)encodeURL:(NSString *)string;
- (NSString*)getRequestUrl;
- (NSString*)getRequestHost;

- (NSDictionary*)getStaticParams;
+ (NSDictionary*)getDicFromString:(NSString*)cachedResponse;

@end
