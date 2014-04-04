//
//  ITTBaseDataRequest.m
//
//
//  Created by lian jie on 6/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ITTBaseDataRequest.h"
#import "CJSONDeserializer.h"
#import "DataCacheManager.h"
#import "ITTDataRequestManager.h"
#import "ITTMaskActivityView.h"

#define DEFAULT_LOADING_MESSAGE  @"正在加载..."

@interface ITTBaseDataRequest(){
}
@end

@implementation ITTBaseDataRequest

#pragma mark - init methods using delegate

+ (id)silentRequestWithDelegate:(id<DataRequestDelegate>)delegate
{
    ITTBaseDataRequest *request = [[[self class] alloc] initWithDelegate:delegate
                                                          withParameters:nil
                                                       withIndicatorView:nil
                                                       withCancelSubject:nil
                                                         withSilentAlert:YES
                                                            withCacheKey:nil
                                                           withCacheType:DataCacheManagerCacheTypeMemory
                                                            withFilePath:nil];
    [[ITTDataRequestManager sharedManager] addRequest:request];
    return request;
}

+ (id)requestWithDelegate:(id<DataRequestDelegate>)delegate
{
	ITTBaseDataRequest *request = [[[self class] alloc] initWithDelegate:delegate
                                                          withParameters:nil
                                                       withIndicatorView:nil
                                                       withCancelSubject:nil
                                                         withSilentAlert:NO
                                                            withCacheKey:nil
                                                           withCacheType:DataCacheManagerCacheTypeMemory
                                                            withFilePath:nil];
    [[ITTDataRequestManager sharedManager] addRequest:request];
    return request;
}

+ (id)requestWithDelegate:(id<DataRequestDelegate>)delegate
        withCancelSubject:(NSString*)cancelSubject
{
	ITTBaseDataRequest *request = [[[self class] alloc] initWithDelegate:delegate
                                                          withParameters:nil
                                                       withIndicatorView:nil
                                                       withCancelSubject:cancelSubject
                                                         withSilentAlert:NO
                                                            withCacheKey:nil
                                                           withCacheType:DataCacheManagerCacheTypeMemory
                                                            withFilePath:nil];
    [[ITTDataRequestManager sharedManager] addRequest:request];
    return request;
}

+ (id)silentRequestWithDelegate:(id<DataRequestDelegate>)delegate
                 withParameters:(NSDictionary*)params
{
    ITTBaseDataRequest *request = [[[self class] alloc] initWithDelegate:delegate
                                                          withParameters:params
                                                       withIndicatorView:nil
                                                       withCancelSubject:nil
                                                         withSilentAlert:YES
                                                            withCacheKey:nil
                                                           withCacheType:DataCacheManagerCacheTypeMemory
                                                            withFilePath:nil];
    [[ITTDataRequestManager sharedManager] addRequest:request];
    return request;
}

+ (id)requestWithDelegate:(id<DataRequestDelegate>)delegate
           withParameters:(NSDictionary*)params
{
	ITTBaseDataRequest *request = [[[self class] alloc] initWithDelegate:delegate
                                                          withParameters:params
                                                       withIndicatorView:nil
                                                       withCancelSubject:nil
                                                         withSilentAlert:NO
                                                            withCacheKey:nil
                                                           withCacheType:DataCacheManagerCacheTypeMemory
                                                            withFilePath:nil];
    [[ITTDataRequestManager sharedManager] addRequest:request];
    return request;
}

+ (id)requestWithDelegate:(id<DataRequestDelegate>)delegate
           withParameters:(NSDictionary*)params withUrl:(NSString *)url
{
    ITTBaseDataRequest *request = [[[self class] alloc] initWithDelegate:(id<DataRequestDelegate>)delegate
                                                          withRequestUrl:url
                                                          withParameters:params
                                                       withIndicatorView:nil
                                                      withLoadingMessage:nil
                                                       withCancelSubject:nil
                                                         withSilentAlert:NO
                                                            withCacheKey:nil
                                                           withCacheType:DataCacheManagerCacheTypeMemory
                                                            withFilePath:nil];
    [[ITTDataRequestManager sharedManager] addRequest:request];
    return request;
}

