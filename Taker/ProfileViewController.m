//
//  ProfileViewController.m
//  Taker
//
//  Created by 愷愷 on 2015/6/14.
//  Copyright (c) 2015年 mobagel. All rights reserved.
//

#import "ProfileViewController.h"
#import "MoTaker.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //  get player data
    [[[MoTaker sharedInstance]manager]GET:[API_PREFIX stringByAppendingString:@"get_player.php"]
                               parameters:@{@"player_id": [[MoTaker sharedInstance]account]}
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
                NSLog(@"Data = %@", data);
            }
            else {
                [[MoTaker sharedInstance]alert:@"Get Player Data Failed" message:data];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[MoTaker sharedInstance]alert:@"Internet Error" message:[error description]];
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
