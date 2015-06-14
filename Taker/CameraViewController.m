//
//  CameraViewController.m
//  Taker
//
//  Created by 愷愷 on 2015/6/15.
//  Copyright (c) 2015年 mobagel. All rights reserved.
//

#import "CameraViewController.h"
#import "MoTaker.h"
#import "UIButton+Badge.h"
#import "CustomAlertView.h"

#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define GET_IMAGE(__NAME__,__TYPE__)    [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:__NAME__ ofType:__TYPE__]]

@interface CameraViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, retain) UIImagePickerController *imagePickerController;

- (void)setupImagePicker:(UIImagePickerControllerSourceType)sourceType;

@end

@implementation CameraViewController
@synthesize imagePickerController;


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    imageArray = [[NSMutableArray alloc] init];
}

- (IBAction)captureModeChanged:(id)sender
{
    UISwitch *modeSwitch = (UISwitch *)sender;
    
    singleMode = ![modeSwitch isOn];
    
    UIToolbar *view = (UIToolbar *)self.imagePickerController.cameraOverlayView;
    UIBarButtonItem *cameraItem = [[view items] objectAtIndex:3];
    [(UIButton *)cameraItem.customView setBadge:singleMode? -1:0];
    
    [self cancel:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//刷新图片
- (void)refreshImage
{
    //移除所有旧的子view
    for (UIView *subView in scrollView.subviews) {
        [subView removeFromSuperview];
    }
    
    scrollView.contentSize = CGSizeMake(280*imageArray.count, 320);
    for (int i = 0; i < imageArray.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[imageArray objectAtIndex:i]];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.frame = CGRectMake(i*280, 0, 280, 320);
        [scrollView addSubview:imageView];
    }
    
    //清空数组
    [imageArray removeAllObjects];
    [scrollView setContentOffset:CGPointZero];
}

- (IBAction)takePhoto:(id)sender
{
    singleMode = YES;
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    self.imagePickerController = picker;
    [self setupImagePicker:sourceType];
    picker = nil;
    
    UIToolbar *cameraOverlayView = (UIToolbar *)self.imagePickerController.cameraOverlayView;
    UIBarButtonItem *doneItem = [[cameraOverlayView items] lastObject];
    [doneItem setTitle:@"取消"];
    
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

//这里是主要函数
- (void)setupImagePicker:(UIImagePickerControllerSourceType)sourceType
{
    self.imagePickerController.sourceType = sourceType;
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        // 不使用系统的控制界面
        self.imagePickerController.showsCameraControls = NO;
        
        UIToolbar *controlView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-44, self.view.frame.size.width, 44)];
        controlView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        //闪光灯
        UIButton *flashBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        flashBtn.frame = CGRectMake(0, 0, 35, 35);
        flashBtn.showsTouchWhenHighlighted = YES;
        flashBtn.tag = 100;
        [flashBtn setImage:GET_IMAGE(@"camera_flash_auto.png", nil) forState:UIControlStateNormal];
        [flashBtn addTarget:self action:@selector(pushButton:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *flashItem = [[UIBarButtonItem alloc] initWithCustomView:flashBtn];
        if (isPad) {
            //ipad,禁用闪光灯
            flashItem.enabled = NO;
        }
        
        //拍照
        UIButton *cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cameraBtn.frame = CGRectMake(0, 0, 35, 35);
        cameraBtn.showsTouchWhenHighlighted = YES;
        [cameraBtn setImage:GET_IMAGE(@"camera_icon.png", nil) forState:UIControlStateNormal];
        [cameraBtn addTarget:self action:@selector(stillImage:) forControlEvents:UIControlEventTouchUpInside];
        [cameraBtn badgeNumber:-1];
        UIBarButtonItem *takePicItem = [[UIBarButtonItem alloc] initWithCustomView:cameraBtn];
        
        //摄像头切换
        UIButton *cameraDevice = [UIButton buttonWithType:UIButtonTypeCustom];
        cameraDevice.frame = CGRectMake(0, 0, 35, 35);
        cameraDevice.showsTouchWhenHighlighted = YES;
        [cameraDevice setImage:GET_IMAGE(@"camera_mode.png", nil) forState:UIControlStateNormal];
        [cameraDevice addTarget:self action:@selector(changeCameraDevice:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *cameraDeviceItem = [[UIBarButtonItem alloc] initWithCustomView:cameraDevice];
        if (![UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
            //判断是否支持前置摄像头
            cameraDeviceItem.enabled = NO;
        }
        
        //取消、完成
        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(doneAction)];
        
        //模式：单张、多张
        UIButton *modeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        modeBtn.frame = CGRectMake(0, 0, 35, 35);
        modeBtn.showsTouchWhenHighlighted = YES;
        modeBtn.tag = 101;
        [modeBtn setImage:GET_IMAGE(@"camera_set.png", nil) forState:UIControlStateNormal];
        [modeBtn addTarget:self action:@selector(pushButton:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *modeItem = [[UIBarButtonItem alloc] initWithCustomView:modeBtn];
        
        //空item
        UIBarButtonItem *spItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        NSArray *items = [NSArray arrayWithObjects:flashItem,modeItem,spItem,takePicItem,spItem,cameraDeviceItem,doneItem, nil];
        [controlView setItems:items];
        
        self.imagePickerController.cameraOverlayView = controlView;
        
        controlView = nil;
    }
}

//拍照
- (void)stillImage:(id)sender
{
    [self.imagePickerController takePicture];
}

//完成、取消
- (void)doneAction
{
    [self imagePickerControllerDidCancel:self.imagePickerController];
}

#pragma mark - UIImagePickerController回调
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    if (imageArray.count) {
        [self refreshImage];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //保存相片到数组，这种方法不可取,会占用过多内存
    //如果是一张就无所谓了，到时候自己改
    [imageArray addObject:[info objectForKey:UIImagePickerControllerOriginalImage]];
    if (singleMode) {
        [picker dismissViewControllerAnimated:YES completion:nil];
        [self refreshImage];
    }
    else if (imageArray.count == 1) {
        //多张拍摄,不必每次都执行
        UIBarButtonItem *flashItem = [[(UIToolbar *)self.imagePickerController.cameraOverlayView items] lastObject];
        flashItem.title = @"完成";
    }
    
    UIToolbar *view = (UIToolbar *)self.imagePickerController.cameraOverlayView;
    UIBarButtonItem *cameraItem = [[view items] objectAtIndex:3];
    [(UIButton *)cameraItem.customView setBadge:(int)imageArray.count];
}

//弹出选择
- (void)pushButton:(UIButton *)sender
{
    UIView *contentView = nil;
    if (sender.tag == 100) {
        //闪光灯
        contentView = flashView;
        UIButton *button = (UIButton *)[flashView viewWithTag:self.imagePickerController.cameraFlashMode+100];
        button.enabled = NO;
    }
    else {
        //模式
        contentView = modeView;
    }
    
    alertView = [[CustomAlertView alloc] initWithContentView:contentView
                                                       title:nil
                                                     message:nil
                                                    delegate:nil
                                           cancelButtonTitle:nil
                                           otherButtonTitles:nil];
    [alertView show];
}

- (void)changeCameraDevice:(id)sender
{
    if (self.imagePickerController.cameraDevice == UIImagePickerControllerCameraDeviceRear) {
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
            self.imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        }
    }
    else {
        self.imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    }
}

- (IBAction)cancel:(id)sender
{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
}

- (IBAction)setFlashMode:(UIButton *)flashBtn
{
    //ipad没有闪光灯，默认为 自动
    self.imagePickerController.cameraFlashMode = flashBtn.tag-100;
    NSString *imageName = nil;
    switch (flashBtn.tag) {
        case 99:
            imageName = @"camera_flash_off";
            break;
        case 100:
            imageName = @"camera_flash_auto";
            break;
        case 101:
            imageName = @"camera_flash_on";
            break;
        default:
            break;
    }
    UIBarButtonItem *flashItem = [[(UIToolbar *)self.imagePickerController.cameraOverlayView items] objectAtIndex:0];
    [(UIButton *)flashItem.customView setImage:GET_IMAGE(imageName, @"png") forState:UIControlStateNormal];
    
    [self cancel:nil];
}

@end
