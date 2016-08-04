//
//  TestCaseSettingsCheckboxCell.m
//  MoPub-RFM Sample
//
//  Created by Rubicon Project on 7/21/16.
//  Copyright © 2016 Rubicon Project. All rights reserved.
//

#import "TestCaseSettingsCheckboxCell.h"

@implementation TestCaseSettingsCheckboxCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (IBAction)checkboxClicked:(UIButton *)sender {
    if (_delegate) {
        [self.delegate testCaseCheckboxCellClicked:self];
    }
}

@end
