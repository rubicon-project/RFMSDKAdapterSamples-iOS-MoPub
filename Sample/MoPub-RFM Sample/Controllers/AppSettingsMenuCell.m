//
//  AppSettingsMenuCell.m
//  MoPub-RFM Sample
//
//  Created by Rubicon Project on 9/25/15.
//  Copyright © 2015 Rubicon Project. All rights reserved.
//

#import "AppSettingsMenuCell.h"

@implementation AppSettingsMenuCell

- (void)awakeFromNib {
    // Initialization code
    [self initialize];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

-(void)initialize{
    //Set the background cell
    self.settingsBGView.layer.masksToBounds = NO;
}

@end
