//
//  PopupView.m
//  LewPopupViewController
//
//  Created by deng on 15/3/5.
//  Copyright (c) 2015年 pljhonglu. All rights reserved.
//

#import "InviteView.h"
#import "MoTaker.h"
#import "UIViewController+LewPopupViewController.h"
#import "LewPopupViewAnimationFade.h"
#import "CameraViewController.h"


NSArray *invite;
NSTimer *timer;

@implementation InviteView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
            
        timer = [NSTimer scheduledTimerWithTimeInterval:REINVITE_INTERVAL
                                                 target:self
                                               selector:@selector(reinvite)
                                               userInfo:nil
                                                repeats:YES];
        
        
    }
    return self;
}

+ (instancetype)defaultPopupView{
    NSArray* views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([InviteView class]) owner:self options:nil];
    return [views lastObject];
}

- (void)reinvite {

    MoTaker *motaker = [MoTaker sharedInstance];
    [motaker.manager GET:[API_PREFIX stringByAppendingString:@"get_player.php"]
           parameters:@{@"player_id":motaker.account}
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  NSError* error = nil;
                  NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
                  if (error) {
                      [motaker alert:@"Server Error" message:[error description]];
                  }
                  else {
                      NSInteger code = [[json objectForKey:@"code"]integerValue];
                      NSString* data = [json objectForKey:@"data"];
                      if (code == 200) {
                          NSDictionary *player = (NSDictionary*)data;
                          [[MoTaker sharedInstance]setPlayer:player];
                      }
                      else {
                          [motaker alert:@"Get Player Info Failed" message:data];
                      }
                  }
                  
              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  [motaker alert:@"Internet Error" message:[error description]];
              }];
    
    invite = [[[MoTaker sharedInstance]player]objectForKey:@"invite"];
    
    if (invite.count == 0) {
        [self.parentVC lew_dismissPopupView];
    }
    [self.inviteTableView reloadData];
}

#pragma mark - table view
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    //  reuse cell
    
    static NSString *CellIdentifier = @"inviteCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (indexPath.row == invite.count) {
        //last
        cell.textLabel.text = @"Dismiss";
    }else{
        cell.textLabel.text = [invite objectAtIndex:indexPath.row];
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return invite.count+1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if (indexPath.row == invite.count) {
        //last

        //  accept round
        NSLog(@"r = %@",[[MoTaker sharedInstance]round_id]);
        
        for (NSString* invId in invite) {
            [[[MoTaker sharedInstance]manager]POST:[API_PREFIX stringByAppendingString:@"quit_round.php"]
                                        parameters:@{@"round_id":invId}
                                           success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                               NSError* error = nil;
                                               NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
                                               if (error) {
                                                   [[MoTaker sharedInstance]alert:@"Server Error" message:[error description]];
                                               }
                                               else {
                                                   NSInteger code = [[json objectForKey:@"code"]integerValue];
                                                   NSString* data = [json objectForKey:@"data"];
                                                   if (code == 200) {
                                                       [[MoTaker sharedInstance]deny_invitation];
                                                       [self.parentVC lew_dismissPopupView];
                                                   }
                                                   else {
                                                       [[MoTaker sharedInstance]alert:@"Quit Round Failed" message:data];
                                                   }
                                               }
                                               
                                           } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                               [[MoTaker sharedInstance]alert:@"Internet Error" message:[error description]];
                                           }];
        }
        return;
    }
    

    [[MoTaker sharedInstance]deny_invitation];
    
    NSString *round_id = [invite objectAtIndex:indexPath.row];
    [[MoTaker sharedInstance]setRound_id:round_id];

    //  accept round
    [[[MoTaker sharedInstance]manager]POST:[API_PREFIX stringByAppendingString:@"accept_round.php"]
                               parameters:@{@"round_id":round_id}
                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      NSError* error = nil;
                                      NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
                                      NSLog(@"data = %@", [[NSString alloc] initWithData:responseObject encoding:kCFStringEncodingUTF8]);
                                      NSLog(@"json = %@", json);
                                      if (error) {
                                          [[MoTaker sharedInstance]alert:@"Server Error" message:[error description]];
                                      }
                                      else {
                                          NSInteger code = [[json objectForKey:@"code"]integerValue];
                                          NSString* data = [json objectForKey:@"data"];
                                          if (code == 200) {
                                              [timer invalidate];
                                              [self.parentVC lew_dismissPopupView];
                                              CameraViewController *cameraVC = [self.parentVC.storyboard instantiateViewControllerWithIdentifier:@"cameraVC"];
                                              cameraVC.guessMode = YES;
                                              [self.parentVC presentViewController:cameraVC animated:YES completion:nil];
                                          }
                                          else {
                                              [[MoTaker sharedInstance]alert:@"Accept Round Failed" message:data];
                                          }
                                      }
                                      
                                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      [[MoTaker sharedInstance]alert:@"Internet Error" message:[error description]];
                                  }];
    
}

@end
