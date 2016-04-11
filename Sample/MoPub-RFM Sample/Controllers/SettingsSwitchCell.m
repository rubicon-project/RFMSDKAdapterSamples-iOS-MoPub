//
//  SettingsSwitchCell.m
//  MoPub-RFM Sample
//
//  Created by Rubicon Project on 10/9/15.
//  Copyright © 2015 Rubicon Project. All rights reserved.
//

#import "SettingsSwitchCell.h"

@implementation SettingsSwitchCell

- (UIEdgeInsets)layoutMargins{
    return UIEdgeInsetsZero;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (IBAction)switchValueChanged:(UISwitch *)sender {
    if (_delegate) {
        [self.delegate settingsSwitchCellValueChanged:self];
    }
}

@end
