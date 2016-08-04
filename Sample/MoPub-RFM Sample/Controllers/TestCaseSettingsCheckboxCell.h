//
//  TestCaseSettingsCheckboxCell.h
//  MoPub-RFM Sample
//
//  Created by Rubicon Project on 7/21/16.
//  Copyright © 2016 Rubicon Project. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TestCaseSettingsCheckboxCellDelegate;

@interface TestCaseSettingsCheckboxCell : UITableViewCell

@property (weak, nonatomic) id<TestCaseSettingsCheckboxCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIButton *checkbox;
@property (weak, nonatomic) IBOutlet UILabel *label;

- (IBAction)checkboxClicked:(UIButton *)sender;

@end

@protocol TestCaseSettingsCheckboxCellDelegate <NSObject>

-(void)testCaseCheckboxCellClicked:(TestCaseSettingsCheckboxCell *)cell;

@end
