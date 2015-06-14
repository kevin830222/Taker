//
//  GameViewController.h
//  Taker
//
//  Created by 愷愷 on 2015/6/14.
//  Copyright (c) 2015年 mobagel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property IBOutlet UITableView *onlineTableView;
@property NSMutableArray *onlinePlayers;
@property NSTimer *timer, *respondTimer;

@end
