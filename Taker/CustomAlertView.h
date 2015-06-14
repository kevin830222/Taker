//
//  CustomAlertView.h
//  textAlertView
//
//  Created by lv xingtao on 12-10-13.
//  Copyright (c) 2012年 lv xingtao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomAlertView : UIAlertView

- (id)initWithContentView:(UIView *)contentView title:(NSString *)title message:(NSString *)message delegate:(id /*<UIAlertViewDelegate>*/)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...;

@end
