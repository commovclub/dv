//
//  Message.h
//  HotWord
//
//  Created by Jack Liu on 7/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ITTBaseModelObject.h"

@interface Message : ITTBaseModelObject

@property (nonatomic, strong) NSString *messageId;
@property (nonatomic, strong) NSString *senderUserId;
@property (nonatomic, strong) NSString *recevierUserId;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *timestamp;
@property (nonatomic, strong) NSString *dialogEmail;
@property (nonatomic, strong) NSString *dialogNickname;
@property (nonatomic, strong) NSString *dialogAvator;
@property (nonatomic, strong) NSString *recevierAvator;
@property (nonatomic, strong) NSNumber *isReaded;
@property (nonatomic, assign) BOOL isSentFailed;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, assign) BOOL isSending;

@end
