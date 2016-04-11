//
//  AddTestCaseTextFieldCell.m
//  MoPub-RFM Sample
//
//  Created by Rubicon Project on 9/25/15.
//  Copyright © 2015 Rubicon Project. All rights reserved.
//

#import "AddTestCaseTextFieldCell.h"

@implementation AddTestCaseTextFieldCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (_delegate) {
        [self.delegate testCaseTextFieldDidBeginEditing:self];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField*)textField {
    if (textField == self.textField) {
        [textField resignFirstResponder];
    }
    
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (_delegate) {
        [self.delegate testCaseTextFieldCellDidChange:self];
    }
}

@end
