//
//  TRPConstants.h
//  MoPub-RFM Sample
//
//  Created by The Rubicon Project on 2/15/15.
//  Copyright (c) Rubicon Project. All rights reserved.

#ifndef MoPub_RFM_Sample_TRPConstants_h
#define MoPub_RFM_Sample_TRPConstants_h

//Color Defaults
#define COLOR_TRP_STROKE_LOGIN_BOX @"#dddddd"
#define COLOR_TRP_STROKE_LOGIN_BUTTON @"#eeeeee"
#define COLOR_TRP_RED_TINT @"#F44336"
#define COLOR_TRP_BG @"#ECECEC"
#define COLOR_TRP_RED @"#CF242C"
#define COLOR_TRP_BLUE @"#009BDE"
#define COLOR_TRP_OFF_WHITE @"FAFAFA"

//Add Test Case
#define AD_TYPE_LIST_UI_TEXT @{ @"1" : @"Banner", @"2" : @"Interstitial", @"3" : @"Native"}
#define TEST_CASE_NAME_PLACEHOLDER @"Test Case Name"
#define MOPUB_SITE_ID_PLACEHOLDER @"MoPub Ad Unit ID"
#define TEST_CASES_PLIST_KEY @"testCases"
#define TEST_CASES_TEST_CASE_AD_TYPE_PLIST_KEY @"testCaseAdType"
#define TEST_CASES_TEST_CASE_SITE_ID_PLIST_KEY @"testCaseMopubSiteId"
#define TEST_CASES_TEST_CASE_NAME_PLIST_KEY @"testCaseName"

//App Settings
#define APP_SETTINGS_PLIST_KEY @"appSettings"
#define APP_SETTINGS_LOCATION_TYPE_PLIST_KEY @"locationType"
#define APP_SETTINGS_LATITUDE_PLIST_KEY @"latitude"
#define APP_SETTINGS_LONGITUDE_PLIST_KEY @"longitude"
#define APP_SETTINGS_TARGETING_KEY_VALUES_PLIST_KEY @"targetingKeyValues"
#define LOCATION_TYPE_LIST_UI_TEXT @{ @"none" : @"None", @"ip" : @"IP", @"gps" : @"GPS", @"user" : @"User Defined"}

//Settings Menu
#define SETTINGS_MENU_SETTINGS_LABEL @"Settings"
#define SETTINGS_MENU_ABOUT_LABEL @"About"

//Test Case Settings
#define TEST_CASE_SETTINGS_MOPUB_SITE_ID_PREFIX @"Ad Unit ID"
#define SETTINGS_PLIST_FILENAME_WITH_EXT @"MoPubRFMSampleSettings.plist"
#define SETTINGS_PLIST_FILENAME @"MoPubRFMSampleSettings"
#define TEST_CASE_SELECTED_PLIST_KEY @"testCaseSelectedKey"
#define TEST_CASE_AD_WIDTH_PLIST_KEY @"testCaseAdWidth"
#define TEST_CASE_AD_HEIGHT_PLIST_KEY @"testCaseAdHeight"
#define TEST_CASE_TEST_MODE_ENABLED_PLIST_KEY @"testCaseTestModeEnabled"
#define TEST_CASE_TEST_AD_ID_PLIST_KEY @"testCaseTestAdId"
#define TEST_CASE_AD_IS_FULLSCREEN_PLIST_KEY @"testCaseAdIsFullscreen"
#define TEST_CASE_FASTLANE_ENABLED_PLIST_KEY @"testCaseFastLaneEnabled"
#define TEST_CASE_FETCH_ONLY_VIDEO_ADS_KEY @"testCaseFetchOnlyVideoAds"
#define TEST_CASE_FASTLANE_RFM_APP_ID_PLIST_KEY @"testCaseRfmAppId"
#define TEST_CASE_FASTLANE_RFM_PUB_ID_PLIST_KEY @"testCaseRfmPubId"
#define TEST_CASE_SERVER_PLIST_KEY @"testCaseServer"
#define TEST_CASE_AD_IS_REWARDED_VIDEO_PLIST_KEY @"testCaseAdIsRewardedVideo"

