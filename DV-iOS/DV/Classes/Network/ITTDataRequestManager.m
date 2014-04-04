//
//  ITTDataRequestManager.m

#import "ITTDataRequestManager.h"
#import "ITTObjectSingleton.h"
#import "ITTBaseDataRequest.h"

@interface ITTDataRequestManager()
- (void)restore;
@end

@implementation ITTDataRequestManager
ITTOBJECT_SINGLETON_BOILERPLATE(ITTDataRequestManager, sharedManager)

- (id)init{
    self = [super init];
    if(self){
        [self restore];
    }
    return self;
}


#pragma mark - private methods
- (void)restore{
    _requests = [[NSMutableArray alloc] init];
}
#pragma mark - public methods

- (void)addRequest:(ITTBaseDataRequest*)request{
    [_requests addObject:request];
}
- (void)removeRequest:(ITTBaseDataRequest*)request{
    [_requests removeObject:request];
}

@end
