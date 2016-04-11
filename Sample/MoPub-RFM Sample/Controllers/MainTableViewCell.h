//
//  MainTableViewCell.h
//  MoPub-RFM Sample
//
//  Created by Rubicon Project on 9/21/15.
//  Copyright © 2015 Rubicon Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@protocol MainViewCellDelegate;

@interface MainTableViewCell : UITableViewCell

@property (weak, nonatomic) id<MainViewCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UILabel *testCaseNumber;
@property (weak, nonatomic) IBOutlet UILabel *testCaseName;
@property (weak, nonatomic) IBOutlet UILabel *siteId;

@end

@protocol MainViewCellDelegate <NSObject>

@end
