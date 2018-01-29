//
//  notification.m
//  MyZyxel
//
//  Created by line on 2017/5/16.
//  Copyright © 2017年 Zyxel. All rights reserved.
//

#import "notification.h"

@interface notification ()
{
    MBProgressHUD *m_HUD;
    BOOL messageStatus;
    BOOL messageDetailStatus;
    NSUUID *uuid;
    NSInteger action;
    NSInteger selectMessageId;
    NSString *deviceId;
    NSString *deviceName;
    NSString *osVersion;
    NSString *deviceModel;
    NSString *language;
    NSString *timeZoneStr;
    NSString *appVersion;
    NSString *appBuildNum;
    NSString *signature;
    NSString *appInfo;
    NSString *userId;
    NSMutableDictionary *body;
    NSMutableArray *messageIdList;
    NSMutableArray *createAtList;
    NSMutableArray *messageBodyList;
    NSMutableArray *titleList;
    NSMutableArray *typeList;
    NSMutableArray *newlyList;
    NSMutableArray *readLogList;
}
@end

@implementation notification
- (void)dealloc
{
    m_HUD = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.messageContent.scrollView setBounces: NO];
    [self.messageDetailBackBtn setHitTestEdgeInsets: UIEdgeInsetsMake(60, 60, 60, 60)];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    if (m_HUD == nil)
    {
        m_HUD = [[MBProgressHUD alloc]initWithView: self.view];
        [m_HUD setContentColor: [UIColor whiteColor]];
        [m_HUD.bezelView setBackgroundColor: [UIColor blackColor]];
        [m_HUD showAnimated: YES];
        [m_HUD setMinShowTime: 15];
    }
    [self.contentView setHidden: YES];
    [self.errorView setHidden: YES];
    [self.noNotificationView setHidden: YES];
    [self.tabBarController.tabBar setUserInteractionEnabled: NO];
    [self selfLayout];
//    [self registerDevice];
//    [self updateDevice];
//    [self bindingDevice];
//    [self unBindingDevice];
//    [self getMessageList];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
    messageStatus = YES;
    [self.view addSubview: m_HUD];
    action = ENTER_NOTIFICATION;
    [self initEnv];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - GET SERVER INFO
