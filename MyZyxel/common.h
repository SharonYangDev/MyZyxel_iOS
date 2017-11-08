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
#include "openssl/crypto.h"

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
    SERVICE_CHECK_MANUAL_LICENSE,
    SERVICE_CHECK_SCAN_LICENSE,
    SERVICE_REGISTER_LICENSE,
    // HOME
    ENTER_HOME,
    HOME_GET_LICENSES,
    HOME_ACTIVATE_LICENSE,
    HOME_SCAN_ACTIVATE_LICENSE,
    HOME_MANUAL_ACTIVATE_LICENSE,
    HOME_BOUNDLE_LICENSE,
    // NOTIFICATION
    ENTER_NOTIFICATION,
    NOTIFICATION_GET_MESSAGE_DETAIL
};

enum SignStatus
{
    REGISTER_DEVICE = 0,
    UPDATE_DEVICE,
    REMOTE_DEVICE,
    BINDING_DEVICE,
    UNBINDING_DEVICE,
    GET_MESSAGE_LIST,
    GET_MESSAGE_DETAIL
};

#define debug(s, ...) if (DEBUGMODE) NSLog(@"\n\t[%@:%d] %@\n", [[NSString stringWithUTF8String:__FUNCTION__] lastPathComponent], \
__LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__])

#define service_debug(s, ...) if (SERVICEMODE) NSLog(@"\n\t[%@:%d] %@\n", [[NSString stringWithUTF8String:__FUNCTION__] lastPathComponent], \
__LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__])

#define device_debug(s, ...) if (DEVICEMODE) NSLog(@"\n\t[%@:%d] %@\n", [[NSString stringWithUTF8String:__FUNCTION__] lastPathComponent], \
__LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__])

#define push_debug(s, ...) if (PUSHMODE) NSLog(@"\n\t[%@:%d] %@\n", [[NSString stringWithUTF8String:__FUNCTION__] lastPathComponent], \
__LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__])

#define response_debug(s, ...) if (RESPONSEMODE) NSLog(@"\n\t[%@:%d] %@\n", [[NSString stringWithUTF8String:__FUNCTION__] lastPathComponent], \
__LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__])

#define tableview_debug(s, ...) if (TABLEVIEWMODE) NSLog(@"\n\t[%@:%d] %@\n", [[NSString stringWithUTF8String:__FUNCTION__] lastPathComponent], \
__LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__])

#endif

//#define SITE
#define RELEASE
#define DEBUGMODE 0
#define DEVICEMODE 0
#define SERVICEMODE 0
#define TABLEVIEWMODE 0
#define RESPONSEMODE 0
#define PUSHMODE 0
#define PUSH_SITE @"https://push-ebeta.myzyxel.com"
//#define PUSH_SITE @"http://push-ebeta.myzyxel.ecoworkinc.com"
#define APP_VERSION @"Version 1.0.0.10B5S5"

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
#define AKID @"2f03a193-479e-40b3-afec-86c9e0891a1e"
#define API_KEY @"HuPLm41QCjdySvHOKG1f42AIjwjU29Q3lbdu9iB8"
#define PRIVATE_KEY @"-----BEGIN RSA PRIVATE KEY-----\nMIIEpAIBAAKCAQEAp/8x9SXEYm3ma72yvihqpBJmiVZeg148wiOrgRDYrnfe/R2kv0HlKUpPxMveHHHeMu9cbu6I3DC2f7E0jVf3q9wANC4W/HvpHiZNgKkN0oXkKrj7fWXtCSS6Nc0uW25eKWKiCZGmYOSnn8oyg2A+NZqTSFpkebjZBYKuVi5VUfVWleTP/epywsFS47jS2lYxEWeKhy77pNiLe8dsWj04RQAIRyE9hJAeZEjC6/SYPtkdoS3nJLnyVsgX5aO5CXNJqYF0c7sqMIqtXFJQDAx40F53g6ixHPlTZq57y8/KZRVCOkB05CAXryTif5GUbpX5rvABfam6F+U6iUXeEusZnwIDAQABAoIBAQCKehOu9DuluttVch+VGXGV3skAad4sQRCqIobrM3y4i3yWfcngESwZVfTczgM+xSmYKK+zjRHpFopIRUSBQcKYuha87ETsSCNHQ+FcrX0ETHNgN+ytV8gEYm7PjFqq6RXa3T+dzZ4sfi4hy6TJoBqHSuwelsv9fb3+CdM0nKqdi9yZlJLVNDQntG5spqsszOI7cHV+ZVmV01W1M/QJLJAE5UNDwoeuDjh9CL7hxveInSCD4lHPi7QWOu7YIXF6j+3dGDWt84qRa2sRZL0P/MqUJPmxgU7nizti4Tr6/1Ut8QnSw1SM21WfycmBArEwGGMQoasCMb3CHJt6ixJ/mXhJAoGBANUHaY18B4OAbfW7uX5zWEbX1egqZbPgnSAd0e2q4cjH2L07IwXCaPkgoc73FugkVGVomecwuWRqHtH/hgVm7Lmti4tJUUuynqndS+WSzEn31LkwfvBMtHjE6+1cKj77zEd4wSyBDGZRHy9c4HZLF277odPNZAhfYm2iAViidYIVAoGBAMniX5UqDjkFPQw9Oin3zrv8ZVqyYFBX1b5rHGtGG6/a67SbDn01e+OBkJOG5VSM0UkOTtUSTNyjSyOkHuqtWOuLWsPdc+r4Nsgb9ZX/OYu876PXdEQCuS4aL8nk3J+6+SFU19A4znb5V6mPJTXWwS3ugUUuEA9B/7SaAvQjAv3jAoGAGfzkgJEf7YfuYir7jxSNMV9FRiRd8dq18GQS5xaQosjWhQdA14QHAFVdx/zWu40rCo//LngANeLITcAJXoFW4bPtMRnJpB1vQ7OufZwx9dgZCFqFMdV5sr37NiKnOLXJDvMJRd+cXqMI1eNTsrqoai6iaE9HI8pXHJ7F4UU4Zp0CgYEAyGyT5fuNiTBZLhhu8RFSzbBCUyt5kOnSiqu92AYPIKPfkzrIxKdfajrL9JpcfHcco0GwI7p6UiVPSH/8LZGREK8VmhP1q9VmVX3kb1ilocQdyPPyOj7V5x4aSX6LRYyTHnMjmlV7LARY8j3pfCzLNjVtYufbC7rDCGJKAmPr6W8CgYAvd9hoZAoRLYs8TLVEZXuvr23HPSNDSUYgvP9riiVApTSXx+3X8dNwdyRAGWxirZoeAgq6t8Fjk4iqIdP8sXWeWPgXj2Hnr8ijVUF/Jk6XEhaeqKqXf1qOiQDPq3WAcsDezDJaXP8vo7uTJUP3KAu83CDpG0KIEkvf+ftt0q3agA==\n-----END RSA PRIVATE KEY-----"
#endif /* common_h */
