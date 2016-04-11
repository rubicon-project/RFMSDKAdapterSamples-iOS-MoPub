//
//  RPLogger.h
//  MoPub-RFM Sample
//
//  Created by Rubicon Project on 9/23/15.
//  Copyright © 2015 Rubicon Project. All rights reserved.
//

extern int ddLogLevel;

#define RPLogError(fmt, ...) DDLogError((@"%@:%@:[Line %d] " fmt), THIS_FILE, THIS_METHOD,__LINE__, ##__VA_ARGS__);
#define RPLogWarn(fmt, ...) DDLogWarn((@"%@:%@:[Line %d] " fmt), THIS_FILE, THIS_METHOD,__LINE__, ##__VA_ARGS__);
#define RPLogInfo(fmt, ...) DDLogInfo((@"%@:%@:[Line %d] " fmt), THIS_FILE, THIS_METHOD,__LINE__, ##__VA_ARGS__);
#define RPLogDebug(fmt, ...) DDLogDebug((@"%@:%@:[Line %d] " fmt), THIS_FILE, THIS_METHOD,__LINE__, ##__VA_ARGS__);
#define RPLogVerbose(fmt, ...) DDLogVerbose((@"%@:%@:[Line %d] " fmt), THIS_FILE, THIS_METHOD,__LINE__, ##__VA_ARGS__);

