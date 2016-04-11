//
//  AddTestCaseViewController.h
//  MoPub-RFM Sample
//
//  Created by Rubicon Project on 9/25/15.
//  Copyright © 2015 Rubicon Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@protocol AddTestCaseViewControllerDelegate;

@interface AddTestCaseViewController : BaseViewController

#define AddTestCaseTextFieldCellLabel @"AddTestCaseTextFieldCell"
#define AddTestCasePickerViewCellLabel @"AddTestCasePickerViewCell"

@property (nonatomic,assign) id<AddTestCaseViewControllerDelegate>delegate;

- (IBAction)addTestCaseButtonClicked:(UIButton *)sender;
- (IBAction)cancelButtonClicked:(UIButton *)sender;

@end

@protocol AddTestCaseViewControllerDelegate <NSObject>

-(void)addTestCaseViewShouldDismiss:(AddTestCaseViewController *)addTestCaseViewController;

@end