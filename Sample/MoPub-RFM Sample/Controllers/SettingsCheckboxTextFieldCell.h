//
//  SettingsCheckboxTextFieldCell.h
//  MoPub-RFM Sample
//
//  Created by Rubicon Project on 10/9/15.
//  Copyright © 2015 Rubicon Project. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SettingsCheckboxTextFieldCellDelegate;

@interface SettingsCheckboxTextFieldCell : UITableViewCell<UITextFieldDelegate>

@property (weak, nonatomic) id<SettingsCheckboxTextFieldCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIButton *checkbox;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *checkboxLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;

- (IBAction)boxChecked:(UIButton *)sender;

@end

@protocol SettingsCheckboxTextFieldCellDelegate<NSObject>

-(void)settingsCheckboxTextFieldDidBeginEditing:(SettingsCheckboxTextFieldCell *)settingsCell;
-(void)settingCheckboxTextFieldCellChecked:(SettingsCheckboxTextFieldCell *)settingsCell;

@end
