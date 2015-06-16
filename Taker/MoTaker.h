//
//  MoTaker.h
//  Taker
//
//  Created by 愷愷 on 2015/6/14.
//  Copyright (c) 2015年 mobagel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MeetiFramework/AFNetworking.h>

#define API_PREFIX              @"http://52.68.245.163/dev/"
#define HEATBEAT_INTERVAL       3
#define ONLINE_INTERVAL         5
#define RESPOND_INTERVAL        0.5
#define RESPOND_TIMEOUT         10
#define INVITE_INTERVAL         0.5
#define REINVITE_INTERVAL       0.5
#define WAIT_ANSWER_INTERVAL    0.5


@interface MoTaker : NSObject

+ (MoTaker*)sharedInstance;

@property UIViewController *vc;
@property NSString* round_id;
@property NSDictionary* round;
@property NSDictionary* player;
@property NSString* account;
@property NSString* password;
@property BOOL inviteNotify;
@property AFHTTPRequestOperationManager* manager;

- (void)alert:(NSString*)title
      message:(NSString*)message;

- (void)get_player;

- (void)accept_invitation:(UIViewController*)vc;

- (void)deny_invitation;

@end
