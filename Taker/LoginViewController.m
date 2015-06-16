//
//  LoginViewController.m
//  Taker
//
//  Created by 愷愷 on 2015/6/14.
//  Copyright (c) 2015年 mobagel. All rights reserved.
//

#import "LoginViewController.h"
#import "MoTaker.h"

#define kOFFSET_FOR_KEYBOARD 150.0

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //  auto login
    NSString *account = [[MoTaker sharedInstance]account];
    NSString *password = [[MoTaker sharedInstance]password];
    if (account && password) {
        self.accountTF.text = account;
        self.passwordTF.text = password;
        [self login:nil];
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)login:(id)sender {
    NSString *account = self.accountTF.text;
    NSString *password = self.passwordTF.text;
    
    [[[MoTaker sharedInstance]manager]POST:[API_PREFIX stringByAppendingString:@"login.php"] parameters:@{@"player_id": account, @"password": password} success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSError* error = nil;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                             options:kNilOptions
                                                               error:&error];

        if (error) {
            [[MoTaker sharedInstance]alert:@"Server Error" message:[error description]];
        }
        else {
            NSInteger code = [[json objectForKey:@"code"]integerValue];
            if (code == 200) {
                //  save to local storage
                [[NSUserDefaults standardUserDefaults]setObject:account forKey:@"account"];
                [[NSUserDefaults standardUserDefaults]setObject:password forKey:@"password"];
                
                //  set instance info
                [[MoTaker sharedInstance]setAccount:account];
                [[MoTaker sharedInstance]setPassword:password];
                
                UIViewController *rootVC = [self.storyboard instantiateViewControllerWithIdentifier:@"rootVC"];
                [self presentViewController:rootVC animated:YES completion:nil];
            }
            else {
                NSString* data = [json objectForKey:@"data"];
                [[MoTaker sharedInstance]alert:@"Login Failed" message:data];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[MoTaker sharedInstance]alert:@"Internet Error" message:[error description]];
    }];
    
}

- (IBAction)signup:(id)sender {
    NSString *account = self.accountTF.text;
    NSString *password = self.passwordTF.text;
    [[[MoTaker sharedInstance]manager]POST:[API_PREFIX stringByAppendingString:@"signup.php"] parameters:@{@"player_id": account, @"password": password} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError* error = nil;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                             options:kNilOptions
                                                               error:&error];
        
        if (error) {
            [[MoTaker sharedInstance]alert:@"Server Error" message:[error description]];
        }
        else {
            NSInteger code = [[json objectForKey:@"code"]integerValue];
            if (code == 200) {
                UIViewController *rootVC = [self.storyboard instantiateViewControllerWithIdentifier:@"rootVC"];
                [self presentViewController:rootVC animated:YES completion:nil];
            }
            else {
                NSString* data = [json objectForKey:@"data"];
                [[MoTaker sharedInstance]alert:@"Signup Failed" message:data];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[MoTaker sharedInstance]alert:@"Internet Error" message:[error description]];
    }];
}


#pragma mark - keyboard

-(void)keyboardWillShow {
    // Animate the current view out of the way
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)keyboardWillHide {
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)sender
{
//    if ([sender isEqual:self.accountTF])
    {
        //move the main view, so that the keyboard does not hide it.
        if  (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
    }
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

@end
