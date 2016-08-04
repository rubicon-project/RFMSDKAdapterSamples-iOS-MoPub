//
//  AdViewController.m
//  MoPub-RFM Sample
//
//  Created by Rubicon Project on 9/23/15.
//  Copyright © 2015 Rubicon Project. All rights reserved.
//

#import "AdViewController.h"
#import "TRPConstants.h"
#import "Settings.h"
#import "RPDeviceInfo.h"
#import <RFMAdSDK/RFMAdSDK.h>
#import <MPAdView.h>
#import "MPRewardedVideo.h"
#import "MoPub.h"
#import <MPInterstitialAdController.h>
#import <CoreLocation/CoreLocation.h>

@import CoreLocation;

@interface AdViewController ()<MPAdViewDelegate, MPInterstitialAdControllerDelegate, CLLocationManagerDelegate, RFMFastLaneDelegate, MPRewardedVideoDelegate> {
    NSNumber *_successCounter;
    NSNumber *_failureCounter;
    NSDate *_adRequestTime;
    BOOL _requestsStarted;
}

@property (weak, nonatomic) IBOutlet UIView *adContainer;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *countersExpandButton;
@property (weak, nonatomic) IBOutlet UIButton *logsExpandButton;
@property (weak, nonatomic) IBOutlet UIButton *logsClearButton;
@property (weak, nonatomic) IBOutlet UIButton *requestAdButton;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITextView *countersTextArea;
@property (weak, nonatomic) IBOutlet UITextView *logsTextArea;
@property (weak, nonatomic) IBOutlet UIView *logsSection;
@property (weak, nonatomic) IBOutlet UIView *countersSection;
@property (weak, nonatomic) IBOutlet UIView *adLabelView;
@property (weak, nonatomic) IBOutlet UIView *countersHeader;
@property (weak, nonatomic) IBOutlet UIView *logsHeader;
@property (weak, nonatomic) IBOutlet UIView *logsView;
@property (weak, nonatomic) IBOutlet UIView *countersView;

@property (nonatomic, strong) NSString *mopubAdUnitId;
@property (nonatomic, strong) NSNumber *bannerWidth;
@property (nonatomic, strong) NSNumber *bannerHeight;

@property (nonatomic, assign) BOOL adIsBanner;
@property (nonatomic, assign) BOOL adIsRewardedVideo;
@property (nonatomic, assign) BOOL isTestMode;
@property (nonatomic, strong) NSString *adKeywords;
@property (nonatomic, strong) CLLocation *location;

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (nonatomic) MPAdView *adView;
@property (nonatomic, retain) MPInterstitialAdController *interstitialAdView;

@property (nonatomic, strong) RFMAdRequest *fastlaneRequest;
@property (nonatomic, assign) BOOL isFastlane;
@property (nonatomic, assign, readonly) BOOL fetchOnlyVideoAds;

- (IBAction)countersExpandButtonClicked:(UIButton *)sender;
- (IBAction)logsExpandButtonClicked:(UIButton *)sender;
- (IBAction)logsClearButtonClicked:(UIButton *)sender;
- (IBAction)requestAdButtonClicked:(UIButton *)sender;
- (IBAction)backButtonClicked:(UIButton *)sender;

@end

@implementation AdViewController {
    NSString *_rewardedVideoAdUnitId;
}

#define SCROLL_VIEW_DEFAULT_HEIGHT 513
#define SHADOW_LAYER_NAME @"shadow"
#define SegueAdViewToSettings @"PlacementToSettingsSegue"

- (void)viewDidLoad{
    [super viewDidLoad];
    [self initialize];
    [self setCountersText];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initialize];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (self.adIsBanner) {
        [self configureViewForPlacementWidth:([self.bannerWidth integerValue] != 0 ? [self.bannerWidth integerValue] : 320) height:[self.bannerHeight integerValue] != 0 ? [self.bannerHeight integerValue] : 50];
    } else {
        [self configureViewForPlacementWidth:320 height:50];
    }
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self addShadowsAndRoundedCornersToViews];
}

-(void)dealloc{
    if (_adView) {
        _adView.delegate = nil;
    }
    
    if (_interstitialAdView) {
        _interstitialAdView.delegate = nil;
    }
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    
    if (_adView) {
        _adView.delegate = nil;
    }
    
    if (_interstitialAdView) {
        _interstitialAdView.delegate = nil;
    }
}

