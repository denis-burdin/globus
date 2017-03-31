//
//  TwitterViewController.m
//  test
//
//  Created by Dennis Burdin on 30.01.17.
//  Copyright © 2017 Dennis Burdin. All rights reserved.
//

#import "TwitterViewController.h"
#import "TwitterEngine.h"
#import <UIScrollView+InfiniteScroll.h>

static NSString *const kTwitter = @"Twitter";

@interface TwitterViewController ()
{
    NSMutableArray* _tweets;
}

@end

@implementation TwitterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    [self.tableView addInfiniteScrollWithHandler:^(UITableView* tableView) {
        // update table view
        [[TwitterEngine sharedInstance] getTimelineAction:^(NSArray * _Nullable tweets) {
            [_tweets addObjectsFromArray:tweets];
            [self.tableView reloadData];

            // finish infinite scroll animation
            [self.tableView finishInfiniteScroll];
        }];
    }];
    
    // Do any additional setup after loading the view.
    [[TwitterEngine sharedInstance] getTimelineAction:^(NSArray * _Nullable tweets) {
        _tweets = [NSMutableArray arrayWithArray:tweets];
        [self.tableView reloadData];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configurateUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configurateUI {
    [self setNeedsStatusBarAppearanceUpdate];
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationItem setHidesBackButton:NO animated:NO];
    self.navigationController.navigationBar.topItem.title = @"";
    self.navigationItem.title = kTwitter;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellIdentifier"];
    }
    
    NSDictionary *status = [_tweets objectAtIndex:indexPath.row];
    
    NSString *text = [status valueForKey:@"text"];
    NSString *screenName = [status valueForKeyPath:@"user.screen_name"];
    NSString *dateString = [status valueForKey:@"created_at"];
    
    cell.textLabel.text = text;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"@%@ | %@", screenName, dateString];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_tweets count];
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
