//
//  SettingsPickerCell.h
//  MoPub-RFM Sample
//
//  Created by Rubicon Project on 10/13/15.
//  Copyright © 2015 Rubicon Project. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingsPickerCellDelegate;

@interface SettingsPickerCell : UITableViewCell<UITextFieldDelegate>

@property (weak, nonatomic) id<SettingsPickerCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIButton *dropdown;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIPickerView *menu;

- (IBAction)dropdownClicked:(UIButton *)sender;

@end

@protocol SettingsPickerCellDelegate <NSObject>

-(void)settingsPickerViewCellClicked:(SettingsPickerCell *)settingsCell;
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;

@end