-(void)initialize{
    Settings *settings = [Settings sharedInstance];
    
    if (self.locationManager == nil) {
        self.locationManager = [[CLLocationManager alloc] init];
        
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = 500;
    }
    
    NSDictionary *tempTestCaseDictionary = [settings getSettingForKey:TEST_CASES_PLIST_KEY];
    NSDictionary *tempAppSettingsDictionary = [settings getSettingForKey:APP_SETTINGS_PLIST_KEY];
    NSString *testCaseSelectedId = (NSString *)[settings getSettingForKey:TEST_CASE_SELECTED_PLIST_KEY];
    NSDictionary *testCaseSelected = tempTestCaseDictionary[testCaseSelectedId];
    NSDictionary *targetingKVs = tempAppSettingsDictionary[APP_SETTINGS_TARGETING_KEY_VALUES_PLIST_KEY];
    
    self.mopubAdUnitId = (NSString *)[testCaseSelected valueForKey:TEST_CASES_TEST_CASE_SITE_ID_PLIST_KEY];
    self.adIsBanner = ([[testCaseSelected valueForKey:TEST_CASES_TEST_CASE_AD_TYPE_PLIST_KEY] isEqual: @0]) ? YES : NO;
    self.isTestMode = [[testCaseSelected valueForKey:TEST_CASE_TEST_MODE_ENABLED_PLIST_KEY] boolValue];
    self.adIsRewardedVideo = [[testCaseSelected valueForKey:TEST_CASE_AD_IS_REWARDED_VIDEO_PLIST_KEY] boolValue];
    
    if ([targetingKVs count]) {
        NSMutableString *keywords = [[NSMutableString alloc] init];
        
        for (NSString *key in targetingKVs){
            [keywords appendString:[NSString stringWithFormat:@"%@:%@,", key, targetingKVs[key]]];
        }
        
        self.adKeywords = [keywords substringToIndex:[keywords length] - 1];
    }
    
    if ([tempAppSettingsDictionary[APP_SETTINGS_LOCATION_TYPE_PLIST_KEY] isEqual:@"gps"] || [tempAppSettingsDictionary[APP_SETTINGS_LOCATION_TYPE_PLIST_KEY] isEqual:@"ip"]) {
        if([CLLocationManager locationServicesEnabled]){
            [self.locationManager startUpdatingLocation];
            
            self.location = self.locationManager.location;
        }
    } else if ([tempAppSettingsDictionary[APP_SETTINGS_LOCATION_TYPE_PLIST_KEY] isEqual:@"user"]) {
        double lat = [tempAppSettingsDictionary[APP_SETTINGS_LATITUDE_PLIST_KEY] doubleValue];
        double lon = [tempAppSettingsDictionary[APP_SETTINGS_LONGITUDE_PLIST_KEY] doubleValue];
        
        self.location = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
    }
    
    self.bannerWidth = [testCaseSelected valueForKey:TEST_CASE_AD_WIDTH_PLIST_KEY];
    self.bannerHeight = [testCaseSelected valueForKey:TEST_CASE_AD_HEIGHT_PLIST_KEY];
    
    self.pageLabel.text = (NSString *)[testCaseSelected valueForKey:TEST_CASES_TEST_CASE_NAME_PLIST_KEY];
    self.pageSubLabel.text = [NSString stringWithFormat:@"%@: %@", TEST_CASE_SETTINGS_MOPUB_SITE_ID_PREFIX, self.mopubAdUnitId];
    [self.requestAdButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    _requestsStarted = NO;
}

- (IBAction)backButtonClicked:(UIButton *)sender{
    [self resetAdViewAndResetCounters:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)requestAdButtonClicked:(UIButton *)sender{
    [self requestNewAd];
}

- (void)setTestCaseInfo:(NSDictionary *)testCaseInfo
{
    _testCaseInfo = testCaseInfo;
    self.isFastlane = [_testCaseInfo[TEST_CASE_FASTLANE_ENABLED_PLIST_KEY] boolValue];
    if(self.isFastlane) {
        self.fastlaneRequest = [[RFMAdRequest alloc] initRequestWithServer:_testCaseInfo[TEST_CASE_SERVER_PLIST_KEY]
                                                                  andAppId:_testCaseInfo[TEST_CASE_FASTLANE_RFM_APP_ID_PLIST_KEY]
                                                                  andPubId:_testCaseInfo[TEST_CASE_FASTLANE_RFM_PUB_ID_PLIST_KEY]];
    } else {
        self.fastlaneRequest = nil;
    }
}

- (BOOL)fetchOnlyVideoAds
{
    return [self.testCaseInfo[TEST_CASE_FETCH_ONLY_VIDEO_ADS_KEY] boolValue];
}

-(void)requestNewAd{
    if (!self.mopubAdUnitId || [self.mopubAdUnitId isEqualToString:@""]) {
        [self appendTextToConsoleView:@"Invalid Ad Unit ID\nPlease enter a valid MoPub Ad Unit ID\n"];
        return;
    }
    
    _adRequestTime = [NSDate date];
    
    if (self.adIsBanner) {
        // Change button image
        _requestsStarted = !_requestsStarted;
        if (_requestsStarted) {
            [self.requestAdButton setImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
            [self.adView startAutomaticallyRefreshingContents];
        } else {
            [self.requestAdButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
            [self.adView stopAutomaticallyRefreshingContents];
            return;
        }
        
        // Banner request
        if (!_adView) {
            self.adView = [[MPAdView alloc] initWithAdUnitId:self.mopubAdUnitId size:self.adContainer.frame.size];
            self.adView.delegate = self;
        }
        
        self.adView.adUnitId = self.mopubAdUnitId;
//        self.adView.testing = self.isTestMode;
        
        if (self.adKeywords) {
            self.adView.keywords = self.adKeywords;
        }
        
        if (self.location) {
            self.adView.location = self.location;
        }
        
        if(self.isFastlane) {
            self.fastlaneRequest.fetchOnlyVideoAds = self.fetchOnlyVideoAds;
            RFMFastLane *fastLane = [[RFMFastLane alloc] initWithSize:self.adView.frame.size delegate:self];
            [fastLane preFetchAdWithParams:self.fastlaneRequest];
        } else {
            [self.adView loadAd];
            [self.adContainer addSubview:self.adView];
        }
    } else if (self.adIsRewardedVideo) {
        [self.requestAdButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        
        [[MoPub sharedInstance] initializeRewardedVideoWithGlobalMediationSettings:nil delegate:(id)self];
        _rewardedVideoAdUnitId = self.mopubAdUnitId;
        // Precache rewarded video
        [MPRewardedVideo loadRewardedVideoAdWithAdUnitID:_rewardedVideoAdUnitId withMediationSettings:nil];
    } else {
        [self.requestAdButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        
        // Interstitial request
        if (!_interstitialAdView) {
            self.interstitialAdView = [MPInterstitialAdController interstitialAdControllerForAdUnitId:self.mopubAdUnitId];
            self.interstitialAdView.delegate = self;
        }
    
        self.interstitialAdView.adUnitId = self.mopubAdUnitId;
        self.interstitialAdView.testing = self.isTestMode;
        
        if (self.adKeywords) {
            self.interstitialAdView.keywords = self.adKeywords;
        }

        if (self.location) {
            self.interstitialAdView.location = self.location;
        }
        
        if(self.isFastlane) {
            self.fastlaneRequest.rfmAdType = RFM_ADTYPE_INTERSTITIAL;
            self.fastlaneRequest.fetchOnlyVideoAds = self.fetchOnlyVideoAds;
            RFMFastLane *fastLane = [[RFMFastLane alloc] initWithSize:self.interstitialAdView.view.frame.size delegate:self];
            [fastLane preFetchAdWithParams:self.fastlaneRequest];
        } else {
            [self.interstitialAdView loadAd];
        }
    }
    
    [self appendTextToConsoleView:[NSString stringWithFormat:@"Requesting Ad Unit: %@", self.mopubAdUnitId]];
}

- (IBAction)countersExpandButtonClicked:(UIButton *)sender{
    CGFloat logsSectionYAxis, scrollviewHeight;
    
    if (self.countersView.hidden) {
        [self.countersExpandButton setImage:[UIImage imageNamed:@"card-less"] forState:UIControlStateNormal];
        logsSectionYAxis = (self.countersSection.frame.origin.y + self.countersSection.frame.size.height + 10);
        scrollviewHeight = self.scrollView.contentSize.height + self.countersView.frame.size.height;
        self.countersView.hidden = NO;
        self.countersSection.layer.shadowOpacity = 0.8;
    } else {
        [self.countersExpandButton setImage:[UIImage imageNamed:@"card-more"] forState:UIControlStateNormal];
        logsSectionYAxis = (self.countersSection.frame.origin.y + self.countersSection.frame.size.height - self.countersView.frame.size.height + 10);
        scrollviewHeight = self.scrollView.contentSize.height - self.countersView.frame.size.height;
        self.countersView.hidden = YES;
        self.countersSection.layer.shadowOpacity = 0.0;
    }
    
    self.logsSection.frame = CGRectMake(self.logsSection.frame.origin.x, logsSectionYAxis, self.logsSection.frame.size.width, self.logsSection.frame.size.height);
    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, scrollviewHeight);
}

- (IBAction)logsExpandButtonClicked:(UIButton *)sender{
    CGFloat scrollviewHeight;
    
    if (self.logsView.hidden) {
        [self.logsExpandButton setImage:[UIImage imageNamed:@"card-less"] forState:UIControlStateNormal];
        scrollviewHeight = self.scrollView.contentSize.height + self.logsView.frame.size.height;
        self.logsView.hidden = NO;
        self.logsSection.layer.shadowOpacity = 0.8;
    } else {
        [self.logsExpandButton setImage:[UIImage imageNamed:@"card-more"] forState:UIControlStateNormal];
        scrollviewHeight = self.scrollView.contentSize.height - self.logsView.frame.size.height;
        self.logsView.hidden = YES;
        self.logsSection.layer.shadowOpacity = 0.0;
    }
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, scrollviewHeight);
}

- (IBAction)logsClearButtonClicked:(UIButton *)sender{
    self.logsTextArea.text = @"";
}

#pragma mark - View Setup
-(void)addShadowsAndRoundedCornersToViews{
    NSArray *sections = @[self.adLabelView, self.countersSection, self.logsSection];
    
    for (UIView *section in sections) {
        [self addShadowsAndRoundedCorners:section];
    }
    
    // Hide navigation bar
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

-(void)addShadowsAndRoundedCorners:(UIView *)view{
    if (![view.layer.name isEqual:SHADOW_LAYER_NAME]){
        view.layer.name = SHADOW_LAYER_NAME;
        view.layer.masksToBounds = NO;
        view.layer.shadowOpacity = 0.8;
        view.layer.shadowRadius = 2.0;
        view.layer.shadowOffset = CGSizeMake(-0.5, 0.5);
    }
    
    if (view == self.countersSection || view == self.logsSection) {
        view.layer.shadowColor = [UIColor grayColor].CGColor;
        CGFloat cornerRadius = 3.0f;
        view.layer.cornerRadius = cornerRadius;
        
        UIView *sectionHeader, *sectionTextArea;
        if (view == self.countersSection) {
            sectionTextArea = self.countersView;
            sectionHeader = self.countersHeader;
        } else if (view == self.logsSection) {
            sectionTextArea = self.logsView;
            sectionHeader = self.logsHeader;
        }
        
        UIBezierPath *maskPath;
        CAShapeLayer *maskLayer;
        
        // Rounding bottom corners
        maskPath = [UIBezierPath bezierPathWithRoundedRect:sectionTextArea.bounds
                                         byRoundingCorners:(UIRectCornerBottomLeft|UIRectCornerBottomRight)
                                               cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
        maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = sectionTextArea.bounds;
        maskLayer.path = maskPath.CGPath;
        sectionTextArea.layer.mask = maskLayer;
        
        // Rounding top corners
        maskPath = [UIBezierPath bezierPathWithRoundedRect:sectionHeader.bounds
                                         byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight)
                                               cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
        maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = sectionHeader.bounds;
        maskLayer.path = maskPath.CGPath;
        sectionHeader.layer.mask = maskLayer;
        
        view.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds cornerRadius:cornerRadius].CGPath;
    } else if (view == self.adLabelView) {
        view.layer.shadowColor = [UIColor blackColor].CGColor;
        view.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake(view.bounds.origin.x + 1.0, view.bounds.origin.y + view.bounds.size.height - 1.0, view.bounds.size.width - 2.0, 2.0)].CGPath;
    }
}

-(void)setCountersText{
    self.countersTextArea.text = [NSString stringWithFormat:@"Success: %d      Failure: %d", [_successCounter intValue], [_failureCounter intValue]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:SegueAdViewToSettings]) {
        [self resetAdViewAndResetCounters:NO];
    }
}

-(void)resetAdViewAndResetCounters:(BOOL)resetCounters {
    if (self.adView) {
        self.adView = nil;
        for (UIView *subview in [self.adContainer subviews]) {
            [subview removeFromSuperview];
        }
        
        if (_requestsStarted) {
            [self.adView stopAutomaticallyRefreshingContents];
            _requestsStarted = NO;
        }
    }
    
    // Clear logs when leaving ad preview
    if (resetCounters) {
        _successCounter = 0;
        _failureCounter = 0;
        [self setCountersText];
        self.logsTextArea.text = @"";
    }
}

-(void)configureViewForPlacementWidth:(NSUInteger)newAdWidth
                               height:(NSUInteger)newAdHeight{
    NSUInteger currentHeight = self.adContainer.frame.size.height;
    NSUInteger currentScrollViewHeight = SCROLL_VIEW_DEFAULT_HEIGHT + currentHeight;
    
    //Reset Scroll View Frame;
    NSInteger scrollHeightDelta = newAdHeight - currentHeight;
    
    if (scrollHeightDelta == 0) {
        [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, currentScrollViewHeight)];
        return;
    }
    
    CGRect adContainerFrame = self.adContainer.frame;
    
    if (adContainerFrame.size.width == newAdWidth &&
        adContainerFrame.size.height == newAdHeight) {
        return;
    }
    
    adContainerFrame.size.width = newAdWidth;
    adContainerFrame.size.height = newAdHeight;
    CGFloat newAdContainerOrigin_X = ([RPDeviceInfo deviceScreenWidth:[UIApplication sharedApplication].statusBarOrientation] - newAdWidth)/2;
    adContainerFrame.origin.x = newAdContainerOrigin_X;
    
    self.adContainer.frame = adContainerFrame;
    
    CGFloat scrollHeight = currentScrollViewHeight + scrollHeightDelta;
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, scrollHeight)];
    
    //Update positions of sections after ad container has changed
    CGFloat newAdLabelViewYAxis = self.adLabelView.frame.origin.y + scrollHeightDelta;
    CGFloat newCountersSectionYAxis = self.countersSection.frame.origin.y + scrollHeightDelta;
    CGFloat newLogsSectionYAxis = self.logsSection.frame.origin.y + scrollHeightDelta;
    
    self.adLabelView.frame = CGRectMake(self.adContainer.frame.origin.x, newAdLabelViewYAxis, self.adContainer.frame.size.width, self.adLabelView.frame.size.height);
    self.countersSection.frame = CGRectMake(self.countersSection.frame.origin.x, newCountersSectionYAxis, self.countersSection.frame.size.width, self.countersSection.frame.size.height);
    self.logsSection.frame = CGRectMake(self.logsSection.frame.origin.x, newLogsSectionYAxis, self.logsSection.frame.size.width, self.logsSection.frame.size.height);
    
    //Update the shadow for ad label view
    [self addShadowsAndRoundedCorners:self.adLabelView];
}

