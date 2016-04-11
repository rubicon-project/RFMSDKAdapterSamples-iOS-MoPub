//
//  BaseViewController.h
//  MoPub-RFM Sample
//
//  Created by Rubicon Project on 9/23/15.
//  Copyright © 2015 Rubicon Project. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *topBarView;
@property (weak, nonatomic) IBOutlet UILabel *pageLabel;
@property (weak, nonatomic) IBOutlet UILabel *pageSubLabel;
@property (weak, nonatomic) IBOutlet UIButton *adSettingsButton;

- (IBAction)adSettingsButtonClicked:(UIButton *)sender;

@end
