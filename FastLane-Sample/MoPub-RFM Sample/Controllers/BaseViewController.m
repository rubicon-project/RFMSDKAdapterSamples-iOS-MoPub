//
//  BaseViewController.m
//  MoPub-RFM Sample
//
//  Created by Rubicon Project on 9/23/15.
//  Copyright © 2015 Rubicon Project. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNeedsStatusBarAppearanceUpdate];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // Hide navigation bar
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self initializeView];
}

-(void)initializeView{
    // Top bar view shadow
    CGFloat shadowHeight = 10.0f;
    self.topBarView.layer.masksToBounds = NO;
    self.topBarView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.topBarView.layer.shadowOpacity = 0.8;
    self.topBarView.layer.shadowRadius = 4.0;
    self.topBarView.layer.shadowOffset = CGSizeMake(0.0, 2.0);
    self.topBarView.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake(self.topBarView.bounds.origin.x, self.topBarView.bounds.size.height - shadowHeight, self.view.bounds.size.width, shadowHeight)].CGPath;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (IBAction)adSettingsButtonClicked:(UIButton *)sender {
}

@end