#pragma mark - Logging
-(void)appendTextToConsoleView:(NSString *)appendString{
    NSString *currentConsoleText = self.logsTextArea.text;
    
    [self.logsTextArea setText:[NSString stringWithFormat:@"%@\n%@", currentConsoleText, appendString]];
    [self.logsTextArea scrollRangeToVisible:NSMakeRange(self.logsTextArea.text.length, 0)];
}

#pragma mark - <MPAdViewDelegate>
- (UIViewController *)viewControllerForPresentingModalView{
    return self;
}

- (void)adViewDidLoadAd:(MPAdView *)view{
    [self appendTextToConsoleView:CONSOLE_VIEW_AD_SUCCESS];
    
    _successCounter = [NSNumber numberWithInt:[_successCounter intValue] + 1];
    [self setCountersText];
}

- (void)adViewDidFailToLoadAd:(MPAdView *)view{
    [self appendTextToConsoleView:CONSOLE_VIEW_AD_FAILURE];
    
    _failureCounter = [NSNumber numberWithInt:[_failureCounter intValue] + 1];
    [self setCountersText];
}

#pragma mark - <MPInterstitialAdControllerDelegate>
- (void)interstitialDidLoadAd:(MPInterstitialAdController *)interstitial{
    [self appendTextToConsoleView:CONSOLE_VIEW_INTERSTITIAL_DID_LOAD_AD];
    [self.interstitialAdView showFromViewController:self];
    
    _successCounter = [NSNumber numberWithInt:[_successCounter intValue] + 1];
    [self setCountersText];
}

