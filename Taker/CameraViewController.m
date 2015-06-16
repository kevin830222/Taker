//
//  CameraViewController.m
//  Taker
//
//  Created by 愷愷 on 2015/6/15.
//  Copyright (c) 2015年 mobagel. All rights reserved.
//

#import "CameraViewController.h"
#import "MoTaker.h"
#import <AVFoundation/AVFoundation.h>
#import <ImageIO/CGImageProperties.h>
#import "PopupView.h"
#import "LewPopupViewAnimationFade.h"

AVCaptureSession *session;
AVCaptureDevice *frontDevice = nil, *backDevice = nil;
AVCaptureDeviceInput *frontInput = nil, *backInput = nil, *currentInput = nil;
NSMutableArray *pictures;
AVCaptureStillImageOutput *imageOutput;
NSInteger current_prob_cnt = 0;

typedef enum : NSUInteger {
    ProblemMode,
    GuessMode,
} TakerMode;

@interface CameraViewController () <UITabBarDelegate>

@end

@implementation CameraViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.guessMode = NO;
    }
    return self;
}

- (void)viewDidLoad {

    
    [super viewDidLoad];
    session = [[AVCaptureSession alloc]init];
    
    if ([session canSetSessionPreset:AVCaptureSessionPresetLow]) {
        [session setSessionPreset:AVCaptureSessionPresetLow];
    }
    else {
        [[MoTaker sharedInstance]alert:@"Preset Session Failed" message:@"Cannot preset photo"];
    }
    
    pictures = [[NSMutableArray alloc]init];
    
    NSArray *devices = [AVCaptureDevice devices];
    
    for (AVCaptureDevice *device in devices) {
        if ([device hasMediaType:AVMediaTypeVideo]) {
            if ([device position] == AVCaptureDevicePositionBack) {
                backDevice = device;
            }
            else if (device.position == AVCaptureDevicePositionFront) {
                frontDevice = device;
            }
        }
    }
    
    if (backDevice) {
        NSError *error = nil;
        backInput = [AVCaptureDeviceInput deviceInputWithDevice:backDevice error:&error];
        currentInput = backInput;
        if (error) {
            [[MoTaker sharedInstance]alert:@"Device Input Failed" message:@"Switch to front camera"];
            if (frontDevice) {
                error = nil;
                frontInput = [AVCaptureDeviceInput deviceInputWithDevice:frontDevice error:&error];
                currentInput = frontInput;
                if (error) {
                    [[MoTaker sharedInstance]alert:@"Device Input Failed" message:@"Camera Not Found"];
                }

            }
            else {
                [[MoTaker sharedInstance]alert:nil message:@"Camera Not Found"];
            }
        }
    }
    
    if (currentInput) {
        [session addInput:currentInput];
    }
    
    
    //  建立 AVCaptureVideoPreviewLayer
    AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    [previewLayer setVideoGravity:AVLayerVideoGravityResize];
    [previewLayer setFrame:self.cameraView.frame];
    [self.cameraView.layer addSublayer:previewLayer];
    [[self.cameraView layer] setMasksToBounds:YES];
    
    //  建立 AVCaptureStillImageOutput
    imageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil];
    [imageOutput setOutputSettings:outputSettings];
    [session addOutput:imageOutput];
    
    [hintView setBackgroundColor:[[hintView backgroundColor] colorWithAlphaComponent:0.5f]];
    hintView.alpha = 0.0;
    
    //  出題
    [[[MoTaker sharedInstance] manager]
     POST:[API_PREFIX stringByAppendingPathComponent:@"next_problem.php"]
                                  parameters:@{@"round_id": [[MoTaker sharedInstance] round_id]}
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSLog(@"response = %@",operation.responseString);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
     }];
}



-(IBAction)switch_view{
    if ([session isRunning]) {
        [session stopRunning];
        [UIView animateWithDuration:0.3f animations:^{
            hintView.alpha = 1.0;
            self.cameraView.alpha = 0.0;
        }];
    }else{
        [UIView animateWithDuration:0.3f animations:^{
            hintView.alpha = 0.0;
            self.cameraView.alpha = 1.0;
        } completion:^(BOOL finished) {
            [session startRunning];
        }];
    }

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    get_round_timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(get_round) userInfo:nil repeats:YES];

    if (self.guessMode){
        [self switchMode:GuessMode];
    }else{
        [self switchMode:ProblemMode];
    }
}

