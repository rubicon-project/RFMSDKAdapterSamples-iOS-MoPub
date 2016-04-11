//
//  SettingsKeyValueCell.m
//  MoPub-RFM Sample
//
//  Created by Rubicon Project on 10/13/15.
//  Copyright © 2015 Rubicon Project. All rights reserved.
//

#import "SettingsKeyValueCell.h"

@implementation SettingsKeyValueCell

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

- (IBAction)buttonPressed:(UIButton *)sender {
    if (_delegate) {
        [self.delegate settingKeyValueCellButtonPressed:self];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (_delegate) {
        [self.delegate settingKeyValueCellTextFieldDidBeginEditing:self];
    }
}

@end
