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
}

- (IBAction)pushLoginButton:(id)sender {
    [[TwitterEngine sharedInstance] login];
}

@end
