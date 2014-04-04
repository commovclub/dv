//
//  ITTDataRequestManager.h

#import <Foundation/Foundation.h>
@class ITTBaseDataRequest;

@interface ITTDataRequestManager : NSObject{
    NSMutableArray *_requests;
}

+ (ITTDataRequestManager *)sharedManager;

- (void)addRequest:(ITTBaseDataRequest*)request;
- (void)removeRequest:(ITTBaseDataRequest*)request;
@end