#define PLACEHOLDER_SETTINGS_CUSTOM_SIZE @"Custom Size"
#define PLACEHOLDER_SETTINGS_TEST_AD_ID @"Ad ID of RFM Ad to be fetched"
#define PLACEHOLDER_SETTINGS_RFM_APP_ID @"RFM App ID, only if using FastLane"
#define PLACEHOLDER_SETTINGS_RFM_PUB_ID @"RFM Publisher ID, only if using FastLane"

//MoPub delegate console text
#define CONSOLE_VIEW_AD_SUCCESS @"Ad success"
#define CONSOLE_VIEW_AD_FAILURE @"Ad failure"
#define CONSOLE_VIEW_INTERSTITIAL_DID_LOAD_AD @"Interstitial did load ad"
#define CONSOLE_VIEW_INTERSTITIAL_DID_FAIL_TO_LOAD_AD @"Interstitial did fail to load ad"
#define CONSOLE_VIEW_INTERSTITIAL_WILL_APPEAR @"Interstitial will appear"
#define CONSOLE_VIEW_INTERSTITIAL_DID_APPEAR @"Interstitial did appear"
#define CONSOLE_VIEW_INTERSTITIAL_WILL_DISAPPEAR @"Interstitial will disappear"
#define CONSOLE_VIEW_INTERSTITIAL_DID_DISAPPEAR @"Interstitial did disappear"
#define CONSOLE_VIEW_INTERSTITIAL_DID_EXPIRE @"Interstitial did expire"
#define CONSOLE_VIEW_INTERSTITIAL_DID_RECEIVE_TAP_EVENT @"Interstitial did receive tap event"

//MoPub Rewarded video delegate console text
#define CONSOLE_VIEW_SHOULD_REWARD_USER @"Should reward user"
#define CONSOLE_VIEW_REWARDED_VIDEO_DID_FAIL_TO_PLAY @"Rewarded video did fail to play"
#define CONSOLE_VIEW_REWARDED_VIDEO_DID_LOAD @"Rewarded video did load"
#define CONSOLE_VIEW_REWARDED_VIDEO_DID_FAIL_TO_LOAD @"Rewarded video did fail to load"
#define CONSOLE_VIEW_REWARDED_VIDEO_WILL_APPEAR @"Rewarded video will appear"
#define CONSOLE_VIEW_REWARDED_VIDEO_DID_APPEAR @"Rewarded video did appear"
#define CONSOLE_VIEW_REWARDED_VIDEO_WILL_DISAPPEAR @"Rewarded video will disappear"
#define CONSOLE_VIEW_REWARDED_VIDEO_DID_DISAPPEAR @"Rewarded video did disappear"
#define CONSOLE_VIEW_REWARDED_VIDEO_DID_EXPIRE @"Rewarded video did expire"
#define CONSOLE_VIEW_REWARDED_VIDEO_DID_RECEIVE_TAP_EVENT @"Rewarded video did receive tap event"

//FastLane console text
#define CONSOLE_VIEW_FINAL_FASTLANE_INFO @"Final FastLane ad info"
#define CONSOLE_VIEW_FINAL_FASTLANE_CUSTOM_TARGETING @"FastLane: Using custom targeting from app settings instead of response"
#define CONSOLE_VIEW_FINAL_FASTLANE_FAILED_TO_RECEIVE_INFO @"Failed to receive FastLane ad info"
#define CONSOLE_VIEW_FINAL_FASTLANE_SENDING_REGULAR_REQUEST @"Sending regular waterfall request without FastLane info"

//Native console text
#define CONSOLE_VIEW_NATIVE_LOADED_AD @"Successfully loaded native ad"
#define CONSOLE_VIEW_NATIVE_FAILED_TO_LOAD_AD @"Failed to load native ad"
#define CONSOLE_VIEW_NATIVE_WILL_PRESENT_MODAL @"Will present modal for native ad"
#define CONSOLE_VIEW_NATIVE_DID_DISMISS_MODAL @"Did dismiss modal for native ad"
#define CONSOLE_VIEW_NATIVE_WILL_LEAVE_APPLICATION @"Will leave application from native ad"

//OS version detector
#define RP_SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

#endif
