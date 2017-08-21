//
//  FirstViewController.m
//  MyZyxel
//
//  Created by line on 2017/5/12.
//  Copyright © 2017年 Zyxel. All rights reserved.
//

#import "home.h"

@interface home ()<UITableViewDelegate, UITableViewDataSource>
{
    MBProgressHUD *m_HUD;
    BOOL scanStatus;
    BOOL _scanStatus;
    BOOL searchDevicesListStatus;
    BOOL searchKeyWordStatus;
    BOOL scrollViewStatus;
    BOOL renewStatus;
    BOOL completeStatus;
    AVCaptureSession *_session;
    NSInteger startPage;
    NSInteger expiredCount;
    NSInteger deviceType;
    NSMutableArray *homeDeviceNameList;
    NSMutableArray *homeDeviceMacList;
    NSMutableArray *homeDeviceIdList;
    NSMutableArray *homeDeviceServiceList;
    NSMutableArray *deviceServicesList;
    NSMutableArray *serviceCodeList;
    NSMutableArray *serviceRemainAmountList;
    NSMutableArray *searchDeviceNameList;
    NSMutableArray *searchDeviceMacList;
    NSMutableArray *renewServiceNameList;
    NSMutableArray *renewServiceAmountList;
    NSMutableArray *renewServiceTotalList;
    NSMutableArray *renewServiceLinkList;
    NSMutableArray *renewServiceIdList;
    NSMutableArray *activateLicenseNameList;
    NSMutableArray *activateLicenseExpiredDateList;
    NSMutableArray *renewErrServiceIdList;
    NSMutableArray *renewErrMessageList;
    NSMutableArray *servicePageList;
    NSMutableArray *showNameList;
    NSMutableArray *showDateList;
    NSMutableArray *mutiShowNameList;
    NSMutableArray *mutiShowDateList;
    NSString *keyWord;
    NSString *boundleLicense;
}
@end
@implementation home
#pragma mark - SYSTEM FUNCTION
- (void)dealloc
{
    m_HUD = nil;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tabBarController.tabBar setUnselectedItemTintColor: [UIColor whiteColor]];
    [self getDeviceType];
    [self.scanViewEnterLicenseTxt.layer setCornerRadius: self.scanViewEnterLicenseTxt.frame.size.height/2];
    [self.scanViewEnterLicenseTxt addTarget: self action: @selector(manualEnterLicense) forControlEvents: UIControlEventEditingDidEndOnExit];
    servicePageList = [[NSMutableArray alloc]init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    [self.profileView setHidden: YES];
    [self.searchView setHidden: YES];
    [self.renewView setHidden: YES];
    [self.maskView setHidden: YES];
    [self.completeView setHidden: YES];
    [self.homeView setHidden: YES];
    [self.scanView setHidden: YES];
    [self.mutiView setHidden: YES];
    [self.noWorkView setHidden: YES];
    [self.errorView setHidden: YES];
    if (m_HUD == nil)
    {
        m_HUD = [[MBProgressHUD alloc]initWithView: self.view];
        [m_HUD setContentColor: [UIColor whiteColor]];
        [m_HUD.bezelView setBackgroundColor: [UIColor blackColor]];
        [m_HUD showAnimated: YES];
        [m_HUD setMinShowTime: 5];
    }
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
    [self.view addSubview: m_HUD];
    [self initEnv];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    //debug(@"8888888 = %@", self.tabBarController.tabBar.selectedItem.title);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - INIT SETTINGS
- (void)initEnv
{
    scrollViewStatus = NO;
    [self.userAccountLbl setText: [public get_user_account]];
    [self.scanView setFrame: CGRectMake(375, 0, 375, 667)];
    [self.displayView setDecelerationRate: UIScrollViewDecelerationRateFast];
    [self setRegisteredLicenseFrame];
    [self getDevicesInfo];
}
#pragma mark - BUTTON EVENTS
- (IBAction)profileBtn:(id)sender
{
    [self.profileView setHidden: NO];
    switch (deviceType)
    {
        case 1:
        {
            [self.profileView setFrame: CGRectMake(-255, 0, 255, 519)];
            [UIView animateWithDuration: 0.5 animations:^{
                [self.profileView setFrame: CGRectMake(0, 0, 255, 519)];
                [self.maskView setHidden: NO];
            }];
            break;
        }
        case 2:
        {
            [self.profileView setFrame: CGRectMake(-310, 0, 310, 618)];
            [UIView animateWithDuration: 0.5 animations:^{
                [self.profileView setFrame: CGRectMake(0, 0, 310, 618)];
                [self.maskView setHidden: NO];
            }];
            break;
        }
        case 3:
        {
            [self.profileView setFrame: CGRectMake(-349, 0, 349, 687)];
            [UIView animateWithDuration: 0.5 animations:^{
                [self.profileView setFrame: CGRectMake(0, 0, 349, 687)];
                [self.maskView setHidden: NO];
            }];
        }
            break;
    }
    self.maskViewTapGesture = [[UITapGestureRecognizer alloc]initWithTarget: self action: @selector(maskViewGesture)];
    [self.maskView addGestureRecognizer: self.maskViewTapGesture];
    self.profileViewLeftSwipeGesture = [[UISwipeGestureRecognizer alloc]initWithTarget: self action: @selector(maskViewGesture)];
    [self.profileViewLeftSwipeGesture setDirection: UISwipeGestureRecognizerDirectionLeft];
    [self.profileView addGestureRecognizer: self.profileViewLeftSwipeGesture];
}
- (IBAction)searchBtn:(id)sender
{
    searchDevicesListStatus = YES;
    //deviceListStatus = NO;
    [self.searchDeviceExpiredList reloadData];
    dispatch_async(dispatch_get_main_queue(), ^() {
        [self.searchView setHidden: NO];
        [self.homeView setHidden: YES];
        [self.searchDevicesText addTarget:self action:@selector(searchDeviceInfo) forControlEvents: UIControlEventEditingDidEndOnExit];
    });
}
- (IBAction)searchCancelBtn:(id)sender
{
    searchDevicesListStatus = NO;
    //deviceListStatus = YES;
    [self.searchView setHidden: YES];
    [self.homeView setHidden: NO];
}
- (void)renewBtn:(UIButton *)sender
{
    if (DEBUG) debug(@"device id = %d", sender.tag);
    renewErrServiceIdList = [[NSMutableArray alloc]init];
    renewErrMessageList = [[NSMutableArray alloc]init];
    activateLicenseNameList = [[NSMutableArray alloc]init];
    activateLicenseExpiredDateList = [[NSMutableArray alloc]init];
    showNameList = [[NSMutableArray alloc]init];
    showDateList = [[NSMutableArray alloc]init];
    renewStatus = YES;
    scanStatus = YES;
    [self.renewDoneBtn setHidden: YES];
    [self.renewCancelBtn setHidden: NO];
    [self.scanDoneBtn setHidden: YES];
    [self.scanCancelBtn setHidden: NO];
    [self.activageServiceName setHidden: YES];
    [self.activateExpireDate setHidden: YES];
    [self.scanViewMessage setHidden: YES];
    [self.renewServiceName setText: [homeDeviceNameList objectAtIndex: sender.tag]];
    NSInteger deviceId = [[homeDeviceIdList objectAtIndex: sender.tag]integerValue];
    [self.renewServiceName setTag: deviceId];
    [self.renewServiceMacAddress setText: [homeDeviceMacList objectAtIndex: sender.tag]];
    [self.scanDeviceName setText: [homeDeviceNameList objectAtIndex: sender.tag]];
    [self.scanMacAddress setText: [homeDeviceMacList objectAtIndex: sender.tag]];
    [self.mutiServiceName setText: [homeDeviceNameList objectAtIndex: sender.tag]];
    [self.mutiServiceMac setText: [homeDeviceMacList objectAtIndex: sender.tag]];
    [self.completeDeviceName setText: [homeDeviceNameList objectAtIndex: sender.tag]];
    [self.completeMacAddress setText: [homeDeviceMacList objectAtIndex: sender.tag]];
    [self getLicenseServiceInfo: [homeDeviceIdList objectAtIndex: sender.tag] and: serviceCodeList];
}
- (IBAction)renewCancelBtn:(id)sender
{
    renewStatus = NO;
    [self getDevicesInfo];
}
- (IBAction)scanCancelBtn:(id)sender
{
    [_session stopRunning];
    renewStatus = NO;
    [self getDevicesInfo];
}
- (IBAction)renewScanCodeBtn:(id)sender
{
    _scanStatus = YES;
    [self.scanViewMessage setHidden: YES];
    [self.renewView setHidden: YES];
    [self.scanView setHidden: NO];
    [self scanCode];

}
- (IBAction)renewUseRegisteredLicenseBtn:(id)sender
{
    [self.scanView setHidden: YES];
    [self.renewView setHidden: NO];
    [_session stopRunning];
}
- (IBAction)logout:(id)sender
{
    dispatch_async(dispatch_get_main_queue(), ^() {
        [self cleanCacheAndCookie];
    });
}
- (void)renewActivateBtn:(UIButton *)sender
{
    if (DEBUG) debug(@"device id = %@, service list = %@", [NSString stringWithFormat: @"%d", self.renewServiceName.tag], [renewServiceIdList objectAtIndex: sender.tag]);
    [self activateLicenseInfo: [NSString stringWithFormat: @"%d", self.renewServiceName.tag] andServiceId: [renewServiceIdList objectAtIndex: sender.tag]];
}
- (IBAction)completeViewOKBtn:(id)sender
{
    completeStatus = NO;
    [self getDevicesInfo];
}

- (IBAction)renewDoneBtn:(id)sender
{
    renewStatus = NO;
    completeStatus = YES;
    [self.completeLicenseList reloadData];
    dispatch_async(dispatch_get_main_queue(), ^() {
        [self.renewView setHidden: YES];
        [self.completeView setHidden: NO];
    });
}

- (IBAction)scanDoneBtn:(id)sender
{
    renewStatus = NO;
    completeStatus = YES;
    [self.completeLicenseList reloadData];
    dispatch_async(dispatch_get_main_queue(), ^() {
        [self.scanView setHidden: YES];
        [self.completeView setHidden: NO];
    });
}

- (IBAction)mutiViewActivateBtn:(id)sender
{
    [self activateMutiLicense: [NSString stringWithFormat: @"%d", self.renewServiceName.tag] andLicenseKey: boundleLicense];
}
- (IBAction)mutiViewCancelBtn:(id)sender
{
    [self.mutiView setHidden: YES];
    [self.scanView setHidden: NO];
    [_session startRunning];
    _scanStatus = YES;
}

- (IBAction)tryAgainBtn:(id)sender
{
}
#pragma mark - GET SERVER INFO
- (void)getDevicesInfo
{
    [m_HUD setHidden: NO];
    [m_HUD.label setText: @"Load device data ..."];
    NSError *error;
    NSDictionary *payload = @{
                              @"status": @"service_expire",
                              @"from": @0,
                              @"to": @2
                            };
    NSString *token = [Jwt encodeWithPayload: payload andKey: [public get_secret_access_key] andError:&error];
    if(token == nil)
    {
        // Print error
        if (DEBUG) debug(@"Code: %li", (long)[error code]);
        if (DEBUG) debug(@"Reason: %@", [error localizedFailureReason]);
    }
    else
    {
        if (DEBUG) debug(@"jwt token = %@", token);
    }

    NSString *get_devices_info_url = [NSString stringWithFormat: @"%@/api/v2/my/devices?token=%@&access_key_id=%@", DATA_URL, token, [public get_access_key_id]];
    if (DEBUG) debug(@"get_devices_info_url = %@", get_devices_info_url);
    NSURL *url = [NSURL URLWithString: get_devices_info_url];
    NSMutableURLRequest *request_user_info = [NSMutableURLRequest requestWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [request_user_info setHTTPMethod: @"GET"];
    [request_user_info setValue: [public get_access_token] forHTTPHeaderField: @"Authorization"];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest: request_user_info
                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
      {
          NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData: data options: kNilOptions error: nil];
          if (DEBUG) debug(@"devicesInfo = %@", json);
          
          NSMutableDictionary *status = [json objectForKey: @"return_status"];
          NSString *code = [NSString stringWithFormat: @"%@", [status objectForKey: @"code"]];
          NSString *message = [NSString stringWithFormat: @"%@", [status objectForKey: @"message"]];
          if ([code isEqualToString: @"0"])
          {
              NSString *encryptionCode = [json objectForKey: @"data"];
              NSString *iv = [encryptionCode substringWithRange: NSMakeRange(0, 16)];
              NSString *encrypted_data = [encryptionCode substringFromIndex: 16];
              NSString *sha256_decode_data = [public sha256: [public get_secret_access_key]];
              NSData *decode_key = [public hexToBytes: sha256_decode_data];
              NSData *base64_decode_data = [[NSData alloc]initWithData: (NSData *)[public base64_decode: encrypted_data]];
              NSData *aes_decode_data = [[NSData alloc]initWithData: [public aes_cbc_256: base64_decode_data andIv: iv andkey: decode_key andType: kCCDecrypt]];
              NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingUTF8);
              NSString *devicesInfo = [[NSString alloc]initWithData: aes_decode_data encoding: enc];
              if (DEBUG) debug(@"devices info = %@", devicesInfo);
              NSMutableDictionary *devices_info_json = [NSJSONSerialization JSONObjectWithData: aes_decode_data options:kNilOptions error: nil];
              NSInteger getExpiredCount = [[devices_info_json objectForKey: @"total"]integerValue];
              expiredCount = getExpiredCount;
              if (DEBUG) debug(@"devices = %@", [devices_info_json objectForKey: @"devices"]);
              if (getExpiredCount > 0)
              {
                  homeDeviceNameList = [[NSMutableArray alloc]init];
                  homeDeviceMacList = [[NSMutableArray alloc]init];
                  homeDeviceIdList = [[NSMutableArray alloc]init];
                  homeDeviceServiceList = [[NSMutableArray alloc]init];
                  
                  NSArray *deviceListArr = [devices_info_json objectForKey: @"devices"];
                  for (NSDictionary *device in deviceListArr)
                  {
                      NSString *name = [NSString stringWithFormat: @"%@", [device objectForKey: @"name"]];
                      [homeDeviceNameList addObject: name];
                      NSString *mac_address = [NSString stringWithFormat: @"%@", [device objectForKey: @"mac_address"]];
                      [homeDeviceMacList addObject: mac_address];
                      NSString *did = [NSString stringWithFormat: @"%@", [device objectForKey: @"id"]];
                      [homeDeviceIdList addObject: did];
                      [homeDeviceServiceList addObject: [device objectForKey: @"services"]];
                  }
                  
                  dispatch_async(dispatch_get_main_queue(), ^() {
                      for (int i=0; i<expiredCount; i++) {
                          UIView *view = [[UIView alloc]viewWithTag: i];
                          [view removeFromSuperview];
                      }
                      [self.pageControl setNumberOfPages: expiredCount];
                      // set scrollview width and height
                      CGFloat width, height;
                      width = self.displayView.frame.size.width;
                      height = self.displayView.frame.size.height;
                      [self.displayView setContentSize:CGSizeMake(width*self.pageControl.numberOfPages, height)];
                      [self.pageControl setCurrentPage:0];
                      // set scrollview content
                      [self displayInit];
                      [self.noWorkView setHidden: YES];
                      [self.renewView setHidden: YES];
                      [self.scanView setHidden: YES];
                      [self.completeView setHidden: YES];
                      [m_HUD setHidden: YES];
                      [self.displayView setHidden: NO];
                      [self.tabBarController.tabBar setHidden: NO];
                      [self.homeView setHidden: NO];
                  });
              }
              else
              {
                  dispatch_async(dispatch_get_main_queue(), ^() {
                      // show no device view
                      [self.displayView setHidden: YES];
                      [self.renewView setHidden: YES];
                      [self.scanView setHidden: YES];
                      [self.completeView setHidden: YES];
                      [m_HUD setHidden: YES];
                      [self.noWorkView setHidden: NO];
                      [self.tabBarController.tabBar setHidden: NO];
                      [self.homeView setHidden: NO];
                  });
              }
          }
      }] resume];
}
- (void)getLicenseServiceInfo:(NSString *)deviceId and:(NSMutableArray *)parsed_module_code
{
    [m_HUD setHidden: NO];
    [m_HUD.label setText: @"Load service data ..."];
    NSString *codeFormat = [[NSString alloc]init];
    for(int i=0;i<[parsed_module_code count];i++)
    {
        if (i == ([parsed_module_code count]-1))
        {
            codeFormat = [codeFormat stringByAppendingFormat: @"\"%@\"", [parsed_module_code objectAtIndex: i]];
        }
        else
        {
            codeFormat = [codeFormat stringByAppendingFormat: @"\"%@\",", [parsed_module_code objectAtIndex: i]];
        }
    }
    NSError *error;
    NSString *payloadFormat = [NSString stringWithFormat: @"{"
                               "\"device_id\": \"%@\","
                               "\"status\": \"wait_for_renew\","
                               "\"renew_list\": ["
                                                 "%@"
                                                "]"
                               "}", deviceId, codeFormat];
    NSData *payloadJson = [payloadFormat dataUsingEncoding: NSUTF8StringEncoding];
    NSDictionary *payload = [NSJSONSerialization JSONObjectWithData: payloadJson options: kNilOptions error: &error];
    NSString *token = [Jwt encodeWithPayload: payload andKey: [public get_secret_access_key] andError:&error];
    if(token == nil)
    {
        // Print error
        if (DEBUG) debug(@"Code: %li", (long)[error code]);
        if (DEBUG) debug(@"Reason: %@", [error localizedFailureReason]);
    }
    else
    {
        if (DEBUG) debug(@"jwt token = %@", token);
    }
    
    NSString *get_license_service_info_url = [NSString stringWithFormat: @"%@/api/v2/my/device/license_services?token=%@&access_key_id=%@", DATA_URL, token, [public get_access_key_id]];
    if (DEBUG) debug(@"get_license_service_info_url = %@", get_license_service_info_url);
    NSURL *url = [NSURL URLWithString: get_license_service_info_url];
    NSMutableURLRequest *request_user_info = [NSMutableURLRequest requestWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [request_user_info setHTTPMethod: @"GET"];
    [request_user_info setValue: [public get_access_token] forHTTPHeaderField: @"Authorization"];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest: request_user_info
                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
      {
          NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData: data options: kNilOptions error: nil];
          if (DEBUG) debug(@"license service info = %@", json);
          NSMutableDictionary *status = [json objectForKey: @"return_status"];
          NSString *code = [NSString stringWithFormat: @"%@", [status objectForKey: @"code"]];
          NSString *message = [NSString stringWithFormat: @"%@", [status objectForKey: @"message"]];
          if ([code isEqualToString: @"0"])
          {
              NSString *encryptionCode = [json objectForKey: @"data"];
              NSString *iv = [encryptionCode substringWithRange: NSMakeRange(0, 16)];
              NSString *encrypted_data = [encryptionCode substringFromIndex: 16];
              NSString *sha256_decode_data = [public sha256: [public get_secret_access_key]];
              NSData *decode_key = [public hexToBytes: sha256_decode_data];
              
              NSData *base64_decode_data = [[NSData alloc]initWithData: (NSData *)[public base64_decode: encrypted_data]];
              NSData *aes_decode_data = [[NSData alloc]initWithData: [public aes_cbc_256: base64_decode_data andIv: iv andkey: decode_key andType: kCCDecrypt]];
              
              NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingUTF8);
              NSString *licenseServiceInfo = [[NSString alloc]initWithData: aes_decode_data encoding: enc];
              if (DEBUG) debug(@"license service info = %@", licenseServiceInfo);
              renewServiceNameList = [[NSMutableArray alloc]init];
              renewServiceTotalList = [[NSMutableArray alloc]init];
              renewServiceAmountList = [[NSMutableArray alloc]init];
              renewServiceLinkList = [[NSMutableArray alloc]init];
              renewServiceIdList = [[NSMutableArray alloc]init];
              NSMutableDictionary *license_info_json = [NSJSONSerialization JSONObjectWithData: aes_decode_data options:kNilOptions error: nil];
              NSInteger total = [[license_info_json objectForKey: @"total"]integerValue];
              if (total > 0)
              {
                  NSArray *licenseListArr = [license_info_json objectForKey: @"services"];

                  for (NSDictionary *license in licenseListArr)
                  {
                      NSString *name = [NSString stringWithFormat: @"%@", [license objectForKey: @"name"]];
                      [renewServiceNameList addObject: name];
                      NSString *total = [NSString stringWithFormat: @"%@", [license objectForKey: @"total"]];
                      [renewServiceTotalList addObject: total];
                      NSString *amount = [NSString stringWithFormat: @"%@", [license objectForKey: @"amount"]];
                      [renewServiceAmountList addObject: amount];
                      NSString *link = [NSString stringWithFormat: @"%@", [license objectForKey: @"linked_on"]];
                      [renewServiceLinkList addObject: link];
                      NSString *serviceId = [NSString stringWithFormat: @"%@", [license objectForKey: @"license_service_id"]];
                      [renewServiceIdList addObject: serviceId];
                  }
                  
                  dispatch_async(dispatch_get_main_queue(), ^() {
                      [self.renewRegisteredLicenseList reloadData];
                      dispatch_async(dispatch_get_main_queue(), ^() {
                          [self.homeView setHidden: YES];
                          [self.tabBarController.tabBar setHidden: YES];
                          [self.renewView setHidden: NO];
                          [m_HUD setHidden: YES];
                      });
                  });
              }
              else
              {
                  if (scanStatus == YES)
                  {
                      // enter scan mode
                      dispatch_async(dispatch_get_main_queue(), ^() {
                          _scanStatus = YES;
                          [self.homeView setHidden: YES];
                          [self.tabBarController.tabBar setHidden: YES];
                          [self.scanView setHidden: NO];
                          [self scanCode];
                          [m_HUD setHidden: YES];
                      });
                  }
              }
              scanStatus = NO;
          }
      }] resume];
}
- (void)activateLicenseInfo:(NSString *)deviceId andServiceId:(NSString *)serviceId
{
    [m_HUD setHidden: NO];
    [m_HUD.label setText: @"Activate license ..."];
    NSError *error;
    NSString *payloadFormat = [NSString stringWithFormat: @"{"
                               "\"device_id\": \"%@\","
                               "\"license_service_id\": \"%@\","
                               "}", deviceId, serviceId];
    NSData *payloadJson = [payloadFormat dataUsingEncoding: NSUTF8StringEncoding];
    NSDictionary *payload = [NSJSONSerialization JSONObjectWithData: payloadJson options: kNilOptions error: &error];
    debug(@"payload = %@", payload);
    NSString *token = [Jwt encodeWithPayload: payload andKey: [public get_secret_access_key] andError:&error];
    if(token == nil)
    {
        // Print error
        if (DEBUG) debug(@"Code: %li", (long)[error code]);
        if (DEBUG) debug(@"Reason: %@", [error localizedFailureReason]);
    }
    else
    {
        if (DEBUG) debug(@"jwt token = %@", token);
    }
    
    NSString *get_activate_license_info_url = [NSString stringWithFormat: @"%@/api/v2/my/device/license_services/activate?token=%@&access_key_id=%@", DATA_URL, token, [public get_access_key_id]];
    if (DEBUG) debug(@"get_activate_license_info_url = %@", get_activate_license_info_url);
    NSURL *url = [NSURL URLWithString: get_activate_license_info_url];
    NSMutableURLRequest *request_user_info = [NSMutableURLRequest requestWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [request_user_info setHTTPMethod: @"POST"];
    [request_user_info setValue: [public get_access_token] forHTTPHeaderField: @"Authorization"];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest: request_user_info
                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
      {
          NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData: data options: kNilOptions error: nil];
          if (DEBUG) debug(@"activate license info = %@", json);
          NSMutableDictionary *status = [json objectForKey: @"return_status"];
          NSString *code = [NSString stringWithFormat: @"%@", [status objectForKey: @"code"]];
          NSString *message = [NSString stringWithFormat: @"%@", [status objectForKey: @"message"]];
          if ([code isEqualToString: @"0"])
          {
              NSString *encryptionCode = [json objectForKey: @"data"];
              NSString *iv = [encryptionCode substringWithRange: NSMakeRange(0, 16)];
              NSString *encrypted_data = [encryptionCode substringFromIndex: 16];
              NSString *sha256_decode_data = [public sha256: [public get_secret_access_key]];
              NSData *decode_key = [public hexToBytes: sha256_decode_data];
              
              NSData *base64_decode_data = [[NSData alloc]initWithData: (NSData *)[public base64_decode: encrypted_data]];
              NSData *aes_decode_data = [[NSData alloc]initWithData: [public aes_cbc_256: base64_decode_data andIv: iv andkey: decode_key andType: kCCDecrypt]];
              
              NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingUTF8);
              NSString *activateLicenseInfo = [[NSString alloc]initWithData: aes_decode_data encoding: enc];
              if (DEBUG) debug(@"activate license info = %@", activateLicenseInfo);
              
              NSMutableDictionary *activate_license_info_json = [NSJSONSerialization JSONObjectWithData: aes_decode_data options:kNilOptions error: nil];
              NSDictionary *activateServiceInfo = [activate_license_info_json objectForKey: @"service"];
              NSString *name = [NSString stringWithFormat: @"%@", [activateServiceInfo objectForKey: @"name"]];
              NSString *expired_at = [NSString stringWithFormat: @"%@", [activateServiceInfo objectForKey: @"expired_at"]];

              dispatch_async(dispatch_get_main_queue(), ^() {
                  [self setActivateLicense: name andExpireDate: expired_at];
                  [self getLicenseServiceInfo: deviceId and: serviceCodeList];
                  
                  [m_HUD setHidden: YES];
              });
          }
          else
          {
              dispatch_async(dispatch_get_main_queue(), ^() {
                  [renewErrServiceIdList addObject: serviceId];
                  [renewErrMessageList addObject: message];
                  [self.renewRegisteredLicenseList reloadData];
                  [m_HUD setHidden: YES];
              });
          }
      }] resume];
}
- (void)scanActivateLicenseInfo:(NSString *)deviceId andLicenseKey:(NSString *)licenseKey
{
    [m_HUD setHidden: NO];
    [m_HUD.label setText: @"Activate license ..."];
    NSError *error;
    NSString *payloadFormat = [NSString stringWithFormat: @"{"
                               "\"pretend\": true,"
                               "\"device_id\": \"%@\","
                               "\"license_key\": \"%@\""
                               "}", deviceId, licenseKey];
    NSData *payloadJson = [payloadFormat dataUsingEncoding: NSUTF8StringEncoding];
    NSDictionary *payload = [NSJSONSerialization JSONObjectWithData: payloadJson options: kNilOptions error: &error];
    debug(@"payload = %@", payload);
    NSString *token = [Jwt encodeWithPayload: payload andKey: [public get_secret_access_key] andError:&error];
    if(token == nil)
    {
        // Print error
        if (DEBUG) debug(@"Code: %li", (long)[error code]);
        if (DEBUG) debug(@"Reason: %@", [error localizedFailureReason]);
    }
    else
    {
        if (DEBUG) debug(@"jwt token = %@", token);
    }
    
    NSString *get_activate_license_info_url = [NSString stringWithFormat: @"%@/api/v2/my/device/licenses/renew?token=%@&access_key_id=%@", DATA_URL, token, [public get_access_key_id]];
    if (DEBUG) debug(@"scan_activate_license_info_url = %@", get_activate_license_info_url);
    NSURL *url = [NSURL URLWithString: get_activate_license_info_url];
    NSMutableURLRequest *request_user_info = [NSMutableURLRequest requestWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [request_user_info setHTTPMethod: @"POST"];
    [request_user_info setValue: [public get_access_token] forHTTPHeaderField: @"Authorization"];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest: request_user_info
                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
      {
     
          NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData: data options: kNilOptions error: nil];
          if (DEBUG) debug(@"activate license info = %@", json);
          NSMutableDictionary *status = [json objectForKey: @"return_status"];
          NSString *code = [NSString stringWithFormat: @"%@", [status objectForKey: @"code"]];
          NSString *message = [NSString stringWithFormat: @"%@", [status objectForKey: @"message"]];
          if ([code isEqualToString: @"0"])
          {
              NSString *encryptionCode = [json objectForKey: @"data"];
              NSString *iv = [encryptionCode substringWithRange: NSMakeRange(0, 16)];
              NSString *encrypted_data = [encryptionCode substringFromIndex: 16];
              NSString *sha256_decode_data = [public sha256: [public get_secret_access_key]];
              NSData *decode_key = [public hexToBytes: sha256_decode_data];
              NSData *base64_decode_data = [[NSData alloc]initWithData: (NSData *)[public base64_decode: encrypted_data]];
              NSData *aes_decode_data = [[NSData alloc]initWithData: [public aes_cbc_256: base64_decode_data andIv: iv andkey: decode_key andType: kCCDecrypt]];
              NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingUTF8);
              NSString *activateLicenseInfo = [[NSString alloc]initWithData: aes_decode_data encoding: enc];
              if (DEBUG) debug(@"activate license info = %@", activateLicenseInfo);
              NSMutableDictionary *activate_license_info_json = [NSJSONSerialization JSONObjectWithData: aes_decode_data options:kNilOptions error: nil];
              NSInteger total = [[activate_license_info_json objectForKey: @"total"]integerValue];
              if (total > 0)
              {
                  NSArray *activateServiceInfo = [activate_license_info_json objectForKey: @"services"];
                  NSString *name = [[NSString alloc]init];
                  NSString *expired_at = [[NSString alloc]init];
                  for (int i=0; i<[activateServiceInfo count]; i++) {
                      NSDictionary *data = [activateServiceInfo objectAtIndex: i];
                      name = [NSString stringWithFormat: @"%@", [data objectForKey: @"name"]];
                      expired_at = [NSString stringWithFormat: @"%@", [data objectForKey: @"expired_at"]];
                  }
                  dispatch_async(dispatch_get_main_queue(), ^() {
                      // deltet object
                      if ([showNameList count] > 0)
                      {
                          for (UILabel *name in showNameList)
                          {
                              [name removeFromSuperview];
                          }
                          for (UILabel *date in showDateList)
                          {
                              [date removeFromSuperview];
                          }
                          showNameList = [[NSMutableArray alloc]init];
                          showDateList = [[NSMutableArray alloc]init];
                      }
                      [self.scanViewEnterLicenseTxt setText: @""];
                      [self.scanCancelBtn setHidden: YES];
                      [self.scanDoneBtn setHidden: NO];
                      [self.renewCancelBtn setHidden: YES];
                      [self.renewDoneBtn setHidden: NO];
                      [activateLicenseNameList addObject: name];
                      [activateLicenseExpiredDateList addObject: expired_at];
                      // insert activate data
                      UILabel *showName = [[UILabel alloc]initWithFrame: CGRectMake(0, 0, 120, 20)];
                      [showName setFont: [UIFont systemFontOfSize: 13]];
                      [showName setText: name];
                      UILabel *showDate = [[UILabel alloc]initWithFrame: CGRectMake(120, 0, 160, 20)];
                      [showDate setFont: [UIFont systemFontOfSize: 13]];
                      [showDate setText: expired_at];
                      [self.scanScrollView addSubview: showName];
                      [self.scanScrollView addSubview: showDate];
                      [showNameList addObject: showName];
                      [showDateList addObject: showDate];
                      
                      [self.scanViewMessage setHidden: YES];
                      _scanStatus = YES;
                      [m_HUD setHidden: YES];
                  });
              }
              else
              {
                  // no service data
                  [self.scanViewMessage setText: @"no service data"];
                  [self.scanViewMessage setHidden: NO];
                  _scanStatus = YES;
                  [m_HUD setHidden: YES];
              }
          }
          else if ([code isEqualToString: @"400.5.16"])
          {
              NSString *encryptionCode = [json objectForKey: @"data"];
              NSString *iv = [encryptionCode substringWithRange: NSMakeRange(0, 16)];
              NSString *encrypted_data = [encryptionCode substringFromIndex: 16];
              NSString *sha256_decode_data = [public sha256: [public get_secret_access_key]];
              NSData *decode_key = [public hexToBytes: sha256_decode_data];
              
              NSData *base64_decode_data = [[NSData alloc]initWithData: (NSData *)[public base64_decode: encrypted_data]];
              NSData *aes_decode_data = [[NSData alloc]initWithData: [public aes_cbc_256: base64_decode_data andIv: iv andkey: decode_key andType: kCCDecrypt]];
              
              NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingUTF8);
              NSString *activateLicenseInfo = [[NSString alloc]initWithData: aes_decode_data encoding: enc];
              if (DEBUG) debug(@"activate license info = %@", activateLicenseInfo);
              NSMutableDictionary *activate_license_info_json = [NSJSONSerialization JSONObjectWithData: aes_decode_data options:kNilOptions error: nil];
              NSInteger total = [[activate_license_info_json objectForKey: @"total"]integerValue];
              if (total > 0)
              {
                  dispatch_async(dispatch_get_main_queue(), ^() {
                      // deltet object
                      if ([mutiShowNameList count] > 0)
                      {
                          for (UILabel *name in mutiShowNameList)
                          {
                              [name removeFromSuperview];
                          }
                          for (UILabel *date in mutiShowDateList)
                          {
                              [date removeFromSuperview];
                          }
                          mutiShowNameList = [[NSMutableArray alloc]init];
                          mutiShowDateList = [[NSMutableArray alloc]init];
                      }
                      NSArray *getAllInfo = [activate_license_info_json objectForKey: @"services"];
                      for (int i=0; i<[getAllInfo count]; i++)
                      {
                          NSDictionary *data = [getAllInfo objectAtIndex: i];
                          if (DEBUG) debug(@"name = %@, amount = %@, renewed = %@", [data objectForKey: @"name"], [data objectForKey: @"amount"], [data objectForKey: @"renew"]);
                          // insert activate data
                          UILabel *showName = [[UILabel alloc]initWithFrame: CGRectMake(0, i*30, 120, 20)];
                          [showName setFont: [UIFont systemFontOfSize: 13]];
                          [showName setText: [NSString stringWithFormat: @"%@", [data objectForKey: @"name"]]];
                          UILabel *showDate = [[UILabel alloc]initWithFrame: CGRectMake(120, i*30, 160, 20)];
                          [showDate setFont: [UIFont systemFontOfSize: 13]];
                          NSInteger amountProc = [[data objectForKey: @"amount"]integerValue];
                          int getYear = (int)amountProc/365;
                          [showDate setText: [NSString stringWithFormat: @"%d year service", getYear]];
                          [self.mutiScrollView addSubview: showName];
                          [self.mutiScrollView addSubview: showDate];
                          [mutiShowNameList addObject: showName];
                          [mutiShowDateList addObject: showDate];
                          [self.mutiScrollView setContentSize: CGSizeMake(self.mutiScrollView.frame.size.width, (i*30)+30)];
                      }

                      // boundle license
                      [_session stopRunning];
                      [self.scanView setHidden: YES];
                      [self.mutiView setHidden: NO];
                      [m_HUD setHidden: YES];
                  });
              }
              else
              {
                  // no service data
                  [self.scanViewMessage setText: @"no service data"];
                  [self.scanViewMessage setHidden: NO];
                  _scanStatus = YES;
                  [m_HUD setHidden: YES];
              }
          }
          else
          {
              dispatch_async(dispatch_get_main_queue(), ^() {
                  [self.scanViewMessage setText: message];
                  [self.scanViewMessage setHidden: NO];
                  _scanStatus = YES;
                  [m_HUD setHidden: YES];
              });
          }
      }] resume];
}
- (void)activateMutiLicense:(NSString *)deviceId andLicenseKey:(NSString *)licenseKey
{
    [m_HUD setHidden: NO];
    [m_HUD.label setText: @"Activate license ..."];
    NSError *error;
    NSString *payloadFormat = [NSString stringWithFormat: @"{"
                               "\"pretend\": false,"
                               "\"device_id\": \"%@\","
                               "\"license_key\": \"%@\""
                               "}", deviceId, licenseKey];
    NSData *payloadJson = [payloadFormat dataUsingEncoding: NSUTF8StringEncoding];
    NSDictionary *payload = [NSJSONSerialization JSONObjectWithData: payloadJson options: kNilOptions error: &error];
    debug(@"payload = %@", payload);
    NSString *token = [Jwt encodeWithPayload: payload andKey: [public get_secret_access_key] andError:&error];
    if(token == nil)
    {
        // Print error
        if (DEBUG) debug(@"Code: %li", (long)[error code]);
        if (DEBUG) debug(@"Reason: %@", [error localizedFailureReason]);
    }
    else
    {
        if (DEBUG) debug(@"jwt token = %@", token);
    }
    
    NSString *get_activate_license_info_url = [NSString stringWithFormat: @"%@/api/v2/my/device/licenses/renew?token=%@&access_key_id=%@", DATA_URL, token, [public get_access_key_id]];
    if (DEBUG) debug(@"scan_activate_license_info_url = %@", get_activate_license_info_url);
    NSURL *url = [NSURL URLWithString: get_activate_license_info_url];
    NSMutableURLRequest *request_user_info = [NSMutableURLRequest requestWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [request_user_info setHTTPMethod: @"POST"];
    [request_user_info setValue: [public get_access_token] forHTTPHeaderField: @"Authorization"];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest: request_user_info
                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
      {
          NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData: data options: kNilOptions error: nil];
          if (DEBUG) debug(@"activate license info = %@", json);
          NSMutableDictionary *status = [json objectForKey: @"return_status"];
          NSString *code = [NSString stringWithFormat: @"%@", [status objectForKey: @"code"]];
          NSString *message = [NSString stringWithFormat: @"%@", [status objectForKey: @"message"]];
          if ([code isEqualToString: @"0"])
          {
              NSString *encryptionCode = [json objectForKey: @"data"];
              NSString *iv = [encryptionCode substringWithRange: NSMakeRange(0, 16)];
              NSString *encrypted_data = [encryptionCode substringFromIndex: 16];
              NSString *sha256_decode_data = [public sha256: [public get_secret_access_key]];
              NSData *decode_key = [public hexToBytes: sha256_decode_data];
              NSData *base64_decode_data = [[NSData alloc]initWithData: (NSData *)[public base64_decode: encrypted_data]];
              NSData *aes_decode_data = [[NSData alloc]initWithData: [public aes_cbc_256: base64_decode_data andIv: iv andkey: decode_key andType: kCCDecrypt]];
              NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingUTF8);
              NSString *activateLicenseInfo = [[NSString alloc]initWithData: aes_decode_data encoding: enc];
              if (DEBUG) debug(@"activate license info = %@", activateLicenseInfo);
              NSMutableDictionary *activate_license_info_json = [NSJSONSerialization JSONObjectWithData: aes_decode_data options:kNilOptions error: nil];
              NSInteger total = [[activate_license_info_json objectForKey: @"total"]integerValue];
              if (total > 0)
              {
                  // deltet object
                  if ([showNameList count] > 0)
                  {
                      for (UILabel *name in showNameList)
                      {
                          [name removeFromSuperview];
                      }
                      for (UILabel *date in showDateList)
                      {
                          [date removeFromSuperview];
                      }
                      showNameList = [[NSMutableArray alloc]init];
                      showDateList = [[NSMutableArray alloc]init];
                  }
                  dispatch_async(dispatch_get_main_queue(), ^() {
                  NSArray *activateServiceInfo = [activate_license_info_json objectForKey: @"services"];
                  for (int i=0; i<[activateServiceInfo count]; i++) {
                      NSDictionary *data = [activateServiceInfo objectAtIndex: i];
                      NSString *renewed = [NSString stringWithFormat: @"%@", [data objectForKey: @"renewed"]];
                      NSString *name = [NSString stringWithFormat: @"%@", [data objectForKey: @"name"]];
                      NSString *expired_at = [NSString stringWithFormat: @"%@", [data objectForKey: @"expired_at"]];
                      [activateLicenseNameList addObject: name];
                      [activateLicenseExpiredDateList addObject: expired_at];
                      // insert activate data
                      UILabel *showName = [[UILabel alloc]initWithFrame: CGRectMake(0, i*30, 120, 20)];
                      [showName setFont: [UIFont systemFontOfSize: 13]];
                      if ([renewed isEqualToString: @"1"])
                      {
                          [showName setText: [NSString stringWithFormat: @"%@ renewed", name]];
                      }
                      else
                      {
                          [showName setText: [NSString stringWithFormat: @"%@ added", name]];
                      }
                      UILabel *showDate = [[UILabel alloc]initWithFrame: CGRectMake(120, i*30, 160, 20)];
                      [showDate setFont: [UIFont systemFontOfSize: 13]];
                      [showDate setText: expired_at];
                      [self.scanScrollView addSubview: showName];
                      [self.scanScrollView addSubview: showDate];
                      [showNameList addObject: showName];
                      [showDateList addObject: showDate];
                      [self.scanScrollView setContentSize: CGSizeMake(self.scanScrollView.frame.size.width, (i*30)+30)];
                  }
                      [self.scanViewEnterLicenseTxt setText: @""];
                      [self.scanCancelBtn setHidden: YES];
                      [self.scanDoneBtn setHidden: NO];
                      [self.renewCancelBtn setHidden: YES];
                      [self.renewDoneBtn setHidden: NO];
                      [self.mutiView setHidden: YES];
                      [self.scanView setHidden: NO];
                      [m_HUD setHidden: YES];
                      [_session startRunning];
                      _scanStatus = YES;
                  });
              }
              else
              {
                  // no service data
              }
          }
          else
          {
              // error
          }
      }] resume];
}
#pragma mark - FUNCTION EVENTS
- (void)displayInit
{
    if ([servicePageList count] > 0)
    {
        for (UIView *service in servicePageList)
        {
            [service removeFromSuperview];
        }
        servicePageList = [[NSMutableArray alloc]init];
    }
    NSString* displayValue = [NSString stringWithFormat:@"%ld", expiredCount];
    [self.expiredCountLbl setText: displayValue];
    [self.expiredCountLbl setHidden: NO];
    self.pageControl.userInteractionEnabled = NO;
    [self.displayView setPagingEnabled:YES];
    [self.displayView setShowsHorizontalScrollIndicator:NO];
    [self.displayView setShowsVerticalScrollIndicator:NO];
    [self.displayView setScrollsToTop:NO];

    for (int i=0; i<expiredCount; i++) {
        serviceCodeList = [[NSMutableArray alloc]init];
        serviceRemainAmountList = [[NSMutableArray alloc]init];
        for (NSDictionary *service in [homeDeviceServiceList objectAtIndex: i])
        {
            NSString *parsed_module_code = [service objectForKey: @"name"];
            [serviceCodeList addObject: parsed_module_code];
            NSString *remain_amount = [NSString stringWithFormat: @"Expire in %@ Days", [service objectForKey: @"remain_amount"]];
            [serviceRemainAmountList addObject: remain_amount];
        }
        UIView *servicePage;
        UIImageView *reduce;
        UIScrollView *contentView;
        UILabel *deviceName;
        UILabel *deviceMac;
        UILabel *deviceIndex;
        UIButton *renewBtn;
        switch (deviceType)
        {
            case 1:
                servicePage = [[UIView alloc]initWithFrame: CGRectMake(i*265, 0, 320, 321)];
                reduce = [[UIImageView alloc]initWithFrame: CGRectMake(20, 64, 225, 40)];
                contentView = [[UIScrollView alloc]initWithFrame: CGRectMake(0, 104, 265, 167)];
                deviceName = [[UILabel alloc]initWithFrame: CGRectMake(32, 0, 200, 30)];
                deviceMac = [[UILabel alloc]initWithFrame: CGRectMake(32, 34, 200, 30)];
                deviceIndex = [[UILabel alloc]initWithFrame: CGRectMake(0, 0, 30, 30)];
                renewBtn = [[UIButton alloc]initWithFrame: CGRectMake(92, 281, 80, 30)];
                break;
            case 2:
                servicePage = [[UIView alloc]initWithFrame: CGRectMake(i*320, 0, 320, 420)];
                reduce = [[UIImageView alloc]initWithFrame: CGRectMake(20, 64, 280, 40)];
                contentView = [[UIScrollView alloc]initWithFrame: CGRectMake(0, 104, 320, 256)];
                deviceName = [[UILabel alloc]initWithFrame: CGRectMake(60, 0, 200, 30)];
                deviceMac = [[UILabel alloc]initWithFrame: CGRectMake(60, 34, 200, 30)];
                deviceIndex = [[UILabel alloc]initWithFrame: CGRectMake(0, 0, 30, 30)];
                renewBtn = [[UIButton alloc]initWithFrame: CGRectMake(120, 370, 80, 30)];
                break;
            case 3:
                servicePage = [[UIView alloc]initWithFrame: CGRectMake(i*359, 0, 359, 420)];
                reduce = [[UIImageView alloc]initWithFrame: CGRectMake(20, 64, 374, 40)];
                contentView = [[UIScrollView alloc]initWithFrame: CGRectMake(0, 104, 359, 256)];
                deviceName = [[UILabel alloc]initWithFrame: CGRectMake(60, 0, 200, 30)];
                deviceMac = [[UILabel alloc]initWithFrame: CGRectMake(60, 34, 200, 30)];
                deviceIndex = [[UILabel alloc]initWithFrame: CGRectMake(0, 0, 30, 30)];
                renewBtn = [[UIButton alloc]initWithFrame: CGRectMake(139, 412, 80, 30)];
                break; 
        }

        [reduce setImage: [UIImage imageNamed: @"reduce.png"]];
        [contentView setScrollEnabled: YES];
        [deviceName setText: [NSString stringWithFormat: @"%@", [homeDeviceNameList objectAtIndex: i]]];
        [deviceName setTextAlignment: NSTextAlignmentCenter];
        [deviceMac setText: [NSString stringWithFormat: @"%@", [homeDeviceMacList objectAtIndex: i]]];
        [deviceMac setTextAlignment: NSTextAlignmentCenter];
        [deviceIndex setText: [NSString stringWithFormat: @"%d", i+1]];
        [deviceIndex setTextAlignment: NSTextAlignmentCenter];
        [deviceIndex setFont:[UIFont systemFontOfSize: 12]];
        [renewBtn setTitle: @"Renew" forState: UIControlStateNormal];
        [renewBtn setBackgroundImage: [UIImage imageNamed: @"renew_btn.png"] forState: UIControlStateNormal];
        [renewBtn.layer setCornerRadius: renewBtn.frame.size.height/2];
        [renewBtn.titleLabel setFont: [UIFont systemFontOfSize: 13]];
        // device index
        [renewBtn setTag: i];
        [renewBtn addTarget: self action: @selector(renewBtn:) forControlEvents: UIControlEventTouchUpInside];

        [servicePage addSubview: deviceName];
        [servicePage addSubview: deviceMac];
        [servicePage addSubview: deviceIndex];
        [servicePage addSubview: reduce];
        [servicePage addSubview: contentView];
        [servicePage addSubview: renewBtn];
        [servicePageList addObject: servicePage];
        UILabel *code;
        UILabel *amount;
        for (int j=0; j<[serviceCodeList count]; j++) {
            switch (deviceType)
            {
                case 1:
                    code = [[UILabel alloc]initWithFrame: CGRectMake(15, j*30, 100, 20)];
                    amount = [[UILabel alloc]initWithFrame: CGRectMake(145, j*30, 120, 20)];
                    [contentView setContentSize: CGSizeMake(265, (j*30)+20)];
                    break;
                case 2:
                    code = [[UILabel alloc]initWithFrame: CGRectMake(35, j*30, 100, 20)];
                    amount = [[UILabel alloc]initWithFrame: CGRectMake(180, j*30, 140, 20)];
                    [contentView setContentSize: CGSizeMake(320, (j*30)+20)];
                    break;
                case 3:
                    code = [[UILabel alloc]initWithFrame: CGRectMake(35, j*30, 100, 20)];
                    amount = [[UILabel alloc]initWithFrame: CGRectMake(180, j*30, 140, 20)];
                    [contentView setContentSize: CGSizeMake(359, (j*30)+20)];
                    break;
            }
            //[contentView setBackgroundColor: [UIColor redColor]];
            [code setText: [serviceCodeList objectAtIndex: j]];
            [code setFont: [UIFont systemFontOfSize: 15]];
            [amount setText: [serviceRemainAmountList objectAtIndex: j]];
            [amount setFont: [UIFont systemFontOfSize: 13]];
            [contentView addSubview: code];
            [contentView addSubview: amount];
        }
        [self.displayView addSubview: servicePage];
    }
}
- (void)setActivateLicense:(NSString *)name andExpireDate:(NSString *)expiredDate
{
    [self.scanCancelBtn setHidden: YES];
    [self.scanDoneBtn setHidden: NO];
    [self.renewCancelBtn setHidden: YES];
    [self.renewDoneBtn setHidden: NO];
    [self.activageServiceName setText: name];
    [self.activateExpireDate setText: expiredDate];
    [self.activageServiceName setHidden: NO];
    [self.activateExpireDate setHidden: NO];
    [activateLicenseNameList addObject: name];
    [activateLicenseExpiredDateList addObject: expiredDate];
}
- (void)getDeviceType
{
    CGSize screenSize = [[UIScreen mainScreen]bounds].size;
    NSInteger deviceWidth = screenSize.width;
    NSInteger deviceHeight = screenSize.height;
    
    if (deviceWidth == 320 && deviceHeight == 568)
    {
        deviceType = 1;
    }
    else if (deviceWidth == 375 && deviceHeight == 667)
    {
        deviceType = 2;
    }
    else if (deviceWidth == 414 && deviceHeight == 736)
    {
        deviceType = 3;
    }
}
- (void)maskViewGesture
{

        [UIView animateWithDuration: 0.5 animations:^{
            switch (deviceType)
            {
                case 1:
                    [self.profileView setFrame: CGRectMake(-255, 0, 255, 519)];
                    break;
                case 2:
                    [self.profileView setFrame: CGRectMake(-310, 0, 310, 618)];
                    break;
                case 3:
                    [self.profileView setFrame: CGRectMake(-349, 0, 349, 687)];
                    break;
            }
            [self.maskView setHidden: YES];
            
        } completion:^(BOOL finished) {
            [self.profileView setHidden: YES];
        }];
}
- (void)cleanCacheAndCookie{
    [m_HUD setHidden: NO];
    [m_HUD.label setText: @"logout ..."];
    // clean cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]){
        [storage deleteCookie:cookie];
    }
    // clean UIWebView cache
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
    [m_HUD setHidden: YES];
}
- (void)searchDeviceInfo
{
    searchDeviceNameList = [[NSMutableArray alloc]init];
    searchDeviceMacList = [[NSMutableArray alloc]init];
    searchKeyWordStatus = NO;
    keyWord = self.searchDevicesText.text;
    if ([keyWord length] > 0)
    {
        for (int i=0; i<[homeDeviceNameList count]; i++) {
            NSRange searchName = [[homeDeviceNameList objectAtIndex: i]rangeOfString: keyWord];
            NSRange searchMac = [[homeDeviceMacList objectAtIndex: i]rangeOfString: keyWord];
            if (searchName.location == NSNotFound && searchMac.location == NSNotFound)
            {
                // show message
            }
            else
            {
                [searchDeviceNameList addObject: [homeDeviceNameList objectAtIndex: i]];
                [searchDeviceMacList addObject: [homeDeviceMacList objectAtIndex: i]];
                searchKeyWordStatus = YES;
            }
        }
        
        if (searchKeyWordStatus == YES)
        {
            [self.searchDeviceExpiredList reloadData];
        }
    }
    else
    {
        searchKeyWordStatus = NO;
        [self.searchDeviceExpiredList reloadData];
    }
}
- (void)manualEnterLicense
{
    [self.scanViewMessage setHidden: YES];
    NSString *licenseKey = self.scanViewEnterLicenseTxt.text;
    [self scanActivateLicenseInfo: [NSString stringWithFormat: @"%ld", self.renewServiceName.tag] andLicenseKey: licenseKey];
}
- (void)setRegisteredLicenseFrame
{
//    switch (deviceType)
//    {
//        case 1:
//            [self.displayView setFrame: CGRectMake(27, 163, 265, 321)];
//            [self.page1 setFrame: CGRectMake(0, 0, 265, 321)];
//            [self.page2 setFrame: CGRectMake(265, 0, 265, 321)];
//            [self.page3 setFrame: CGRectMake(530, 0, 265, 321)];
//            [self.page4 setFrame: CGRectMake(795, 0, 265, 321)];
//            break;
//        case 2:
//            [self.page1 setFrame: CGRectMake(0, 0, 320, 420)];
//            [self.page2 setFrame: CGRectMake(320, 0, 320, 420)];
//            [self.page3 setFrame: CGRectMake(640, 0, 320, 420)];
//            [self.page4 setFrame: CGRectMake(960, 0, 320, 420)];
//            break;
//        case 3:
//            [self.page1 setFrame: CGRectMake(0, 0, 365, 489)];
//            [self.page2 setFrame: CGRectMake(365, 0, 365, 489)];
//            [self.page3 setFrame: CGRectMake(730, 0, 365, 489)];
//            [self.page4 setFrame: CGRectMake(1095, 0, 365, 489)];
//            break;
//    }
}
#pragma mark - SCAN EVENTS
- (void)scanCode
{
    if (_session == nil)
    {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
        if (!input) return;
        AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        CGRect scanCrop=[self getScanCrop: self.scanF.bounds readerViewBounds: self.view.frame];
        
        output.rectOfInterest = scanCrop;
        _session = [[AVCaptureSession alloc]init];
        [_session setSessionPreset:AVCaptureSessionPresetHigh];
        
        [_session addInput:input];
        [_session addOutput:output];
        // set scan code type
        output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
        
        AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession: _session];
        layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
        layer.frame = self.scanF.layer.bounds;
        [self.scanF.layer insertSublayer: layer atIndex:0];
        
        [_session startRunning];
    }
    else
    {
        [_session startRunning];
    }
}
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count>0) {
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex : 0];
        if ([[metadataObject type]isEqualToString: AVMetadataObjectTypeQRCode])
        {
            if (_scanStatus)
            {
                if (DEBUG) debug(@"scan data = %@", metadataObject.stringValue);
                boundleLicense = metadataObject.stringValue;
                [self scanActivateLicenseInfo: [NSString stringWithFormat: @"%d", self.renewServiceName.tag] andLicenseKey: metadataObject.stringValue];
                _scanStatus = NO;
            }
        }
    }
}
-(CGRect)getScanCrop:(CGRect)rect readerViewBounds:(CGRect)readerViewBounds
{
    
    CGFloat x,y,width,height;
    
    x = (CGRectGetHeight(readerViewBounds)-CGRectGetHeight(rect))/2/CGRectGetHeight(readerViewBounds);
    y = (CGRectGetWidth(readerViewBounds)-CGRectGetWidth(rect))/2/CGRectGetWidth(readerViewBounds);
    width = CGRectGetHeight(rect)/CGRectGetHeight(readerViewBounds);
    height = CGRectGetWidth(rect)/CGRectGetWidth(readerViewBounds);
    
    return CGRectMake(x, y, width, height);
    
}
#pragma mark SCROLLVIEW CALLBACK
- (void)scrollViewWillBeginDragging:(UIScrollView *)sender
{
}
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat width = self.displayView.frame.size.width;
    NSInteger currentPage = ((self.displayView.contentOffset.x - width / 2) / width) + 1;
    [self.pageControl setCurrentPage:currentPage];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
}
#pragma mark - TABLEVIEW CALLBACK
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 0;
    if (searchDevicesListStatus == YES)
    {
        if (searchKeyWordStatus == YES)
        {
            count = [searchDeviceNameList count];
        }
        else
        {
            count = [homeDeviceNameList count];
        }
    }
    
    if (renewStatus == YES)
    {
        count = [renewServiceNameList count];
    }
    
    if (completeStatus == YES)
    {
        count = [activateLicenseNameList count];
    }
    if (DEBUG_TABLE) debug(@"searchDeviceListStatus = %d, renewStatus = %d, completeStatus = %d", searchDevicesListStatus, renewStatus, completeStatus);
    return count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (searchDevicesListStatus == YES)
    {
        SearchDevicesListCell *searchDevicesCell = [tableView dequeueReusableCellWithIdentifier: @"searchDevicesListCell"];
        if (searchKeyWordStatus == YES)
        {
            [searchDevicesCell.deviceName setText: [searchDeviceNameList objectAtIndex: indexPath.row]];
            [searchDevicesCell.macAddress setText: [searchDeviceMacList objectAtIndex: indexPath.row]];
        }
        else
        {
            [searchDevicesCell.deviceName setText: [homeDeviceNameList objectAtIndex: indexPath.row]];
            [searchDevicesCell.macAddress setText: [homeDeviceMacList objectAtIndex: indexPath.row]];
        }
        cell = searchDevicesCell;
    }
    
    if (renewStatus == YES)
    {
        RegisteredLicenseListCell *registeredLicensCell = [tableView dequeueReusableCellWithIdentifier: @"registeredLicenseListCell"];
        [registeredLicensCell.serviceName setText: [renewServiceNameList objectAtIndex: indexPath.row]];
        NSInteger amountProc = [[renewServiceAmountList objectAtIndex: indexPath.row]integerValue];
        int getYear = (int)amountProc/365;
        int getDay = amountProc%365;
        NSString *amountStr = [NSString stringWithFormat: @"%d year service +  %d days", getYear, getDay];
        [registeredLicensCell.serviceAmount setText: amountStr];
        [registeredLicensCell.count.layer setMasksToBounds: YES];
        [registeredLicensCell.count.layer setCornerRadius: registeredLicensCell.count.frame.size.width/2];
        [registeredLicensCell.count setText: [renewServiceTotalList objectAtIndex: indexPath.row]];
        [registeredLicensCell.activate.layer setBorderColor: [UIColor colorWithRed: 235.0 green: 180.0 blue: 0.0 alpha: 1.0].CGColor];
        [registeredLicensCell.activate setTag: indexPath.row];
        [registeredLicensCell.activate addTarget: self action: @selector(renewActivateBtn:) forControlEvents: UIControlEventTouchUpInside];
        [registeredLicensCell.activate.layer setBorderWidth: 1];
        [registeredLicensCell.activate.layer setCornerRadius: registeredLicensCell.activate.frame.size.height/2];
        if ([[renewServiceLinkList objectAtIndex: indexPath.row] isEqualToString: @"device"] || [[renewServiceLinkList objectAtIndex: indexPath.row] isEqualToString: @"user"])
        {
            [registeredLicensCell.link setHidden: NO];
        }
        else
        {
            [registeredLicensCell.link setHidden: YES];
        }
        [registeredLicensCell.message setHidden: YES];

        // activate failed
        for (int i=0; i<[renewErrServiceIdList count]; i++)
        {
            if ([[renewErrServiceIdList objectAtIndex: i] isEqualToString: [renewServiceIdList objectAtIndex: indexPath.row]])
            {
                [registeredLicensCell.message setText: [renewErrMessageList objectAtIndex: i]];
                [registeredLicensCell.message setHidden: NO];
                [registeredLicensCell.activate setEnabled: NO];
                [registeredLicensCell.activate setTitleColor: [UIColor darkGrayColor] forState: UIControlStateNormal];
                [registeredLicensCell.activate.layer setBorderColor: [UIColor darkGrayColor].CGColor];
            }
        }
        cell = registeredLicensCell;
    }
    
    if (completeStatus == YES)
    {
        CompleteServiceCell *completeServiceCell = [tableView dequeueReusableCellWithIdentifier: @"completeServiceListCell"];
        if (completeServiceCell == nil)
        {
            completeServiceCell = [[CompleteServiceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier: @"page1ServiceCell"];
        }
        
        [completeServiceCell.serviceName setText: [activateLicenseNameList objectAtIndex: indexPath.row]];
        [completeServiceCell.expiredDateAt setText: [activateLicenseExpiredDateList objectAtIndex: indexPath.row]];
        
        cell = completeServiceCell;
    }
    
    return cell;
}
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (searchDevicesListStatus == YES)
    {
        SearchDevicesListCell *cell = [tableView cellForRowAtIndexPath: indexPath];
        NSInteger searchIndex = [homeDeviceNameList indexOfObject: cell.deviceName.text];
        [self.displayView setContentOffset:CGPointMake(searchIndex*CGRectGetWidth(self.displayView.frame), 0) animated: NO];
        [self.pageControl setCurrentPage: searchIndex];
        [self.searchView setHidden: YES];
        [self.homeView setHidden: NO];
    }
    return indexPath;
}
@end
