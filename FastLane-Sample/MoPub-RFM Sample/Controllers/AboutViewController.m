//
//  AboutViewController.m
//  MoPub-RFM Sample
//
//  Created by Rubicon Project on 9/21/15.
//  Copyright © 2015 Rubicon Project. All rights reserved.
//

#import "AboutViewController.h"
#import "AboutViewCell.h"
#import <ColorUtils/ColorUtils.h>
#import "TRPConstants.h"
#import <RFMAdSDK/RFMAdSDK.h>
#import <mopub-ios-sdk/MoPub.h>

@interface AboutViewController ()

@end

@implementation AboutViewController

typedef NS_ENUM(NSInteger, AboutRows) {
    RFMSdkVersionRow = 0,
    MoPubSdkVersionRow,
    AppVersion,
    
    AboutNumRows
};

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNavigationControllerStyle];
}

-(void)setNavigationControllerStyle{
    self.title = @"About";
    
    // Custom navigation back button
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    closeButton.frame = CGRectMake(0, 0, 30, 30);
    [closeButton addTarget:self action:@selector(closeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
}

- (void)closeButtonClicked{
    [self resignFirstResponder];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return AboutNumRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AboutViewCell *cell = (AboutViewCell *)[tableView dequeueReusableCellWithIdentifier:@"AboutViewCell" forIndexPath:indexPath];
    
    switch (indexPath.row) {
        case RFMSdkVersionRow:
            cell.title.text = @"RFM SDK Version";
            cell.subtitle.text = [RFMAdView rfmSDKVersion];
            break;
        case MoPubSdkVersionRow:
            cell.title.text = @"MoPub SDK Version";
            cell.subtitle.text = [[MoPub sharedInstance] version];
            break;
        case AppVersion:
            cell.title.text = @"Sample App Version";
            cell.subtitle.text = [NSString stringWithFormat:@"%@", [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"]];
            break;
        default:
            cell.title.text = @"";
            cell.subtitle.text = @"";
            break;
    }
    
    return cell;
}

@end
