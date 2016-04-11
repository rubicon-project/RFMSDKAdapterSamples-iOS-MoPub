//
//  AppSettingsViewController.m
//  MoPub-RFM Sample
//
//  Created by Rubicon Project on 10/13/15.
//  Copyright © 2015 Rubicon Project. All rights reserved.
//

#import "AppSettingsViewController.h"
#import "SettingsCheckboxTextFieldCell.h"
#import "SettingsSwitchCell.h"
#import "SettingsTextFieldCell.h"
#import "SettingsKeyValueCell.h"
#import "SettingsPickerCell.h"
#import "SettingsLabelCell.h"
#import "MainViewController.h"
#import "Settings.h"
#import "TRPConstants.h"
#import "RPDeviceInfo.h"

@interface AppSettingsViewController () <UITableViewDataSource, UITableViewDelegate, SettingsKeyValueCellDelegate, SettingsTextFieldCellDelegate, SettingsPickerCellDelegate, UIPickerViewDelegate, UIPickerViewDataSource> {
    UITextField *_latTextField;
    UITextField *_lonTextField;
    UIButton *_locationTypeDropdown;
}

@property (nonatomic, strong) NSMutableDictionary *tempKVDictionary;
@property (nonatomic, strong) NSMutableDictionary *appSettingsDictionary;
@property (nonatomic, strong) Settings *settings;
@property (nonatomic, strong) NSString *testCaseSelectedId;

@property (nonatomic, strong) NSDictionary *sectionTitles;
@property (nonatomic, strong) NSDictionary *rowMap;
@property (nonatomic, strong) NSDictionary *cellIdentifierMap;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)backButtonClicked:(UIButton *)sender;
- (IBAction)saveButtonClicked:(UIButton *)sender;

@end

@implementation AppSettingsViewController

typedef NS_ENUM(NSInteger, AppSettingSections) {
    SectionLocationTargeting = 0,
    SectionKeyValueTargeting,
    
    AppSettingsNumSections
};

typedef NS_ENUM(NSInteger, LocationTargetingSectionRows) {
    LocationTargetingSectionLocationType = 0,
    LocationTargetingSectionLatitude,
    LocationTargetingSectionLongitude,
    
    LocationTargetingSectionNumRows
};

typedef NS_ENUM(NSInteger, KeyValueTargetingSectionRows) {
    KeyValueTargetingAddPair = 0,
    
    KeyValueTargetingSectionNumRows
};

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialize];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self initialize];
}

