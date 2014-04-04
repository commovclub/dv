//
//  DataEnvironment.h

#import <Foundation/Foundation.h>
#import "HTUser.h"
#import <CoreLocation/CoreLocation.h>
#import "Contact.h"

@interface DataEnvironment : NSObject {
    NSString *_urlRequestHost;
}
@property (nonatomic,strong) NSString *urlRequestHost;
@property (nonatomic,strong) HTUser *currentUser;
@property (nonatomic,strong) HTUser *editingUser;
@property (nonatomic,assign) BOOL needRefresh;
@property (nonatomic,assign) CLLocationCoordinate2D currentLocation;
@property (nonatomic,retain) Contact *currentContact;
@property (nonatomic,retain) Contact *editingContact;

+ (DataEnvironment *)sharedDataEnvironment;
- (void)logout;

- (void)clearNetworkData;
- (void)clearCacheData;
@end