//- (void)registerDevice
//{
//    signature = [[NSString alloc]initWithString: [self generateSign: REGISTER_DEVICE]];
//    NSString *register_device_url = [NSString stringWithFormat: @"%@/v1/devices", PUSH_SITE];
//    NSURL *url = [NSURL URLWithString: register_device_url];
//    NSMutableURLRequest *request_register_device = [NSMutableURLRequest requestWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 30];
//    [request_register_device setHTTPMethod: @"POST"];
//    [request_register_device setValue: API_KEY forHTTPHeaderField: @"X-Api-Key"];
//    [request_register_device setValue: signature forHTTPHeaderField: @"X-Signature"];
//    [request_register_device setValue: timeStamp forHTTPHeaderField: @"X-Timestamp"];
//    [request_register_device setValue: @"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField: @"Content-Type"];
//    NSString *deviceToken = [public get_device_token];
//    NSString *urlEncode = [public stringByAddingPercentEscapesForURLParameter: appInfo];
//    NSString *stringData = [NSString stringWithFormat: @"access_key_id=%@&udid=%@&push_token=%@&app_info=%@", AKID, deviceId, deviceToken, urlEncode];
//    NSData *postData = [stringData dataUsingEncoding: NSUTF8StringEncoding];
//    [request_register_device setHTTPBody: postData];
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//    [[session dataTaskWithRequest: request_register_device
//                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//                    if (data != nil)
//                    {
//                        NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData: data options: kNilOptions error: nil];
//                        notification_debug(@"json = %@", json);
//                    }
//                }] resume];
//}
//- (void)updateDevice
//{
//    signature = [[NSString alloc]initWithString: [self generateSign: BINDING_DEVICE]];
//    NSString *register_device_url = [NSString stringWithFormat: @"%@/v1/devices", PUSH_SITE];
//    NSURL *url = [NSURL URLWithString: register_device_url];
//    NSMutableURLRequest *request_register_device = [NSMutableURLRequest requestWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 30];
//    [request_register_device setHTTPMethod: @"PUT"];
//    [request_register_device setValue: API_KEY forHTTPHeaderField: @"X-Api-Key"];
//    [request_register_device setValue: signature forHTTPHeaderField: @"X-Signature"];
//    [request_register_device setValue: timeStamp forHTTPHeaderField: @"X-Timestamp"];
//    [request_register_device setValue: @"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField: @"Content-Type"];
//    NSString *deviceToken = [public get_device_token];
//    NSString *urlEncode = [public stringByAddingPercentEscapesForURLParameter: appInfo];
//    NSString *stringData = [NSString stringWithFormat: @"access_key_id=%@&udid=%@&push_token=%@&app_info=%@", AKID, deviceId, deviceToken, urlEncode];
//    NSData *postData = [stringData dataUsingEncoding: NSUTF8StringEncoding];
//    [request_register_device setHTTPBody: postData];
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//    [[session dataTaskWithRequest: request_register_device
//                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//                    if (data != nil)
//                    {
//                        NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData: data options: kNilOptions error: nil];
//                        notification_debug(@"json = %@", json);
//                    }
//                }] resume];
//}
//- (void)bindingDevice
//{
//    signature = [[NSString alloc]initWithString: [self generateSign: BINDING_DEVICE]];
//    NSString *register_device_url = [NSString stringWithFormat: @"%@/v1/devices/binding", PUSH_SITE];
//    NSURL *url = [NSURL URLWithString: register_device_url];
//    NSMutableURLRequest *request_register_device = [NSMutableURLRequest requestWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 30];
//    [request_register_device setHTTPMethod: @"POST"];
//    [request_register_device setValue: API_KEY forHTTPHeaderField: @"X-Api-Key"];
//    [request_register_device setValue: signature forHTTPHeaderField: @"X-Signature"];
//    [request_register_device setValue: timeStamp forHTTPHeaderField: @"X-Timestamp"];
//    [request_register_device setValue: @"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField: @"Content-Type"];
//    NSString *urlEncode = [public stringByAddingPercentEscapesForURLParameter: userId];
//    NSString *stringData = [NSString stringWithFormat: @"access_key_id=%@&udid=%@&user_id=%@", AKID, deviceId, urlEncode];
//    NSData *postData = [stringData dataUsingEncoding: NSUTF8StringEncoding];
//    notification_debug(@"post data = %@", stringData);
//    [request_register_device setHTTPBody: postData];
//
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//    [[session dataTaskWithRequest: request_register_device
//                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//                    if (data != nil)
//                    {
//                        NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData: data options: kNilOptions error: nil];
//                        notification_debug(@"json = %@", json);
//                    }
//                }] resume];
//}
//- (void)unBindingDevice
//{
//    signature = [[NSString alloc]initWithString: [self generateSign: BINDING_DEVICE]];
//    NSString *register_device_url = [NSString stringWithFormat: @"%@/v1/devices/binding", PUSH_SITE];
//    NSURL *url = [NSURL URLWithString: register_device_url];
//    NSMutableURLRequest *request_register_device = [NSMutableURLRequest requestWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 30];
//    [request_register_device setHTTPMethod: @"DELETE"];
//    [request_register_device setValue: API_KEY forHTTPHeaderField: @"X-Api-Key"];
//    [request_register_device setValue: signature forHTTPHeaderField: @"X-Signature"];
//    [request_register_device setValue: timeStamp forHTTPHeaderField: @"X-Timestamp"];
//    [request_register_device setValue: @"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField: @"Content-Type"];
//    NSString *stringData = [NSString stringWithFormat: @"access_key_id=%@&udid=%@&user_id=%@", AKID, deviceId, userId];
//    NSData *postData = [stringData dataUsingEncoding: NSUTF8StringEncoding];
//    [request_register_device setHTTPBody: postData];
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//    [[session dataTaskWithRequest: request_register_device
//                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//                    if (data != nil)
//                    {
//                        NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData: data options: kNilOptions error: nil];
//                        notification_debug(@"json = %@", json);
//                    }
//                }] resume];
//}
- (void)getMessageList
{
    [m_HUD setHidden: NO];
    [self checkReadLog];
    NSString *timeStamp = [public getTimeStamp];
    NSString *signature = [[NSString alloc]initWithString: [public generateSign: GET_MESSAGE_LIST andTimeStamp: timeStamp andInboxId: nil]];
    notification_debug(@"sig len = %d", [signature length]);
    NSString *sigFormat = [signature substringToIndex: 344];
    notification_debug(@"format = %@", sigFormat);
    NSString *register_device_url = [NSString stringWithFormat: @"%@/v1/inboxes/personal?access_key_id=%@&user_id=%@&from=%@&to=%@", PUSH_SITE, AKID, [public get_user_id], [public messageRange: @"from"], [public messageRange: @"to"]];
    notification_debug(@"url = %@", register_device_url);
    NSURL *url = [NSURL URLWithString: register_device_url];
    NSMutableURLRequest *request_register_device = [NSMutableURLRequest requestWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 30];
    [request_register_device setHTTPMethod: @"GET"];
    [request_register_device setValue: API_KEY forHTTPHeaderField: @"X-Api-Key"];
    [request_register_device setValue: sigFormat forHTTPHeaderField: @"X-Signature"];
    [request_register_device setValue: timeStamp forHTTPHeaderField: @"X-Timestamp"];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest: request_register_device
                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                    if (data != nil)
                    {
                        NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData: data options: kNilOptions error: nil];
//                        notification_debug(@"json = %@", json);
                        if ([[json objectForKey: @"code"] isEqualToString: @"0000"])
                        {
                            messageIdList = [[NSMutableArray alloc]init];
                            createAtList = [[NSMutableArray alloc]init];
                            messageBodyList = [[NSMutableArray alloc]init];
                            titleList = [[NSMutableArray alloc]init];
                            typeList = [[NSMutableArray alloc]init];
                            newlyList = [[NSMutableArray alloc]init];
                            NSArray *messageList = [json objectForKey: @"data"];
                            if([messageList count] > 0)
                            {
                                for (NSDictionary *message in messageList)
                                {
                                    notification_debug(@"inbox_id = %@", [message objectForKey: @"inbox_id"]);
                                    notification_debug(@"title = %@", [message objectForKey: @"title"]);
                                    notification_debug(@"body = %@", [message objectForKey: @"body"]);
                                    notification_debug(@"create time = %@", [message objectForKey: @"created_at"]);
                                    notification_debug(@"type = %@", [message objectForKey: @"type"]);
                                    NSString *inboxId = [NSString stringWithFormat: @"%@", [message objectForKey: @"inbox_id"]];
                                    [messageIdList addObject: inboxId];
                                    BOOL compareRes = NO;
                                    for (NSString *log in readLogList)
                                    {
                                        if ([log isEqualToString: inboxId])
                                        {
                                            compareRes = YES;
                                            break;
                                        }
                                    }
                                    if (compareRes == YES)
                                    {
                                        [newlyList addObject: @"YES"];
                                    }
                                    else
                                    {
                                        [newlyList addObject: @"NO"];
                                    }
                                    [titleList addObject: [NSString stringWithFormat: @"%@", [message objectForKey: @"title"]]];
                                    NSString *bodyStr = [NSString stringWithFormat: @"%@", [message objectForKey: @"body"]];
                                    // remove trim and new line 2
                                    //NSCharacterSet *dontWantChar = [NSCharacterSet whitespaceAndNewlineCharacterSet];
                                    //[messageBodyList addObject: [[bodyStr componentsSeparatedByCharactersInSet:dontWantChar]componentsJoinedByString:@""]];
                                    [messageBodyList addObject: bodyStr];
                                    NSString *createDate = [NSString stringWithFormat: @"%@", [message objectForKey: @"created_at"]];
                                    NSArray *date = [createDate componentsSeparatedByString: @"T"];
                                    NSArray *time = [[date objectAtIndex: 1]componentsSeparatedByString: @"."];
                                    [createAtList addObject: [NSString stringWithFormat: @"%@ %@", [date objectAtIndex: 0], [time objectAtIndex: 0]]];
                                    [typeList addObject: [NSString stringWithFormat: @"%@", [message objectForKey: @"type"]]];
                                }
                                dispatch_async(dispatch_get_main_queue(), ^() {
                                    messageDetailStatus = NO;
                                    messageStatus = YES;
                                    [self.messageList reloadData];
                                    [self.contentView setHidden: YES];
                                    [self.listView setHidden: NO];
                                    [self.errorView setHidden: YES];
                                    [self.noNotificationView setHidden: YES];
                                    [self.tabBarController.tabBar setHidden: NO];
                                });
                            }
                            else
                            {
                                [self.noNotificationView setHidden: NO];
                            }
                            dispatch_async(dispatch_get_main_queue(), ^() {
                                [m_HUD setHidden: YES];
                            });
                        }
                        else
                        {
                            // response error
                            dispatch_async(dispatch_get_main_queue(), ^() {
                                [m_HUD setHidden: YES];
                            });
                        }
                    }
                    else
                    {
                        // no reponse data
                        notification_debug(@"No response data");
                        [self.tabBarController.tabBar setHidden: YES];
                        [self.errorView setHidden: NO];
                        [m_HUD setHidden: YES];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^() {
                        [self.tabBarController.tabBar setUserInteractionEnabled: YES];
                    });
                }] resume];
}
- (void)getmessageDetail:(NSString *)inboxId
{
    [m_HUD setHidden: NO];
    [self writeReadLog: inboxId];
    NSString *timeStamp = [public getTimeStamp];
    NSString *signature = [[NSString alloc]initWithString: [public generateSign: GET_MESSAGE_DETAIL andTimeStamp: timeStamp andInboxId: inboxId]];
    NSString *sigFormat = [signature substringToIndex: 344];
    notification_debug(@"sign = %@", signature);
    //NSString *inboxId = [messageIdList objectAtIndex: selectMessageId];
    NSString *register_device_url = [NSString stringWithFormat: @"%@/v1/inboxes/personal/%@?access_key_id=%@&user_id=%@", PUSH_SITE, inboxId, AKID, [public get_user_id]];
    NSURL *url = [NSURL URLWithString: register_device_url];
    NSMutableURLRequest *request_register_device = [NSMutableURLRequest requestWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 30];
    [request_register_device setHTTPMethod: @"GET"];
    [request_register_device setValue: API_KEY forHTTPHeaderField: @"X-Api-Key"];
    [request_register_device setValue: sigFormat forHTTPHeaderField: @"X-Signature"];
    [request_register_device setValue: timeStamp forHTTPHeaderField: @"X-Timestamp"];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest: request_register_device
                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                    if (data != nil)
                    {
                        NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData: data options: kNilOptions error: nil];
//                        notification_debug(@"json = %@", json);
                        if ([[json objectForKey: @"code"] isEqualToString: @"0000"])
                        {
                            NSMutableDictionary *detail = [json objectForKey: @"data"];
//                            notification_debug(@"body = %@", [detail objectForKey: @"body"]);
//                            notification_debug(@"title = %@", [detail objectForKey: @"title"]);
//                            notification_debug(@"type = %@", [detail objectForKey: @"type"]);
                            NSString *body = [NSString stringWithFormat: @"%@", [detail objectForKey: @"body"]];
                            body = [body stringByReplacingOccurrencesOfString: @"\n" withString: @"<br />"];
                            NSString *title = [NSString stringWithFormat: @"%@", [detail objectForKey: @"title"]];

                            NSString *strFormat = [NSString stringWithFormat: @"<html><head><title>%@</title></head><body><div style=\"float:left;padding-left:20px;padding-right:20px;\"><div style=\"font-family:CenturyGothic;font-size:16px; line-height:30px;\">%@</div></div></body></html>", title, body];
                            dispatch_async(dispatch_get_main_queue(), ^() {
                                [self.messageTitle setText: [titleList objectAtIndex: selectMessageId]];
                                [self.messageTime setText: [createAtList objectAtIndex: selectMessageId]];
                                [self.messageContent loadHTMLString: strFormat baseURL: nil];
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    [self.listView setHidden: YES];
                                    [self.tabBarController.tabBar setHidden: YES];
                                    [self.contentView setHidden: NO];
                                    [self.errorView setHidden: YES];
                                    [m_HUD setHidden: YES];
                                });
                            });
                        }
                        else
                        {
                            // response error
                            dispatch_async(dispatch_get_main_queue(), ^() {
                                [m_HUD setHidden: YES];
                            });
                        }
                    }
                    else
                    {
                        // no response data
                        notification_debug(@"No response data");
                        [self.tabBarController.tabBar setHidden: YES];
                        [self.errorView setHidden: NO];
                        [m_HUD setHidden: YES];
                    }
                }] resume];
}
#pragma mark - FUNCTION EVENTS
- (void)initEnv
{
    if ([public checkNetWorkConn])
    {
        [self getMessageList];
    }
    else
    {
        [self.listView setHidden: YES];
        [self.tabBarController.tabBar setHidden: YES];
        [self.errorView setHidden: NO];
        [m_HUD setHidden: YES];
    }
}
- (void)checkReadLog
{
    readLogList = [[NSMutableArray alloc]init];
    NSString* documentPath= [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString* readPath = [documentPath stringByAppendingPathComponent:@"readLog"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath: readPath])
    {
        readLogList = [[NSMutableArray alloc]initWithContentsOfFile: readPath];
        notification_debug(@"readLog = %@", readLogList);
    }
}
- (void)writeReadLog:(NSString *)inboxId
{
    NSString* documentPath= [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString* writePath = [documentPath stringByAppendingPathComponent:@"readLog"];
    BOOL compareRes = NO;
    for (NSString *log in readLogList)
    {
        if ([inboxId isEqualToString: log])
        {
            compareRes = YES;
            break;
        }
    }
    if (compareRes == NO)
    {
        [readLogList addObject: inboxId];
        [readLogList writeToFile: writePath atomically: YES];
    }
}
- (void)selfLayout
{
    switch (public.getDeviceType)
    {
        case 1:
            [self.tryAgainBtn setFrame: CGRectMake(124, 360, 73, 30)];
            [self.errorLbl setFrame: CGRectMake(60, 54, 200, 21)];
            break;
        case 2:
            [self.tryAgainBtn setFrame: CGRectMake(144, 424, 87, 33)];
            [self.errorLbl setFrame: CGRectMake(87, 66, 200, 21)];
            break;
        case 3:
            [self.tryAgainBtn setFrame: CGRectMake(160, 468, 93, 35)];
            [self.errorLbl setFrame: CGRectMake(107, 74, 200, 21)];
            break;
        default:
            // other size
            break;
    }
}
//- (void)getAppInfo
//{
//    deviceName = [NSString stringWithFormat: @"%@", [[UIDevice currentDevice]model]];
//    osVersion = [NSString stringWithFormat: @"%@", [[UIDevice currentDevice]systemVersion]];
//    deviceModel = [public deviceModelName];
//    language = [[NSLocale preferredLanguages] objectAtIndex:0];
//    NSTimeZone* timeZone = [NSTimeZone localTimeZone];
//    NSInteger offset = (([timeZone secondsFromGMT]/60)/60);
//    timeZoneStr = [NSString stringWithFormat: @"+%ld00", (long)offset];
//    appVersion = [[[NSBundle mainBundle]infoDictionary]objectForKey: @"CFBundleShortVersionString"];
//    appBuildNum = [[[NSBundle mainBundle]infoDictionary]objectForKey: @"CFBundleVersion"];
//    uuid = [UIDevice currentDevice].identifierForVendor;
//    deviceId = [NSString stringWithFormat: @"%@", uuid];
//    userId = [public get_user_id];
//    body = [[NSMutableDictionary alloc]init];
//    [body setValue: deviceName forKey: @"device_name"];
//    [body setValue: appVersion forKey: @"app_version"];
//    [body setValue: appBuildNum forKey: @"app_build"];
//    [body setValue: timeZoneStr forKey: @"timezone"];
//    [body setValue: language forKey: @"language"];
//    [body setValue: osVersion forKey: @"os_version"];
//    [body setValue: deviceModel forKey: @"device_model"];
//    if ([NSJSONSerialization isValidJSONObject: body])
//    {
//        NSData *jsonData = [NSJSONSerialization dataWithJSONObject: body options: NSJSONWritingPrettyPrinted error: nil];
//        appInfo = [[[NSString alloc]initWithData: jsonData encoding: NSUTF8StringEncoding]stringByReplacingOccurrencesOfString: @"\n" withString: @""];
//    }
//
//    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
//    NSTimeInterval time=[date timeIntervalSince1970];
//    timeStamp = [NSString stringWithFormat:@"%.0f", time];
//}

//- (NSString *)generateSign:(NSInteger)option
//{
//    NSMutableDictionary *parameter =[[NSMutableDictionary alloc]init];
//    if (option == REGISTER_DEVICE || option == UPDATE_DEVICE)
//    {
//        [parameter setValue: timeStamp forKey: @"X-Timestamp"];
//        [parameter setValue: AKID forKey: @"access_key_id"];
//        [parameter setValue: deviceId forKey: @"udid"];
//        [parameter setValue: [public get_device_token] forKey: @"push_token"];
//        [parameter setValue: appInfo forKey: @"app_info"];
//    }
//    else if (option == BINDING_DEVICE || option == UNBINDING_DEVICE)
//    {
//        [parameter setValue: timeStamp forKey: @"X-Timestamp"];
//        [parameter setValue: AKID forKey: @"access_key_id"];
//        [parameter setValue: deviceId forKey: @"udid"];
//        [parameter setValue: userId forKey: @"user_id"];
//    }
//    else if (option == GET_MESSAGE_LIST)
//    {
//        [parameter setValue: timeStamp forKey: @"X-Timestamp"];
//        [parameter setValue: AKID forKey: @"access_key_id"];
//        [parameter setValue: userId forKey: @"user_id"];
//        [parameter setValue: @"201708" forKey: @"from"];
//        [parameter setValue: [self messageRange] forKey: @"to"];
//    }
//    else if (option == GET_MESSAGE_DETAIL)
//    {
//        [parameter setValue: timeStamp forKey: @"X-Timestamp"];
//        [parameter setValue: AKID forKey: @"access_key_id"];
//        [parameter setValue: userId forKey: @"user_id"];
//        [parameter setValue: [messageIdList objectAtIndex: selectMessageId] forKey: @"inbox_id"];
//    }
//    NSArray *keyArr = [parameter allKeys];
//    NSArray *keySort = [keyArr sortedArrayUsingSelector: @selector(compare:)];
//    NSString *strFormat = [[NSString alloc]init];
//    for (int i=0; i<[keySort count]; i++)
//    {
//        strFormat = [strFormat stringByAppendingString: [parameter objectForKey: [keySort objectAtIndex: i]]];
//    }
//    notification_debug(@"sign data = %@", strFormat);
//    return [NSString stringWithFormat: @"%@", [[public signMessage: PRIVATE_KEY and: strFormat]stringByReplacingOccurrencesOfString:@"\n" withString: @""]];
//}
//- (NSString *)messageRange
//{
//    NSDate *currentDateandTime = [NSDate date];
//    NSDateFormatter *date_formater=[[NSDateFormatter alloc]init];
//    [date_formater setDateFormat:@"YYYYMM"];
//    NSString *dateStr = [date_formater stringFromDate:currentDateandTime];
//    return dateStr;
//}
#pragma mark - BUTTON EVENTS
- (IBAction)messageDetailBackBtn:(id)sender
{
    action = ENTER_NOTIFICATION;
    if ([public checkNetWorkConn])
    {
        [self getMessageList];
    }
    else
    {
        [self.errorView setHidden: NO];
    }
}
- (IBAction)tryAgainBtn:(id)sender
{
    if ([public checkNetWorkConn])
    {
        if (action == ENTER_NOTIFICATION)
        {
            [self getMessageList];
        }
        else if (action == NOTIFICATION_GET_MESSAGE_DETAIL)
        {
            [self getmessageDetail: [messageIdList objectAtIndex: selectMessageId]];
        }
    }
    else
    {
        notification_debug(@"No Internet.");
    }
}
#pragma mark - TABLEVIEW CALL BACK
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 0;
    if (messageStatus == YES)
    {
        count = [titleList count];
    }
    return count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (messageStatus == YES)
    {
        static NSString *CellIdentifier = @"messageListCell";
        MessageListCell *messageCell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
        if (messageCell == nil)
        {
            messageCell = [[MessageListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
        }
        if ([[newlyList objectAtIndex: indexPath.row] isEqualToString: @"YES"])
        {
            [messageCell.newly setHidden: YES];
        }
        else
        {
            [messageCell.newly setHidden: NO];
        }
        [messageCell.title setText: [titleList objectAtIndex: indexPath.row]];
        [messageCell.content setText:[messageBodyList objectAtIndex: indexPath.row]];
        [messageCell.time setText: [createAtList objectAtIndex: indexPath.row]];
        cell = messageCell;
    }
    return cell;
}
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (messageStatus == YES)
    {
        messageStatus = NO;
        messageDetailStatus = YES;
        action = NOTIFICATION_GET_MESSAGE_DETAIL;
        selectMessageId = indexPath.row;
        if ([public checkNetWorkConn])
        {
            [self getmessageDetail: [messageIdList objectAtIndex: indexPath.row]];
        }
        else
        {
            [self.errorView setHidden: NO];
        }
    }
    return indexPath;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
@end
