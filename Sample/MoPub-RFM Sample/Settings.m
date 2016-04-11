//
//  Settings.m
//  MoPub-RFM Sample
//
//  Created by Rubicon Project on 9/29/15.
//  Copyright © 2015 Rubicon Project. All rights reserved.
//

#import "Settings.h"
#import "TRPConstants.h"
#import "RPLogger.h"

@interface Settings()

@property(nonatomic, strong) NSMutableDictionary *settingsDictionary;
@end

@implementation Settings

#pragma mark Singleton
+(Settings *)sharedInstance{
    static Settings *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[Settings alloc] init];
    });
    
    return _sharedInstance;
}

#pragma mark External
-(void)updateSampleSettings:(NSDictionary *)newSettings{
    NSMutableDictionary *tempDictionary = [self getSettingsDictionary];

    for (NSString *key in newSettings) {
        self.settingsDictionary[key] = newSettings[key];
        tempDictionary[key]=newSettings[key];
    }
    
    [tempDictionary writeToFile:[self getSettingsPlistInDoc] atomically: YES];
}

-(id)getSettingForKey:(NSString *)key{
    return (self.settingsDictionary[key]);
}

#pragma mark Internal
-(id)init{
    self = [super init];
    
    if (self) {
        self.settingsDictionary = [self getSettingsDictionary];
    }

    return self;
}

-(NSString *)getSettingsPlistInDoc{
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDir = documentPaths[0];
    NSString *settingsPlistInDoc = [documentsDir
                                    stringByAppendingPathComponent:SETTINGS_PLIST_FILENAME_WITH_EXT];
    return settingsPlistInDoc;
}

-(NSMutableDictionary *)getSettingsDictionary{
    NSError *error;
    NSString *settingsPlistInDoc = [self getSettingsPlistInDoc];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:settingsPlistInDoc]) {
        NSString *settingsPlistInBundle = [[NSBundle mainBundle]
                                           pathForResource:SETTINGS_PLIST_FILENAME
                                           ofType:@"plist"];
        
        [fileManager copyItemAtPath:settingsPlistInBundle toPath:settingsPlistInDoc error:&error];
    }
    
    if (error) {
        RPLogError(@"Error copying settings from bundle: %@",error.localizedDescription);
        return nil;
    } else {
        return([NSMutableDictionary dictionaryWithContentsOfFile:settingsPlistInDoc]);
    }
}

@end
