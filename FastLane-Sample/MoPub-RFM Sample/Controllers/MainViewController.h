//
//  MainViewController.h
//  MoPub-RFM Sample
//
//  Created by The Rubicon Project on 2/15/15.
//  Copyright (c) Rubicon Project. All rights reserved.

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface MainViewController : BaseViewController

#define MainTableViewCellLabel @"MainTableViewCell"

- (IBAction)addTestCase:(UIButton *)sender;
- (IBAction)showSettingsMenu:(UIButton *)sender;

@end
