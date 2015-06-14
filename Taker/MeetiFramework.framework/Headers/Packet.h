//
//  Message.h
//  MoAddressBook
//
//  Created by yang on 2014/3/6.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum msgtype : int16_t {
    PackageInfoWords      = 1,
    PackageInfoImage      = 2,
    PackageInfoPDF        = 3,
    PackageInfoVideo      = 4,
    PackageInfoVoice      = 5,
    PackageInfoToDoList   = 6,
    PackageInfoUart       = 7,
    PackageInfoGPIO       = 8,
    PackageInfoJoinGroup  = 9,
    PackageInfoLeaveGroup = 10
}PackageInfo;

@interface Packet : NSObject

@property (nonatomic, strong) NSString * message;
@property (nonatomic) PackageInfo type;
@property (nonatomic, strong) NSString * date;
@property (nonatomic, strong) NSString * gid;
@property (nonatomic, strong) NSString * sender;


- (NSDictionary*)todictionary;

- (void)updateDataWithDictionary:(NSDictionary*)dic;

@end
