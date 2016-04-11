//
//  AddTestCaseTextFieldCell.h
//  MoPub-RFM Sample
//
//  Created by Rubicon Project on 9/25/15.
//  Copyright © 2015 Rubicon Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@protocol AddTestCaseTextFieldCellDelegate;

@interface AddTestCaseTextFieldCell : UITableViewCell<UITextFieldDelegate>

@property (weak, nonatomic) id<AddTestCaseTextFieldCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@protocol AddTestCaseTextFieldCellDelegate <NSObject>

-(void)testCaseTextFieldCellDidChange:(AddTestCaseTextFieldCell *)cell;
-(void)testCaseTextFieldDidBeginEditing:(AddTestCaseTextFieldCell *)cell;

@end