+ (id)requestWithDelegate:(id<DataRequestDelegate>)delegate
           withParameters:(NSDictionary*)params
             withCacheKey:(NSString*)cache
            withCacheType:(DataCacheManagerCacheType)cacheType
{
    ITTBaseDataRequest *request = [[[self class] alloc] initWithDelegate:delegate
                                                          withParameters:params
                                                       withIndicatorView:nil
                                                       withCancelSubject:nil
                                                         withSilentAlert:NO
                                                            withCacheKey:cache
                                                           withCacheType:cacheType
                                                            withFilePath:nil];
    [[ITTDataRequestManager sharedManager] addRequest:request];
    return request;
}

+ (id)requestWithDelegate:(id<DataRequestDelegate>)delegate
           withParameters:(NSDictionary*)params
        withCancelSubject:(NSString*)cancelSubject
{
	ITTBaseDataRequest *request = [[[self class] alloc] initWithDelegate:delegate
                                                          withParameters:params
                                                       withIndicatorView:nil
                                                       withCancelSubject:cancelSubject
                                                         withSilentAlert:NO
                                                            withCacheKey:nil
                                                           withCacheType:DataCacheManagerCacheTypeMemory
                                                            withFilePath:nil];
    [[ITTDataRequestManager sharedManager] addRequest:request];
    return request;
}

+ (id)requestWithDelegate:(id<DataRequestDelegate>)delegate
        withIndicatorView:(UIView*)indiView
        withCancelSubject:(NSString*)cancelSubject
{
	ITTBaseDataRequest *request = [[[self class] alloc] initWithDelegate:delegate
                                                          withParameters:nil
                                                       withIndicatorView:indiView
                                                       withCancelSubject:cancelSubject
                                                         withSilentAlert:NO
                                                            withCacheKey:nil
                                                           withCacheType:DataCacheManagerCacheTypeMemory
                                                            withFilePath:nil];
    [[ITTDataRequestManager sharedManager] addRequest:request];
    return request;
}

+ (id)requestWithDelegate:(id<DataRequestDelegate>)delegate
        withIndicatorView:(UIView*)indiView
{
	ITTBaseDataRequest *request = [[[self class] alloc] initWithDelegate:delegate
                                                          withParameters:nil
                                                       withIndicatorView:indiView
                                                       withCancelSubject:nil
                                                         withSilentAlert:NO
                                                            withCacheKey:nil
                                                           withCacheType:DataCacheManagerCacheTypeMemory
                                                            withFilePath:nil];
    [[ITTDataRequestManager sharedManager] addRequest:request];
    return request;
}

+ (id)requestWithDelegate:(id<DataRequestDelegate>)delegate
           withParameters:(NSDictionary*)params
        withIndicatorView:(UIView*)indiView
{
	ITTBaseDataRequest *request = [[[self class] alloc] initWithDelegate:delegate
                                                          withParameters:params
                                                       withIndicatorView:indiView
                                                       withCancelSubject:nil
                                                         withSilentAlert:NO
                                                            withCacheKey:nil
                                                           withCacheType:DataCacheManagerCacheTypeMemory
                                                            withFilePath:nil];
    [[ITTDataRequestManager sharedManager] addRequest:request];
    return request;
}

+ (id)requestWithDelegate:(id<DataRequestDelegate>)delegate
           withParameters:(NSDictionary*)params
        withIndicatorView:(UIView*)indiView
             withCacheKey:(NSString*)cache
            withCacheType:(DataCacheManagerCacheType)cacheType
{
	ITTBaseDataRequest *request = [[[self class] alloc] initWithDelegate:delegate
                                                          withParameters:params
                                                       withIndicatorView:indiView
                                                       withCancelSubject:nil
                                                         withSilentAlert:NO
                                                            withCacheKey:cache
                                                           withCacheType:DataCacheManagerCacheTypeMemory
                                                            withFilePath:nil];
    [[ITTDataRequestManager sharedManager] addRequest:request];
    return request;
}

