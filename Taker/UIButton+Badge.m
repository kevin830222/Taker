//
//  UIButton+Badge.m
//  ImagePickerDemo
//
//  Created by raozhongxiong on 12-11-23.
//  Copyright (c) 2012年 raozhongxiong. All rights reserved.
//

#import "UIButton+Badge.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIButton (Badge)

- (void)badgeNumber:(int)number
{
    if (self) {
        UILabel *badgerLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
        badgerLab.layer.cornerRadius =  10.0;
        badgerLab.backgroundColor = [UIColor darkGrayColor];
        badgerLab.textColor = [UIColor whiteColor];
        badgerLab.text = [NSString stringWithFormat:@"%d",number];
        badgerLab.textAlignment = UITextAlignmentCenter;
        badgerLab.center = CGPointMake(self.frame.size.width, 0);
        badgerLab.font = [UIFont systemFontOfSize:14];
        badgerLab.adjustsFontSizeToFitWidth = YES;
        badgerLab.tag = 100;
        badgerLab.hidden = YES;
        [self addSubview:badgerLab];
    }
}

- (void)setBadge:(int)badge
{
    if (self) {
        UILabel *lab = (UILabel *)[self viewWithTag:100];
        if (badge == -1) {
            lab.hidden = YES;
        }
        else {
            lab.hidden = NO;
            lab.text = [NSString stringWithFormat:@"%d",badge];
        }
    }
}

@end
