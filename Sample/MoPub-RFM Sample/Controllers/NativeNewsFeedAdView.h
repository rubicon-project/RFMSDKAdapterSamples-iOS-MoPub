//
//  NativeNewsFeedAdView.h
//  MoPub-RFM Sample
//
//  Created by Rubicon Project on 10/23/16.
//  Copyright © 2016 Rubicon Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoPub.h"

@interface NativeNewsFeedAdView : UIView <MPNativeAdRendering>

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *ctaLabel;
@property (strong, nonatomic) UIImageView *iconImageView;
@property (strong, nonatomic) UIImageView *adChoicesIconImageView;
@property (strong, nonatomic) UILabel *sponsoredLabel;
@property (strong, nonatomic) UIImageView *starRatingImageView;

@end
