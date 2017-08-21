//
//  common.h
//  MyZyxel
//
//  Created by line on 2017/5/16.
//  Copyright © 2017年 Zyxel. All rights reserved.
//

#ifndef common_h
#define common_h

#ifndef debug

#import "MBProgressHUD/MBProgressHUD.h"
#import "Jwt.h"
#import "Reachability.h"

#define debug(s, ...) NSLog(@"\n\t[%@:%d] %@\n", [[NSString stringWithUTF8String:__FUNCTION__] lastPathComponent], \
__LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__])
#endif

#define DEBUG 1
#define DEBUG_TABLE 1

#define CLIENT_ID @"2743579a84d07e87cd1aa6405044952af408033a6d6d96c99708cc5ce8ecddf1"
#define CLIENT_SECRET @"3451eedf7f384979534864984027a4136659e42a91633512ec404b0c9e27b92a"
#define REDIRECT_URI @"myZyxel://auth/callback"
#define SITE_URL @"https://accounts-sit.myzyxel.com"
#define DATA_URL @"https://portal-sit.myzyxel.com"
#endif /* common_h */