- (void)interstitialDidFailToLoadAd:(MPInterstitialAdController *)interstitial{
    [self appendTextToConsoleView:CONSOLE_VIEW_INTERSTITIAL_DID_FAIL_TO_LOAD_AD];

    _failureCounter = [NSNumber numberWithInt:[_failureCounter intValue] + 1];
    [self setCountersText];
}

- (void)interstitialWillAppear:(MPInterstitialAdController *)interstitial{
    [self appendTextToConsoleView:CONSOLE_VIEW_INTERSTITIAL_WILL_APPEAR];
}

- (void)interstitialDidAppear:(MPInterstitialAdController *)interstitial{
    [self appendTextToConsoleView:CONSOLE_VIEW_INTERSTITIAL_DID_APPEAR];
}

- (void)interstitialWillDisappear:(MPInterstitialAdController *)interstitial{
    [self appendTextToConsoleView:CONSOLE_VIEW_INTERSTITIAL_WILL_DISAPPEAR];
}

- (void)interstitialDidDisappear:(MPInterstitialAdController *)interstitial{
    [self appendTextToConsoleView:CONSOLE_VIEW_INTERSTITIAL_DID_DISAPPEAR];
}

- (void)interstitialDidExpire:(MPInterstitialAdController *)interstitial{
    [self appendTextToConsoleView:CONSOLE_VIEW_INTERSTITIAL_DID_EXPIRE];
}