+ (id)requestWithDelegate:(id<DataRequestDelegate>)delegate
           withParameters:(NSDictionary*)params
        withIndicatorView:(UIView*)indiView
        withCancelSubject:(NSString*)cancelSubject
{
	ITTBaseDataRequest *request = [[[self class] alloc] initWithDelegate:delegate
                                                          withParameters:params
                                                       withIndicatorView:indiView
                                                       withCancelSubject:cancelSubject
                                                         withSilentAlert:NO
                                                            withCacheKey:nil
                                                           withCacheType:DataCacheManagerCacheTypeMemory
                                                            withFilePath:nil];
    [[ITTDataRequestManager sharedManager] addRequest:request];
    return request;
}

- (id)initWithDelegate:(id<DataRequestDelegate>)delegate
        withParameters:(NSDictionary*)params
     withIndicatorView:(UIView*)indiView
     withCancelSubject:(NSString*)cancelSubject
       withSilentAlert:(BOOL)silent
          withCacheKey:(NSString*)cacheKey
         withCacheType:(DataCacheManagerCacheType)cacheType
          withFilePath:(NSString*)localFilePath
{
    
	return [self initWithDelegate:delegate
                   withRequestUrl:nil
                   withParameters:params
                withIndicatorView:indiView
               withLoadingMessage:nil
                withCancelSubject:cancelSubject
                  withSilentAlert:silent
                     withCacheKey:cacheKey
                    withCacheType:cacheType
                     withFilePath:localFilePath];
}

- (id)initWithDelegate:(id<DataRequestDelegate>)delegate
        withRequestUrl:(NSString*)url
        withParameters:(NSDictionary*)params
     withIndicatorView:(UIView*)indiView
    withLoadingMessage:(NSString*)loadingMessage
     withCancelSubject:(NSString*)cancelSubject
       withSilentAlert:(BOOL)silent
          withCacheKey:(NSString*)cache
         withCacheType:(DataCacheManagerCacheType)cacheType
          withFilePath:(NSString*)localFilePath
{
    self = [super init];
	if(self) {
        _requestUrl = url;
        if (!_requestUrl) {
            _requestUrl = [self getRequestUrl];
        }
		_indicatorView = indiView;
		_isLoading = NO;
		_delegate = delegate;
		_resultDic = nil;
        _result = nil;
        _useSilentAlert = silent;
        _cacheKey = cache;
        if (_cacheKey && [_cacheKey length] > 0) {
            _usingCacheData = YES;
        }
        _cacheType = cacheType;
        if (cancelSubject && cancelSubject.length > 0) {
            _cancelSubject = cancelSubject;
        }
        
        if (_cancelSubject && _cancelSubject) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelRequest) name:_cancelSubject object:nil];
        }
        
        _totalData = NSIntegerMax;
        _downloadedData = 0;
        _currentProgress = 0;
        
        _requestStartTime = [NSDate date];
        _parameters = params;
        BOOL useCurrentCache = NO;
        if (localFilePath) {
            _filePath = localFilePath;
        }
        
        NSObject *cacheData = [[DataCacheManager sharedManager] getCachedObjectByKey:_cacheKey];
        if (cacheData) {
            useCurrentCache = [self onReceivedCacheData:cacheData];
        }
        
        if (!useCurrentCache) {
            _usingCacheData = NO;
            [self doRequestWithParams:params];
            ITTDINFO(@"request %@ is created", [self class]);
        }else{
            _usingCacheData = YES;
            [self performSelector:@selector(doRelease) withObject:nil afterDelay:0.1f];
        }
        self.loadingMessage = loadingMessage;
        if (!self.loadingMessage) {
            self.loadingMessage = DEFAULT_LOADING_MESSAGE;
        }
	}
	return self;
}

