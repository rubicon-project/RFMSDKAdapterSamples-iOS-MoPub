//
//  MainViewController.m
//  MoPub-RFM Sample
//
//  Created by The Rubicon Project on 2/15/15.
//  Copyright (c) Rubicon Project. All rights reserved.

#import "MainViewController.h"
#import <ColorUtils/ColorUtils.h>
#import "TRPConstants.h"
#import "MainTableViewCell.h"
#import "AddTestCaseViewController.h"
#import "AppSettingsMenuViewController.h"
#import "AdViewController.h"
#import "Settings.h"
#import <mopub-ios-sdk/MoPub.h>
#import <RFMAdSDK/RFMAdSDK.h>

typedef NS_ENUM(NSInteger, TestCasesSections){
    SectionPreset = 0,
    SectionUserDefined,
    
    TestCasesNumSections
};

typedef NS_ENUM(NSInteger, PresetTestCasesRowMap){
    PresetTestCaseBanner = 0,
    PresetTestCaseInterstitial,
    
    PresetTestCaseNumRows
};

@interface MainViewController ()<UITableViewDataSource, UITableViewDelegate, MainViewCellDelegate, AddTestCaseViewControllerDelegate, AppSettingsMenuDelegate>

@property (nonatomic, strong) NSDictionary *sectionTitles;
@property (nonatomic, strong) NSDictionary *rowMap;
@property (nonatomic, strong) NSMutableDictionary *tempTestCaseDictionary;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) Settings *settings;

@end

@implementation MainViewController

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
    [self setNavigationControllerStyle];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

-(void)setNavigationControllerStyle{
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithString:COLOR_TRP_RED_TINT];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.title = @"Test Cases";
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],
                              NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:20.0f]}];
}

-(void)reloadTableData{
    self.tempTestCaseDictionary = (NSMutableDictionary *)[self.settings getSettingForKey:TEST_CASES_PLIST_KEY];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

-(void)initialize{
    if (!_sectionTitles) {
        _sectionTitles = @{ @(SectionPreset):@"PRESET",
                            @(SectionUserDefined):@"USER DEFINED"
                            };
    }
    
    if (!_rowMap) {
        _rowMap = @{ @(SectionPreset):@(PresetTestCaseNumRows) };
    }
    
    // Init settings
    self.settings = [Settings sharedInstance];
    
    [self reloadTableData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return TestCasesNumSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numRows = 0;
    
    if (section == SectionPreset) {
        numRows = PresetTestCaseNumRows;
    } else if (section == SectionUserDefined) {
        numRows = self.tempTestCaseDictionary ? self.tempTestCaseDictionary.count - PresetTestCaseNumRows : 0;
    }
    
    return numRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = MainTableViewCellLabel;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                                            forIndexPath:indexPath];
    [self configureCell:cell identifier:cellIdentifier forIndexPath:indexPath];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 42)];
    [view setBackgroundColor:[UIColor colorWithString:COLOR_TRP_BG]];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(32, 10, tableView.frame.size.width - 64, 22)];
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
    return 48;
}

#pragma mark - configure cells
- (void)configureCell:(UITableViewCell *)aCell identifier:(NSString *)cellIdentifier forIndexPath:(NSIndexPath *)indexPath{
    if ([cellIdentifier isEqualToString:MainTableViewCellLabel]) {
        MainTableViewCell *cell = (MainTableViewCell *)aCell;
        cell.delegate = self;
        cell.testCaseNumber.text = [NSString stringWithFormat: @"%ld", (long)indexPath.row + 1];
        
        NSInteger tableRowNum;

        if (indexPath.section == SectionPreset) {
            tableRowNum = indexPath.row;
        } else if (indexPath.section == SectionUserDefined) {
            tableRowNum = indexPath.row + PresetTestCaseNumRows;
        }
        
        NSDictionary *testCase = [[NSDictionary alloc] initWithDictionary:[self.tempTestCaseDictionary valueForKey:[NSString stringWithFormat:@"%ld", (long)tableRowNum]]];
        
        cell.testCaseName.text = [testCase valueForKey:TEST_CASES_TEST_CASE_NAME_PLIST_KEY];
        cell.siteId.text = [NSString stringWithFormat:@"%@: %@", TEST_CASE_SETTINGS_MOPUB_SITE_ID_PREFIX, [testCase valueForKey:TEST_CASES_TEST_CASE_SITE_ID_PLIST_KEY]];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    BOOL canEdit = NO;
    
    if (indexPath.section == SectionUserDefined) {
        canEdit = YES;
    }
    
    return canEdit;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        UITableViewCell *aCell = [tableView cellForRowAtIndexPath:indexPath];
        NSString *key;
        
        if ([aCell isKindOfClass:[MainTableViewCell class]]) {
            MainTableViewCell *testCaseCell = (MainTableViewCell *)aCell;
            key = [NSString stringWithFormat:@"%d", [testCaseCell.testCaseNumber.text intValue] + 1 ];
            [self.tempTestCaseDictionary removeObjectForKey:key];
        }
        
        //Get the key, delete object for this key from tempKVDict, delete row from tableview
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger tableRowNum = 0;
    
    for (NSInteger i = 0; i < indexPath.section; i++) {
        tableRowNum += [self tableView:tableView numberOfRowsInSection:i];
    }
    
    tableRowNum += indexPath.row;

    // Store selected test case
    NSDictionary *newSettings = @{ TEST_CASE_SELECTED_PLIST_KEY : [NSString stringWithFormat:@"%ld", tableRowNum] };
    [self.settings updateSampleSettings:newSettings];
    
    // Go to ad view
    AdViewController *adViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdViewController"];
    [self.navigationController pushViewController:adViewController animated:YES];
}

- (IBAction)addTestCase:(UIButton *)sender {
    AddTestCaseViewController *addTestCaseVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddTestCaseViewController"];
    
    addTestCaseVC.delegate = self;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:addTestCaseVC];
    navigationController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    navigationController.navigationBarHidden = YES;
    navigationController.modalPresentationCapturesStatusBarAppearance = YES;
    
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (IBAction)showSettingsMenu:(UIButton *)sender {
    AppSettingsMenuViewController *settingsMenuVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AppSettingsMenuViewController"];
    
    settingsMenuVC.delegate = self;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:settingsMenuVC];
    navigationController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    navigationController.navigationBarHidden = YES;
    navigationController.modalPresentationCapturesStatusBarAppearance = YES;
    
    [self presentViewController:navigationController animated:NO completion:nil];
}

#pragma mark - AddTestCaseViewController Delegate
-(void)addTestCaseViewShouldDismiss:(AddTestCaseViewController *)addTestCaseViewController{
    [self dismissViewControllerAnimated:YES completion:^{
        [self reloadTableData];
    }];
}

#pragma mark - AppSettingsMenu Delegate
-(void)appSettingsMenuShouldDismiss:(AppSettingsMenuViewController *)appSettingsMenuViewController{
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