-(void)initialize{
    self.settings = [Settings sharedInstance];
    
    if (!_sectionTitles) {
        _sectionTitles = @{ @(SectionLocationTargeting):@"LOCATION TARGETING",
                            @(SectionKeyValueTargeting):@"KEY VALUE TARGETING"
                            };
    }
    
    if (!_rowMap) {
        _rowMap = @{
                    @(SectionLocationTargeting):@(LocationTargetingSectionNumRows),
                    @(SectionKeyValueTargeting):@(KeyValueTargetingSectionNumRows)
                    };
    }
    
    if (!_cellIdentifierMap) {
        _cellIdentifierMap = @{
                               [NSIndexPath indexPathForRow:LocationTargetingSectionLocationType inSection:SectionLocationTargeting]:SettingsCellPicker,
                               [NSIndexPath indexPathForRow:LocationTargetingSectionLatitude inSection:SectionLocationTargeting]:SettingsCellTextField,
                               [NSIndexPath indexPathForRow:LocationTargetingSectionLongitude inSection:SectionLocationTargeting]:SettingsCellTextField,
                               
                               [NSIndexPath indexPathForRow:KeyValueTargetingAddPair inSection:SectionKeyValueTargeting]:SettingsCellKeyValue
                               };
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.appSettingsDictionary = (NSMutableDictionary *)[self.settings getSettingForKey:APP_SETTINGS_PLIST_KEY];
    
    // Key value targeting
    if (!_tempKVDictionary) {
        _tempKVDictionary =  [NSMutableDictionary dictionaryWithCapacity:1];
    }
    
    [_tempKVDictionary removeAllObjects];
    
    self.tempKVDictionary = self.appSettingsDictionary[APP_SETTINGS_TARGETING_KEY_VALUES_PLIST_KEY];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (IBAction)backButtonClicked:(UIButton *)sender {
    [self resignFirstResponder];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)saveButtonClicked:(UIButton *)sender {
    // Storing app settings
    [self resignFirstResponder];
    
    NSDictionary *newSettings = @{
                                  APP_SETTINGS_PLIST_KEY:self.appSettingsDictionary
                                  };
    
    [self.settings updateSampleSettings:newSettings];

    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return AppSettingsNumSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numRows = 0;
    
    if (self.rowMap.count >= section) {
        numRows = [self.rowMap[@(section)] integerValue];
    }
    
    //Add rows for KV section
    if (section == SectionKeyValueTargeting) {
        numRows += self.tempKVDictionary ? self.tempKVDictionary.count : 0;
    }
    
    return numRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier;
    
    if ((indexPath.section == SectionKeyValueTargeting) && (indexPath.row != KeyValueTargetingAddPair)) {
        cellIdentifier = SettingsCellLabel;
    } else {
        cellIdentifier = self.cellIdentifierMap[indexPath];
    }
    
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
        
        if (indexPath.section == SectionLocationTargeting) {
            switch (indexPath.row) {
                case LocationTargetingSectionLatitude:
                {
                    textCell.label.text = @"Latitude";
                    
                    if ([self.appSettingsDictionary[APP_SETTINGS_LATITUDE_PLIST_KEY] intValue] != 0) {
                        textCell.textField.text = [self.appSettingsDictionary[APP_SETTINGS_LATITUDE_PLIST_KEY] stringValue];
                    } else {
                        textCell.textField.text = @"";
                    }
                    
                    if ([self.appSettingsDictionary[APP_SETTINGS_LOCATION_TYPE_PLIST_KEY] isEqual:@"user"]) {
                        textCell.textField.enabled = YES;
                        textCell.textField.hidden = NO;
                    } else {
                        textCell.textField.enabled = NO;
                        textCell.textField.hidden = YES;
                    }
                    
                    _latTextField = textCell.textField;
                    [textCell.textField addTarget:self action:@selector(latitudeChanged:) forControlEvents:UIControlEventEditingChanged];
                }
                    break;
                    
                case LocationTargetingSectionLongitude:
                {
                    textCell.label.text = @"Longitude";
                    
                    if ([self.appSettingsDictionary[APP_SETTINGS_LONGITUDE_PLIST_KEY] intValue] != 0) {
                        textCell.textField.text = [self.appSettingsDictionary[APP_SETTINGS_LONGITUDE_PLIST_KEY] stringValue];
                    } else {
                        textCell.textField.text = @"";
                    }
                    
                    if ([self.appSettingsDictionary[APP_SETTINGS_LOCATION_TYPE_PLIST_KEY] isEqual:@"user"]) {
                        textCell.textField.enabled = YES;
                        textCell.textField.hidden = NO;
                    } else {
                        textCell.textField.enabled = NO;
                        textCell.textField.hidden = YES;
                    }
                    
                    _lonTextField = textCell.textField;
                    [textCell.textField addTarget:self action:@selector(longitudeChanged:) forControlEvents:UIControlEventEditingChanged];
                }
                    break;
                    
                default:
                {
                    textCell.label.text = @"";
                    
                }
                    break;
            }
        }
    } else if ([cellIdentifier isEqualToString:SettingsCellKeyValue]) {
        SettingsKeyValueCell *kvCell = (SettingsKeyValueCell *)aCell;
        kvCell.delegate = self;
        
        if (indexPath.section == SectionKeyValueTargeting) {
            switch (indexPath.row) {
                case KeyValueTargetingAddPair:
                {
                    kvCell.label.text = @"Add Pair";
                }
                    break;
                    
                default:
                    break;
            }
        }
    } else if ([cellIdentifier isEqualToString:SettingsCellPicker]) {
        SettingsPickerCell *selectMenuCell = (SettingsPickerCell *)aCell;
        selectMenuCell.delegate = self;
        selectMenuCell.dropdown.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        if (indexPath.section == SectionLocationTargeting) {
            switch (indexPath.row) {
                case LocationTargetingSectionLocationType:
                {
                    selectMenuCell.label.text = @"Location Type";
                    
                    NSString *selectTitle = self.appSettingsDictionary[APP_SETTINGS_LOCATION_TYPE_PLIST_KEY] ? self.appSettingsDictionary[APP_SETTINGS_LOCATION_TYPE_PLIST_KEY] : @"none";
                    [selectMenuCell.dropdown setTitle:LOCATION_TYPE_LIST_UI_TEXT[selectTitle] forState:UIControlStateNormal];
                    _locationTypeDropdown = selectMenuCell.dropdown;
                    
                    [selectMenuCell.menu setBackgroundColor:[UIColor lightGrayColor]];
                    selectMenuCell.menu.delegate = self;
                    selectMenuCell.menu.dataSource = self;
                }
                    break;
                    
                default:
                {
                    selectMenuCell.label.text = @"";
                }
                    break;
            }
        }
    } else if ([cellIdentifier isEqualToString:SettingsCellLabel]) {
        SettingsLabelCell *labelCell = (SettingsLabelCell *)aCell;
        
        if (indexPath.section == SectionKeyValueTargeting) {
            if ((indexPath.row - KeyValueTargetingSectionNumRows) <= [self.tempKVDictionary count]) {
                NSArray *keyArray = [[self.tempKVDictionary allKeys] sortedArrayUsingSelector:@selector(localizedCompare:)];
                NSString *key = [keyArray objectAtIndex:(indexPath.row -1)];
                
                labelCell.labelOne.text = key;
                NSString *value = [self.tempKVDictionary valueForKey:key];
                labelCell.labelTwo.text = value;
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

#pragma mark - KV dynamic rows

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    // Return NO if you do not want the specified item to be editable.
    BOOL canEdit = NO;
    
    if (indexPath.section == SectionKeyValueTargeting && indexPath.row != KeyValueTargetingAddPair) {
        canEdit = YES;
    }
    
    return canEdit;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        UITableViewCell *aCell = [tableView cellForRowAtIndexPath:indexPath];
        NSString *key;
        
        if ([aCell isKindOfClass:[SettingsLabelCell class]]) {
            SettingsLabelCell *labelCell = (SettingsLabelCell *)aCell;
            
            key = labelCell.labelOne.text;
            [self.tempKVDictionary removeObjectForKey:key];
        }
        
        //Get the key, delete object for this key from tempKVDict, delete row from tableview
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

#pragma mark - Settings Key Value Cell
-(void)settingKeyValueCellButtonPressed:(SettingsKeyValueCell *)cell{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    if (indexPath.section == SectionKeyValueTargeting) {
        if (indexPath.row == KeyValueTargetingAddPair) {
            NSString *key = cell.key.text;
            NSString *value = cell.value.text;
            
            if (key == nil || value == nil || [key isEqualToString:@""]|| [value isEqualToString:@""]) {
                UIAlertView *prompt = [[UIAlertView alloc]initWithTitle:@"Invalid input"
                                                                message:[NSString stringWithFormat:@"You entered key: %@ and value: %@. Please enter non-empty text.",key,value]
                                                               delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Okay", nil];
                [prompt show];
            } else if ([self.tempKVDictionary objectForKey:key]) {
                UIAlertView *prompt = [[UIAlertView alloc]initWithTitle:@"Key already exists"
                                                                message:[NSString stringWithFormat:@"You entered key: %@ and value: %@. Please enter a unique key.",key,value]
                                                               delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Okay", nil];
                [prompt show];
            } else {
                self.tempKVDictionary[key] = value;
                
                //add kv to the table
                //Get num rows for the section KVTargetingSectId and create index path.
                NSUInteger numKVRows = [self.tableView numberOfRowsInSection:SectionKeyValueTargeting];
                
                NSUInteger newIndex[] = {(NSUInteger)SectionKeyValueTargeting, numKVRows};
                NSIndexPath *newPath = [[NSIndexPath alloc] initWithIndexes:newIndex
                                                                     length:2];
                
                [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:newPath, nil]
                                      withRowAnimation:UITableViewRowAnimationNone];
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:SectionKeyValueTargeting]
                              withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }
    }
}

-(void)settingKeyValueCellTextFieldDidBeginEditing:(SettingsKeyValueCell *)settingsCell{
    CGPoint scrollPoint = CGPointMake(0, settingsCell.frame.origin.y);
    scrollPoint = [self.tableView convertPoint:scrollPoint fromView:settingsCell.superview];
    [self.tableView setContentOffset:scrollPoint animated:YES];
}

#pragma mark - Settings Cell Delegates
-(void)settingsTextFieldDidBeginEditing:(SettingsTextFieldCell *)settingsCell{
    CGPoint scrollPoint = CGPointMake(0, settingsCell.frame.origin.y);
    scrollPoint = [self.tableView convertPoint:scrollPoint fromView:settingsCell.superview];
    [self.tableView setContentOffset:scrollPoint animated:YES];
}

#pragma mark - Text Field Changed Events

- (void)latitudeChanged:(UITextField *)textField{
    NSNumber *newVal = [NSNumber numberWithDouble:[_latTextField.text doubleValue]];
    
    if (_latTextField.text.length == 0) {
        newVal = @0;
        [_latTextField resignFirstResponder];
    }
    
    [self.appSettingsDictionary setObject:newVal forKey:APP_SETTINGS_LATITUDE_PLIST_KEY];
}

- (void)longitudeChanged:(UITextField *)textField{
    NSNumber *newVal = [NSNumber numberWithDouble:[_lonTextField.text doubleValue]];
    
    if (_lonTextField.text.length == 0) {
        newVal = @0;
        [_lonTextField resignFirstResponder];
    }
    
    [self.appSettingsDictionary setObject:newVal forKey:APP_SETTINGS_LONGITUDE_PLIST_KEY];
}

#pragma mark - Picker View Delegates

-(void)settingsPickerViewCellClicked:(SettingsPickerCell *)settingsCell{
    settingsCell.menu.hidden = !settingsCell.menu.hidden;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSString *key = [LOCATION_TYPE_LIST_UI_TEXT allKeys][row];
    [_locationTypeDropdown setTitle:LOCATION_TYPE_LIST_UI_TEXT[key] forState:UIControlStateNormal];
    self.appSettingsDictionary[APP_SETTINGS_LOCATION_TYPE_PLIST_KEY] = key;
    
    if ([key isEqual:@"user"]) {
        _latTextField.enabled = YES;
        _latTextField.hidden = NO;
        _lonTextField.enabled = YES;
        _lonTextField.hidden = NO;
    } else {
        _latTextField.enabled = NO;
        _latTextField.hidden = YES;
        _lonTextField.enabled = NO;
        _lonTextField.hidden = YES;
    }
    
    pickerView.hidden = YES;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return LOCATION_TYPE_LIST_UI_TEXT.count;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *key = [LOCATION_TYPE_LIST_UI_TEXT allKeys][row];
    return LOCATION_TYPE_LIST_UI_TEXT[key];
}

@end
