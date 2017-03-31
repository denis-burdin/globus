//
//  InitialViewController.m
//  test
//
//  Created by Dennis Burdin on 30.01.17.
//  Copyright © 2017 Dennis Burdin. All rights reserved.
//

#import "InitialViewController.h"
#import "TwitterEngine.h"

@interface InitialViewController ()

@end

@implementation InitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configurateUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configurateUI {
    [self setNeedsStatusBarAppearanceUpdate];
    [self.navigationController.navigationBar setHidden:YES];
    [self.navigationItem setHidesBackButton:YES animated:NO];
    self.lblLoginStatus.hidden = YES;
    self.lblUserID.text = @"";
    self.lblUserName.text = @"";
    self.showTweetsButton.hidden = YES;    
}

- (IBAction)pushLoginButton:(id)sender {
    __weak typeof(self) weakSelf = self;

    [[TwitterEngine sharedInstance] login:^(NSString *username, NSString *userID) {
        if (!username) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ошибка"
                                                            message:@"Пожалуйста, установите приложение Twitter и настройте Ваш аккаунт"
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:nil];
            [alert show];
        } else {
            weakSelf.loginButton.hidden = YES;
            weakSelf.lblLoginStatus.hidden = NO;
            weakSelf.showTweetsButton.hidden = NO;
            weakSelf.lblUserID.text = [NSString stringWithFormat:@"id: %@", userID];
            weakSelf.lblUserName.text = [NSString stringWithFormat:@"имя: %@", username];
        }
    }];
}

@end
