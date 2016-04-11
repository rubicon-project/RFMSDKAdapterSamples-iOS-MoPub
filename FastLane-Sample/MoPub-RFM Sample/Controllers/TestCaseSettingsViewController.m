//
//  TestCaseSettingsViewController.m
//  MoPub-RFM Sample
//
//  Created by Rubicon Project on 9/28/15.
//  Copyright © 2015 Rubicon Project. All rights reserved.
//

#import "TestCaseSettingsViewController.h"
#import "SettingsCheckboxTextFieldCell.h"
#import "SettingsSwitchCell.h"
#import "SettingsTextFieldCell.h"
#import "MainViewController.h"
#import "Settings.h"
#import "TRPConstants.h"
#import "RPDeviceInfo.h"

@interface TestCaseSettingsViewController () <SettingsSwitchCellDelegate, SettingsTextFieldCellDelegate, SettingsCheckboxTextFieldCellDelegate> {
    UITextField *_testAdIdTextField;
    UIButton *_widthCheckbox;
    UIButton *_heightCheckbox;
    UITextField *_widthTextField;
    UITextField *_heightTextField;
}

@property (nonatomic, strong) NSMutableDictionary *testCaseSettings;
@property (nonatomic, strong) NSMutableDictionary *tempTestCaseDictionary;
@property (nonatomic, strong) Settings *settings;
@property (nonatomic, strong) NSString *testCaseSelectedId;

@property (nonatomic, strong) NSDictionary *sectionTitles;
@property (nonatomic, strong) NSDictionary *rowMap;
@property (nonatomic, strong) NSDictionary *cellIdentifierMap;

@end

@implementation TestCaseSettingsViewController

typedef NS_ENUM(NSInteger, TestCaseSettingSections) {
    SectionSize = 0,
    SectionTestSettings,
    
    TestCaseSettingsNumSections
};

typedef NS_ENUM(NSInteger, SizeSectionRows) {
    SizeSectionRowWidth = 0,
    SizeSectionRowHeight,
    
    SizeSectionNumRows
};

typedef NS_ENUM(NSInteger, TestSettingsSectionRows) {
    TestSettingsSectionRowTestMode = 0,
    TestSettingsSectionRowTestAdId,
    
    TestSettingsSectionNumRows
};

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialize];
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self initialize];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    // Show navigation bar
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

