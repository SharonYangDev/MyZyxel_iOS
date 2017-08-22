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
#import "scaleClickRange.h"

enum actionStatus
{
    // DEVICE
    ENTER_DEVICE = 0,
    ENTER_DEVICE_DETAIL,
    BACK_DEVICE,
    EDIT_DEVICE,
    EDIT_SEARCH_RESELLER,
    ADD_LICENSE,
    DEVICE_ACTIVATE_LICENSE,
    DEVICE_CHECK_MANUAL_ADD_LICENSE,
    DEVICE_CHECK_SCAN_ADD_LICENSE,
    DEVICE_SCAN_MANUAL_ACTIVATE,
    REGISTER_CHECK_MANUAL_DEVICE,
    REGISTER_CHECK_SCAN_DEVICE,
    REGISTER_SEARCH_RESELLER,
    REGISTER_COMPLETE,
    REGISTER_SKIP,
    // SERVICE
    ENTER_SERVICE,
    SERVICE_GET_LICENSE,
    SERVICE_GET_DEVICE,
    SERVICE_ACTIVATE_LICENSE,
    SERVICE_CHECK_LICENSE ,
    SERVICE_REGISTER_LICENSE,
    // HOME
    ENTER_HOME,
    HOME_GET_LICENSES,
    HOME_ACTIVATE_LICENSE,
    HOME_SCAN_ACTIVATE_LICENSE,
    HOME_MANUAL_ACTIVATE_LICENSE,
    HOME_BOUNDLE_LICENSE
};

#define debug(s, ...) NSLog(@"\n\t[%@:%d] %@\n", [[NSString stringWithUTF8String:__FUNCTION__] lastPathComponent], \
__LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__])
#endif

//#define SITE
#define RELEASE
#define DEBUG 1
#define TABELVIEW 1
#define RESPONSE 1

#ifdef SITE
    #define CLIENT_ID @"2743579a84d07e87cd1aa6405044952af408033a6d6d96c99708cc5ce8ecddf1"
    #define CLIENT_SECRET @"3451eedf7f384979534864984027a4136659e42a91633512ec404b0c9e27b92a"
    #define SITE_URL @"https://accounts-sit.myzyxel.com"
    #define DATA_URL @"https://portal-sit.myzyxel.com"
#else
    #define CLIENT_ID @"2080f0cb0df2992acabd8d7b5d958ab7e79d7d8c2849a46c7bc3386325629bd8"
    #define CLIENT_SECRET @"cbac8e4c82173440fab4a64abce5286fb748fa0228a1f286e025ff42632f1eee"
    #define SITE_URL @"https://accounts-ebeta.myzyxel.com"
    #define DATA_URL @"https://portal-ebeta.myzyxel.com"
#endif
#define REDIRECT_URI @"myZyxel://auth/callback"
#endif /* common_h */
