//
//  RPDeviceInfo.h
//  MoPub-RFM Sample
//
//  Created by Rubicon Project on 10/12/15.
//  Copyright © 2015 Rubicon Project. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RPDeviceInfo : NSObject

+(CGFloat)deviceScreenHeight:(UIInterfaceOrientation)currentOrientation;
+(CGFloat)deviceScreenWidth:(UIInterfaceOrientation)currentOrientation;
+(BOOL)isIpad;

@end
