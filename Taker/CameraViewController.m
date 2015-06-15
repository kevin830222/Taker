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

AVCaptureSession *session;
AVCaptureDevice *frontDevice = nil, *backDevice = nil;
AVCaptureDeviceInput *frontInput = nil, *backInput = nil, *currentInput = nil;
NSMutableArray *pictures;
AVCaptureStillImageOutput *imageOutput;

@interface CameraViewController ()

@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    session = [[AVCaptureSession alloc]init];
    
    if ([session canSetSessionPreset:AVCaptureSessionPresetPhoto]) {
        [session setSessionPreset:AVCaptureSessionPresetPhoto];
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
    
    
    //建立 AVCaptureVideoPreviewLayer
    AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [previewLayer setFrame:self.cameraView.frame];
    [self.cameraView.layer addSublayer:previewLayer];
    
    //建立 AVCaptureStillImageOutput
    imageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil];
    [imageOutput setOutputSettings:outputSettings];
    [session addOutput:imageOutput];
    
    [session startRunning];

    
}

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
            
            //取得的靜態影像
            UIImage *image = [[UIImage alloc] initWithData:imageData];
            self.imageView.image = image;
            
            [[[MoTaker sharedInstance] manager] POST:@"url" parameters:@"" constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                [formData appendPartWithFileData:imageData name:@"file" fileName:@"image.jpg" mimeType:@"image/jpeg"];
            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
            }];
            
            
            //取得影像資料（需要ImageIO.framework 與 CoreMedia.framework）
//            CFDictionaryRef myAttachments = CMGetAttachment(imageDataSampleBuffer, kCGImagePropertyExifDictionary, NULL);
//            NSLog(@"影像屬性: %@", myAttachments);
            
            
            
//            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
            
        }
    }];
    
}

- (void)get_problem {
}

@end