- (void)interstitialDidReceiveTapEvent:(MPInterstitialAdController *)interstitial{
    [self appendTextToConsoleView:CONSOLE_VIEW_INTERSTITIAL_DID_RECEIVE_TAP_EVENT];
}

#pragma mark - MoPub Rewarded Video

- (void)rewardedVideoAdDidLoadForAdUnitID:(NSString *)adUnitID {
    [self appendTextToConsoleView:CONSOLE_VIEW_REWARDED_VIDEO_DID_LOAD];
    
    if ([MPRewardedVideo hasAdAvailableForAdUnitID:_rewardedVideoAdUnitId]) {
        [MPRewardedVideo presentRewardedVideoAdForAdUnitID:_rewardedVideoAdUnitId fromViewController:self];
    }
    
    _successCounter = [NSNumber numberWithInt:[_successCounter intValue] + 1];
    [self setCountersText];
}

- (void)rewardedVideoAdDidFailToLoadForAdUnitID:(NSString*)adUnitID error:(NSError *)error {
    [self appendTextToConsoleView:CONSOLE_VIEW_REWARDED_VIDEO_DID_FAIL_TO_LOAD];
    
    _failureCounter = [NSNumber numberWithInt:[_failureCounter intValue] + 1];
    [self setCountersText];
}