#pragma mark - init methods using delegate

+ (id)requestWithParameters:(NSDictionary*)params
          withIndicatorView:(UIView*)indiView
          withCancelSubject:(NSString*)cancelSubject
          onRequestFinished:(void(^)(ITTBaseDataRequest *request))onFinishedBlock
{
    
	ITTBaseDataRequest *request = [[[self class] alloc] initWithParameters:params
                                                            withRequestUrl:nil
                                                         withIndicatorView:indiView
                                                        withLoadingMessage:nil
                                                         withCancelSubject:cancelSubject
                                                           withSilentAlert:YES
                                                              withCacheKey:nil
                                                             withCacheType:DataCacheManagerCacheTypeMemory
                                                              withFilePath:nil
                                                            onRequestStart:nil
                                                         onRequestFinished:onFinishedBlock
                                                         onRequestCanceled:nil
                                                           onRequestFailed:nil
                                                         onProgressChanged:nil];
    [[ITTDataRequestManager sharedManager] addRequest:request];
    return request;
}

+ (id)requestWithParameters:(NSDictionary*)params
          withIndicatorView:(UIView*)indiView
          withCancelSubject:(NSString*)cancelSubject
             onRequestStart:(void(^)(ITTBaseDataRequest *request))onStartBlock
          onRequestFinished:(void(^)(ITTBaseDataRequest *request))onFinishedBlock
          onRequestCanceled:(void(^)(ITTBaseDataRequest *request))onCanceledBlock
            onRequestFailed:(void(^)(ITTBaseDataRequest *request))onFailedBlock
{
    
	ITTBaseDataRequest *request = [[[self class] alloc] initWithParameters:params
                                                            withRequestUrl:nil
                                                         withIndicatorView:indiView
                                                        withLoadingMessage:nil
                                                         withCancelSubject:cancelSubject
                                                           withSilentAlert:YES
                                                              withCacheKey:nil
                                                             withCacheType:DataCacheManagerCacheTypeMemory
                                                              withFilePath:nil
                                                            onRequestStart:onStartBlock
                                                         onRequestFinished:onFinishedBlock
                                                         onRequestCanceled:onCanceledBlock
                                                           onRequestFailed:onFailedBlock
                                                         onProgressChanged:nil];
    [[ITTDataRequestManager sharedManager] addRequest:request];
    return request;
}



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
       onProgressChanged:(void(^)(ITTBaseDataRequest *request,float))onProgressChangedBlock
{
    self = [super init];
	if(self) {
        _requestUrl = url;
        if (!_requestUrl) {
            _requestUrl = [self getRequestUrl];
        }
		_indicatorView = indiView;
		_isLoading = NO;
		_resultDic = nil;
        _result = nil;
        _useSilentAlert = silent;
        _cacheKey = cache;
        if (_cacheKey && [_cacheKey length] > 0) {
            _usingCacheData = YES;
        }
        _cacheType = cacheType;
        if (cancelSubject && cancelSubject.length > 0) {
            _cancelSubject = cancelSubject;
        }
        
        if (_cancelSubject && _cancelSubject) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelRequest) name:_cancelSubject object:nil];
        }
        if (onStartBlock) {
            _onRequestStartBlock = [onStartBlock copy];
        }
        if (onFinishedBlock) {
            _onRequestFinishBlock = [onFinishedBlock copy];
        }
        if (onCanceledBlock) {
            _onRequestCanceled = [onCanceledBlock copy];
        }
        if (onFailedBlock) {
            _onRequestFailedBlock = [onFailedBlock copy];
        }
        if (onProgressChangedBlock) {
            _onRequestProgressChangedBlock = [onProgressChangedBlock copy];
        }
        if (localFilePath) {
            _filePath = localFilePath;
        }
        self.loadingMessage = loadingMessage;
        if (!self.loadingMessage) {
            self.loadingMessage = DEFAULT_LOADING_MESSAGE;
        }
        _requestStartTime = [NSDate date];
        _parameters = params;
        BOOL useCurrentCache = NO;
        
        NSObject *cacheData = [[DataCacheManager sharedManager] getCachedObjectByKey:_cacheKey];
        if (cacheData) {
            useCurrentCache = [self onReceivedCacheData:cacheData];
        }
        
        if (!useCurrentCache) {
            _usingCacheData = NO;
            [self doRequestWithParams:params];
            ITTDINFO(@"request %@ is created", [self class]);
        }else{
            _usingCacheData = YES;
            [self performSelector:@selector(doRelease) withObject:nil afterDelay:0.1f];
        }
	}
	return self;
}

