//
//  AppSettingsMenuViewController.m
//  MoPub-RFM Sample
//
//  Created by Rubicon Project on 9/25/15.
//  Copyright © 2015 Rubicon Project. All rights reserved.
//

#import "AppSettingsMenuViewController.h"
#import "AppSettingsMenuCell.h"
#import "TRPConstants.h"

@interface AppSettingsMenuViewController ()

@property (weak, nonatomic) IBOutlet UIView *transparentBackground;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation AppSettingsMenuViewController

typedef NS_ENUM(NSInteger, SettingTypes) {
    AppSettingsRow = 0,
    AboutRow,
    
    SettingsNumRows
};

#define AppSettingsSegue @"AppSettingsSegue"
#define AboutSettingsSegue @"AboutSettingsSegue"

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(backgroundTouched:)];
    [self.transparentBackground addGestureRecognizer:singleFingerTap];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self addRoundedCornersAndShadow];
}

-(void)addRoundedCornersAndShadow{
    self.tableView.layer.masksToBounds = NO;
    self.tableView.layer.cornerRadius = 3.0f;
    self.tableView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.tableView.layer.shadowOpacity = 0.8;
    self.tableView.layer.shadowRadius = 2.0;
    self.tableView.layer.shadowOffset = CGSizeMake(-0.5, 0.5);
    self.tableView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.tableView.bounds cornerRadius:3.0].CGPath;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return SettingsNumRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     AppSettingsMenuCell *cell = (AppSettingsMenuCell *)[tableView dequeueReusableCellWithIdentifier:@"AppSettingsMenuCell"
                                                         forIndexPath:indexPath];
     
     switch (indexPath.row) {
         case AppSettingsRow:
             cell.settingsLabel.text = SETTINGS_MENU_SETTINGS_LABEL;
             break;
         case AboutRow:
             cell.settingsLabel.text = SETTINGS_MENU_ABOUT_LABEL;
             break;
         default:
             cell.settingsLabel.text = @"";
             break;
     }
     
     return cell;
 }

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //Load the detailed view controller
    switch (indexPath.row) {
        case AppSettingsRow:
        {
            [self performSegueWithIdentifier:AppSettingsSegue sender:self];
        }
            break;
            
        case AboutRow:
        {
            [self performSegueWithIdentifier:AboutSettingsSegue sender:self];
        }
            break;
            
        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void)backgroundTouched:(UITapGestureRecognizer *)recognizer{
    [self.delegate appSettingsMenuShouldDismiss:self];
}

@end
