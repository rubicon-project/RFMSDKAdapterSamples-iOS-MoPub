//
//  RPDeviceInfo.m
//  MoPub-RFM Sample
//
//  Created by Rubicon Project on 10/12/15.
//  Copyright © 2015 Rubicon Project. All rights reserved.
//

#import "RPDeviceInfo.h"
#import "TRPConstants.h"

@implementation RPDeviceInfo

+(CGFloat)deviceScreenHeight:(UIInterfaceOrientation)currentOrientation{
    CGRect frame = [UIScreen mainScreen].bounds;
    CGFloat deviceScreenHeight =frame.size.height;
    
    if (RP_SYSTEM_VERSION_LESS_THAN(@"8.0") && UIInterfaceOrientationIsLandscape(currentOrientation)){
        deviceScreenHeight = frame.size.width;
    }
    
    return deviceScreenHeight;
}

+(CGFloat)deviceScreenWidth:(UIInterfaceOrientation)currentOrientation{
    CGRect frame = [UIScreen mainScreen].bounds;
    CGFloat deviceScreenWidth =frame.size.width;
    
    if (RP_SYSTEM_VERSION_LESS_THAN(@"8.0") && UIInterfaceOrientationIsLandscape(currentOrientation)){
        deviceScreenWidth = frame.size.height;
    }
    
    return deviceScreenWidth;
}

+(BOOL)isIpad{
    BOOL isIpad = NO;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        isIpad = YES;
    }
    
    return isIpad;
}

@end
