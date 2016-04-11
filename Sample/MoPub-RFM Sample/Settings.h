//
//  Settings.h
//  MoPub-RFM Sample
//
//  Created by Rubicon Project on 9/29/15.
//  Copyright © 2015 Rubicon Project. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Settings : NSObject

+(Settings *)sharedInstance;
-(void)updateSampleSettings:(NSDictionary *)newSettings;
-(id)getSettingForKey:(NSString *)key;

@end
