//
//  NativeNewsFeedAdView.m
//  MoPub-RFM Sample
//
//  Created by Rubicon Project on 10/23/16.
//  Copyright © 2016 Rubicon Project. All rights reserved.
//

#import "NativeNewsFeedAdView.h"

#define AD_VIEW_MARGINS 10.0f
#define STAR_RATING_IMAGE_WIDTH_HEIGHT_RATIO 6.25f

@interface NativeNewsFeedAdView ()

@property (nonatomic, strong) UIImageView *ratingImageView;

@end

@implementation NativeNewsFeedAdView

- (id)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.titleLabel = [[UILabel alloc] init];
        self.ctaLabel = [[UILabel alloc] init];
        self.sponsoredLabel = [[UILabel alloc] init];
        self.adChoicesIconImageView = [[UIImageView alloc] init];
        
        self.iconImageView = [[UIImageView alloc] init];
        self.iconImageView.hidden = YES;
        [self addSubview:self.iconImageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat adViewWidth = self.frame.size.width;
    CGFloat adViewHeight = self.frame.size.height;
    
    self.adChoicesIconImageView.frame = CGRectMake(AD_VIEW_MARGINS, AD_VIEW_MARGINS, 20, 20);
    
    self.iconImageView.frame = CGRectMake(AD_VIEW_MARGINS * 2, adViewHeight/4, adViewHeight/2, adViewHeight/2);
    self.iconImageView.hidden = NO;
    
    CGFloat titleLabelXPos = self.iconImageView.frame.origin.x + self.iconImageView.frame.size.width + (AD_VIEW_MARGINS * 2);
    CGFloat titleLabelYPos = self.iconImageView.frame.origin.y;
    CGFloat titleLabelWidth = adViewWidth - titleLabelXPos - (AD_VIEW_MARGINS * 2);
    CGFloat titleLabelHeight = self.iconImageView.frame.size.height / 2;
    self.titleLabel.frame = CGRectMake(titleLabelXPos, titleLabelYPos, titleLabelWidth, titleLabelHeight);
    
    if (_ratingImageView) {
        CGFloat ratingImageViewWidth = adViewWidth - titleLabelXPos - (AD_VIEW_MARGINS * 2);
        CGFloat ratingImageViewHeight = ratingImageViewWidth / STAR_RATING_IMAGE_WIDTH_HEIGHT_RATIO;
        _ratingImageView.frame = CGRectMake(titleLabelXPos, titleLabelYPos + titleLabelHeight, ratingImageViewWidth, ratingImageViewHeight);
        _ratingImageView.hidden = NO;
    }
    
    CGFloat sponsoredLabelXPos = self.adChoicesIconImageView.frame.size.width + AD_VIEW_MARGINS;
    CGFloat sponsoredLabelWidth = adViewWidth - sponsoredLabelXPos - (AD_VIEW_MARGINS);
    self.sponsoredLabel.frame = CGRectMake(sponsoredLabelXPos, AD_VIEW_MARGINS, sponsoredLabelWidth, 20);
    self.sponsoredLabel.textAlignment = NSTextAlignmentRight;
    self.sponsoredLabel.font = [UIFont systemFontOfSize:10.0f];
    
    CGFloat ctaLabelXPos = adViewWidth/2;
    CGFloat ctaLabelYPos = _ratingImageView.frame.origin.y + _ratingImageView.frame.size.height + AD_VIEW_MARGINS;
    CGFloat ctaLabelHeight = adViewHeight - ctaLabelYPos - AD_VIEW_MARGINS;
    CGFloat ctaLabelWidth = adViewWidth - ctaLabelXPos - AD_VIEW_MARGINS;
    self.ctaLabel.frame = CGRectMake(ctaLabelXPos, ctaLabelYPos, ctaLabelWidth, ctaLabelHeight);
    self.ctaLabel.layer.borderColor = [[UIColor grayColor] CGColor];
    self.ctaLabel.layer.borderWidth = 1.0f;
}

- (UILabel *)nativeTitleTextLabel {
    return self.titleLabel;
}

- (UIImageView *)nativeIconImageView {
    return self.iconImageView;
}

- (UILabel *)nativeCallToActionTextLabel {
    return self.ctaLabel;
}

- (UIImageView *)nativePrivacyInformationIconImageView {
    return self.adChoicesIconImageView;
}

- (void)layoutStarRating:(NSNumber *)starRating {
    UIImage *ratingImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@-star-rating", starRating]];
    _ratingImageView = [[UIImageView alloc] initWithImage:ratingImage];
    _ratingImageView.hidden = YES;
    [self addSubview:_ratingImageView];
}

- (void)layoutCustomAssetsWithProperties:(NSDictionary *)customProperties imageLoader:(MPNativeAdRenderingImageLoader *)imageLoader {
    if ([customProperties objectForKey:@"sponsored"]) {
        [self.sponsoredLabel setText:[NSString stringWithFormat:@"Sponsored by %@", [customProperties objectForKey:@"sponsored"]]];
        [self addSubview:self.sponsoredLabel];
    }
}

@end
