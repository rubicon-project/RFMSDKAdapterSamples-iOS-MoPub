//
//  BaseTableViewController.m
//  MoPub-RFM Sample
//
//  Created by Rubicon Project on 9/23/15.
//  Copyright © 2015 Rubicon Project. All rights reserved.
//

#import "BaseTableViewController.h"
#import "TRPConstants.h"

@interface BaseTableViewController ()

@end

@implementation BaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self initializeView];
}

-(void)initializeView{
    // Navigation bar style
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithString:COLOR_TRP_BG];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor],
                              NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:20.0f]}];
    
    // Navigation bar shadow
    CGFloat shadowHeight = 10.0f;
    self.navigationController.navigationBar.layer.masksToBounds = NO;
    self.navigationController.navigationBar.layer.shadowColor = [UIColor blackColor].CGColor;
    self.navigationController.navigationBar.layer.shadowOpacity = 0.8;
    self.navigationController.navigationBar.layer.shadowRadius = 2.0;
    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0.0, 1.0);
    self.navigationController.navigationBar.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake(0.0f, self.navigationController.navigationBar.bounds.size.height - shadowHeight, self.navigationController.navigationBar.bounds.size.width, shadowHeight)].CGPath;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // Show navigation bar 
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

@end
