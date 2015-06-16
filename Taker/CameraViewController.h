//
//  CameraViewController.h
//  Taker
//
//  Created by 愷愷 on 2015/6/15.
//  Copyright (c) 2015年 mobagel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CameraViewController : UIViewController
{
    int counter;
    IBOutlet UIView* problemModeView;
    IBOutletCollection(UIImageView)NSArray* imageViews;
    IBOutlet UIView* hintView;
    IBOutlet UILabel* hintLabel;
    

    IBOutletCollection(UIImageView)NSArray* guessImageViews;
    IBOutletCollection(UIButton)NSArray* guessAnswerButton;
    IBOutlet UIView* guessModeView;

    NSTimer*            get_round_timer;
    
}
@property IBOutlet UIView *cameraView;
@property (nonatomic, readwrite, assign)BOOL guessMode;

@end
