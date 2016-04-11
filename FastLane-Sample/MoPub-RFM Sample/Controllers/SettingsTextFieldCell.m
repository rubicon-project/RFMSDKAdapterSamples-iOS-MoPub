//
//  SettingsTextFieldCell.m
//  MoPub-RFM Sample
//
//  Created by Rubicon Project on 10/9/15.
//  Copyright © 2015 Rubicon Project. All rights reserved.
//

#import "SettingsTextFieldCell.h"

@implementation SettingsTextFieldCell

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

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (_delegate) {
        [self.delegate settingsTextFieldDidBeginEditing:self];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField*)textField {
    if (textField == self.textField) {
        [textField resignFirstResponder];
    }
    
    return YES;
}

@end
