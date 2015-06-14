//
//  InviteView.h
//  LewPopupViewController
//
//  Created by deng on 15/3/5.
//  Copyright (c) 2015年 pljhonglu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InviteView : UIView <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)IBOutlet UIView *innerView;
@property (nonatomic, weak)UIViewController *parentVC;
@property IBOutlet UITableView *inviteTableView;


+ (instancetype)defaultPopupView;


@end
