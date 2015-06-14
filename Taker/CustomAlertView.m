//
//  CustomAlertView.m
//  textAlertView
//
//  Created by lv xingtao on 12-10-13.
//  Copyright (c) 2012年 lv xingtao. All rights reserved.
//
#define kAlertViewBackground            @"alert-window.png"
#import "CustomAlertView.h"

@interface CustomAlertView ()
{
    CGRect contentViewframe;
}

@end

@implementation CustomAlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)layoutSubviews{
    
    float xc = (self.frame.size.width-contentViewframe.size.width-10)*0.5;
    float yc = (self.frame.size.height-contentViewframe.size.height)*0.5;
    CGRect rect = CGRectMake(self.frame.origin.x+xc, self.frame.origin.y+yc, contentViewframe.size.width+10, contentViewframe.size.height);
    self.frame = rect;
    
    for (UIView *v in self.subviews) {
        if ([v isKindOfClass:[UIImageView class]]) {
            UIImageView *imageV = (UIImageView *)v;
            UIImage *image = [UIImage imageNamed:kAlertViewBackground];
            [imageV setImage:image];
        }
    }
}

- (id)initWithContentView:(UIView *)contentView title:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    self = [super initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
    
    if (self) {
        
        contentViewframe = contentView.frame;
        
        contentView.center = self.center;
        [self addSubview:contentView];
    }
    
    return self;
}

@end
