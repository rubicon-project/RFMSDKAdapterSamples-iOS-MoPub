//
//  SettingsTextFieldCell.h
//  MoPub-RFM Sample
//
//  Created by Rubicon Project on 10/9/15.
//  Copyright © 2015 Rubicon Project. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingsTextFieldCellDelegate;

@interface SettingsTextFieldCell : UITableViewCell<UITextFieldDelegate>

@property (weak, nonatomic) id<SettingsTextFieldCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@protocol SettingsTextFieldCellDelegate<NSObject>

-(void)settingsTextFieldDidBeginEditing:(SettingsTextFieldCell *)settingsCell;

@end
