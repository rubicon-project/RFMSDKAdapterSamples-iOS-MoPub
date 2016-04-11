//
//  SettingsKeyValueCell.h
//  MoPub-RFM Sample
//
//  Created by Rubicon Project on 10/13/15.
//  Copyright © 2015 Rubicon Project. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingsKeyValueCellDelegate;

@interface SettingsKeyValueCell : UITableViewCell<UITextFieldDelegate>

@property (nonatomic,weak) id<SettingsKeyValueCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UITextField *key;
@property (weak, nonatomic) IBOutlet UITextField *value;

- (IBAction)buttonPressed:(UIButton *)sender;

@end

@protocol SettingsKeyValueCellDelegate <NSObject>

-(void)settingKeyValueCellButtonPressed:(SettingsKeyValueCell *)cell;
-(void)settingKeyValueCellTextFieldDidBeginEditing:(SettingsKeyValueCell *)cell;

@end