#pragma mark - file download related init methods
+ (void)requestWithDelegate:(id<DataRequestDelegate>)delegate
             withParameters:(NSDictionary*)params
          withIndicatorView:(UIView*)indiView
          withCancelSubject:(NSString*)cancelSubject
               withFilePath:(NSString*)localFilePath
{
    
	ITTBaseDataRequest *request = [[[self class] alloc] initWithDelegate:delegate
                                                          withParameters:params
                                                       withIndicatorView:indiView
                                                       withCancelSubject:cancelSubject
                                                         withSilentAlert:NO
                                                            withCacheKey:nil
                                                           withCacheType:DataCacheManagerCacheTypeMemory
                                                            withFilePath:localFilePath];
    [[ITTDataRequestManager sharedManager] addRequest:request];
}

+ (void)requestWithParameters:(NSDictionary*)params
            withIndicatorView:(UIView*)indiView
            withCancelSubject:(NSString*)cancelSubject
                 withFilePath:(NSString*)localFilePath
            onRequestFinished:(void(^)(ITTBaseDataRequest *request))onFinishedBlock
            onProgressChanged:(void(^)(ITTBaseDataRequest *request,float))onProgressChangedBlock
{
    
	ITTBaseDataRequest *request = [[[self class] alloc] initWithParameters:params
                                                            withRequestUrl:nil
                                                         withIndicatorView:indiView
                                                        withLoadingMessage:nil
                                                         withCancelSubject:cancelSubject
                                                           withSilentAlert:YES
                                                              withCacheKey:nil
                                                             withCacheType:DataCacheManagerCacheTypeMemory
                                                              withFilePath:localFilePath
                                                            onRequestStart:nil
                                                         onRequestFinished:onFinishedBlock
                                                         onRequestCanceled:nil
                                                           onRequestFailed:nil
                                                         onProgressChanged:onProgressChangedBlock];
    [[ITTDataRequestManager sharedManager] addRequest:request];
}

#pragma mark - lifecycle methods

- (void)doRelease
{
    //remove self from Request Manager to release self;
    [[ITTDataRequestManager sharedManager] removeRequest:self];
}

- (void)dealloc
{
    if (_indicatorView) {
        //make sure indicator is closed
        [self showIndicator:NO];
    }
    if (_cancelSubject && _cancelSubject) {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:_cancelSubject
                                                      object:nil];
    }
    
    ITTDINFO(@"request %@ is released,time spend on this request:%f seconds", [self class],[[NSDate date] timeIntervalSinceDate:_requestStartTime]);
}

#pragma mark - util methods

+ (NSDictionary*)getDicFromString:(NSString*)cachedResponse
{
	NSData *jsonData = [cachedResponse dataUsingEncoding:NSUTF8StringEncoding];
	return [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:nil];
}

- (BOOL)onReceivedCacheData:(NSObject*)cacheData
{
    // handle cache data in subclass
    // return yes to finish request, return no to continue request from server
    return NO;
}

- (void)processResult
{
    _result = [[ITTRequestResult alloc] initWithCode:self.resultDic[@"code"]
                                         withMessage:self.resultDic[@"msg"]];
    if (![_result isSuccess]) {
        ITTDERROR(@"request[%@] failed with message %@",self,_result.code);
    }else {
        ITTDINFO(@"request[%@] :%@" ,self ,@"success");
    }
}

