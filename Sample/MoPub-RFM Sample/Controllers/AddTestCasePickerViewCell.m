//
//  AddTestCasePickerViewCell.m
//  MoPub-RFM Sample
//
//  Created by Rubicon Project on 9/25/15.
//  Copyright © 2015 Rubicon Project. All rights reserved.
//

#import "AddTestCasePickerViewCell.h"

@implementation AddTestCasePickerViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)dropdownClicked:(UIButton *)sender {
    if (_delegate) {
        [self.delegate testCasePickerViewCellClicked:self];
    }
}

@end
