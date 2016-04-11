//
//  AppSettingsMenuViewController.h
//  MoPub-RFM Sample
//
//  Created by Rubicon Project on 9/25/15.
//  Copyright © 2015 Rubicon Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@protocol AppSettingsMenuDelegate;

@interface AppSettingsMenuViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,assign) id<AppSettingsMenuDelegate>delegate;

@end

@protocol AppSettingsMenuDelegate <NSObject>

-(void)appSettingsMenuShouldDismiss:(AppSettingsMenuViewController *)appSettingsMenuViewController;

@end