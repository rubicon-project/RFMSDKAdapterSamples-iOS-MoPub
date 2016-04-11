//
//  AddTestCaseViewController.m
//  MoPub-RFM Sample
//
//  Created by Rubicon Project on 9/25/15.
//  Copyright © 2015 Rubicon Project. All rights reserved.
//

#import "AddTestCaseViewController.h"
#import "AddTestCaseTextFieldCell.h"
#import "AddTestCasePickerViewCell.h"
#import "TRPConstants.h"
#import "MainViewController.h"
#import "Settings.h"

typedef NS_ENUM(NSInteger, AddTestCaseRowMap){
    TestCaseNameRow = 0,
    MoPubSiteIdRow,
    AdTypeRow,
    
    AddTestCaseNumRows
};

@interface AddTestCaseViewController ()<UITableViewDataSource, UITableViewDelegate, AddTestCaseTextFieldCellDelegate, AddTestCasePickerViewCellDelegate>{
    UIButton *_adTypeDropdown;
    UITextField *_testCaseNameTextField;
    UITextField *_moPubSiteIdTextField;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerMenu;
@property (weak, nonatomic) IBOutlet UIView *formContainer;
@property (nonatomic, strong) Settings *settings;

@end

@implementation AddTestCaseViewController

-(void)awakeFromNib{
    [super awakeFromNib];
    [self initialize];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self initialize];
    }
    
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self initialize];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self addRoundedCorners];
}

-(void)addRoundedCorners{
    self.formContainer.layer.cornerRadius = 3.0f;
}

-(void)initialize{
    // Init settings
    self.settings = [Settings sharedInstance];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return AddTestCaseNumRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier;

    if (indexPath.row == TestCaseNameRow || indexPath.row == MoPubSiteIdRow) {
        cellIdentifier = AddTestCaseTextFieldCellLabel;
    } else if (indexPath.row == AdTypeRow) {
        cellIdentifier = AddTestCasePickerViewCellLabel;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                                            forIndexPath:indexPath];
    [self configureCell:cell identifier:cellIdentifier forIndexPath:indexPath];
    
    return cell;
}

#pragma mark - configure cells
- (void)configureCell:(UITableViewCell *)aCell identifier:(NSString *)cellIdentifier forIndexPath:(NSIndexPath *)indexPath{
    if ([cellIdentifier isEqualToString:AddTestCaseTextFieldCellLabel]) {
        AddTestCaseTextFieldCell *cell = (AddTestCaseTextFieldCell *)aCell;
        cell.delegate = self;
        cell.textField.textColor = [UIColor lightGrayColor];

        switch (indexPath.row) {
            case TestCaseNameRow:
            {
                cell.textField.text = TEST_CASE_NAME_PLACEHOLDER;
                _testCaseNameTextField = cell.textField;
            }
                break;
                
            case MoPubSiteIdRow:
            {
                cell.textField.text = MOPUB_SITE_ID_PLACEHOLDER;
                _moPubSiteIdTextField = cell.textField;
            }
                break;
                
            default:
            {
                cell.textField.text = @"";
            }
                break;
        }
    } else if ([cellIdentifier isEqualToString:AddTestCasePickerViewCellLabel]) {
        AddTestCasePickerViewCell *cell = (AddTestCasePickerViewCell *)aCell;
        cell.delegate = self;
        cell.dropDownButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
//        NSString *selectTitle = self.prefsDictionary[kPlacementPrefsKeyLocationType] ? self.prefsDictionary[kPlacementPrefsKeyLocationType] : @"none";
//        [selectMenuCell.dropdown setTitle:LOCATION_TYPE_LIST_UI_TEXT[selectTitle] forState:UIControlStateNormal];
        _adTypeDropdown = cell.dropDownButton;
        
        [self.pickerMenu setBackgroundColor:[UIColor lightGrayColor]];
    }
}

#pragma mark - Settings Cell Delegates
-(void)testCaseTextFieldDidBeginEditing:(AddTestCaseTextFieldCell *)cell{
    if (cell.textField.textColor == [UIColor lightGrayColor]) {
        cell.textField.text = @"";
        cell.textField.textColor = [UIColor blackColor];
    }
}