- (BOOL)isSuccess
{
    if (_result && [_result isSuccess]) {
        return YES;
    }
    return NO;
}

- (NSString*)encodeURL:(NSString *)string
{
	NSString *newString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)string, NULL, CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
	if (newString) {
		return newString;
	}
	return @"";
}

- (void)cancelRequest
{
}

- (void)showNetowrkUnavailableAlertView:(NSString*)message
{
}

- (void)showIndicator:(BOOL)bshow
{
	_isLoading = bshow;
    if (bshow) {
        if (!_maskActivityView) {
            _maskActivityView = [ITTMaskActivityView loadFromXib];
            [_maskActivityView showInView:self.indicatorView withHintMessage:self.loadingMessage onCancleRequest:^(ITTMaskActivityView *hintView){
                [self cancelRequest];
            }];
        }
    }else {
        if (_maskActivityView) {
            [_maskActivityView hide];
        }
    }
}

- (BOOL)handleResultString:(NSString*)resultString
{
    NSString *trimmedString = [resultString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	_resultString = trimmedString;
    //add callback here
	if (!_resultString || [_resultString length] == 0) {
		ITTDERROR(@"!empty response error with Request:%@",[self class]);
		return NO;
	}
	//ITTDINFO(@"raw response:%@",_resultString);
    
	NSData *jsonData;
	if ([[_resultString  substringWithRange:NSMakeRange(0,1)] isEqualToString: @"["] ) {
		jsonData = [[[@"{\"data\":" stringByAppendingString:self.resultString ] stringByAppendingString:@"}"] dataUsingEncoding:NSUTF8StringEncoding];
	}else {
		jsonData = [self.resultString  dataUsingEncoding:NSUTF8StringEncoding];
	}
    NSError *error;
    NSDictionary *resultDic = [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];
    
	if(!resultDic) {
        if (_delegate) {
            //using delegate
            if([_delegate respondsToSelector:@selector(request:didFailLoadWithError:)]){
                [_delegate request:self
              didFailLoadWithError:[NSError errorWithDomain:NSURLErrorDomain
                                                       code:0
                                                   userInfo:nil]];
            }
        }else {
            //using block callback
            if (_onRequestFailedBlock) {
                _onRequestFailedBlock(self,[NSError errorWithDomain:NSURLErrorDomain
                                                               code:0
                                                           userInfo:nil]);
            }
        }
        ITTDERROR(@"http request:%@\n with error:%@\n raw result:%@",[self class],error,_resultString);
        return NO;
	}else{
        _resultDic = [[NSMutableDictionary alloc] initWithDictionary:resultDic];
        [self processResult];
        if ([self.result isSuccess] && _cacheKey) {
            if (_cacheType == DataCacheManagerCacheTypeMemory) {
                [[DataCacheManager sharedManager] addObjectToMemory:self.resultDic forKey:_cacheKey];
            }else{
                [[DataCacheManager sharedManager] addObject:self.resultDic forKey:_cacheKey];
            }
        }
        
        
        if (_delegate) {
            if([_delegate respondsToSelector:@selector(requestDidFinishLoad:)]){
                [_delegate requestDidFinishLoad:self];
            }
        }else {
            if (_onRequestFinishBlock) {
                _onRequestFinishBlock(self);
            }
        }
        return YES;
    }
}

#pragma mark - hook methods
- (void)doRequestWithParams:(NSDictionary*)params
{
    ITTDERROR(@"should implement request logic here!");
}

- (NSStringEncoding)getResponseEncoding
{
    return NSUTF8StringEncoding;
    //return CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
}

- (NSDictionary*)getStaticParams
{
	return @{};
}

- (ITTRequestMethod)getRequestMethod
{
	return ITTRequestMethodGet;
}

- (NSString*)getRequestUrl
{
	return @"";
}

- (NSString*)getRequestHost
{
	return DATA_ENV.urlRequestHost;
}

@end
