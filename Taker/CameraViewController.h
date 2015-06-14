//
//  CameraViewController.h
//  Taker
//
//  Created by 愷愷 on 2015/6/15.
//  Copyright (c) 2015年 mobagel. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomAlertView;
@interface CameraViewController : UIViewController
{
    NSMutableArray *imageArray;
    
    IBOutlet UIView *flashView;
    IBOutlet UIView *modeView;
    IBOutlet UIScrollView *scrollView;
    
    BOOL singleMode;    //单张拍摄
    CustomAlertView *alertView;
}

- (IBAction)cancel:(id)sender;
- (IBAction)takePhoto:(id)sender;
- (IBAction)setFlashMode:(UIButton *)flashBtn;
- (IBAction)captureModeChanged:(id)sender;


@end