- (void)switchMode:(TakerMode)mode {
    switch (mode) {
        case ProblemMode: {
            self.guessMode = NO;
            problemModeView.hidden = NO;
            guessModeView.hidden = YES;
            
            [UIView animateWithDuration:0.3f animations:^{
                hintView.alpha = 1.0;
                self.cameraView.alpha = 0.0;
                [[hintView layer] setCornerRadius:10];
            }];
            break;
        }
        case GuessMode: {
            self.guessMode = YES;
            problemModeView.hidden = YES;
            guessModeView.hidden = NO;
            self.cameraView.hidden = YES;
            PopupView *view = [PopupView defaultPopupView];
            view.parentVC = self;
            [self lew_presentPopupView:view animation:[LewPopupViewAnimationFade new] dismissed:^{
            }];
            break;
        }
        default:
            break;
    }
}


-(void)get_round{
    [[[MoTaker sharedInstance] manager] GET:[API_PREFIX stringByAppendingPathComponent:@"get_round.php"] parameters:@{@"round_id":[[MoTaker sharedInstance] round_id]} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError* error = nil;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
        if (error) {
            [[MoTaker sharedInstance]alert:@"Server Error" message:[error description]];
        }
        else {
            NSInteger code = [[json objectForKey:@"code"]integerValue];
            NSString* data = [json objectForKey:@"data"];
            if (code == 200) {
                [[MoTaker sharedInstance]setRound:(NSDictionary*)data];
                NSLog(@"round = %@", data);
            }
            else {
                [[MoTaker sharedInstance]alert:@"Get Round Data Failed" message:data];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[MoTaker sharedInstance]alert:@"Internet Error" message:[error description]];
    }];}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)switchCamera {
    [session beginConfiguration];
    [session removeInput:currentInput];
    if (currentInput.device.position == AVCaptureDevicePositionFront) {
        currentInput = backInput;
    }
    else if (currentInput.device.position == AVCaptureDevicePositionFront) {
        currentInput = frontInput;
    }
    [session addInput:currentInput];
    [session commitConfiguration];
}


- (IBAction)takePicture:(id)sender {
    
    if (![session isRunning]) {
        return;
    }
    AVCaptureConnection *myVideoConnection = nil;
    
    //從 AVCaptureStillImageOutput 中取得正確類型的 AVCaptureConnection
    for (AVCaptureConnection *connection in imageOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo]) {
                myVideoConnection = connection;
                break;
            }
        }
    }
    
    //擷取影像（包含拍照音效）
    [imageOutput captureStillImageAsynchronouslyFromConnection:myVideoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        
        //完成擷取時的處理常式(Block)
        if (imageDataSampleBuffer) {
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            
            NSDictionary *round = [[MoTaker sharedInstance]round];
            
            NSString* filename = [NSString stringWithFormat:@"%@-%@-%d.jpg",[[MoTaker sharedInstance] round_id], [round objectForKey:@"prob_cnt"],counter];
        
            [[[MoTaker sharedInstance] manager] POST:[API_PREFIX stringByAppendingString:@"send_picture.php"]
                                          parameters:@"" constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                [formData appendPartWithFileData:imageData name:@"file" fileName:filename mimeType:@"image/jpeg"];
            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                
                NSError* error = nil;
                NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
                if (error) {
                    [[MoTaker sharedInstance]alert:@"Server Error" message:[error description]];
                }
                else {
                    NSInteger code = [[json objectForKey:@"code"]integerValue];
                    NSString* data = [json objectForKey:@"data"];
                    if (code == 200) {
                        //取得的靜態影像
                      
                        UIImage *image = [[UIImage alloc] initWithData:imageData];
                        for (UIImageView* v in imageViews) {
                            if (counter == v.tag) {
                                [v setImage:image];
                                break;
                            }
                        }
                        counter++;
                        
                        //  拍滿四張
                        if (counter == 4) {
                            PopupView *view = [PopupView defaultPopupView];
                            [self lew_presentPopupView:view animation:[LewPopupViewAnimationFade new]];
                            answer_timer = [NSTimer scheduledTimerWithTimeInterval:WAIT_ANSWER_INTERVAL
                                                                            target:self
                                                                          selector:@selector(didAnswerProblem)
                                                                          userInfo:nil
                                                                           repeats:YES];
                        }
                    }
                    else {
                        [[MoTaker sharedInstance]alert:@"Send Picture Failed" message:data];
                    }
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"fail");
            }];
            
        }
    }];
    
}

- (void)didAnswerProblem {
    NSDictionary* round = [[MoTaker sharedInstance]round];
    if ([[round objectForKey:@"prob_cnt"]integerValue] > current_prob_cnt) {
        current_prob_cnt = [[round objectForKey:@"prob_cnt"]integerValue];
        [self lew_dismissPopupView];
        [self switchMode:GuessMode];
    }
}

- (void)get_problem {
}

@end
