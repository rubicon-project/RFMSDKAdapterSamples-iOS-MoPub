//
//  SettingsSwitchCell.h
//  MoPub-RFM Sample
//
//  Created by Rubicon Project on 10/9/15.
//  Copyright © 2015 Rubicon Project. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingsSwitchCellDelegate;

@interface SettingsSwitchCell : UITableViewCell

@property (weak, nonatomic) id<SettingsSwitchCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UISwitch *cellSwitch;

- (IBAction)switchValueChanged:(UISwitch *)sender;

@end

@protocol SettingsSwitchCellDelegate <NSObject>

-(void)settingsSwitchCellValueChanged:(SettingsSwitchCell *)switchCell;

@end