-(void)initialize{
    self.settings = [Settings sharedInstance];
    
    if (!_sectionTitles) {
        _sectionTitles = @{ @(SectionSize):@"SIZE",
                            @(SectionTestSettings):@"TEST SETTINGS"
                            };
    }
    
    if (!_rowMap) {
        _rowMap = @{
                    @(SectionSize):@(SizeSectionNumRows),
                    @(SectionTestSettings):@(TestSettingsSectionNumRows)
                    };
    }
    
    if (!_cellIdentifierMap) {
        _cellIdentifierMap = @{
                               [NSIndexPath indexPathForRow:SizeSectionRowWidth inSection:SectionSize]:SettingsCellCheckboxTextField,
                               [NSIndexPath indexPathForRow:SizeSectionRowHeight inSection:SectionSize]:SettingsCellCheckboxTextField,
                               
                               [NSIndexPath indexPathForRow:TestSettingsSectionRowTestMode inSection:SectionTestSettings]:SettingsCellSwitch,
                               [NSIndexPath indexPathForRow:TestSettingsSectionRowTestAdId inSection:SectionTestSettings]:SettingsCellTextField
                               };
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.tempTestCaseDictionary = (NSMutableDictionary *)[self.settings getSettingForKey:TEST_CASES_PLIST_KEY];
    self.testCaseSelectedId = (NSString *)[self.settings getSettingForKey:TEST_CASE_SELECTED_PLIST_KEY];
    self.testCaseSettings = (NSMutableDictionary *)[self.tempTestCaseDictionary[self.testCaseSelectedId] mutableCopy];
    
    [self setNavigationControllerStyle];
    
    // Disable editing of settings if test case is preset
    if ([self isPreset]) {
        self.tableView.userInteractionEnabled = NO;
    }
}

-(BOOL)isPreset{
    return ([self.testCaseSelectedId isEqualToString:@"0"] || [self.testCaseSelectedId isEqualToString:@"1"] || !self.testCaseSelectedId);
}

-(void)setNavigationControllerStyle{
    self.title = @"Test Case Settings";
    
    // Custom navigation back button
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    closeButton.frame = CGRectMake(0, 0, 30, 30);
    [closeButton addTarget:self action:@selector(closeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
    
    if (![self isPreset]) {
        // Custom navigation save button
        UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [saveButton setImage:[UIImage imageNamed:@"accept"] forState:UIControlStateNormal];
        saveButton.frame = CGRectMake(0, 0, 30, 30);
        [saveButton addTarget:self action:@selector(saveButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:saveButton];
    }
}

- (void)closeButtonClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveButtonClicked{
    // Storing settings
    [self.tempTestCaseDictionary setObject:self.testCaseSettings forKey:self.testCaseSelectedId];
    
    // Storing test cases
    NSDictionary *newSettings = @{
                                  TEST_CASES_PLIST_KEY:self.tempTestCaseDictionary
                                  };
    
    [self.settings updateSampleSettings:newSettings];

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return TestCaseSettingsNumSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numRows = 0;
    
    if (self.rowMap.count >= section) {
        numRows = [self.rowMap[@(section)] integerValue];
    }
    
    return numRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = self.cellIdentifierMap[indexPath];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                                            forIndexPath:indexPath];
    [self configureCell:cell identifier:cellIdentifier forIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)aCell identifier:(NSString *)cellIdentifier forIndexPath:(NSIndexPath *)indexPath {
    if ([cellIdentifier isEqualToString:SettingsCellTextField]) {
        SettingsTextFieldCell *textCell = (SettingsTextFieldCell *)aCell;
        textCell.delegate = self;
        textCell.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        
        if (indexPath.section == SectionTestSettings) {
            switch (indexPath.row) {
                case TestSettingsSectionRowTestAdId:
                    textCell.label.text = @"Test Ad ID";
                    
                    if ([self.testCaseSettings[TEST_CASE_TEST_AD_ID_PLIST_KEY] intValue] != 0) {
                        textCell.textField.text = [self.testCaseSettings[TEST_CASE_TEST_AD_ID_PLIST_KEY] stringValue];
                        textCell.textField.textColor = [UIColor blackColor];
                    } else {
                        textCell.textField.text = PLACEHOLDER_SETTINGS_TEST_AD_ID;
                        textCell.textField.textColor = [UIColor lightGrayColor];
                    }

                    _testAdIdTextField = textCell.textField;
                    [textCell.textField addTarget:self action:@selector(testAdIdChanged:) forControlEvents:UIControlEventEditingChanged];
                    break;
                default:
                    textCell.label.text = @"";
                    break;
            }
        }
    } else if ([cellIdentifier isEqualToString:SettingsCellCheckboxTextField]) {
        SettingsCheckboxTextFieldCell *checkboxTextCell = (SettingsCheckboxTextFieldCell *)aCell;
        checkboxTextCell.delegate = self;
        checkboxTextCell.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        
        if (indexPath.section == SectionSize) {
//            BOOL adIsBanner = ([self.testCaseSettings[TEST_CASES_TEST_CASE_AD_TYPE_PLIST_KEY] isEqual: @0]) ? YES : NO;
//            
//            if (!adIsBanner) {
//                checkboxTextCell.checkbox.selected = YES;
//                checkboxTextCell.textField.enabled = NO;
//                checkboxTextCell.textField.hidden = YES;
//                checkboxTextCell.userInteractionEnabled = NO;
//            }
            
            switch (indexPath.row) {
                case SizeSectionRowWidth:
                {
                    checkboxTextCell.label.text = @"Width (dp)";
                    checkboxTextCell.checkboxLabel.text = @"Device Width";
                    
                    if ([self.testCaseSettings[TEST_CASE_AD_IS_FULLSCREEN_PLIST_KEY] boolValue] || [RPDeviceInfo deviceScreenWidth:[UIApplication sharedApplication].statusBarOrientation] == [self.testCaseSettings[TEST_CASE_AD_WIDTH_PLIST_KEY] integerValue]) {
                        checkboxTextCell.checkbox.selected = YES;
                        checkboxTextCell.textField.enabled = NO;
                        checkboxTextCell.textField.hidden = YES;
                    } else {
                        checkboxTextCell.checkbox.selected = NO;
                        checkboxTextCell.textField.enabled = YES;
                        checkboxTextCell.textField.hidden = NO;
                        
                        if ([self.testCaseSettings[TEST_CASE_AD_WIDTH_PLIST_KEY] intValue] != 0) {
                            checkboxTextCell.textField.text = [self.testCaseSettings[TEST_CASE_AD_WIDTH_PLIST_KEY] stringValue];
                            checkboxTextCell.textField.textColor = [UIColor blackColor];
                        } else {
                            checkboxTextCell.textField.text = PLACEHOLDER_SETTINGS_CUSTOM_SIZE;
                            checkboxTextCell.textField.textColor = [UIColor lightGrayColor];
                        }
                    }
                    
                    _widthTextField = checkboxTextCell.textField;
                    _widthCheckbox = checkboxTextCell.checkbox;
                    [checkboxTextCell.textField addTarget:self action:@selector(bannerWidthChanged:) forControlEvents:UIControlEventEditingChanged];
                }
                    break;
                    
                case SizeSectionRowHeight:
                {
                    checkboxTextCell.label.text = @"Height (dp)";
                    checkboxTextCell.checkboxLabel.text = @"Device Height";
                    
                    if ([self.testCaseSettings[TEST_CASE_AD_IS_FULLSCREEN_PLIST_KEY] boolValue] || [RPDeviceInfo deviceScreenHeight:[UIApplication sharedApplication].statusBarOrientation] == [self.testCaseSettings[TEST_CASE_AD_HEIGHT_PLIST_KEY] integerValue]) {
                        checkboxTextCell.checkbox.selected = YES;
                        checkboxTextCell.textField.enabled = NO;
                        checkboxTextCell.textField.hidden = YES;
                    } else {
                        checkboxTextCell.checkbox.selected = NO;
                        checkboxTextCell.textField.enabled = YES;
                        checkboxTextCell.textField.hidden = NO;
                        
                        if ([self.testCaseSettings[TEST_CASE_AD_HEIGHT_PLIST_KEY] intValue] != 0) {
                            checkboxTextCell.textField.text = [self.testCaseSettings[TEST_CASE_AD_HEIGHT_PLIST_KEY] stringValue];
                            checkboxTextCell.textField.textColor = [UIColor blackColor];
                        } else {
                            checkboxTextCell.textField.text = PLACEHOLDER_SETTINGS_CUSTOM_SIZE;
                            checkboxTextCell.textField.textColor = [UIColor lightGrayColor];
                        }
                    }
                    
                    _heightTextField = checkboxTextCell.textField;
                    _heightCheckbox = checkboxTextCell.checkbox;
                    [checkboxTextCell.textField addTarget:self action:@selector(bannerHeightChanged:) forControlEvents:UIControlEventEditingChanged];
                }
                    break;
                    
                default:
                {
                    checkboxTextCell.label.text = @"";
                }
                    break;
            }
        }
    } else if ([cellIdentifier isEqualToString:SettingsCellSwitch]) {
        SettingsSwitchCell *switchCell = (SettingsSwitchCell *)aCell;
        switchCell.delegate = self;
        
        if (indexPath.section == SectionTestSettings) {
            switch (indexPath.row) {
                case TestSettingsSectionRowTestMode:
                {
                    switchCell.label.text = @"Test Mode Enable";
                    switchCell.cellSwitch.on = [self.testCaseSettings[TEST_CASE_TEST_MODE_ENABLED_PLIST_KEY] boolValue];
                }
                    break;
                    
                default:
                    break;
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 72;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 42)];
    [view setBackgroundColor:[UIColor clearColor]];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 10, tableView.frame.size.width - 64, 22)];
    [label setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
    [label setTextColor:[UIColor colorWithRed:(0/255.0) green:(0/255.0) blue:(0/255.0) alpha:0.54]];
    
    NSString *sectionTitle = nil;
    if (self.sectionTitles.count >= section) {
        sectionTitle = self.sectionTitles[@(section)];
    }
    
    [label setText:sectionTitle];
    [view addSubview:label];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 42;
}

#pragma mark - Settings Cell Delegates
-(void)settingsTextFieldDidBeginEditing:(SettingsTextFieldCell *)settingsCell{
    if (settingsCell.textField.textColor == [UIColor lightGrayColor]) {
        settingsCell.textField.text = @"";
        settingsCell.textField.textColor = [UIColor blackColor];
    }
}

-(void)settingsSwitchCellValueChanged:(SettingsSwitchCell *)switchCell{
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:switchCell.center];
    
    if (indexPath.section == SectionTestSettings) {
        switch (indexPath.row) {
            case TestSettingsSectionRowTestMode:
            {
                self.testCaseSettings[TEST_CASE_TEST_MODE_ENABLED_PLIST_KEY] = [NSNumber numberWithBool:switchCell.cellSwitch.on];
            }
                break;
                
            default:
                break;
        }
    }
}

-(void)settingsCheckboxTextFieldDidBeginEditing:(SettingsCheckboxTextFieldCell *)settingsCell{
    if (settingsCell.textField.textColor == [UIColor lightGrayColor]) {
        settingsCell.textField.text = @"";
        settingsCell.textField.textColor = [UIColor blackColor];
    }
}

-(void)settingCheckboxTextFieldCellChecked:(SettingsCheckboxTextFieldCell *)settingsCell{
    settingsCell.checkbox.selected = !settingsCell.checkbox.selected;
    
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:settingsCell.center];
    
    if (indexPath.section == SectionSize) {
        if (settingsCell.checkbox.selected) {
            settingsCell.textField.enabled = NO;
            settingsCell.textField.hidden = YES;
            
            if (indexPath.row == SizeSectionRowWidth) {
                self.testCaseSettings[TEST_CASE_AD_WIDTH_PLIST_KEY] = [NSNumber numberWithDouble:[RPDeviceInfo deviceScreenWidth:[UIApplication sharedApplication].statusBarOrientation]];
            } else if (indexPath.row == SizeSectionRowHeight) {
                self.testCaseSettings[TEST_CASE_AD_HEIGHT_PLIST_KEY] = [NSNumber numberWithDouble:[RPDeviceInfo deviceScreenHeight:[UIApplication sharedApplication].statusBarOrientation]];
            }
        } else {
            settingsCell.textField.enabled = YES;
            settingsCell.textField.hidden = NO;
            
            if (indexPath.row == SizeSectionRowWidth) {
                NSNumber *width;
                if (settingsCell.textField.textColor != [UIColor blackColor]) {
                    width = @0;
                } else if ([settingsCell.textField.text intValue] != 0) {
                    width = [NSNumber numberWithInteger:[settingsCell.textField.text integerValue]];
                }
                
                self.testCaseSettings[TEST_CASE_AD_WIDTH_PLIST_KEY] = width;
            } else if (indexPath.row == SizeSectionRowHeight) {
                NSNumber *height;
                if (settingsCell.textField.textColor != [UIColor blackColor]) {
                    height = @0;
                } else if ([settingsCell.textField.text intValue] != 0) {
                    height = [NSNumber numberWithInteger:[settingsCell.textField.text integerValue]];
                }
                
                self.testCaseSettings[TEST_CASE_AD_HEIGHT_PLIST_KEY] = height;
            }
        }
        
        if (_widthCheckbox.selected && _heightCheckbox.selected) {
            self.testCaseSettings[TEST_CASE_AD_IS_FULLSCREEN_PLIST_KEY] = @YES;
        } else {
            self.testCaseSettings[TEST_CASE_AD_IS_FULLSCREEN_PLIST_KEY] = @NO;
        }
    }
}

- (void)bannerWidthChanged:(UITextField *)textField{
    NSNumber *newVal = [NSNumber numberWithInteger:[_widthTextField.text integerValue]];
    
    if (_widthTextField.text.length == 0) {
        _widthTextField.textColor = [UIColor lightGrayColor];
        _widthTextField.text = PLACEHOLDER_SETTINGS_CUSTOM_SIZE;
        newVal = @0;
        
        [_widthTextField resignFirstResponder];
    }
    
    [self.testCaseSettings setObject:newVal forKey:TEST_CASE_AD_WIDTH_PLIST_KEY];
}

- (void)bannerHeightChanged:(UITextField *)textField{
    NSNumber *newVal = [NSNumber numberWithInteger:[_heightTextField.text integerValue]];
    
    if (_heightTextField.text.length == 0) {
        _heightTextField.textColor = [UIColor lightGrayColor];
        _heightTextField.text = PLACEHOLDER_SETTINGS_CUSTOM_SIZE;
        newVal = @0;
        
        [_heightTextField resignFirstResponder];
    }
    
    [self.testCaseSettings setObject:newVal forKey:TEST_CASE_AD_HEIGHT_PLIST_KEY];
}

- (void)testAdIdChanged:(UITextField *)textField{
    NSNumber *newVal = [NSNumber numberWithInteger:[_testAdIdTextField.text integerValue]];
    
    if (_testAdIdTextField.text.length == 0) {
        _testAdIdTextField.textColor = [UIColor lightGrayColor];
        _testAdIdTextField.text = PLACEHOLDER_SETTINGS_TEST_AD_ID;
        newVal = @0;
        
        [_testAdIdTextField resignFirstResponder];
    }
    
    [self.testCaseSettings setObject:newVal forKey:TEST_CASE_TEST_AD_ID_PLIST_KEY];
}

@end
