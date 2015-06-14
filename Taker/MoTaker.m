//
//  MoTaker.m
//  Taker
//
//  Created by 愷愷 on 2015/6/14.
//  Copyright (c) 2015年 mobagel. All rights reserved.
//

#import "MoTaker.h"
#import "UIViewController+LewPopupViewController.h"
#import "LewPopupViewAnimationFade.h"
#import "InviteView.h"

NSTimer *inviteTimer;

@implementation MoTaker

static MoTaker* instance = nil;

+(MoTaker*)sharedInstance{
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
        instance.vc = nil;
        instance.round_id = nil;
        instance.round = nil;
        instance.player = nil;
        instance.account = [[NSUserDefaults standardUserDefaults]objectForKey:@"account"];
        instance.password = [[NSUserDefaults standardUserDefaults]objectForKey:@"password"];
        instance.manager = [AFHTTPRequestOperationManager manager];
        instance.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        instance.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    });
    return instance;
}

+ (id)allocWithZone:(NSZone *)zone {
    
    return [self sharedInstance];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (void)accept_invitation:(UIViewController*)vc {
    self.vc = vc;
    inviteTimer = [NSTimer scheduledTimerWithTimeInterval:INVITE_INTERVAL
                                                   target:self
                                                 selector:@selector(get_player)
                                                 userInfo:nil
                                                  repeats:YES];
}

- (void)deny_invitation {
    [inviteTimer invalidate];
}



- (void)alert:(NSString*)title
      message:(NSString*)message {
    if (title == nil) {
        title = @"Notice";
    }
    if (message == nil) {
        message = @"Unknown Error";
    }
    UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertview show];
}

- (void)get_player {
    if (self.account == nil || self.password == nil)   return;
    [self.manager GET:[API_PREFIX stringByAppendingString:@"get_player.php"]
           parameters:@{@"player_id":self.account}
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  NSError* error = nil;
                  NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
                  if (error) {
                      [self alert:@"Server Error" message:[error description]];
                  }
                  else {
                      NSInteger code = [[json objectForKey:@"code"]integerValue];
                      NSString* data = [json objectForKey:@"data"];
                      if (code == 200) {
                          NSDictionary *player = (NSDictionary*)data;
                          self.player = player;
                          if ([(NSArray*)[player objectForKey:@"invite"] count]) {
                              
                              InviteView *view = [InviteView defaultPopupView];
                              view.parentVC = self.vc;
                              [self.vc lew_presentPopupView:view animation:[LewPopupViewAnimationFade new] dismissed:^{
                                  [self accept_invitation:self.vc];
                              }];
                              
                              [self deny_invitation];

                          }
                          NSLog(@"%@", player);
                      }
                      else {
                          [self alert:@"Get Player Info Failed" message:data];
                      }
                  }
                  
              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  [self alert:@"Internet Error" message:[error description]];
              }];
    
}


@end


