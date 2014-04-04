//
//  NewMessage.h
//
//  Created by Jack on 13-5-26.
//
//

#import "ITTBaseDataRequest.h"

@interface DVMessage : ITTBaseModelObject
@property (nonatomic, strong) NSString *uuid ;
@property (nonatomic, strong) NSString *title ;
@property (nonatomic, strong) NSString *message ;
@property (nonatomic, strong) NSString *status ;//状态 new：新消息, read：已读消息
@property (nonatomic, strong) NSString *createdAt ;
@property (nonatomic, strong) NSString *fromMemberId ;
@property (nonatomic, strong) NSString *fromMemberName ;
@property (nonatomic, strong) NSString *fromMemberAvatar ;
@property (nonatomic, strong) NSString *toMemberId ;
@property (nonatomic, strong) NSString *toMemberName ;
@property (nonatomic, strong) NSString *toMemberAvatar ;
@property (nonatomic, assign) BOOL isSentFailed;
@property (nonatomic, assign) BOOL isSending;
@end
