//
//  TwitterViewController.m
//  test
//
//  Created by Dennis Burdin on 30.01.17.
//  Copyright © 2017 Dennis Burdin. All rights reserved.
//

#import "TwitterViewController.h"
#import "TwitterEngine.h"

static NSString *const kTwitter = @"Twitter";

@interface TwitterViewController ()

@end

@implementation TwitterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[TwitterEngine sharedInstance] getTimelineAction];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configurateUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configurateUI {
    [self setNeedsStatusBarAppearanceUpdate];
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationItem setHidesBackButton:NO animated:NO];
    self.navigationController.navigationBar.topItem.title = @"";
    self.navigationItem.title = kTwitter;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
