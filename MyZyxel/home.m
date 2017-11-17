//
//  FirstViewController.m
//  MyZyxel
//
//  Created by line on 2017/5/12.
//  Copyright © 2017年 Zyxel. All rights reserved.
//

#import "home.h"

@interface home ()<AVCaptureMetadataOutputObjectsDelegate>
{
    MBProgressHUD *m_HUD;
    BOOL scanStatus;
    BOOL _scanStatus;
    BOOL searchDevicesListStatus;
    BOOL searchKeyWordStatus;
    BOOL scrollViewStatus;
    BOOL renewStatus;
    BOOL completeStatus;
    BOOL bindingRes;
    BOOL registerRes;
    AVCaptureSession *_session;
    NSInteger startPage;
    NSInteger expiredCount;
    NSInteger deviceType;
    NSInteger action;
    NSMutableArray *homeDeviceNameList;
    NSMutableArray *homeDeviceMacList;
    NSMutableArray *homeDeviceIdList;
    NSMutableArray *homeDeviceServiceList;
    NSMutableArray *deviceServicesList;
    NSMutableArray *serviceCodeList;
    NSMutableArray *serviceNameList;
    NSMutableArray *serviceRemainAmountList;
    NSMutableArray *serviceGracePeriodList;
    NSMutableArray *serviceGraceRemainAmoutList;
    NSMutableArray *searchDeviceNameList;
    NSMutableArray *searchDeviceMacList;
    NSMutableArray *renewServiceNameList;
    NSMutableArray *renewServiceAmountList;
    NSMutableArray *renewServiceTotalList;
    NSMutableArray *renewServiceLinkList;
    NSMutableArray *renewServiceIdList;
    NSMutableArray *renewModuleCodeList;
    NSMutableArray *activateLicenseNameList;
    NSMutableArray *activateLicenseExpiredDateList;
    NSMutableArray *renewErrServiceIdList;
    NSMutableArray *renewErrMessageList;
    NSMutableArray *servicePageList;
    NSMutableArray *showNameList;
    NSMutableArray *showDateList;
    NSMutableArray *mutiShowNameList;
    NSMutableArray *mutiShowDateList;
    NSString *homeRenewCodeList;
    NSString *boundleLicense;
    NSString *homeDeviceId;
    NSString *homeServiceName;
    NSString *homeServiceId;
    NSString *HomeScanServiceName;
    NSString *homeScanLicenseKey;
    NSString *bundleEventType;
    int deviceNum;
}
@end
@implementation home
#pragma mark - SYSTEM FUNCTION
- (void)dealloc
{
    m_HUD = nil;
    self.helpWebView = nil;
    self.privacyWebView = nil;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // check notification register device and binding
    NSThread *thread = [[NSThread alloc] initWithTarget: self selector: @selector(checkPushInfo) object: nil];
    [thread start];
    NSThread *tutoriaThread = [[NSThread alloc]initWithTarget: self selector: @selector(checkTutoriaInfo) object: nil];
    [tutoriaThread start];
    
    [self.tabBarController.tabBar setUnselectedItemTintColor: [UIColor whiteColor]];
    [self getDeviceType];
    [self.scanViewEnterLicenseTxt.layer setCornerRadius: self.scanViewEnterLicenseTxt.frame.size.height/2];
    [self.scanViewEnterLicenseTxt addTarget: self action: @selector(manualEnterLicense) forControlEvents: UIControlEventEditingDidEndOnExit];
    [self.helpBackBtn.layer setMasksToBounds: YES];
    [self.helpBackBtn.layer setCornerRadius: self.helpBackBtn.layer.frame.size.height/2];
    [self.helpBackBtn.layer setCornerRadius: self.helpBackBtn.layer.frame.size.width/2];
    [self.privacyBackBtn.layer setMasksToBounds: YES];
    [self.privacyBackBtn.layer setCornerRadius: self.privacyBackBtn.layer.frame.size.width/2];
    [self.privacyBackBtn.layer setCornerRadius: self.privacyBackBtn.layer.frame.size.height/2];
    [self.completeViewOkBtn.layer setMasksToBounds: YES];
    [self.completeViewOkBtn.layer setCornerRadius: self.completeViewOkBtn.frame.size.height/2];
    [self.mutiViewCancelBtn.layer setMasksToBounds: YES];
    [self.mutiViewCancelBtn.layer setCornerRadius: self.mutiViewCancelBtn.frame.size.height/2];
    [self.mutiViewActivateBtn.layer setMasksToBounds: YES];
    [self.mutiViewActivateBtn.layer setCornerRadius: self.mutiViewActivateBtn.frame.size.height/2];
    UIImageView *searchImageView = [[UIImageView alloc]initWithFrame: CGRectMake(0, 0, self.searchDeviceExpiredList.frame.size.width, self.searchDeviceExpiredList.frame.size.height)];
    [searchImageView setImage: [UIImage imageNamed: @"search_bg.png"]];
    [self.searchDeviceExpiredList setBackgroundView: searchImageView];
    servicePageList = [[NSMutableArray alloc]init];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithString: self.renewScanCodeBtn.titleLabel.text];
    [attrString setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Oblique" size:15.0],NSForegroundColorAttributeName:[UIColor darkGrayColor],NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]} range:NSMakeRange(0,[attrString length])];
    [self.renewScanCodeBtn setAttributedTitle: attrString forState: UIControlStateNormal];
    attrString = [[NSMutableAttributedString alloc]initWithString: self.renewUseRegisteredLicenseBtn.titleLabel.text];
    [attrString setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Oblique" size:15.0],NSForegroundColorAttributeName:[UIColor darkGrayColor],NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]} range:NSMakeRange(0,[attrString length])];
    [self.renewUseRegisteredLicenseBtn setAttributedTitle: attrString forState: UIControlStateNormal];
    [self.profileBtn setHitTestEdgeInsets: UIEdgeInsetsMake(60, 60, 60, 60)];
    [self.searchBtn setHitTestEdgeInsets: UIEdgeInsetsMake(60, 60, 60, 60)];
    [self.searchCancelBtn setHitTestEdgeInsets: UIEdgeInsetsMake(60, 60, 60, 60)];
    [self.renewCancelBtn setHitTestEdgeInsets: UIEdgeInsetsMake(60, 60, 60, 60)];
    [self.scanCancelBtn setHitTestEdgeInsets: UIEdgeInsetsMake(60, 60, 60, 60)];
    [self.profileVersion setText: APP_VERSION];
    [self.helpWebView.scrollView setBounces: NO];
    [self.privacyWebView.scrollView setBounces: NO];
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
    [self.helpView setHidden: YES];
    [self.privacyView setHidden: YES];
    [self selfLayout];
    if (m_HUD == nil)
    {
        m_HUD = [[MBProgressHUD alloc]initWithView: self.view];
        [m_HUD setContentColor: [UIColor whiteColor]];
        [m_HUD.bezelView setBackgroundColor: [UIColor blackColor]];
        [m_HUD showAnimated: YES];
        [m_HUD setMinShowTime: 5];
    }
    [self.tabBarController.tabBar setUserInteractionEnabled: NO];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
    [self.view addSubview: m_HUD];
    action = ENTER_HOME;
    [self initEnv];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - INIT SETTINGS
- (void)initEnv
{
    deviceNum = 0;
    scrollViewStatus = NO;
    [self.userAccountLbl setText: [public get_user_account]];
    [self.scanView setFrame: CGRectMake(375, 0, 375, 667)];
    // speed
    [self.displayView setDecelerationRate: UIScrollViewDecelerationRateFast];
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
            [self.profileView setFrame: CGRectMake(-255, 0, 255, 568)];
            [UIView animateWithDuration: 0.5 animations:^{
                [self.profileView setFrame: CGRectMake(0, 0, 255, 568)];
                [self.tabBarController.tabBar setHidden: YES];
                [self.maskView setHidden: NO];
            }];
            break;
        }
        case 2:
        {
            [self.profileView setFrame: CGRectMake(-310, 0, 310, 667)];
            [UIView animateWithDuration: 0.5 animations:^{
                [self.profileView setFrame: CGRectMake(0, 0, 310, 667)];
                [self.tabBarController.tabBar setHidden: YES];
                [self.maskView setHidden: NO];
            }];
            break;
        }
        case 3:
        {
            [self.profileView setFrame: CGRectMake(-349, 0, 349, 736)];
            [UIView animateWithDuration: 0.5 animations:^{
                [self.profileView setFrame: CGRectMake(0, 0, 349, 736)];
                [self.tabBarController.tabBar setHidden: YES];
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
    [m_HUD setHidden: NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        searchDevicesListStatus = YES;
        //deviceListStatus = NO;
        [self.searchDeviceExpiredList reloadData];
        [self.searchView setHidden: NO];
        [self.searchNoResView setHidden: YES];
        [self.tabBarController.tabBar setHidden: YES];
        [self.homeView setHidden: YES];
        [self.searchDevicesText addTarget:self action:@selector(searchDeviceInfo) forControlEvents: UIControlEventEditingDidEndOnExit];
        [self.searchDeviceExpiredList setHidden: NO];
        [m_HUD setHidden: YES];
    });
}
- (IBAction)searchCancelBtn:(id)sender
{
    [m_HUD setHidden: NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        searchDevicesListStatus = NO;
        //deviceListStatus = YES;
        [self hiddeKeyboard];
        [self.searchView setHidden: YES];
        [self.homeView setHidden: NO];
        [self.tabBarController.tabBar setHidden: NO];
        [m_HUD setHidden: YES];
    });
}
- (void)renewBtn:(UIButton *)sender
{
    debug(@"device id = %ld", (long)sender.tag);
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
    homeDeviceId = [homeDeviceIdList objectAtIndex: sender.tag];
    debug(@"homeRenewCodeList = %@", [serviceCodeList objectAtIndex: sender.tag]);
    homeRenewCodeList = [NSString stringWithFormat: @"%@", [serviceCodeList objectAtIndex: sender.tag]];
    action = HOME_GET_LICENSES;
    if ([public checkNetWorkConn])
    {
        [self getLicenseServiceInfo: [homeDeviceIdList objectAtIndex: sender.tag] andCodeList: homeRenewCodeList];
    }
    else
    {
        [self.errorView setHidden: NO];
    }
}
- (IBAction)renewCancelBtn:(id)sender
{
    renewStatus = NO;
    [self.activageServiceName setText: @""];
    [self.activateExpireDate setText: @""];
    action = ENTER_HOME;
    [self getDevicesInfo];
}
- (IBAction)scanCancelBtn:(id)sender
{
    [_session stopRunning];
    renewStatus = NO;
    [self.activageServiceName setText: @""];
    [self.activateExpireDate setText: @""];
    [self hiddeKeyboard];
    action = ENTER_HOME;
    if ([public checkNetWorkConn])
    {
        [self getDevicesInfo];
    }
    else
    {
        [self.errorView setHidden: NO];
    }
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
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(unBindingDevice) object:nil];
    [thread start];
    [self cleanCacheAndCookie];
}
- (void)renewActivateBtn:(UIButton *)sender
{
    debug(@"device id = %@, service list = %@", [NSString stringWithFormat: @"%ld", (long)self.renewServiceName.tag], [renewServiceIdList objectAtIndex: sender.tag]);
    homeServiceName = [NSString stringWithFormat: @"%ld", (long)self.renewServiceName.tag];
    homeServiceId = [renewServiceIdList objectAtIndex: sender.tag];
    action = HOME_ACTIVATE_LICENSE;
    if ([public checkNetWorkConn])
    {
        [self activateLicenseInfo: [NSString stringWithFormat: @"%ld", (long)self.renewServiceName.tag] andServiceId: [renewServiceIdList objectAtIndex: sender.tag]];
    }
    else
    {
        [self.errorView setHidden: NO];
    }
}
- (IBAction)completeViewOKBtn:(id)sender
{
    completeStatus = NO;
    if ([public checkNetWorkConn])
    {
        [self getDevicesInfo];
    }
    else
    {
        [self.errorView setHidden: NO];
    }
}

- (IBAction)renewDoneBtn:(id)sender
{
    renewStatus = NO;
    completeStatus = YES;
    [self.completeLicenseList reloadData];
    dispatch_async(dispatch_get_main_queue(), ^() {
        [self.renewView setHidden: YES];
        [self.completeView setHidden: NO];
        [self.activageServiceName setText: @""];
        [self.activateExpireDate setText: @""];
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
        [self.activageServiceName setText: @""];
        [self.activateExpireDate setText: @""];
    });
}

- (IBAction)mutiViewActivateBtn:(id)sender
{
    action = HOME_BOUNDLE_LICENSE;
    if ([public checkNetWorkConn])
    {
        [self activateMutiLicense: [NSString stringWithFormat: @"%ld", (long)self.renewServiceName.tag] andLicenseKey: boundleLicense];
    }
    else
    {
        [self.errorView setHidden: NO];
    }
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
    if ([public checkNetWorkConn])
    {
        if (action == ENTER_HOME)
        {
            [self getDevicesInfo];
        }
        else if (action == HOME_GET_LICENSES)
        {
            [self getLicenseServiceInfo: homeDeviceId andCodeList: homeRenewCodeList];
        }
        else if (action == HOME_ACTIVATE_LICENSE)
        {
            [self activateLicenseInfo: homeServiceName andServiceId: homeServiceId];
        }
        else if (action == HOME_MANUAL_ACTIVATE_LICENSE)
        {
            NSString *licenseKey = self.scanViewEnterLicenseTxt.text;
            [self scanActivateLicenseInfo: [NSString stringWithFormat: @"%ld", (long)self.renewServiceName.tag] andLicenseKey: licenseKey andEventType: @"manually"];
        }
        else if (action == HOME_SCAN_ACTIVATE_LICENSE)
        {
            [self scanActivateLicenseInfo: HomeScanServiceName andLicenseKey: homeScanLicenseKey andEventType: @"scan"];
        }
        else if (action == HOME_BOUNDLE_LICENSE)
        {
            [self activateMutiLicense: [NSString stringWithFormat: @"%ld", (long)self.renewServiceName.tag] andLicenseKey: boundleLicense];
        }
    }
    else
    {
        debug(@"No Internet.");
    }
}
- (IBAction)helpBtn:(id)sender
{
    [m_HUD setHidden: NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *path = [NSString stringWithFormat: @"%@", [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html" inDirectory:@"WH"]];
        path = [path stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        NSURL * url = [NSURL URLWithString: path];
        NSURLRequest * request = [NSURLRequest requestWithURL:url];
        [self.helpWebView loadRequest:request];
        [self.helpWebView setScalesPageToFit: YES];
        [self.homeView setHidden: YES];
        [self.profileView setHidden: YES];
        [self.maskView setHidden: YES];
        [self.helpView setHidden: NO];
        [m_HUD setHidden: YES];
    });
}
- (IBAction)helpBackBtn:(id)sender
{
    [m_HUD setHidden: NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.helpView setHidden: YES];
        [self.homeView setHidden: NO];
        [self.tabBarController.tabBar setHidden: NO];
        self.helpWebView = nil;
        [m_HUD setHidden: YES];
    });
}
- (IBAction)privacyBtn:(id)sender
{
    [m_HUD setHidden: NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSURL * url = [NSURL URLWithString:[[NSBundle mainBundle] pathForResource:@"privacy_statement" ofType:@"htm"]];
        NSURLRequest * request = [NSURLRequest requestWithURL:url];
        [self.privacyWebView loadRequest:request];
        [self.privacyWebView setScalesPageToFit: YES];
        [self.homeView setHidden: YES];
        [self.profileView setHidden: YES];
        [self.maskView setHidden: YES];
        [self.privacyView setHidden: NO];
        [m_HUD setHidden: YES];
    });
}
- (IBAction)privacyBackBtn:(id)sender
{
    [m_HUD setHidden: NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.privacyView setHidden: YES];
        [self.homeView setHidden: NO];
        [self.tabBarController.tabBar setHidden: NO];
        self.privacyWebView = nil;
        [m_HUD setHidden: YES];
    });
}
- (IBAction)tutoriaHomeTBtn:(id)sender
{
    [self.tutoriaHomeTView setHidden: YES];
    [public recordTutoriaInfo: @"homeT"];
}
- (IBAction)registerSTBtn:(id)sender
{
    [self.tutoriaRegisterSTView setHidden: YES];
    [public recordTutoriaInfo: @"registerST"];
}
#pragma mark - GET SERVER INFO
// API 1 GET DEVICE INFORMATION
- (void)getDevicesInfo
{
    [m_HUD setHidden: NO];
    NSError *error;
    NSDictionary *payload = @{
                              @"status": @"service_expire",
                              @"from": @-2,
                              @"to": @2
                            };
    NSString *token = [Jwt encodeWithPayload: payload andKey: [public get_secret_access_key] andError:&error];
    if(token == nil)
    {
        // Print error
        debug(@"Code: %li", (long)[error code]);
        debug(@"Reason: %@", [error localizedFailureReason]);
    }
    else
    {
        debug(@"jwt token = %@", token);
    }
    NSString *get_devices_info_url = [NSString stringWithFormat: @"%@/api/v2/my/devices?token=%@&access_key_id=%@", DATA_URL, token, [public get_access_key_id]];
    debug(@"get_devices_info_url = %@", get_devices_info_url);
    NSURL *url = [NSURL URLWithString: get_devices_info_url];
    NSMutableURLRequest *request_user_info = [NSMutableURLRequest requestWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 30];
    [request_user_info setHTTPMethod: @"GET"];
    [request_user_info setValue: [public get_access_token] forHTTPHeaderField: @"Authorization"];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest: request_user_info
                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
      {
          if (data != nil)
          {
              NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData: data options: kNilOptions error: nil];
              debug(@"devicesInfo = %@", json);
              
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
                  debug(@"devices info = %@", devicesInfo);
                  NSMutableDictionary *devices_info_json = [NSJSONSerialization JSONObjectWithData: aes_decode_data options:kNilOptions error: nil];
                  NSInteger getExpiredCount = [[devices_info_json objectForKey: @"total"]integerValue];
                  expiredCount = getExpiredCount;
                  debug(@"devices = %@", [devices_info_json objectForKey: @"devices"]);
                  if (getExpiredCount > 0)
                  {
                      homeDeviceNameList = [[NSMutableArray alloc]init];
                      homeDeviceMacList = [[NSMutableArray alloc]init];
                      homeDeviceIdList = [[NSMutableArray alloc]init];
                      homeDeviceServiceList = [[NSMutableArray alloc]init];
                      NSMutableArray *all = [[NSMutableArray alloc]init];
                      NSString *strFormat = [[NSString alloc]init];
                      NSArray *deviceListArr = [devices_info_json objectForKey: @"devices"];
                      NSString *serviceArr = [[NSString alloc]init];
                      for (NSDictionary *device in deviceListArr)
                      {
                          strFormat = @"";
                          NSString *name = [NSString stringWithFormat: @"%@", [device objectForKey: @"name"]];
                          // filter service list
                          //                          BOOL display = [public checkServiceStatus: name];
                          //                          if (display == YES)
                          //                          {
//                          [homeDeviceNameList addObject: name];
                          strFormat = [strFormat stringByAppendingString: name];
                          NSString *mac_address = [NSString stringWithFormat: @"%@", [device objectForKey: @"mac_address"]];
//                          [homeDeviceMacList addObject: mac_address];
                          strFormat = [strFormat stringByAppendingString: [NSString stringWithFormat: @"|%@", mac_address]];
                          NSString *did = [NSString stringWithFormat: @"%@", [device objectForKey: @"id"]];
//                          [homeDeviceIdList addObject: did];
                          strFormat = [strFormat stringByAppendingString: [NSString stringWithFormat: @"|%@", did]];
//                          [homeDeviceServiceList addObject: [device objectForKey: @"services"]];
                          serviceArr = @"";
                          for (NSDictionary *getServiceInfo in [device objectForKey: @"services"])
                          {
                              if ([serviceArr length] > 0)
                              {
                                  serviceArr = [serviceArr stringByAppendingString: [NSString stringWithFormat: @",%@", [getServiceInfo objectForKey: @"expire_status"]]];
                              }
                              else
                              {
                                  serviceArr = [serviceArr stringByAppendingString: [NSString stringWithFormat: @"%@", [getServiceInfo objectForKey: @"expire_status"]]];
                              }
                              serviceArr = [serviceArr stringByAppendingString: [NSString stringWithFormat: @"/%@", [getServiceInfo objectForKey: @"grace_period"]]];
                              serviceArr = [serviceArr stringByAppendingString: [NSString stringWithFormat: @"/%@", [getServiceInfo objectForKey: @"grace_remain_amount"]]];
                              serviceArr = [serviceArr stringByAppendingString: [NSString stringWithFormat: @"/%@", [getServiceInfo objectForKey: @"name"]]];
                              serviceArr = [serviceArr stringByAppendingString: [NSString stringWithFormat: @"/%@", [getServiceInfo objectForKey: @"parsed_module_code"]]];
                              serviceArr = [serviceArr stringByAppendingString: [NSString stringWithFormat: @"/%@", [getServiceInfo objectForKey: @"remain_amount"]]];
                          }
                          strFormat = [strFormat stringByAppendingString: [NSString stringWithFormat: @"|%@", serviceArr]];
                          [all addObject: strFormat];
//                          }
                      }
                      // sort
                      NSArray *sort = [all sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
                      debug(@"sort = %@", sort);
                      for (NSString *str in sort)
                      {
                          NSArray *cutArr = [str componentsSeparatedByString: @"|"];
                          [homeDeviceNameList addObject: cutArr[0]];
                          [homeDeviceMacList addObject: cutArr[1]];
                          [homeDeviceIdList addObject: cutArr[2]];
                          [homeDeviceServiceList addObject: cutArr[3]];
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
                          switch (deviceType) {
                              case 1:
                                  [self.displayView setContentSize:CGSizeMake(width*self.pageControl.numberOfPages, 0)];
                                  break;
                              case 2:
                                  [self.displayView setContentSize:CGSizeMake(width*self.pageControl.numberOfPages, 0)];
                                  break;
                              case 3:
                                  [self.displayView setContentSize:CGSizeMake(width*self.pageControl.numberOfPages, 0)];
                                  break;
                          }
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
                          [self.errorView setHidden: YES];
                          [self.homeView setHidden: NO];
                      });
                  }
                  else
                  {
                      // no device
                      dispatch_async(dispatch_get_main_queue(), ^() {
                          [self.displayView setHidden: YES];
                          [self.renewView setHidden: YES];
                          [self.scanView setHidden: YES];
                          [self.completeView setHidden: YES];
                          [m_HUD setHidden: YES];
                          [self.noWorkView setHidden: NO];
                          [self.tabBarController.tabBar setHidden: NO];
                          [self.errorView setHidden: YES];
                          [self.homeView setHidden: NO];
                      });
                  }
              }
              else
              {
                  // response error
                  response_debug(@"error code = %@, error message = %@", code, message);
                  [self.tabBarController.tabBar setHidden: YES];
                  [self.errorView setHidden: NO];
                  [m_HUD setHidden: YES];
              }
          }
          else
          {
              // no response
              response_debug(@"No response data");
              [self.tabBarController.tabBar setHidden: YES];
              [self.errorView setHidden: NO];
              [m_HUD setHidden: YES];
          }
          // thread
          dispatch_async(dispatch_get_main_queue(), ^{
              [self.tabBarController.tabBar setUserInteractionEnabled: YES];
          });
      }] resume];
}
// API 2 GET SERVICE LICENSE
- (void)getLicenseServiceInfo:(NSString *)deviceId andCodeList:(NSString *)parsed_module_code
{
    debug(@"parsed module code = %@", parsed_module_code);
    [m_HUD setHidden: NO];
    NSError *error;
    NSString *payloadFormat = [NSString stringWithFormat: @"{"
                               "\"device_id\": \"%@\","
                               "\"status\": \"wait_for_renew\","
                               "\"renew_list\": ["
                                                 "%@"
                                                "]"
                               "}", deviceId, parsed_module_code];
    NSData *payloadJson = [payloadFormat dataUsingEncoding: NSUTF8StringEncoding];
    NSDictionary *payload = [NSJSONSerialization JSONObjectWithData: payloadJson options: kNilOptions error: &error];
    NSString *token = [Jwt encodeWithPayload: payload andKey: [public get_secret_access_key] andError:&error];
    if(token == nil)
    {
        // Print error
        debug(@"Code: %li", (long)[error code]);
        debug(@"Reason: %@", [error localizedFailureReason]);
    }
    else
    {
        debug(@"jwt token = %@", token);
    }
    NSString *get_license_service_info_url = [NSString stringWithFormat: @"%@/api/v2/my/device/license_services?token=%@&access_key_id=%@", DATA_URL, token, [public get_access_key_id]];
    debug(@"get_license_service_info_url = %@", get_license_service_info_url);
    NSURL *url = [NSURL URLWithString: get_license_service_info_url];
    NSMutableURLRequest *request_user_info = [NSMutableURLRequest requestWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [request_user_info setHTTPMethod: @"GET"];
    [request_user_info setValue: [public get_access_token] forHTTPHeaderField: @"Authorization"];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest: request_user_info
                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
      {
          if (data != nil)
          {
              NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData: data options: kNilOptions error: nil];
              debug(@"license service info = %@", json);
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
                  debug(@"license service info = %@", licenseServiceInfo);
                  renewServiceNameList = [[NSMutableArray alloc]init];
                  renewServiceTotalList = [[NSMutableArray alloc]init];
                  renewServiceAmountList = [[NSMutableArray alloc]init];
                  renewServiceLinkList = [[NSMutableArray alloc]init];
                  renewServiceIdList = [[NSMutableArray alloc]init];
                  renewModuleCodeList = [[NSMutableArray alloc]init];
                  NSMutableDictionary *license_info_json = [NSJSONSerialization JSONObjectWithData: aes_decode_data options:kNilOptions error: nil];
                  NSInteger total = [[license_info_json objectForKey: @"total"]integerValue];
                  if (total > 0)
                  {
                      // filter module code
                      NSArray *renewListArr = [license_info_json objectForKey: @"renew_list"];
                      for (NSString *code in renewListArr)
                      {
                          [renewModuleCodeList addObject: [NSString stringWithFormat: @"%@", code]];
                      }
                      NSMutableArray *all = [[NSMutableArray alloc]init];
                      NSString *strFormat = [[NSString alloc]init];
                      NSArray *licenseListArr = [license_info_json objectForKey: @"services"];
                      for (NSDictionary *license in licenseListArr)
                      {
                          strFormat = @"";
                          NSString *name = [NSString stringWithFormat: @"%@", [license objectForKey: @"name"]];
//                          [renewServiceNameList addObject: name];
                          strFormat = [strFormat stringByAppendingString: name];
                          NSString *total = [NSString stringWithFormat: @"%@", [license objectForKey: @"total"]];
//                          [renewServiceTotalList addObject: total];
                          strFormat = [strFormat stringByAppendingString: [NSString stringWithFormat: @"|%@", total]];
                          NSString *amount = [NSString stringWithFormat: @"%@", [license objectForKey: @"amount"]];
//                          [renewServiceAmountList addObject: amount];
                          strFormat = [strFormat stringByAppendingString: [NSString stringWithFormat: @"|%@", amount]];
                          NSString *link = [NSString stringWithFormat: @"%@", [license objectForKey: @"linked_on"]];
//                          [renewServiceLinkList addObject: link];
                          strFormat = [strFormat stringByAppendingString: [NSString stringWithFormat: @"|%@", link]];
                          NSString *serviceId = [NSString stringWithFormat: @"%@", [license objectForKey: @"license_service_id"]];
//                          [renewServiceIdList addObject: serviceId];
                          strFormat = [strFormat stringByAppendingString: [NSString stringWithFormat: @"|%@", serviceId]];
                          [all addObject: strFormat];
                      }
                      NSArray *sort = [all sortedArrayUsingSelector:@selector(compare:)];
                      for (NSString *str in sort)
                      {
                          NSArray *cutArr = [str componentsSeparatedByString: @"|"];
                          [renewServiceNameList addObject: cutArr[0]];
                          [renewServiceTotalList addObject: cutArr[1]];
                          [renewServiceAmountList addObject: cutArr[2]];
                          [renewServiceLinkList addObject: cutArr[3]];
                          [renewServiceIdList addObject: cutArr[4]];
                      }
                      dispatch_async(dispatch_get_main_queue(), ^() {
                          [self.renewRegisteredLicenseList reloadData];
                          dispatch_async(dispatch_get_main_queue(), ^() {
                              [self.homeView setHidden: YES];
                              [self.tabBarController.tabBar setHidden: YES];
                              [self.renewView setHidden: NO];
                              [self.errorView setHidden: YES];
                              [m_HUD setHidden: YES];
                          });
                      });
                  }
                  else
                  {
                      // no register license
                      if (scanStatus == YES)
                      {
                          // enter scan mode
                          dispatch_async(dispatch_get_main_queue(), ^() {
                              _scanStatus = YES;
                              [self.scanViewEnterLicenseTxt setText: @""];
                              [self.homeView setHidden: YES];
                              [self.tabBarController.tabBar setHidden: YES];
                              [self.scanView setHidden: NO];
                              [self scanCode];
                              [self.errorView setHidden: YES];
                              [m_HUD setHidden: YES];
                          });
                      }
                  }
                  scanStatus = NO;
              }
              else
              {
                  // response error
                  response_debug(@"error code = %@, error message = %@", code, message);
                  [self.errorView setHidden: NO];
                  [m_HUD setHidden: YES];
              }
          }
          else
          {
              // no response
              response_debug(@"No response data");
              [self.errorView setHidden: NO];
              [m_HUD setHidden: YES];
          }
      }] resume];
}
// API 3 LOG ACTIVATE LICENSE
- (void)activateLicenseInfo:(NSString *)deviceId andServiceId:(NSString *)serviceId
{
    [m_HUD setHidden: NO];
    NSError *error;
    NSUUID *udid = [UIDevice currentDevice].identifierForVendor;
    NSString *os = [NSString stringWithFormat: @"%@", [[UIDevice currentDevice]systemVersion]];
    NSString *payloadFormat = [NSString stringWithFormat: @"{"
                               "\"udid\": \"%@\","
                               "\"os\": \"%@\","
                               "\"event_type\": \"exist\","
                               "\"device_id\": \"%@\","
                               "\"license_service_id\": \"%@\","
                               "}", [NSString stringWithFormat: @"%@", udid], os, deviceId, serviceId];
    NSData *payloadJson = [payloadFormat dataUsingEncoding: NSUTF8StringEncoding];
    NSDictionary *payload = [NSJSONSerialization JSONObjectWithData: payloadJson options: kNilOptions error: &error];
    debug(@"payload = %@", payload);
    NSString *token = [Jwt encodeWithPayload: payload andKey: [public get_secret_access_key] andError:&error];
    if(token == nil)
    {
        // Print error
        debug(@"Code: %li", (long)[error code]);
        debug(@"Reason: %@", [error localizedFailureReason]);
    }
    else
    {
        debug(@"jwt token = %@", token);
    }
    
    NSString *get_activate_license_info_url = [NSString stringWithFormat: @"%@/api/v2/my/device/license_services/activate?token=%@&access_key_id=%@", DATA_URL, token, [public get_access_key_id]];
    debug(@"get_activate_license_info_url = %@", get_activate_license_info_url);
    NSURL *url = [NSURL URLWithString: get_activate_license_info_url];
    NSMutableURLRequest *request_user_info = [NSMutableURLRequest requestWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [request_user_info setHTTPMethod: @"POST"];
    [request_user_info setValue: [public get_access_token] forHTTPHeaderField: @"Authorization"];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest: request_user_info
                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
      {
          if (data != nil)
          {
              NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData: data options: kNilOptions error: nil];
              debug(@"activate license info = %@", json);
              NSMutableDictionary *status = [json objectForKey: @"return_status"];
              NSString *code = [NSString stringWithFormat: @"%@", [status objectForKey: @"code"]];
              NSString *message = [NSString stringWithFormat: @"%@", [status objectForKey: @"message"]];
              if ([code isEqualToString: @"0"])
              {
                  // activate succeeded
                  NSString *encryptionCode = [json objectForKey: @"data"];
                  NSString *iv = [encryptionCode substringWithRange: NSMakeRange(0, 16)];
                  NSString *encrypted_data = [encryptionCode substringFromIndex: 16];
                  NSString *sha256_decode_data = [public sha256: [public get_secret_access_key]];
                  NSData *decode_key = [public hexToBytes: sha256_decode_data];
                  NSData *base64_decode_data = [[NSData alloc]initWithData: (NSData *)[public base64_decode: encrypted_data]];
                  NSData *aes_decode_data = [[NSData alloc]initWithData: [public aes_cbc_256: base64_decode_data andIv: iv andkey: decode_key andType: kCCDecrypt]];
                  NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingUTF8);
                  NSString *activateLicenseInfo = [[NSString alloc]initWithData: aes_decode_data encoding: enc];
                  debug(@"activate license info = %@", activateLicenseInfo);
                  NSMutableDictionary *activate_license_info_json = [NSJSONSerialization JSONObjectWithData: aes_decode_data options:kNilOptions error: nil];
                  NSDictionary *activateServiceInfo = [activate_license_info_json objectForKey: @"service"];
                  NSString *name = [NSString stringWithFormat: @"%@", [activateServiceInfo objectForKey: @"name"]];
                  NSString *expired_at = [NSString stringWithFormat: @"%@", [activateServiceInfo objectForKey: @"expired_at"]];
                  dispatch_async(dispatch_get_main_queue(), ^() {
                      [self setActivateLicense: name andExpireDate: expired_at];
                      action = HOME_GET_LICENSES;
                      if ([public checkNetWorkConn])
                      {
                          // get service information
                          [self getLicenseServiceInfo: deviceId andCodeList: homeRenewCodeList];
                      }
                      else
                      {
                          [self.errorView setHidden: NO];
                      }
                  });
              }
              else
              {
                  // response error .. activate failed
                  dispatch_async(dispatch_get_main_queue(), ^() {
                      NSString *errorMsg = [public checkErrorCode: code];
                      if ([errorMsg isEqualToString: @"unknow"])
                      {
                          [renewErrMessageList addObject: message];
                      }
                      else
                      {
                          [renewErrMessageList addObject: errorMsg];
                      }
                      [renewErrServiceIdList addObject: serviceId];
                      [renewErrMessageList addObject: message];
                      [self.renewRegisteredLicenseList reloadData];
                      [self.errorView setHidden: YES];
                      [m_HUD setHidden: YES];
                  });
              }
          }
          else
          {
              // no response
              response_debug(@"No response data");
              [self.errorView setHidden: NO];
              [m_HUD setHidden: YES];
          }
      }] resume];
}
// API 4 LOG single license REGISTER
- (void)scanActivateLicenseInfo:(NSString *)deviceId andLicenseKey:(NSString *)licenseKey andEventType:(NSString *)eventType
{
    [m_HUD setHidden: NO];
    NSError *error;
    bundleEventType = eventType;
    NSUUID *udid = [UIDevice currentDevice].identifierForVendor;
    NSString *os = [NSString stringWithFormat: @"ios %@", [[UIDevice currentDevice]systemVersion]];
    NSString *payloadFormat = [NSString stringWithFormat: @"{"
                               "\"pretend\": true,"
                               "\"udid\": \"%@\","
                               "\"os\": \"%@\","
                               "\"event_type\": \"%@\","
                               "\"device_id\": \"%@\","
                               "\"license_key\": \"%@\""
                               "}", [NSString stringWithFormat: @"%@", udid], os, eventType, deviceId, licenseKey];
    NSData *payloadJson = [payloadFormat dataUsingEncoding: NSUTF8StringEncoding];
    NSDictionary *payload = [NSJSONSerialization JSONObjectWithData: payloadJson options: kNilOptions error: &error];
    debug(@"payload = %@", payload);
    NSString *token = [Jwt encodeWithPayload: payload andKey: [public get_secret_access_key] andError:&error];
    if(token == nil)
    {
        // Print error
        debug(@"Code: %li", (long)[error code]);
        debug(@"Reason: %@", [error localizedFailureReason]);
    }
    else
    {
        debug(@"jwt token = %@", token);
    }
    NSString *get_activate_license_info_url = [NSString stringWithFormat: @"%@/api/v2/my/device/licenses/renew?token=%@&access_key_id=%@", DATA_URL, token, [public get_access_key_id]];
    debug(@"scan_activate_license_info_url = %@", get_activate_license_info_url);
    NSURL *url = [NSURL URLWithString: get_activate_license_info_url];
    NSMutableURLRequest *request_user_info = [NSMutableURLRequest requestWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [request_user_info setHTTPMethod: @"POST"];
    [request_user_info setValue: [public get_access_token] forHTTPHeaderField: @"Authorization"];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest: request_user_info
                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
      {
          if (data != nil)
          {
              NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData: data options: kNilOptions error: nil];
              debug(@"activate license info = %@", json);
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
                  debug(@"activate license info = %@", activateLicenseInfo);
                  NSMutableDictionary *activate_license_info_json = [NSJSONSerialization JSONObjectWithData: aes_decode_data options:kNilOptions error: nil];
                  NSInteger total = [[activate_license_info_json objectForKey: @"total"]integerValue];
                  if (total > 0)
                  {
                      // single license
                      NSArray *activateServiceInfo = [activate_license_info_json objectForKey: @"services"];
                      NSString *name = [[NSString alloc]init];
                      NSString *expired_at = [[NSString alloc]init];
                      for (int i=0; i<[activateServiceInfo count]; i++) {
                          NSDictionary *data = [activateServiceInfo objectAtIndex: i];
                          name = [NSString stringWithFormat: @"%@", [data objectForKey: @"name"]];
                          expired_at = [NSString stringWithFormat: @"%@", [data objectForKey: @"expired_at"]];
                      }
                      dispatch_async(dispatch_get_main_queue(), ^() {
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
                      [self.errorView setHidden: YES];
                      [m_HUD setHidden: YES];
                  }
              }
              else if ([code isEqualToString: @"400.5.16"])
              {
                  // boundle licnese
                  NSString *encryptionCode = [json objectForKey: @"data"];
                  NSString *iv = [encryptionCode substringWithRange: NSMakeRange(0, 16)];
                  NSString *encrypted_data = [encryptionCode substringFromIndex: 16];
                  NSString *sha256_decode_data = [public sha256: [public get_secret_access_key]];
                  NSData *decode_key = [public hexToBytes: sha256_decode_data];
                  
                  NSData *base64_decode_data = [[NSData alloc]initWithData: (NSData *)[public base64_decode: encrypted_data]];
                  NSData *aes_decode_data = [[NSData alloc]initWithData: [public aes_cbc_256: base64_decode_data andIv: iv andkey: decode_key andType: kCCDecrypt]];
                  
                  NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingUTF8);
                  NSString *activateLicenseInfo = [[NSString alloc]initWithData: aes_decode_data encoding: enc];
                  debug(@"activate license info = %@", activateLicenseInfo);
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
                              debug(@"name = %@, amount = %@, renewed = %@", [data objectForKey: @"name"], [data objectForKey: @"amount"], [data objectForKey: @"renew"]);
                              // insert activate data
                              UILabel *showName = [[UILabel alloc]initWithFrame: CGRectMake(0, i*30, 120, 20)];
                              [showName setFont: [UIFont systemFontOfSize: 13]];
                              [showName setText: [NSString stringWithFormat: @"%@", [data objectForKey: @"name"]]];
                              UILabel *showDate = [[UILabel alloc]initWithFrame: CGRectMake(120, i*30, 160, 20)];
                              [showDate setFont: [UIFont systemFontOfSize: 13]];
                              NSInteger amountProc = [[data objectForKey: @"amount"]integerValue];
                              [showDate setText: [public getServiceTime: amountProc]];
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
                          [self.errorView setHidden: YES];
                          [m_HUD setHidden: YES];
                      });
                  }
                  else
                  {
                      // no service data
                      [self.scanViewMessage setText: @"no service data"];
                      [self.scanViewMessage setHidden: NO];
                      _scanStatus = YES;
                      [self.errorView setHidden: YES];
                      [m_HUD setHidden: YES];
                  }
              }
              else
              {
                  dispatch_async(dispatch_get_main_queue(), ^() {
                      NSString *errorMsg = [public checkErrorCode: code];
                      if ([errorMsg isEqualToString: @"unknow"])
                      {
                          [self.scanViewMessage setText: message];
                      }
                      else
                      {
                         [self.scanViewMessage setText: errorMsg];
                      }
                      [self.scanViewMessage setHidden: NO];
                      _scanStatus = YES;
                      [self.errorView setHidden: YES];
                      [m_HUD setHidden: YES];
                  });
              }
          }
          else
          {
              // no response data
              [self.tabBarController.tabBar setHidden: YES];
              [self.errorView setHidden: NO];
              [m_HUD setHidden: YES];
          }
      }] resume];
}
// API 4 LOG bundle license
- (void)activateMutiLicense:(NSString *)deviceId andLicenseKey:(NSString *)licenseKey
{
    [m_HUD setHidden: NO];
    NSError *error;
    NSUUID *udid = [UIDevice currentDevice].identifierForVendor;
    NSString *os = [NSString stringWithFormat: @"ios %@", [[UIDevice currentDevice]systemVersion]];
    NSString *payloadFormat = [NSString stringWithFormat: @"{"
                               "\"pretend\": false,"
                               "\"udid\": \"%@\","
                               "\"os\": \"%@\","
                               "\"event_type\": \"%@\","
                               "\"device_id\": \"%@\","
                               "\"license_key\": \"%@\""
                               "}", [NSString stringWithFormat: @"%@", udid], os, bundleEventType, deviceId, licenseKey];
    NSData *payloadJson = [payloadFormat dataUsingEncoding: NSUTF8StringEncoding];
    NSDictionary *payload = [NSJSONSerialization JSONObjectWithData: payloadJson options: kNilOptions error: &error];
    debug(@"payload = %@", payload);
    NSString *token = [Jwt encodeWithPayload: payload andKey: [public get_secret_access_key] andError:&error];
    if(token == nil)
    {
        // Print error
        debug(@"Code: %li", (long)[error code]);
        debug(@"Reason: %@", [error localizedFailureReason]);
    }
    else
    {
        debug(@"jwt token = %@", token);
    }
    NSString *get_activate_license_info_url = [NSString stringWithFormat: @"%@/api/v2/my/device/licenses/renew?token=%@&access_key_id=%@", DATA_URL, token, [public get_access_key_id]];
    debug(@"scan_activate_license_info_url = %@", get_activate_license_info_url);
    NSURL *url = [NSURL URLWithString: get_activate_license_info_url];
    NSMutableURLRequest *request_user_info = [NSMutableURLRequest requestWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [request_user_info setHTTPMethod: @"POST"];
    [request_user_info setValue: [public get_access_token] forHTTPHeaderField: @"Authorization"];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest: request_user_info
                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
      {
          if (data != nil)
          {
              NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData: data options: kNilOptions error: nil];
              debug(@"activate license info = %@", json);
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
                  debug(@"activate license info = %@", activateLicenseInfo);
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
                          [self.errorView setHidden: YES];
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
                  // response error
                  debug(@"error code = %@, error message = %@", code, message);
                  [self.errorView setHidden: YES];
                  [m_HUD setHidden: YES];
              }
          }
          else
          {
              // no response data
              response_debug(@"No response data");
              [self.errorView setHidden: NO];
              [m_HUD setHidden: YES];
          }
      }] resume];
}
// API NOTIFICATION REGISTER DEVICE
- (void)registerDevice
{
    NSString *timeStamp = [public getTimeStamp];
    NSString *signature = [[NSString alloc]initWithString: [public generateSign: REGISTER_DEVICE andTimeStamp: timeStamp andInboxId: nil]];
    NSString *sigFormat = [signature substringToIndex: 344];
    NSString *register_device_url = [NSString stringWithFormat: @"%@/v1/devices", PUSH_SITE];
    NSURL *url = [NSURL URLWithString: register_device_url];
    NSMutableURLRequest *request_register_device = [NSMutableURLRequest requestWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 30];
    [request_register_device setHTTPMethod: @"POST"];
    [request_register_device setValue: API_KEY forHTTPHeaderField: @"X-Api-Key"];
    [request_register_device setValue: sigFormat forHTTPHeaderField: @"X-Signature"];
    [request_register_device setValue: timeStamp forHTTPHeaderField: @"X-Timestamp"];
    [request_register_device setValue: @"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField: @"Content-Type"];
    NSString *deviceToken = [public get_device_token];
    NSString *urlEncode = [public stringByAddingPercentEscapesForURLParameter: [public getAppInfo]];
    NSString *stringData = [NSString stringWithFormat: @"access_key_id=%@&udid=%@&push_token=%@&app_info=%@", AKID, [public get_pushUDID], deviceToken, urlEncode];
    NSData *postData = [stringData dataUsingEncoding: NSUTF8StringEncoding];
    [request_register_device setHTTPBody: postData];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest: request_register_device
                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                    if (data != nil)
                    {
                        NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData: data options: kNilOptions error: nil];
                        push_debug(@"json = %@", json);
//                        if ([[json objectForKey: @"code"] isEqualToString: @"0000"])
//                        {
                            [self bindingDevice];
//                        }
                    }
                }] resume];
}
// API NOTIFICATION BINDING DEVICE
- (void)bindingDevice
{
    NSString *timeStamp = [public getTimeStamp];
    NSString * signature = [[NSString alloc]initWithString: [public generateSign: BINDING_DEVICE andTimeStamp: timeStamp andInboxId: nil]];
    NSString *sigFormat = [signature substringToIndex: 344];
    NSString *register_device_url = [NSString stringWithFormat: @"%@/v1/devices/binding", PUSH_SITE];
    NSURL *url = [NSURL URLWithString: register_device_url];
    NSMutableURLRequest *request_register_device = [NSMutableURLRequest requestWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 30];
    [request_register_device setHTTPMethod: @"POST"];
    [request_register_device setValue: API_KEY forHTTPHeaderField: @"X-Api-Key"];
    [request_register_device setValue: sigFormat forHTTPHeaderField: @"X-Signature"];
    [request_register_device setValue: timeStamp forHTTPHeaderField: @"X-Timestamp"];
    [request_register_device setValue: @"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField: @"Content-Type"];
    NSString *urlEncode = [public stringByAddingPercentEscapesForURLParameter: [public get_user_id]];
    NSString *stringData = [NSString stringWithFormat: @"access_key_id=%@&udid=%@&user_id=%@", AKID, [public get_pushUDID], urlEncode];
    NSData *postData = [stringData dataUsingEncoding: NSUTF8StringEncoding];
    [request_register_device setHTTPBody: postData];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest: request_register_device
                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                    if (data != nil)
                    {
                        NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData: data options: kNilOptions error: nil];
                        push_debug(@"json = %@", json);
                        if ([[json objectForKey: @"code"] isEqualToString: @"0000"])
                        {
                            //[self writePushInfo];
//                            bindingRes = YES;
                        }
                    }
                    
                }] resume];
}
// API NOTIFICATION UPDATE DEVICE
- (void)updateDevice
{
    NSString *timeStamp = [public getTimeStamp];
    NSString *signature = [[NSString alloc]initWithString: [public generateSign: BINDING_DEVICE andTimeStamp: timeStamp andInboxId: nil]];
    NSString *sigFormat = [signature substringToIndex: 344];
    NSString *register_device_url = [NSString stringWithFormat: @"%@/v1/devices", PUSH_SITE];
    NSURL *url = [NSURL URLWithString: register_device_url];
    NSMutableURLRequest *request_register_device = [NSMutableURLRequest requestWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 30];
    [request_register_device setHTTPMethod: @"PUT"];
    [request_register_device setValue: API_KEY forHTTPHeaderField: @"X-Api-Key"];
    [request_register_device setValue: sigFormat forHTTPHeaderField: @"X-Signature"];
    [request_register_device setValue: timeStamp forHTTPHeaderField: @"X-Timestamp"];
    [request_register_device setValue: @"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField: @"Content-Type"];
    NSString *deviceToken = [public get_device_token];
    NSString *urlEncode = [public stringByAddingPercentEscapesForURLParameter: [public getAppInfo]];
    NSString *stringData = [NSString stringWithFormat: @"access_key_id=%@&udid=%@&push_token=%@&app_info=%@", AKID, [public get_pushUDID], deviceToken, urlEncode];
    NSData *postData = [stringData dataUsingEncoding: NSUTF8StringEncoding];
    [request_register_device setHTTPBody: postData];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest: request_register_device
                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                    if (data != nil)
                    {
                        NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData: data options: kNilOptions error: nil];
                        push_debug(@"json = %@", json);
                    }
                }] resume];
}
// API NOTIFICATION BINDING DEVICE
- (void)unBindingDevice
{
    NSString *timeStamp = [public getTimeStamp];
    NSString *signature = [[NSString alloc]initWithString: [public generateSign: BINDING_DEVICE andTimeStamp: timeStamp andInboxId: nil]];
    NSString *sigFormat = [signature substringToIndex: 344];
    NSString *register_device_url = [NSString stringWithFormat: @"%@/v1/devices/binding", PUSH_SITE];
    NSURL *url = [NSURL URLWithString: register_device_url];
    NSMutableURLRequest *request_register_device = [NSMutableURLRequest requestWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 30];
    [request_register_device setHTTPMethod: @"DELETE"];
    [request_register_device setValue: API_KEY forHTTPHeaderField: @"X-Api-Key"];
    [request_register_device setValue: sigFormat forHTTPHeaderField: @"X-Signature"];
    [request_register_device setValue: timeStamp forHTTPHeaderField: @"X-Timestamp"];
    [request_register_device setValue: @"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField: @"Content-Type"];
    NSString *urlEncode = [public stringByAddingPercentEscapesForURLParameter: [public get_user_id]];
    NSString *stringData = [NSString stringWithFormat: @"access_key_id=%@&udid=%@&user_id=%@", AKID, [public get_pushUDID], urlEncode];
    NSData *postData = [stringData dataUsingEncoding: NSUTF8StringEncoding];
    [request_register_device setHTTPBody: postData];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest: request_register_device
                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                    if (data != nil)
                    {
                        NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData: data options: kNilOptions error: nil];
                        push_debug(@"json = %@", json);
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
    NSString *displayValue = [NSString stringWithFormat:@"%ld", (long)expiredCount];
    [self.expiredCountLbl setText: displayValue];
    // test expired count width..
    //[self.expiredCountLbl setText: @"9999"];
    [self.expiredCountLbl setHidden: NO];
    self.pageControl.userInteractionEnabled = NO;
    [self.displayView setPagingEnabled:YES];
    [self.displayView setShowsHorizontalScrollIndicator:NO];
    [self.displayView setShowsVerticalScrollIndicator:NO];
    [self.displayView setScrollsToTop:NO];
    serviceCodeList = [[NSMutableArray alloc]init];
    for (int i=0; i<expiredCount; i++) {
        serviceNameList = [[NSMutableArray alloc]init];
        serviceRemainAmountList = [[NSMutableArray alloc]init];
        serviceGracePeriodList = [[NSMutableArray alloc]init];
        serviceGraceRemainAmoutList = [[NSMutableArray alloc]init];
//        serviceTypeList = [[NSMutableArray alloc]init];
        
        NSString *service = [NSString stringWithFormat: @"%@", [homeDeviceServiceList objectAtIndex: i]];
        if ([service length] > 0)
        {
            NSString *codeTmp = [[NSString alloc]init];
            NSArray *serviceInfo = [service componentsSeparatedByString: @","];
            for (int j=0; j<[serviceInfo count]; j++)
            {
                //            for (NSString *str in serviceInfo)
                //            {
                NSArray *serviceDetailInfo = [serviceInfo[j] componentsSeparatedByString: @"/"];
                
                NSString *gracePeriod = [NSString stringWithFormat: @"%@", serviceDetailInfo[1]];
                if ([gracePeriod isEqualToString: @"1"])
                {
                    [serviceGracePeriodList addObject: @"YES"];
                }
                else
                {
                    [serviceGracePeriodList addObject: @"NO"];
                }
                [serviceGraceRemainAmoutList addObject: [NSString stringWithFormat: @"%@", serviceDetailInfo[2]]];
                [serviceNameList addObject: serviceDetailInfo[3]];
                if (j == 0)
                {
                    codeTmp = [NSString stringWithFormat: @"\"%@\"", serviceDetailInfo[4]];
                }
                else
                {
                    codeTmp = [codeTmp stringByAppendingString: [NSString stringWithFormat: @",\"%@\"", serviceDetailInfo[4]]];
                }
                NSInteger day = [serviceDetailInfo[5]integerValue];
                NSString *remain_amount = [public getExpiringTime: day];
                [serviceRemainAmountList addObject: remain_amount];
            }
            debug(@"codeTmp = %@", codeTmp);
            [serviceCodeList addObject: codeTmp];
            debug(@"serviceCodeList = %@", serviceCodeList);
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
                servicePage = [[UIView alloc]initWithFrame: CGRectMake(i*265, 0, 265, self.displayView.frame.size.height)];
                reduce = [[UIImageView alloc]initWithFrame: CGRectMake(20, 104, 225, 40)];
                contentView = [[UIScrollView alloc]initWithFrame: CGRectMake(0, 134, 265, 172)];
                deviceName = [[UILabel alloc]initWithFrame: CGRectMake(20, 70, 225, 30)];
                deviceMac = [[UILabel alloc]initWithFrame: CGRectMake(20, 94, 225, 30)];
                deviceIndex = [[UILabel alloc]initWithFrame: CGRectMake(2, 14, 30, 30)];
                renewBtn = [[UIButton alloc]initWithFrame: CGRectMake(92, 310, 100, 40)];
                break;
            case 2:
                servicePage = [[UIView alloc]initWithFrame: CGRectMake(i*320, 0, 320, self.displayView.frame.size.height)];
                reduce = [[UIImageView alloc]initWithFrame: CGRectMake(20, 124, 280, 40)];
                contentView = [[UIScrollView alloc]initWithFrame: CGRectMake(0, 154, 320, 256)];
                deviceName = [[UILabel alloc]initWithFrame: CGRectMake(20, 90, 280, 30)];
                deviceMac = [[UILabel alloc]initWithFrame: CGRectMake(20, 114, 280, 30)];
                deviceIndex = [[UILabel alloc]initWithFrame: CGRectMake(4, 24, 30, 30)];
                renewBtn = [[UIButton alloc]initWithFrame: CGRectMake(120, 409, 100, 40)];
                break;
            case 3:
                servicePage = [[UIView alloc]initWithFrame: CGRectMake(i*359, 0, 359, self.displayView.frame.size.height)];
                reduce = [[UIImageView alloc]initWithFrame: CGRectMake(20, 144, 319, 40)];
                contentView = [[UIScrollView alloc]initWithFrame: CGRectMake(0, 174, 359, 304)];
                deviceName = [[UILabel alloc]initWithFrame: CGRectMake(20, 110, 319, 30)];
                deviceMac = [[UILabel alloc]initWithFrame: CGRectMake(20, 134, 319, 30)];
                deviceIndex = [[UILabel alloc]initWithFrame: CGRectMake(6, 34, 30, 30)];
                renewBtn = [[UIButton alloc]initWithFrame: CGRectMake(139, 478, 100, 40)];
                break; 
        }

//        [deviceName setBackgroundColor: [UIColor redColor]];
//        [deviceMac setBackgroundColor: [UIColor blueColor]];
//        [contentView setBackgroundColor: [UIColor yellowColor]];
        [reduce setImage: [UIImage imageNamed: @"reduce.png"]];
        [contentView setScrollEnabled: YES];
        [deviceName setText: [NSString stringWithFormat: @"%@", [homeDeviceNameList objectAtIndex: i]]];
        [deviceName setTextAlignment: NSTextAlignmentRight];
        [deviceName setFont: [UIFont fontWithName: @"CenturyGothic-Bold" size: 15]];
        
        [deviceMac setText: [NSString stringWithFormat: @"%@", [homeDeviceMacList objectAtIndex: i]]];
        [deviceMac setTextAlignment: NSTextAlignmentRight];
        [deviceMac setTextColor: [UIColor darkGrayColor]];
        [deviceMac setFont: [UIFont fontWithName: @"CenturyGothic-Bold" size: 15]];
        [deviceIndex setText: [NSString stringWithFormat: @"%d", i+1]];
        
        [deviceIndex setTextAlignment: NSTextAlignmentCenter];
        [deviceIndex setFont:[UIFont systemFontOfSize: 12]];
        [deviceIndex setTextColor: [UIColor whiteColor]];
        [renewBtn setTitle: @"Renew" forState: UIControlStateNormal];
        [renewBtn setBackgroundImage: [UIImage imageNamed: @"renew_btn.png"] forState: UIControlStateNormal];
        [renewBtn.layer setCornerRadius: renewBtn.frame.size.height/2];
        [renewBtn.titleLabel setFont: [UIFont fontWithName: @"CenturyGothic-Bold" size:15]];
        // device index
        [renewBtn setTag: i];
        [renewBtn addTarget: self action: @selector(renewBtn:) forControlEvents: UIControlEventTouchUpInside];
        [servicePage addSubview: deviceName];
        [servicePage addSubview: deviceMac];
        [servicePage addSubview: deviceIndex];
        [servicePage addSubview: reduce];
        [servicePage addSubview: contentView];
        [servicePage addSubview: renewBtn];
        
        [contentView setBounces: NO];
        [contentView setShowsHorizontalScrollIndicator: NO];
        [contentView setShowsVerticalScrollIndicator: NO];
        
        [deviceName setTranslatesAutoresizingMaskIntoConstraints: NO];
        [deviceMac setTranslatesAutoresizingMaskIntoConstraints: NO];
        [reduce setTranslatesAutoresizingMaskIntoConstraints: NO];
        [contentView setTranslatesAutoresizingMaskIntoConstraints: NO];
        // width or height layout
        NSLayoutConstraint *deviceNameHL = [NSLayoutConstraint constraintWithItem: deviceName attribute: NSLayoutAttributeHeight relatedBy: NSLayoutRelationGreaterThanOrEqual toItem: nil attribute: NSLayoutAttributeNotAnAttribute multiplier: 1 constant: 22];
        NSLayoutConstraint *deviceMacHL = [NSLayoutConstraint constraintWithItem: deviceMac attribute: NSLayoutAttributeHeight relatedBy: NSLayoutRelationGreaterThanOrEqual toItem: nil attribute: NSLayoutAttributeNotAnAttribute multiplier: 1 constant: 22];
        NSLayoutConstraint *reduceHL = [NSLayoutConstraint constraintWithItem: reduce attribute: NSLayoutAttributeHeight relatedBy: NSLayoutRelationEqual toItem: nil attribute: NSLayoutAttributeNotAnAttribute multiplier: 1 constant: 40];
        NSLayoutConstraint *renewBtnHL = [NSLayoutConstraint constraintWithItem: renewBtn attribute: NSLayoutAttributeHeight relatedBy: NSLayoutRelationEqual toItem: nil attribute: NSLayoutAttributeNotAnAttribute multiplier: 1 constant: 40];
        NSLayoutConstraint *renewBtnWL = [NSLayoutConstraint constraintWithItem: renewBtn attribute: NSLayoutAttributeWidth relatedBy: NSLayoutRelationEqual toItem: nil attribute: NSLayoutAttributeNotAnAttribute multiplier: 1 constant: 100];
        // renew button
        NSLayoutConstraint *renewBtnBL = [NSLayoutConstraint constraintWithItem: renewBtn attribute: NSLayoutAttributeBottom relatedBy: NSLayoutRelationEqual toItem: servicePage attribute: NSLayoutAttributeBottom multiplier: 1 constant: -20];
        NSLayoutConstraint *renewBtnCenterL = [NSLayoutConstraint constraintWithItem: renewBtn attribute: NSLayoutAttributeCenterX relatedBy: NSLayoutRelationEqual toItem: servicePage attribute: NSLayoutAttributeCenterX multiplier: 1 constant: 0];
        // device mac
        NSLayoutConstraint *deviceMacTL = [NSLayoutConstraint constraintWithItem: deviceMac attribute: NSLayoutAttributeTop relatedBy: NSLayoutRelationEqual toItem: deviceName attribute: NSLayoutAttributeBottom multiplier: 1 constant: 0];
        NSLayoutConstraint *deviceMacRL = [NSLayoutConstraint constraintWithItem: deviceMac attribute: NSLayoutAttributeLeading relatedBy: NSLayoutRelationEqual toItem: servicePage attribute: NSLayoutAttributeLeading multiplier: 1 constant: 20];
        NSLayoutConstraint *deviceMacLL = [NSLayoutConstraint constraintWithItem: deviceMac attribute: NSLayoutAttributeTrailing relatedBy: NSLayoutRelationEqual toItem: servicePage attribute: NSLayoutAttributeTrailing multiplier: 1 constant: -20];
        // device name
        NSLayoutConstraint *deviceNameTL = [NSLayoutConstraint constraintWithItem: deviceName attribute: NSLayoutAttributeTop relatedBy: NSLayoutRelationEqual toItem: servicePage attribute: NSLayoutAttributeTop multiplier: 1 constant: 70];
        NSLayoutConstraint *deviceNameRL = [NSLayoutConstraint constraintWithItem: deviceName attribute: NSLayoutAttributeLeading relatedBy: NSLayoutRelationEqual toItem: servicePage attribute: NSLayoutAttributeLeading multiplier: 1 constant: 20];
        NSLayoutConstraint *deviceNameLL = [NSLayoutConstraint constraintWithItem: deviceName attribute: NSLayoutAttributeTrailing relatedBy: NSLayoutRelationEqual toItem: servicePage attribute: NSLayoutAttributeTrailing multiplier: 1 constant: -20];
        // reduce
        NSLayoutConstraint *reduceTL = [NSLayoutConstraint constraintWithItem: reduce attribute: NSLayoutAttributeTop relatedBy: NSLayoutRelationEqual toItem: deviceMac attribute: NSLayoutAttributeBottom multiplier: 1 constant: -10];
        NSLayoutConstraint *reduceRL = [NSLayoutConstraint constraintWithItem: reduce attribute: NSLayoutAttributeLeading relatedBy: NSLayoutRelationEqual toItem: servicePage attribute: NSLayoutAttributeLeading multiplier: 1 constant: 20];
        NSLayoutConstraint *reduceLL = [NSLayoutConstraint constraintWithItem: reduce attribute: NSLayoutAttributeTrailing relatedBy: NSLayoutRelationEqual toItem: servicePage attribute: NSLayoutAttributeTrailing multiplier: 1 constant: -20];
        // content view
        NSLayoutConstraint *contentViewTL = [NSLayoutConstraint constraintWithItem: contentView attribute: NSLayoutAttributeTop relatedBy: NSLayoutRelationEqual toItem: reduce attribute: NSLayoutAttributeBottom multiplier: 1 constant: -10];
        NSLayoutConstraint *contentViewLL = [NSLayoutConstraint constraintWithItem: contentView attribute: NSLayoutAttributeLeading relatedBy: NSLayoutRelationEqual toItem: servicePage attribute: NSLayoutAttributeLeading multiplier: 1 constant: 0];
        NSLayoutConstraint *contentViewRL = [NSLayoutConstraint constraintWithItem: contentView attribute: NSLayoutAttributeTrailing relatedBy: NSLayoutRelationEqual toItem: servicePage attribute: NSLayoutAttributeTrailing multiplier: 1 constant: 0];
        NSLayoutConstraint *contentViewBL = [NSLayoutConstraint constraintWithItem: contentView attribute: NSLayoutAttributeBottom relatedBy: NSLayoutRelationEqual toItem: renewBtn attribute: NSLayoutAttributeTop multiplier: 1 constant: -10];
        
        NSArray *customLayout = [[NSArray alloc]initWithObjects: renewBtnWL, renewBtnHL, renewBtnBL, renewBtnCenterL, reduceHL, reduceTL, reduceRL, reduceLL, deviceMacHL, deviceNameHL, deviceMacTL, deviceMacRL, deviceMacLL, deviceNameTL, deviceNameRL, deviceNameLL, contentViewTL, contentViewRL, contentViewLL, contentViewBL, nil];
        [servicePage addConstraints: customLayout];
        
        UIGraphicsBeginImageContext(servicePage.frame.size);
        [[UIImage imageNamed:@"device_bg.png"] drawInRect: servicePage.bounds];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [servicePage setBackgroundColor: [UIColor colorWithPatternImage: image]];
        [servicePageList addObject: servicePage];
        
        UILabel *code;
        UILabel *amount;
        UILabel *gracePeriod;
        UIView *view;
        
        view = [[UIView alloc]initWithFrame: CGRectMake(0, 0, contentView.frame.size.width, [serviceNameList count]*57)];
        contentView.contentSize = view.bounds.size;
        for (int j=0; j<[serviceNameList count]; j++)
        {
            switch (deviceType)
            {
                case 1:
                    code = [[UILabel alloc]initWithFrame: CGRectMake(15, j*22, 100, 22)];
                    amount = [[UILabel alloc]initWithFrame: CGRectMake(125, j*22, 120, 22)];
                    gracePeriod = [[UILabel alloc]initWithFrame: CGRectMake(125, j*54, 90, 22)];
//                    [contentView setContentSize: CGSizeMake(265, (j*40)+20)];
                    break;
                case 2:
                    code = [[UILabel alloc]initWithFrame: CGRectMake(15, j*22, 100, 22)];
                    amount = [[UILabel alloc]initWithFrame: CGRectMake(180, j*22, 120, 22)];
                    gracePeriod = [[UILabel alloc]initWithFrame: CGRectMake(180, j*54, 90, 22)];
//                    [contentView setContentSize: CGSizeMake(320, (j*40)+20)];
                    break;
                case 3:
                    code = [[UILabel alloc]initWithFrame: CGRectMake(15, j*22, 100, 22)];
                    amount = [[UILabel alloc]initWithFrame: CGRectMake(224, j*22, 120, 22)];
                    gracePeriod = [[UILabel alloc]initWithFrame: CGRectMake(224, j*54, 90, 22)];
//                    [contentView setContentSize: CGSizeMake(359, (j*30)+20)];
                    break;
            }
            //[contentView setBackgroundColor: [UIColor redColor]];
            //[code setText: @"afsafsafasl;fjasl;kfjoa;lfdija;lsfjlkasjflksajfl;kasjfoiwej;lfjdsa;lkfjasl;kfjklas;fj;laksjfl;as"];
            [code setText: [serviceNameList objectAtIndex: j]];
            [code setFont: [UIFont fontWithName: @"CenturyGothic-Bold" size: 15]];
//            [code setBackgroundColor: [UIColor redColor]];
            [code setLineBreakMode: NSLineBreakByWordWrapping];
            [code setNumberOfLines: 0];
            
            [amount setText: [serviceRemainAmountList objectAtIndex: j]];
            [amount setFont: [UIFont fontWithName: @"CenturyGothic" size: 15]];
            [amount setTextColor: [UIColor darkGrayColor]];
            [amount setTextAlignment: NSTextAlignmentRight];
//            [amount setBackgroundColor: [UIColor blueColor]];
            [amount setLineBreakMode: NSLineBreakByWordWrapping];
            [amount setNumberOfLines: 0];
            
            [gracePeriod setTextAlignment: NSTextAlignmentRight];
            [gracePeriod setFont: [UIFont fontWithName: @"CenturyGothic" size: 15]];
            if ([[serviceGracePeriodList objectAtIndex: j] isEqualToString: @"YES"])
            {
                [gracePeriod setText: [NSString stringWithFormat: @"Grace Period: %@ days", [serviceGraceRemainAmoutList objectAtIndex: j]]];
                [gracePeriod setTextColor: [UIColor redColor]];
            }
            else
            {
//                [gracePeriod setText: @"Grace Period: 0 days"];
                [gracePeriod setHidden: YES];
            }
            if ([amount.text isEqualToString: @"Expired"])
            {
                [gracePeriod setTextColor: [UIColor redColor]];
//                [amount setTextColor: [UIColor redColor]];
            }
            
            [view addSubview: code];
            [view addSubview: amount];
            [view addSubview: gracePeriod];
            [contentView addSubview:view];
            //[contentView addSubview: code];
            //[contentView addSubview: amount];
            
            [code setTranslatesAutoresizingMaskIntoConstraints: NO];
            [amount setTranslatesAutoresizingMaskIntoConstraints: NO];
            [gracePeriod setTranslatesAutoresizingMaskIntoConstraints: NO];
            // code layout
            NSLayoutConstraint *codeHL = [NSLayoutConstraint constraintWithItem: code attribute: NSLayoutAttributeHeight relatedBy: NSLayoutRelationGreaterThanOrEqual toItem: nil attribute: NSLayoutAttributeNotAnAttribute multiplier: 1 constant: 22];
            NSLayoutConstraint *codeLL = [NSLayoutConstraint constraintWithItem: code attribute: NSLayoutAttributeLeading relatedBy: NSLayoutRelationEqual toItem: view attribute: NSLayoutAttributeLeading multiplier: 1 constant: 20];
            NSLayoutConstraint *codeTL = [NSLayoutConstraint constraintWithItem: code attribute: NSLayoutAttributeTop relatedBy: NSLayoutRelationEqual toItem: view attribute: NSLayoutAttributeTop multiplier: 1 constant: j*57];
            NSLayoutConstraint *codeRL = [NSLayoutConstraint constraintWithItem: amount attribute: NSLayoutAttributeLeading relatedBy: NSLayoutRelationEqual toItem: code attribute: NSLayoutAttributeTrailing multiplier: 1 constant: 10];
            // amount layout
            NSLayoutConstraint *amountHL = [NSLayoutConstraint constraintWithItem: amount attribute: NSLayoutAttributeHeight relatedBy: NSLayoutRelationEqual toItem: code attribute: NSLayoutAttributeHeight    multiplier: 1 constant: 0];
            NSLayoutConstraint *amountWL = [NSLayoutConstraint constraintWithItem: amount attribute: NSLayoutAttributeWidth relatedBy: NSLayoutRelationEqual toItem: nil attribute: NSLayoutAttributeNotAnAttribute multiplier: 1 constant: 100];
            NSLayoutConstraint *amountRL = [NSLayoutConstraint constraintWithItem: amount attribute: NSLayoutAttributeTrailing relatedBy: NSLayoutRelationEqual toItem: view attribute: NSLayoutAttributeTrailing multiplier: 1 constant: -16];
            NSLayoutConstraint *amountTL = [NSLayoutConstraint constraintWithItem: amount attribute: NSLayoutAttributeTop relatedBy: NSLayoutRelationEqual toItem: view attribute: NSLayoutAttributeTop multiplier: 1 constant: j*57];
            // gracpe peroid layout
            NSLayoutConstraint *gracePeriodTL = [NSLayoutConstraint constraintWithItem: gracePeriod attribute: NSLayoutAttributeTop relatedBy: NSLayoutRelationEqual toItem: code attribute: NSLayoutAttributeBottom multiplier: 1 constant: 0];
            NSLayoutConstraint *gracePeriodRL = [NSLayoutConstraint constraintWithItem: gracePeriod attribute: NSLayoutAttributeTrailing relatedBy: NSLayoutRelationEqual toItem: view attribute: NSLayoutAttributeTrailing multiplier: 1 constant: -16];
            NSLayoutConstraint *gracePeriodLL = [NSLayoutConstraint constraintWithItem: gracePeriod attribute: NSLayoutAttributeLeading relatedBy: NSLayoutRelationEqual toItem: view attribute: NSLayoutAttributeLeading multiplier: 1 constant: 12];
            NSLayoutConstraint *gracePeriodHL = [NSLayoutConstraint constraintWithItem: gracePeriod attribute: NSLayoutAttributeHeight relatedBy: NSLayoutRelationEqual toItem: nil attribute: NSLayoutAttributeNotAnAttribute multiplier: 1 constant: 22];
            
            NSArray *customLayout = [[NSArray alloc]initWithObjects: codeHL, codeLL, codeTL, amountHL, amountTL, amountRL, codeRL, amountWL, gracePeriodTL, gracePeriodRL, gracePeriodHL, gracePeriodLL, nil];
            [contentView addConstraints: customLayout];
        }
        [self.displayView addSubview: servicePage];
        debug(@"service page size = %f, %f", servicePage.frame.size.width, servicePage.frame.size.height);
    }
}
- (void)setActivateLicense:(NSString *)name andExpireDate:(NSString *)expiredDate
{
    [self.scanCancelBtn setHidden: YES];
    [self.scanDoneBtn setHidden: NO];
    [self.renewCancelBtn setHidden: YES];
    [self.renewDoneBtn setHidden: NO];
    [self.activageServiceName setText: name];
    NSArray *dateStr = [expiredDate componentsSeparatedByString: @"T"];
    [self.activateExpireDate setText: [NSString stringWithFormat: @"Expired at %@", [dateStr objectAtIndex: 0]]];
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
                    [self.profileView setFrame: CGRectMake(-255, 0, 255, 568)];
                    break;
                case 2:
                    [self.profileView setFrame: CGRectMake(-310, 0, 310, 667)];
                    break;
                case 3:
                    [self.profileView setFrame: CGRectMake(-349, 0, 349, 736)];
                    break;
            }
            [self.maskView setHidden: YES];
            
        } completion:^(BOOL finished) {
            [self.tabBarController.tabBar setHidden: NO];
            [self.profileView setHidden: YES];
        }];
}
- (void)cleanCacheAndCookie{
    [m_HUD setHidden: NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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
        [cache setDiskCapacity: 0];
        [cache setMemoryCapacity: 0];
        [m_HUD setHidden: YES];
        [self changeView:@"login"];
    });
}
- (void)searchDeviceInfo
{
    [m_HUD setHidden: NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([homeDeviceNameList count] > 0)
        {
            searchDeviceNameList = [[NSMutableArray alloc]init];
            searchDeviceMacList = [[NSMutableArray alloc]init];
            searchKeyWordStatus = NO;
            NSString *keyWord = [self.searchDevicesText.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if ([keyWord length] > 0)
            {
                // show search result
                for (int i=0; i<[homeDeviceNameList count]; i++) {
                    NSRange searchName = [[homeDeviceNameList objectAtIndex: i]rangeOfString: self.searchDevicesText.text options: NSCaseInsensitiveSearch];
                    NSRange searchMac = [[homeDeviceMacList objectAtIndex: i]rangeOfString: self.searchDevicesText.text options: NSCaseInsensitiveSearch];
                    if (searchName.location == NSNotFound && searchMac.location == NSNotFound)
                    {
                        // show no result message
                        [self.searchDeviceExpiredList setHidden: YES];
                        [self.searchNoResView setHidden: NO];
                    }
                    else
                    {
                        [searchDeviceNameList addObject: [homeDeviceNameList objectAtIndex: i]];
                        [searchDeviceMacList addObject: [homeDeviceMacList objectAtIndex: i]];
                        //[self.searchNoResView setHidden: YES];
                        searchKeyWordStatus = YES;
                    }
                }
                if (searchKeyWordStatus == YES)
                {
                    [self.searchDeviceExpiredList reloadData];
                    // show result
                    [self.searchNoResView setHidden: YES];
                    [self.searchDeviceExpiredList setHidden: NO];
                }
            }
            else
            {
                // show all result
                searchKeyWordStatus = NO;
                [self.searchDeviceExpiredList reloadData];
                [self.searchDeviceExpiredList setHidden: NO];
                [self.searchNoResView setHidden: YES];
            }
            [m_HUD setHidden: YES];
        }
        else
        {
            // show no result message
            [self.searchDeviceExpiredList setHidden: YES];
            [self.searchNoResView setHidden: NO];
            [m_HUD setHidden: YES];
        }
    });
}
- (void)manualEnterLicense
{
    [self.scanViewMessage setHidden: YES];
    NSString *licenseKey = self.scanViewEnterLicenseTxt.text;
    action = HOME_MANUAL_ACTIVATE_LICENSE;
    if ([public checkNetWorkConn])
    {
        [self scanActivateLicenseInfo: [NSString stringWithFormat: @"%ld", (long)self.renewServiceName.tag] andLicenseKey: licenseKey andEventType: @"manually"];
    }
    else
    {
        [self.errorView setHidden: NO];
    }
}
- (void)hiddeKeyboard
{
    // hidde keyboard
    [[[UIApplication sharedApplication]keyWindow]endEditing: YES];
}
- (void)changeView:(NSString *)pageName
{
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:pageName];
    [self presentViewController:vc animated:YES completion:nil];
}
- (void)checkPushInfo
{
    [self registerDevice];
}
- (void)checkTutoriaInfo
{
    if([public checkTutoriaInfo: @"homeT"]) [self.tutoriaHomeTView setHidden: YES];
    if([public checkTutoriaInfo: @"registerST"]) [self.tutoriaRegisterSTView setHidden: YES];
}
- (void)selfLayout
{
    switch (public.getDeviceType)
    {
        case 1:
            [self.tryAgainBtn setFrame: CGRectMake(124, 360, 73, 30)];
            [self.errorLbl setFrame: CGRectMake(60, 54, 200, 21)];
            [self.tutoriaHomeTBtn setFrame: CGRectMake(66, 473, 188, 32)];
            [self.registerSTBtn setFrame: CGRectMake(66, 517, 188, 32)];
            break;
        case 2:
            [self.tryAgainBtn setFrame: CGRectMake(144, 424, 87, 33)];
            [self.errorLbl setFrame: CGRectMake(87, 66, 200, 21)];
            [self.tutoriaHomeTBtn setFrame: CGRectMake(80, 562, 216, 40)];
            [self.registerSTBtn setFrame: CGRectMake(80, 606, 216, 40)];
            break;
        case 3:
            [self.tryAgainBtn setFrame: CGRectMake(160, 468, 93, 35)];
            [self.errorLbl setFrame: CGRectMake(107, 74, 200, 21)];
            [self.tutoriaHomeTBtn setFrame: CGRectMake(88, 625, 240, 44)];
            [self.registerSTBtn setFrame: CGRectMake(88, 669, 240, 44)];
            break;
        case 4:
            [self.tryAgainBtn setFrame: CGRectMake(144, 516, 87, 40)];
            [self.errorLbl setFrame: CGRectMake(87, 82, 200, 22)];
            [self.tutoriaHomeTBtn setFrame: CGRectMake(80, 663, 216, 47)];
            [self.registerSTBtn setFrame: CGRectMake(80, 707, 216, 47)];
        default:
            // other size
            break;
    }
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
                debug(@"scan data = %@", metadataObject.stringValue);
                boundleLicense = metadataObject.stringValue;
                HomeScanServiceName = [NSString stringWithFormat: @"%ld", (long)self.renewServiceName.tag];
                homeScanLicenseKey = metadataObject.stringValue;
                _scanStatus = NO;
                action = HOME_SCAN_ACTIVATE_LICENSE;
                if ([public checkNetWorkConn])
                {
                    [self scanActivateLicenseInfo: [NSString stringWithFormat: @"%ld", (long)self.renewServiceName.tag] andLicenseKey: metadataObject.stringValue andEventType: @"scan"];
                }
                else
                {
                    [self.errorView setHidden: NO];
                }
                
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
    else if (renewStatus == YES)
    {
        count = [renewServiceNameList count];
    }
    else if (completeStatus == YES)
    {
        count = [activateLicenseNameList count];
    }
    tableview_debug(@"searchDeviceListStatus = %d, renewStatus = %d, completeStatus = %d", searchDevicesListStatus, renewStatus, completeStatus);
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
    else if (renewStatus == YES)
    {
        RegisteredLicenseListCell *registeredLicensCell = [tableView dequeueReusableCellWithIdentifier: @"registeredLicenseListCell"];
        [registeredLicensCell.serviceName setText: [renewServiceNameList objectAtIndex: indexPath.row]];
        NSInteger amountProc = [[renewServiceAmountList objectAtIndex: indexPath.row]integerValue];
        NSString *amountStr = [public getServiceTime: amountProc];
        [registeredLicensCell.serviceAmount setText: amountStr];
        [registeredLicensCell.count.layer setMasksToBounds: YES];
        [registeredLicensCell.count.layer setCornerRadius: registeredLicensCell.count.frame.size.width/2];
        [registeredLicensCell.count setText: [renewServiceTotalList objectAtIndex: indexPath.row]];
        [registeredLicensCell.activate setTag: indexPath.row];
        [registeredLicensCell.activate addTarget: self action: @selector(renewActivateBtn:) forControlEvents: UIControlEventTouchUpInside];
        // filter module code
        debug(@"renew license module code = %@", [NSString stringWithFormat: @"%@", [renewModuleCodeList objectAtIndex: indexPath.row]]);
        BOOL display = [public checkActivateStatus: [NSString stringWithFormat: @"%@", [renewModuleCodeList objectAtIndex: indexPath.row]]];
        if (display == NO)
        {
            [registeredLicensCell.activate setEnabled: NO];
        }
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
    else if (completeStatus == YES)
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
        [m_HUD setHidden: NO];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self hiddeKeyboard];
            SearchDevicesListCell *cell = [tableView cellForRowAtIndexPath: indexPath];
//            NSInteger searchIndex = [homeDeviceNameList indexOfObject: cell.deviceName.text];
            NSInteger searchIndex = [homeDeviceMacList indexOfObject: cell.macAddress.text];
            [self.displayView setContentOffset:CGPointMake(searchIndex*CGRectGetWidth(self.displayView.frame), 0) animated: NO];
            [self.pageControl setCurrentPage: searchIndex];
            [self.searchView setHidden: YES];
            [self.homeView setHidden: NO];
            [self.tabBarController.tabBar setHidden: NO];
            [m_HUD setHidden: YES];
        });
    }
    return indexPath;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    debug(@"request URL = %@", request.URL);
    
//    NSString *requestUrl = [NSString stringWithFormat: @"%@", request.URL];
//    NSArray *arr = [requestUrl componentsSeparatedByString: @"#"];
//    if ([arr count] == 2)
//    {
//        [self.helpWebView stringByEvaluatingJavaScriptFromString:@"window.document.location.replace(file:///var/containers/Bundle/Application/2B5A5F9F-3AF2-45BF-B5E1-9C6B7FD4615C/MyZyxel.app/WH/myZyxel/myZyxel.html#ww1413657);"];
//        self.helpWebView = nil;
//        NSURL *url = [NSURL URLWithString: requestUrl];
//        NSURLRequest *request = [NSURLRequest requestWithURL: url];
//        [self.helpWebView loadRequest: request];
//        return NO;
//    }
    return YES;
};

@end
