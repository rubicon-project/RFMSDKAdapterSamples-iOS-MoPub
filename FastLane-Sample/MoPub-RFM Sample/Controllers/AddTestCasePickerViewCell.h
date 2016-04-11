//
//  AddTestCasePickerViewCell.h
//  MoPub-RFM Sample
//
//  Created by Rubicon Project on 9/25/15.
//  Copyright © 2015 Rubicon Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@protocol AddTestCasePickerViewCellDelegate;

@interface AddTestCasePickerViewCell : UITableViewCell

@property (weak, nonatomic) id<AddTestCasePickerViewCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIButton *dropDownButton;

- (IBAction)dropdownClicked:(UIButton *)sender;

@end

@protocol AddTestCasePickerViewCellDelegate <NSObject>

-(void)testCasePickerViewCellClicked:(AddTestCasePickerViewCell *)cell;
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;

@end