- (void)rewardedVideoAdDidFailToPlayForAdUnitID:(NSString *)adUnitID error:(NSError *)error {
    [self appendTextToConsoleView:CONSOLE_VIEW_REWARDED_VIDEO_DID_FAIL_TO_PLAY];
}

- (void)rewardedVideoAdWillAppearForAdUnitID:(NSString *)adUnitID {
    [self appendTextToConsoleView:CONSOLE_VIEW_REWARDED_VIDEO_WILL_APPEAR];
}

- (void)rewardedVideoAdDidAppearForAdUnitID:(NSString *)adUnitID {
    [self appendTextToConsoleView:CONSOLE_VIEW_REWARDED_VIDEO_DID_APPEAR];
}

- (void)rewardedVideoAdWillDisappearForAdUnitID:(NSString *)adUnitID {
    [self appendTextToConsoleView:CONSOLE_VIEW_REWARDED_VIDEO_WILL_DISAPPEAR];
}

- (void)rewardedVideoAdDidDisappearForAdUnitID:(NSString *)adUnitID {
    [self appendTextToConsoleView:CONSOLE_VIEW_REWARDED_VIDEO_DID_DISAPPEAR];
}

- (void)rewardedVideoAdDidExpireForAdUnitID:(NSString *)adUnitID {
    [self appendTextToConsoleView:CONSOLE_VIEW_REWARDED_VIDEO_DID_EXPIRE];
}