-(void)testCaseTextFieldCellDidChange:(AddTestCaseTextFieldCell *)cell{
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:cell.center];
    
    if (cell.textField.text.length == 0) {
        cell.textField.textColor = [UIColor lightGrayColor];
        
        if (indexPath.row == TestCaseNameRow) {
            cell.textField.text = TEST_CASE_NAME_PLACEHOLDER;
        } else if (indexPath.row == MoPubSiteIdRow) {
            cell.textField.text = MOPUB_SITE_ID_PLACEHOLDER;
        }
        
        [cell.textField resignFirstResponder];
    }

    if (indexPath.row == TestCaseNameRow) {
//        self.prefsDictionary[kPlacementPrefsKeyFrequency] = [NSNumber numberWithInteger:[settingsCell.textField.text integerValue]];
    } else if(indexPath.row == MoPubSiteIdRow) {
//        self.prefsDictionary[kPlacementPrefsKeyIntervalMsec] = [NSNumber numberWithInteger:[settingsCell.textField.text integerValue]];
    }
}

-(void)testCasePickerViewCellClicked:(AddTestCasePickerViewCell *)cell{
    self.pickerMenu.hidden = !self.pickerMenu.hidden;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSString *key = [AD_TYPE_LIST_UI_TEXT allKeys][row];
    [_adTypeDropdown setTitle:AD_TYPE_LIST_UI_TEXT[key] forState:UIControlStateNormal];
//    self.prefsDictionary[kPlacementPrefsKeyLocationType] = key;
    
    pickerView.hidden = YES;
}

- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return (int)AD_TYPE_LIST_UI_TEXT.count;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *key = [AD_TYPE_LIST_UI_TEXT allKeys][row];
    return AD_TYPE_LIST_UI_TEXT[key];
}

- (IBAction)addTestCaseButtonClicked:(UIButton *)sender {
    // Validate form
    if (_moPubSiteIdTextField.text == nil ||
        [_moPubSiteIdTextField.text isEqualToString:@""] ||
        [_moPubSiteIdTextField.text isEqualToString:MOPUB_SITE_ID_PLACEHOLDER] ||
        _testCaseNameTextField.text == nil ||
        [_testCaseNameTextField.text isEqualToString:@""] ||
        [_testCaseNameTextField.text isEqualToString:TEST_CASE_NAME_PLACEHOLDER]) {
        UIAlertView *prompt = [[UIAlertView alloc]initWithTitle:@"Invalid input"
                                                        message:@"Please fill out all fields."
                                                       delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Okay", nil];
        [prompt show];
        return;
    }
    
    // Add new test case values
    NSMutableDictionary *newTestCase = [[NSMutableDictionary alloc] init];
    [newTestCase setObject:[NSNumber numberWithInteger:[self.pickerMenu selectedRowInComponent:0]] forKey:TEST_CASES_TEST_CASE_AD_TYPE_PLIST_KEY];
    [newTestCase setObject:(NSString *)_moPubSiteIdTextField.text forKey:TEST_CASES_TEST_CASE_SITE_ID_PLIST_KEY];
    [newTestCase setObject:(NSString *)_testCaseNameTextField.text forKey:TEST_CASES_TEST_CASE_NAME_PLIST_KEY];
    
    // Add new test case to list of test cases
    NSMutableDictionary *oldTestCases = (NSMutableDictionary *)[self.settings getSettingForKey:TEST_CASES_PLIST_KEY];
    NSMutableDictionary *newTestCases = [[NSMutableDictionary alloc] initWithDictionary:oldTestCases];
    [newTestCases setObject:[newTestCase copy] forKey:[NSString stringWithFormat:@"%lu", oldTestCases.count]];
    
    // Storing test cases
    NSDictionary *newSettings = @{
                                  TEST_CASES_PLIST_KEY:newTestCases
                                  };
    
    [self.settings updateSampleSettings:newSettings];
    [self.delegate addTestCaseViewShouldDismiss:self];
}

- (IBAction)cancelButtonClicked:(UIButton *)sender {
    [self.delegate addTestCaseViewShouldDismiss:self];
}

@end
