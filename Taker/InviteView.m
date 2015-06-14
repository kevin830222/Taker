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


NSArray *invite;

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
            
        invite = [[[MoTaker sharedInstance]player]objectForKey:@"invite"];
        
    }
    return self;
}

+ (instancetype)defaultPopupView{
    NSArray* views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([InviteView class]) owner:self options:nil];
    return [views lastObject];
}

- (IBAction)dismissAction:(id)sender{
    [_parentVC lew_dismissPopupView];
}

- (IBAction)dismissViewFadeAction:(id)sender{
    [_parentVC lew_dismissPopupViewWithanimation:[LewPopupViewAnimationFade new]];
}

#pragma mark - table view
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    //  reuse cell
    
    static NSString *CellIdentifier = @"inviteCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [invite objectAtIndex:indexPath.row];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return invite.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    

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
                                              UIViewController *guessVC = [self.parentVC.storyboard instantiateViewControllerWithIdentifier:@"guessVC"];
                                              [self.parentVC presentViewController:guessVC animated:YES completion:nil];
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