- (void)rewardedVideoAdDidReceiveTapEventForAdUnitID:(NSString *)adUnitID {
    [self appendTextToConsoleView:CONSOLE_VIEW_REWARDED_VIDEO_DID_RECEIVE_TAP_EVENT];
}

- (void)rewardedVideoAdShouldRewardForAdUnitID:(NSString *)adUnitID reward:(MPRewardedVideoReward *)reward {
    [self appendTextToConsoleView:CONSOLE_VIEW_SHOULD_REWARD_USER];
}

- (void)rewardedVideoAdWillLeaveApplicationForAdUnitID:(NSString *)adUnitID {}

#pragma mark - FastLane

- (void)didReceiveFastLaneAdInfo:(NSDictionary *)adInfo
{
    if (self.adIsBanner) {
        if (self.adKeywords) {
            [self appendTextToConsoleView:CONSOLE_VIEW_FINAL_FASTLANE_CUSTOM_TARGETING];
            self.adView.keywords = self.adKeywords;
        } else {
            if ([adInfo count]) {
                NSMutableString *keywords = [[NSMutableString alloc] init];
                
                for (NSString *key in adInfo){
                    [keywords appendString:[NSString stringWithFormat:@"%@:%@,", key, adInfo[key]]];
                }
                
                self.adView.keywords = [keywords substringToIndex:[keywords length] - 1];
            }
        }
        
        [self appendTextToConsoleView:[NSString stringWithFormat:@"%@: %@", CONSOLE_VIEW_FINAL_FASTLANE_INFO, self.adView.keywords]];
        NSLog(@"%@", adInfo);
        [self.adView loadAd];
        [self.adContainer addSubview:self.adView];
    } else {
        if (self.adKeywords) {
            [self appendTextToConsoleView:CONSOLE_VIEW_FINAL_FASTLANE_CUSTOM_TARGETING];
            self.interstitialAdView.keywords = self.adKeywords;
        } else {
            if ([adInfo count]) {
                NSMutableString *keywords = [[NSMutableString alloc] init];
                
                for (NSString *key in adInfo){
                    [keywords appendString:[NSString stringWithFormat:@"%@:%@,", key, adInfo[key]]];
                }
                
                self.interstitialAdView.keywords = [keywords substringToIndex:[keywords length] - 1];
            }
        }
        
        [self appendTextToConsoleView:[NSString stringWithFormat:@"%@: %@", CONSOLE_VIEW_FINAL_FASTLANE_INFO, self.interstitialAdView.keywords]];
        
        [self.interstitialAdView loadAd];
    }
}

- (void)didFailToReceiveFastLaneAdWithReason:(NSString *)errorReason
{
   [self appendTextToConsoleView:[NSString stringWithFormat:@"%@: %@", CONSOLE_VIEW_FINAL_FASTLANE_FAILED_TO_RECEIVE_INFO, errorReason]];
    
    _failureCounter = [NSNumber numberWithInt:[_failureCounter intValue] + 1];
    [self setCountersText];
    
    [self appendTextToConsoleView:CONSOLE_VIEW_FINAL_FASTLANE_SENDING_REGULAR_REQUEST];
    if (self.adIsBanner) {
        [self.adView loadAd];
        [self.adContainer addSubview:self.adView];
    } else {
        [self.interstitialAdView loadAd];
    }
}

@end
