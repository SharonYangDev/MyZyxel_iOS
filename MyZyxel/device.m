//
//  SecondViewController.m
//  MyZyxel
//
//  Created by line on 2017/5/12.
//  Copyright © 2017年 Zyxel. All rights reserved.
//

#import "device.h"
#import "DecodeDevicebyQRcode.h"

@interface device ()<AVCaptureMetadataOutputObjectsDelegate>
{
    UIAlertController *registerDeviceAlert;
    MBProgressHUD *m_HUD;
    BOOL deviceListStatus;
    BOOL deviceDetailStatus;
    BOOL renewStatus;
    BOOL addLicenseScanStatus;
    BOOL registerPage1Status;
    BOOL registerPage2Status;
    BOOL registerPage3Status;
    BOOL registerFinalStatus;
    BOOL _scanStatus;
    BOOL scanStatus;
    BOOL _addLicenseScanStatus;
    BOOL searchStatus;
    BOOL searchKeyWordStatus;
    BOOL activateOkStatus;
    NSInteger deviceCount;
    NSInteger action;
    NSInteger registerDeviceIndex;
    NSInteger registerindex;
    NSMutableArray *deviceNameList;
    NSMutableArray *deviceMacAddrList;
    NSMutableArray *deviceIdList;
//    NSMutableArray *deviceParsedModuleCodeList;
    NSMutableArray *deviceExpireServiceList;
    NSMutableArray *deviceNewRegisterList;
//    NSMutableArray *deviceTypeList;
//    NSMutableArray *deviceGracePeriodStatusList;
//    NSMutableArray *deviceGracePeriodAmountList;
    NSMutableArray *detailServiceNameList;
    NSMutableArray *detailServiceAmountList;
    NSMutableArray *detailServiceExpireAtList;
    NSMutableArray *detailServiceStatusList;
    NSMutableArray *detailGracePeriodList;
    NSMutableArray *detailGracePeriodAmountList;
    NSMutableArray *searchDeviceNameList;
    NSMutableArray *searchDeviceMacList;
    NSMutableArray *searchIdList;
    NSMutableArray *searchExpireServiceList;
    NSMutableArray *renewServiceNameList;
    NSMutableArray *renewServiceAmountList;
    NSMutableArray *renewServiceTotalList;
    NSMutableArray *renewServiceId;
    NSMutableArray *registerNewDeviceNameList;
    NSMutableArray *registerNewDeviceMacList;
    NSMutableArray *registerNewDeviceSnList;
    NSMutableArray *registerNewDeviceEventTypeList;
    NSMutableArray *finalNameList;
    NSMutableArray *finalMacList;
    NSMutableArray *finalMessageList;
    NSMutableArray *addLicenseScanKeyList;
    NSMutableArray *addLicenseScanNameList;
    NSMutableArray *addLicenseEventTypeList;
    NSMutableArray *activateKeyList;
    NSMutableArray *activateNameList;
    NSMutableArray *activateMessageList;
    NSString *detailDeviceId;
    NSString *detailDeviceNames;
    NSString *detailDeviceMac;
    NSString *detailDeviceModelCode;
    NSString *detailSn;
    NSString *detailDeviceResellerCorp;
    NSString *detailDeviceResellerEmail;
    NSString *detailDeviceResellerVat;
    NSString *selectDetailDeviceId;
    NSString *selectServiceId;
    NSString *scanStr;
    NSString *scanMac;
    NSString *scanSn;
    AVCaptureSession *_session;
    AVCaptureSession *_session2;
    ST_DeviceInfo scanDeviceInfo;
}
@end

@implementation device
#pragma mark - SYSTEM FUNCTION
- (void)dealloc
{
    m_HUD = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.manualSerialNumber addTarget: self action: @selector(checkDeviceInfo) forControlEvents: UIControlEventEditingDidEndOnExit];
    [self.manualMacAddress addTarget: self action: @selector(checkDeviceInfo) forControlEvents: UIControlEventEditingDidEndOnExit];
    [self.resellerNameTxt addTarget: self action: @selector(searchReseller) forControlEvents: UIControlEventEditingDidEndOnExit];
    [self.editViewSearchTxt addTarget: self action: @selector(editSearchReseller) forControlEvents: UIControlEventEditingDidEndOnExit];
    [self.addLicenseManualViewTxt addTarget: self action: @selector(verificationLicense) forControlEvents: UIControlEventEditingDidEndOnExit];
    [self.searchDeviceTxt addTarget: self action: @selector(searchDeviceInfo) forControlEvents: UIControlEventEditingDidEndOnExit];
    [self.registerDevicePage1ScanNextBtn.layer setMasksToBounds: YES];
    [self.registerDevicePage1ScanNextBtn.layer setCornerRadius: self.registerDevicePage1ScanNextBtn.frame.size.height/2];
    [self.registerDevicePage1ManualNextBtn.layer setMasksToBounds: YES];
    [self.registerDevicePage1ManualNextBtn.layer setCornerRadius: self.registerDevicePage1ManualNextBtn.frame.size.height/2];
    [self.registerDevicePage2SaveBtn.layer setMasksToBounds: YES];
    [self.registerDevicePage2SaveBtn.layer setCornerRadius: self.registerDevicePage2SaveBtn.frame.size.height/2];
    [self.registerDevicePage3RegisterBtn.layer setMasksToBounds: YES];
    [self.registerDevicePage3RegisterBtn.layer setCornerRadius: self.registerDevicePage3RegisterBtn.frame.size.height/2];
    [self.cancelViewExitBtn.layer setMasksToBounds: YES];
    [self.cancelViewExitBtn.layer setCornerRadius: self.cancelViewExitBtn.frame.size.height/2];
    [self.cancelViewContinueBtn.layer setMasksToBounds: YES];
    [self.cancelViewContinueBtn.layer setCornerRadius: self.cancelViewContinueBtn.frame.size.height/2];
    [self.editViewSaveBtn.layer setMasksToBounds: YES];
    [self.editViewSaveBtn.layer setCornerRadius: self.editViewSaveBtn.frame.size.height/2];
    [self.addlicenseScanActivateBtn.layer setMasksToBounds: YES];
    [self.addlicenseScanActivateBtn.layer setCornerRadius: self.addlicenseScanActivateBtn.frame.size.height/2];
    [self.addlicenseManualActivateBtn.layer setMasksToBounds: YES];
    [self.addlicenseManualActivateBtn.layer setCornerRadius: self.addlicenseManualActivateBtn.frame.size.height/2];
    [self.registerDeiveFinalOkBtn.layer setMasksToBounds: YES];
    [self.registerDeiveFinalOkBtn.layer setCornerRadius: self.registerDeiveFinalOkBtn.frame.size.height/2];
    [self.activateOkBtn.layer setMasksToBounds: YES];
    [self.activateOkBtn.layer setCornerRadius: self.activateOkBtn.frame.size.height/2];
    [self.detailAddLicenseBtn.layer setMasksToBounds: YES];
    [self.detailAddLicenseBtn.layer setCornerRadius: self.detailAddLicenseBtn.frame.size.height/2];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithString: self.addLicenseViewBtn.titleLabel.text];
    [attrString setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Oblique" size:15.0],NSForegroundColorAttributeName:[UIColor darkGrayColor],NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]} range:NSMakeRange(0,[attrString length])];
    [self.addLicenseViewBtn setAttributedTitle: attrString forState: UIControlStateNormal];
    attrString = [[NSMutableAttributedString alloc]initWithString: self.addLicenseScanViewBtn.titleLabel.text];
    [attrString setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Oblique" size:15.0],NSForegroundColorAttributeName:[UIColor darkGrayColor],NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]} range:NSMakeRange(0,[attrString length])];
    [self.addLicenseScanViewBtn setAttributedTitle: attrString forState: UIControlStateNormal];
    attrString = [[NSMutableAttributedString alloc]initWithString: self.addlicenseManualViewBtn.titleLabel.text];
    [attrString setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Oblique" size:15.0],NSForegroundColorAttributeName:[UIColor darkGrayColor],NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]} range:NSMakeRange(0,[attrString length])];
    [self.addlicenseManualViewBtn setAttributedTitle: attrString forState: UIControlStateNormal];
    attrString = [[NSMutableAttributedString alloc]initWithString: self.registerDeviceScanBtn.titleLabel.text];
    [attrString setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Oblique" size:15.0],NSForegroundColorAttributeName:[UIColor darkGrayColor],NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]} range:NSMakeRange(0,[attrString length])];
    [self.registerDeviceScanBtn setAttributedTitle: attrString forState: UIControlStateNormal];
    attrString = [[NSMutableAttributedString alloc]initWithString: self.registerDeviceManualBtn.titleLabel.text];
    [attrString setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Oblique" size:15.0],NSForegroundColorAttributeName:[UIColor darkGrayColor],NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]} range:NSMakeRange(0,[attrString length])];
    [self.registerDeviceManualBtn setAttributedTitle: attrString forState: UIControlStateNormal];
    [self.searchList.layer setShadowColor: [UIColor colorWithRed: 44 green: 62 blue: 80 alpha: 1].CGColor];
    [self.deviceAddDeviceBtn setHitTestEdgeInsets: UIEdgeInsetsMake(60, 60, 60, 60)];
    [self.detailEditBtn setHitTestEdgeInsets: UIEdgeInsetsMake(60, 60, 60, 60)];
    [self.deviceDetailBackBtn setHitTestEdgeInsets: UIEdgeInsetsMake(60, 60, 60, 60)];
    [self.editViewCancelBtn setHitTestEdgeInsets: UIEdgeInsetsMake(80, 60, 80, 60)];
    [self.registerDevicepage1ScanCancelBtn setHitTestEdgeInsets: UIEdgeInsetsMake(60, 60, 60, 60)];
    [self.registerDevicepage1ManualCancelBtn setHitTestEdgeInsets: UIEdgeInsetsMake(60, 60, 60, 60)];
    [self.registerDevicePage2BackBtn setHitTestEdgeInsets: UIEdgeInsetsMake(60, 60, 60, 60)];
    [self.registerDevicePage2CancelBtn setHitTestEdgeInsets: UIEdgeInsetsMake(60, 60,60, 60)];
    [self.registerDevicePage3BackBtn setHitTestEdgeInsets: UIEdgeInsetsMake(60, 60, 60, 60)];
    [self.registerDevicePage3CancelBtn setHitTestEdgeInsets: UIEdgeInsetsMake(60, 60, 60, 60)];
    [self.addLicenseCancelBtn setHitTestEdgeInsets: UIEdgeInsetsMake(60, 60, 60, 60)];
    [self.addLicenseScanViewCancelBtn setHitTestEdgeInsets: UIEdgeInsetsMake(60, 60, 60, 60)];
    [self.addLicenseManualViewCancelBtn setHitTestEdgeInsets: UIEdgeInsetsMake(60, 60, 60, 60)];
    [self.searchDeviceCancelBtn setHitTestEdgeInsets: UIEdgeInsetsMake(60, 60, 60, 60)];
    [self.addLicenseDoneBtn setHitTestEdgeInsets: UIEdgeInsetsMake(60, 60, 60, 60)];
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
    [self selfLayout];
    [self.registerDevicePage1ScanView setHidden: NO];
    [self.registerDevicePage1ManualView setHidden: YES];
    [self.registerDevicePage2View setHidden: YES];
    [self.registerDevicePage3View setHidden: YES];
    [self.registerDeviceListView setHidden: YES];
    [self.deviceDetailView setHidden: YES];
    [self.addLicenseView setHidden: YES];
    [self.editView setHidden: YES];
    [self.addLicenseView setHidden: YES];
    [self.addLicenseScanView setHidden: YES];
    [self.addLicenseManualView setHidden: YES];
    [self.searchDeviceView setHidden: YES];
    [self.noDeviceView setHidden: YES];
    [self.errorView setHidden: YES];
    [self.cancelMask setHidden: YES];
    [self.cancalView setHidden: YES];
    [self.activateOkView setHidden: YES];
    [self.tabBarController.tabBar setUserInteractionEnabled: NO];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
    deviceListStatus = YES;
    action = ENTER_DEVICE;
    [self.view addSubview: m_HUD];
    //[m_HUD showWhileExecuting:@selector(initEnv) onTarget:self withObject:nil animated:YES];
    [self initEnv];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - INIT SETTINGS
- (void)initEnv
{
    self.HiddeKeyboardGesture = [[UITapGestureRecognizer alloc]initWithTarget: self action: @selector(hiddeKeyboard)];
    [self.registerDevicePage2View addGestureRecognizer: self.HiddeKeyboardGesture];
    UITapGestureRecognizer *hiddeKeyBoardEditView = [[UITapGestureRecognizer alloc]initWithTarget: self action: @selector(editViewExitDeviceNameTxt:)];
    UITapGestureRecognizer *hiddeKeyBoardRegisterPage1ManualView = [[UITapGestureRecognizer alloc]initWithTarget: self action: @selector(editViewExitDeviceNameTxt:)];
    UITapGestureRecognizer *hiddeKeyBoardAddlicenseManualView = [[UITapGestureRecognizer alloc]initWithTarget: self action: @selector(editViewExitDeviceNameTxt:)];
    hiddeKeyBoardEditView.cancelsTouchesInView = NO;
    hiddeKeyBoardRegisterPage1ManualView.cancelsTouchesInView = NO;
    hiddeKeyBoardAddlicenseManualView.cancelsTouchesInView = NO;
    [self.editView addGestureRecognizer: hiddeKeyBoardEditView];
    [self.registerDevicePage1ManualView addGestureRecognizer: hiddeKeyBoardRegisterPage1ManualView];
    [self.addLicenseManualView addGestureRecognizer: hiddeKeyBoardAddlicenseManualView];
    [self.devicesList setSeparatorStyle: UITableViewCellSeparatorStyleNone];
    [self.detailServiceList setSeparatorStyle: UITableViewCellSeparatorStyleNone];
    if ([public checkNetWorkConn])
    {
        [self getDeviceInfo];
    }
    else
    {
        [self.deviceView setHidden: YES];
        [self.tabBarController.tabBar setHidden: YES];
        [self.errorView setHidden: NO];
        [m_HUD setHidden: YES];
    }
}
#pragma mark - GET SERVER INFO
// API 1
- (void)getDeviceInfo
{
    [m_HUD setHidden: NO];
    selectDetailDeviceId = [[NSString alloc]init];
    NSError *error;
    NSDictionary *payload = @{
                              @"from": @-2,
                              @"to": @2
                            };
    NSString *token = [Jwt encodeWithPayload: payload andKey: [public get_secret_access_key] andError:&error];
    if(token == nil)
    {
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
    NSMutableURLRequest *request_user_info = [NSMutableURLRequest requestWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 15];
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
                  deviceNameList = [[NSMutableArray alloc]init];
                  deviceMacAddrList = [[NSMutableArray alloc]init];
                  deviceExpireServiceList = [[NSMutableArray alloc]init];
                  deviceNewRegisterList = [[NSMutableArray alloc]init];
                  deviceIdList = [[NSMutableArray alloc]init];
//                  deviceParsedModuleCodeList = [[NSMutableArray alloc]init];
//                  deviceTypeList = [[NSMutableArray alloc]init];
//                  deviceGracePeriodStatusList = [[NSMutableArray alloc]init];
//                  deviceGracePeriodAmountList = [[NSMutableArray alloc]init];
                  NSMutableDictionary *devices_info_json = [NSJSONSerialization JSONObjectWithData: aes_decode_data options:kNilOptions error: nil];
                  deviceCount = [[devices_info_json objectForKey: @"total"]integerValue];
                  if (deviceCount > 0)
                  {
                      NSArray *deviceListArr = [devices_info_json objectForKey: @"devices"];
                      for (NSDictionary *device in deviceListArr)
                      {
                          NSString *newlyRegister = [NSString stringWithFormat: @"%@", [device objectForKey: @"newly_registered"]];
                          if ([newlyRegister isEqualToString: @"1"])
                          {
                              [deviceNewRegisterList addObject: @"YES"];
                          }
                          else
                          {
                              [deviceNewRegisterList addObject: @"NO"];
                          }
                          NSString *withExpireServices = [NSString stringWithFormat: @"%@", [device objectForKey: @"with_expire_services"]];
                          if ([withExpireServices isEqualToString: @"1"])
                          {
                              [deviceExpireServiceList addObject: @"YES"];
                          }
                          else
                          {
                              [deviceExpireServiceList addObject: @"NO"];
                          }
//                          NSString *gracePeriod = [NSString stringWithFormat: @"%@", [device objectForKey: @"grace_period"]];
//                          if ([withExpireServices isEqualToString: @"1"])
//                          {
//                              [deviceGracePeriodStatusList addObject: @"YES"];
//                          }
//                          else
//                          {
//                              [deviceGracePeriodStatusList addObject: @"NO"];
//                          }
//                          NSString *name = [NSString stringWithFormat: @"%@", [device objectForKey: @"name"]];
//                          if (name != nil)
//                          {
                              [deviceNameList addObject: [NSString stringWithFormat: @"%@", [device objectForKey: @"name"]]];
//                          }
//                          else
//                          {
//                              [deviceNameList addObject: @""];
//                          }
//                          NSString *gracePeriodAmount = [NSString stringWithFormat: @"%@", [device objectForKey: @"grace_remain_amount"]];
//                          [deviceGracePeriodAmountList addObject: gracePeriodAmount];
//                          NSString *type = [NSString stringWithFormat: @"%@", [device objectForKey: @"type"]];
//                          [deviceTypeList addObject: type];
                          NSString *mac_address = [NSString stringWithFormat: @"%@", [device objectForKey: @"mac_address"]];
                          [deviceMacAddrList addObject: mac_address];
                          NSString *id = [NSString stringWithFormat: @"%@", [device objectForKey: @"id"]];
                          [deviceIdList addObject: id];
//                          NSString *parsedModuleCode = [NSString stringWithFormat: @"%@", [device objectForKey: @"parsed_module_code"]];
//                          [deviceParsedModuleCodeList addObject: parsedModuleCode];
                      }
                      dispatch_async(dispatch_get_main_queue(), ^() {
                          if (deviceListStatus == YES)
                          {
                              [self.noDeviceView setHidden: YES];
                              [self.devicesList setHidden: NO];
                              [self.devicesList reloadData];
                              [self.errorView setHidden: YES];
                              [self.deviceDetailView setHidden: YES];
                              [self.registerDeviceListView setHidden: YES];
                              [self.registerDevicePage1ScanView setHidden: YES];
                              [self.registerDevicePage1ManualView setHidden: YES];
                              [self.registerDevicePage2View setHidden: YES];
                              [self.registerDevicePage3View setHidden: YES];
                              [self.tabBarController.tabBar setHidden: NO];
                              [self.deviceView setHidden: NO];
                              [m_HUD setHidden: YES];
                          }
                      });
                  }
                  else
                  {
                      // no device
                      dispatch_async(dispatch_get_main_queue(), ^() {
                          if (deviceListStatus == YES)
                          {
                              [self.devicesList setHidden: YES];
                              [self.noDeviceView setHidden: NO];
                              [self.errorView setHidden: YES];
                              [m_HUD setHidden: YES];
                          }
                      });
                  }
              }
              else
              {
                  // response error
                  debug(@"server response message = %@", message);
                  [self.tabBarController.tabBar setHidden: YES];
                  [self.errorView setHidden: NO];
                  [m_HUD setHidden: YES];
              }
          }
          else
          {
              // no response data
              [self.tabBarController.tabBar setHidden: YES];
              [self.errorView setHidden: NO];
              [m_HUD setHidden: YES];
          }
          dispatch_async(dispatch_get_main_queue(), ^() {
              [self.tabBarController.tabBar setUserInteractionEnabled: YES];
          });
      }] resume];
}
//API 1 GET DEVICE INFORMATION
- (void)getDeviceDetailInfo:(NSString *)deviceId
{
    [m_HUD setHidden: NO];
    NSError *error;
    NSString *payloadFormat = [NSString stringWithFormat: @"{"
                               "\"device_id\": %@"
                               "}", deviceId];
    NSData *payloadJson = [payloadFormat dataUsingEncoding: NSUTF8StringEncoding];
    NSDictionary *payload = [NSJSONSerialization JSONObjectWithData: payloadJson options: kNilOptions error: &error];
    NSString *token = [Jwt encodeWithPayload: payload andKey: [public get_secret_access_key] andError:&error];
    if(token == nil)
    {
        debug(@"Code: %li", (long)[error code]);
        debug(@"Reason: %@", [error localizedFailureReason]);
    }
    else
    {
        debug(@"jwt token = %@", token);
    }
    NSString *get_devices_detail_info_url = [NSString stringWithFormat: @"%@/api/v2/my/device?token=%@&access_key_id=%@", DATA_URL, token, [public get_access_key_id]];
    debug(@"get_devices_detail_info_url = %@", get_devices_detail_info_url);
    NSURL *url = [NSURL URLWithString: get_devices_detail_info_url];
    NSMutableURLRequest *request_user_info = [NSMutableURLRequest requestWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 15];
    [request_user_info setHTTPMethod: @"GET"];
    [request_user_info setValue: [public get_access_token] forHTTPHeaderField: @"Authorization"];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest: request_user_info
                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
      {
          if (data != nil)
          {
              NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData: data options: kNilOptions error: nil];
              debug(@"devicesDetailInfo = %@", json);
              
              NSString *encryptionCode = [json objectForKey: @"data"];
              NSString *iv = [encryptionCode substringWithRange: NSMakeRange(0, 16)];
              NSString *encrypted_data = [encryptionCode substringFromIndex: 16];
              NSString *sha256_decode_data = [public sha256: [public get_secret_access_key]];
              NSData *decode_key = [public hexToBytes: sha256_decode_data];
              NSData *base64_decode_data = [[NSData alloc]initWithData: (NSData *)[public base64_decode: encrypted_data]];
              NSData *aes_decode_data = [[NSData alloc]initWithData: [public aes_cbc_256: base64_decode_data andIv: iv andkey: decode_key andType: kCCDecrypt]];
              NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingUTF8);
              NSString *devicesDetailInfo = [[NSString alloc]initWithData: aes_decode_data encoding: enc];
              debug(@"devices Detail info = %@", devicesDetailInfo);
              detailServiceNameList = [[NSMutableArray alloc]init];
              detailServiceAmountList = [[NSMutableArray alloc]init];
              detailServiceExpireAtList = [[NSMutableArray alloc]init];
              detailServiceStatusList = [[NSMutableArray alloc]init];
              detailGracePeriodList = [[NSMutableArray alloc]init];
              detailGracePeriodAmountList = [[NSMutableArray alloc]init];
              NSMutableDictionary *devices_detail_info_json = [NSJSONSerialization JSONObjectWithData: aes_decode_data options:kNilOptions error: nil];
              detailDeviceId = [NSString stringWithFormat: @"%@", [devices_detail_info_json objectForKey: @"device_id"]];
              detailDeviceNames = [NSString stringWithFormat: @"%@", [devices_detail_info_json objectForKey: @"name"]];
              detailDeviceMac = [NSString stringWithFormat: @"%@", [devices_detail_info_json objectForKey: @"mac_address"]];
              detailDeviceModelCode = [NSString stringWithFormat: @"%@", [devices_detail_info_json objectForKey: @"model"]];
              detailSn = [NSString stringWithFormat: @"%@", [devices_detail_info_json objectForKey: @"serial_number"]];
              NSDictionary *resellerInfo = [devices_detail_info_json objectForKey: @"reseller_info"];
              debug(@"reseller info = %@", resellerInfo);
              if (resellerInfo != nil)
              {
                  detailDeviceResellerCorp = [NSString stringWithFormat: @"%@", [resellerInfo objectForKey: @"company_name"]];
                  detailDeviceResellerEmail = [NSString stringWithFormat: @"%@", [resellerInfo objectForKey: @"email"]];
                  detailDeviceResellerVat = [NSString stringWithFormat: @"%@", [resellerInfo objectForKey: @"vat_number"]];
              }
              else
              {
                  detailDeviceResellerCorp = @"";
                  detailDeviceResellerEmail = @"";
                  detailDeviceResellerVat = @"";
              }
              NSArray *deviceListArr = [devices_detail_info_json objectForKey: @"services"];
//              debug(@"service list = %@", deviceListArr);
              for (NSDictionary *device in deviceListArr)
              {
                  NSString *name = [NSString stringWithFormat: @"%@", [device objectForKey: @"name"]];
                  // remove PKG_Update
                  if (![name isEqualToString: @"PKG_Update"])
                  {
                      [detailServiceNameList addObject: name];
                      NSNumber *amount = [device objectForKey: @"remain_amount"];
                      [detailServiceAmountList addObject: amount];
                      NSString *expireAt = [NSString stringWithFormat: @"%@", [device objectForKey: @"expired_at"]];
                      [detailServiceExpireAtList addObject: expireAt];
                      NSString *status = [NSString stringWithFormat: @"%@", [device objectForKey: @"expire_status"]];
                      [detailServiceStatusList addObject: status];
                      NSString *gracePeriod = [NSString stringWithFormat: @"%@", [device objectForKey: @"grace_period"]];
                      if ([gracePeriod isEqualToString: @"1"])
                      {
                          [detailGracePeriodList addObject: @"YES"];
                      }
                      else
                      {
                          [detailGracePeriodList addObject: @"NO"];
                      }
                      [detailGracePeriodAmountList addObject: [NSString stringWithFormat: @"%@", [device objectForKey: @"grace_period_amount"]]];
                  }
              }
              dispatch_async(dispatch_get_main_queue(), ^() {
                  if (deviceListStatus == YES || deviceDetailStatus == YES || searchStatus == YES)
                  {
                      [self setDeviceDetailFromDeviceList: detailDeviceNames andMac: detailDeviceMac andModel: detailDeviceModelCode andSerial: detailSn];
                  }
                  if (renewStatus == YES)
                  {
                      [self setDeviceDetailFromAddLicense: detailDeviceNames andMac: detailDeviceMac andModel: detailDeviceModelCode andSerial: detailSn];
                  }
                  if (activateOkStatus == YES)
                  {
                      [self setDeviceDetailFromScanLicense: detailDeviceNames andMac: detailDeviceMac andModel: detailDeviceModelCode andSerial: detailSn];
                  }
              });
          }
          else
          {
              [self.errorView setHidden: NO];
              [m_HUD setHidden: YES];
          }
      }] resume];
}
// API 2 GET SERVICE LICENSE
- (void)getLicenseServiceInfo:(NSString *)deviceId
{
    [m_HUD setHidden: NO];
    NSError *error;
    NSString *payloadFormat = [NSString stringWithFormat: @"{"
                               "\"device_id\": %@,"
                               "\"status\": \"wait_for_renew\""
                               "}", deviceId];
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
              NSMutableDictionary *status = [json objectForKey: @"return_status"];
              NSString *code = [NSString stringWithFormat: @"%@", [status objectForKey: @"code"]];
              NSString *message = [NSString stringWithFormat: @"%@", [status objectForKey: @"message"]];
              if ([code isEqualToString: @"0"])
              {
                  NSMutableDictionary *license_info_json = [NSJSONSerialization JSONObjectWithData: aes_decode_data options:kNilOptions error: nil];
//                  NSString *tt = [license_info_json objectForKey: @"renew_list"];
                  NSArray *licenseListArr = [license_info_json objectForKey: @"services"];
                  renewServiceNameList = [[NSMutableArray alloc]init];
                  renewServiceTotalList = [[NSMutableArray alloc]init];
                  renewServiceAmountList = [[NSMutableArray alloc]init];
                  renewServiceId = [[NSMutableArray alloc]init];
                  // get service info
                  for (NSDictionary *license in licenseListArr)
                  {
                      NSString *name = [NSString stringWithFormat: @"%@", [license objectForKey: @"name"]];
                      // filter service name
                      BOOL display = [public checkServiceStatus: name];
                      if (display == YES)
                      {
                          [renewServiceNameList addObject: name];
                          NSString *total = [NSString stringWithFormat: @"%@", [license objectForKey: @"total"]];
                          [renewServiceTotalList addObject: total];
                          NSString *amount = [NSString stringWithFormat: @"%@", [license objectForKey: @"amount"]];
                          [renewServiceAmountList addObject: amount];
                          NSString *serviceId = [NSString stringWithFormat: @"%@", [license objectForKey: @"license_service_id"]];
                          [renewServiceId addObject: serviceId];
                      }
                  }
                  dispatch_async(dispatch_get_main_queue(), ^() {
                      if (action == DEVICE_ACTIVATE_LICENSE)
                      {
                          [self.addLicenseServiceList reloadData];
                          [self.addlicenseServiceName setHidden: NO];
                          [self.addlicenseServiceExpiredDate setHidden: NO];
                          [self.addLicenseCancelBtn setHidden: YES];
                          [self.addLicenseDoneBtn setHidden: NO];
                      }
                      else
                      {
                          deviceDetailStatus = NO;
                          renewStatus = YES;
                          [self.addLicenseServiceList reloadData];
                          [self.deviceDetailView setHidden: YES];
                          [self.addLicenseView setHidden: NO];
                          [self.errorView setHidden: YES];
                      }
                      [m_HUD setHidden: YES];
                  });
              }
              else
              {
                  // response error
                  debug(@"error message = %@", message);
                  [self.errorView setHidden: NO];
                  [m_HUD setHidden: YES];
              }
          }
          else
          {
              // no response data
              [self.errorView setHidden: NO];
              [m_HUD setHidden: YES];
          }
      }] resume];
}
// API 5 CHECK RESELLER INFORMATION
- (void)searchResellerInfo
{
    [m_HUD setHidden: NO];
    if (self.resellerNameTxt.text.length > 0)
    {
        NSError *error;
        NSString *payloadFormat = [NSString stringWithFormat: @"{"
                                   "\"reseller_search\": \"%@\""
                                   "}", self.resellerNameTxt.text];
        NSData *payloadJson = [payloadFormat dataUsingEncoding: NSUTF8StringEncoding];
        NSDictionary *payload = [NSJSONSerialization JSONObjectWithData: payloadJson options: kNilOptions error: &error];
        NSString *token = [Jwt encodeWithPayload: payload andKey: [public get_secret_access_key] andError:&error];
        if(token == nil)
        {
            debug(@"Code: %li", (long)[error code]);
            debug(@"Reason: %@", [error localizedFailureReason]);
        }
        else
        {
            debug(@"jwt token = %@", token);
        }
        NSString *get_reseller_info_url = [NSString stringWithFormat: @"%@/api/v2/resellers/search?token=%@&access_key_id=%@", DATA_URL, token, [public get_access_key_id]];
        debug(@"get_reseller_info_url = %@", get_reseller_info_url);
        NSURL *url = [NSURL URLWithString: get_reseller_info_url];
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
                  debug(@"resellerInfo = %@", json);
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
                      NSString *resellerInfo = [[NSString alloc]initWithData: aes_decode_data encoding: enc];
                      debug(@"reseller info = %@", resellerInfo);
                      NSMutableDictionary *reseller_info_json = [NSJSONSerialization JSONObjectWithData: aes_decode_data options:kNilOptions error: nil];
                      NSMutableDictionary *resellerList = [reseller_info_json objectForKey: @"reseller_info"];
                      NSString *vatNumber = [NSString stringWithFormat: @"%@", [resellerList objectForKey: @"vat_number"]];
                      dispatch_async(dispatch_get_main_queue(), ^() {
                          [self.resellerInfoMessage setText: @""];
                          [self.resellerNameTxt setText: [resellerList objectForKey: @"company_name"]];
                          [self.resellerMailTxt setText: [resellerList objectForKey: @"email"]];
                          [self.resellerVatTxt setText: vatNumber];
                          [self.errorView setHidden: YES];
                          [m_HUD setHidden: YES];
                      });
                  }
                  else
                  {
                      dispatch_async(dispatch_get_main_queue(), ^() {
                          NSString *errorMsg = [public checkErrorCode: code];
                          if ([errorMsg isEqualToString: @"unknow"])
                          {
                              [self.resellerInfoMessage setText: message];
                          }
                          else
                          {
                              [self.resellerInfoMessage setText: errorMsg];
                          }
                          [self.resellerInfoMessage setHidden: NO];
                          [self.errorView setHidden: YES];
                          [m_HUD setHidden: YES];
                      });
                  }
              }
              else
              {
                  [self.errorView setHidden: NO];
                  [m_HUD setHidden: YES];
              }
          }] resume];
    }
}
// API 5 CHECK RESELLER INFORMATION
- (void)editSearchResellerInfo
{
    [m_HUD setHidden: NO];
    NSError *error;
    NSString *payloadFormat = [NSString stringWithFormat: @"{"
                               "\"reseller_search\": \"%@\""
                               "}", self.editViewSearchTxt.text];
    NSData *payloadJson = [payloadFormat dataUsingEncoding: NSUTF8StringEncoding];
    NSDictionary *payload = [NSJSONSerialization JSONObjectWithData: payloadJson options: kNilOptions error: &error];
    NSString *token = [Jwt encodeWithPayload: payload andKey: [public get_secret_access_key] andError:&error];
    if(token == nil)
    {
        debug(@"Code: %li", (long)[error code]);
        debug(@"Reason: %@", [error localizedFailureReason]);
    }
    else
    {
        debug(@"jwt token = %@", token);
    }
    NSString *get_reseller_info_url = [NSString stringWithFormat: @"%@/api/v2/resellers/search?token=%@&access_key_id=%@", DATA_URL, token, [public get_access_key_id]];
    debug(@"get_reseller_info_url = %@", get_reseller_info_url);
    NSURL *url = [NSURL URLWithString: get_reseller_info_url];
    NSMutableURLRequest *request_user_info = [NSMutableURLRequest requestWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 30];
    [request_user_info setHTTPMethod: @"POST"];
    [request_user_info setValue: [public get_access_token] forHTTPHeaderField: @"Authorization"];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest: request_user_info
                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
      {
          if (data != nil)
          {
              NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData: data options: kNilOptions error: nil];
              debug(@"resellerInfo = %@", json);
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
                  NSString *resellerInfo = [[NSString alloc]initWithData: aes_decode_data encoding: enc];
                  debug(@"reseller info = %@", resellerInfo);
                  NSMutableDictionary *reseller_info_json = [NSJSONSerialization JSONObjectWithData: aes_decode_data options:kNilOptions error: nil];
                  NSMutableDictionary *resellerList = [reseller_info_json objectForKey: @"reseller_info"];
                  NSString *vatNumber = [NSString stringWithFormat: @"%@", [resellerList objectForKey: @"vat_number"]];
                  dispatch_async(dispatch_get_main_queue(), ^() {
                      [self.editResellerInfoMessage setText: @""];
                      [self.editViewResellerName setText: [resellerList objectForKey: @"company_name"]];
                      [self.editViewMail setText: [resellerList objectForKey: @"email"]];
                      [self.editViewVatNumber setText: vatNumber];
                      [self hiddeKeyboard];
                      [self.errorView setHidden: YES];
                      [m_HUD setHidden: YES];
                  });
              }
              else
              {
                  dispatch_async(dispatch_get_main_queue(), ^() {
                      NSString *errorMsg = [public checkErrorCode: code];
                      if ([errorMsg isEqualToString: @"unknow"])
                      {
                          [self.editResellerInfoMessage setText: message];
                      }
                      else
                      {
                          [self.editResellerInfoMessage setText: errorMsg];
                      }
                      [self.editResellerInfoMessage setHidden: NO];
                      [self hiddeKeyboard];
                      [self.errorView setHidden: YES];
                      [m_HUD setHidden: YES];
                  });
              }
          }
          else
          {
              [self.errorView setHidden: NO];
              [m_HUD setHidden: YES];
          }
      }] resume];
}
// API 6 LOG REGISTER DEVICE FOR CHECK
- (void)checkNewDevice:(NSString *)macAddr andSn:(NSString *)serialNum andEventType:(NSString *)eventType
{
    [m_HUD setHidden: NO];
    BOOL macRepeated = NO;
    BOOL snRepeated = NO;
    for (NSString *mac in registerNewDeviceMacList)
    {
        if ([macAddr isEqualToString: mac]) {
            macRepeated = YES;
            break;
        }
    }
    for (NSString *sn in registerNewDeviceSnList)
    {
        if ([serialNum isEqualToString: sn]) {
            snRepeated = YES;
            break;
        }
    }
    if (macRepeated == YES || snRepeated == YES)
    {
        dispatch_async(dispatch_get_main_queue(), ^() {
            [self.scanErrorMessage setText: @"The device is already in the list for add device."];
            [self.scanErrorMessage setHidden: NO];
            [m_HUD setHidden: YES];
            _scanStatus = YES;
        });
    }
    else
    {
        NSError *error;
        NSString *payloadFormat = [NSString stringWithFormat: @"{"
                                   "\"pretend\": true,"
                                   "\"devices\": [{"
                                   "\"mac_address\": \"%@\","
                                   "\"serial_number\": \"%@\""
                                   "}]}", macAddr, serialNum];
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
        
        NSString *reseller_info_url = [NSString stringWithFormat: @"%@/api/v2/my/devices/register?token=%@&access_key_id=%@", DATA_URL, token, [public get_access_key_id]];
        debug(@"reseller_info_url = %@", reseller_info_url);
        NSURL *url = [NSURL URLWithString: reseller_info_url];
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
                  debug(@"device info = %@", json);
                  
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
                      NSString *deviceInfo = [[NSString alloc]initWithData: aes_decode_data encoding: enc];
                      debug(@"device info = %@", deviceInfo);
                      
                      NSMutableDictionary *reseller_info_json = [NSJSONSerialization JSONObjectWithData: aes_decode_data options:kNilOptions error: nil];
                      
                      NSArray *resellerListArr = [reseller_info_json objectForKey: @"devices"];
                      for (NSDictionary *device in resellerListArr)
                      {
                          NSData *return_status = [NSJSONSerialization dataWithJSONObject: [device objectForKey: @"return_status"] options: NSJSONWritingPrettyPrinted error: nil];
                          NSMutableDictionary *status = [NSJSONSerialization JSONObjectWithData: return_status options:kNilOptions error: nil];
                          
                          NSString *return_code = [NSString stringWithFormat: @"%@", [status objectForKey: @"code"]];
                          NSString *return_message = [NSString stringWithFormat: @"%@", [status objectForKey: @"message"]];
                          if ([return_code isEqualToString: @"0"])
                          {
                              NSString *name = [NSString stringWithFormat: @"%@", [device objectForKey: @"model"]];
                              NSString *mac = [NSString stringWithFormat: @"%@", [device objectForKey: @"mac_address"]];
                              NSString *sn = [NSString stringWithFormat: @"%@", [device objectForKey: @"serial_number"]];
                              
                              [registerNewDeviceEventTypeList addObject: [NSString stringWithFormat: @"%@", eventType]];
                              [registerNewDeviceNameList addObject: name];
                              [registerNewDeviceMacList addObject: mac];
                              [registerNewDeviceSnList addObject: sn];
                              
                              dispatch_async(dispatch_get_main_queue(), ^() {
                                  [self.manualMacAddress setText: @""];
                                  [self.manualSerialNumber setText: @""];
                                  [self.manualErrorMessage setHidden: YES];
                                  [self.scanErrorMessage setHidden: YES];
                                  [self.registerDeviceScanList reloadData];
                                  [self.registerDeviceManualList reloadData];
                                  if ([registerNewDeviceNameList count] > 0)
                                  {
                                      [self.registerDevicePage1ManualNextBtn setEnabled: YES];
                                      [self.registerDevicePage1ScanNextBtn setEnabled: YES];
                                      [self.errorView setHidden: YES];
                                      [m_HUD setHidden: YES];
                                      _scanStatus = YES;
                                  }
                              });
                          }
                          else if ([code isEqualToString: @"0"])
                          {
                              dispatch_async(dispatch_get_main_queue(), ^() {
                                  NSString *errorMsg = [public checkErrorCode: return_code];
                                  if ([errorMsg isEqualToString: @"unknow"])
                                  {
                                      [self.manualErrorMessage setText: return_message];
                                      [self.scanErrorMessage setText: return_message];
                                  }
                                  else
                                  {
                                      [self.manualErrorMessage setText: errorMsg];
                                      [self.scanErrorMessage setText: errorMsg];
                                  }
                                  [self.manualErrorMessage setHidden: NO];
                                  [self.scanErrorMessage setHidden: NO];
                                  [self.errorView setHidden: YES];
                                  [m_HUD setHidden: YES];
                                  _scanStatus = YES;
                              });
                          }
                      }
                  }
                  else
                  {
                      dispatch_async(dispatch_get_main_queue(), ^() {
                          NSString *errorMsg = [public checkErrorCode: code];
                          if ([errorMsg isEqualToString: @"unknow"])
                          {
                              [self.manualErrorMessage setText: message];
                              [self.scanErrorMessage setText: message];
                          }
                          else
                          {
                              [self.manualErrorMessage setText: errorMsg];
                              [self.scanErrorMessage setText: errorMsg];
                          }
                          [self.manualErrorMessage setHidden: NO];
                          [self.scanErrorMessage setHidden: NO];
                          [self.errorView setHidden: YES];
                          [m_HUD setHidden: YES];
                          _scanStatus = YES;
                      });
                  }
              }
              else
              {
                  [self.errorView setHidden: NO];
                  [m_HUD setHidden: YES];
              }
          }] resume];
    }
}
// API 6 LOG REGISTER DEVICE FOR REGISTER
- (void)registerNewDevice:(NSString *)registerDeviceFormat andEventType:(NSString *)eventType
{
    NSError *error;
    NSUUID *udid = [UIDevice currentDevice].identifierForVendor;
    NSString *os = [NSString stringWithFormat: @"ios %@", [[UIDevice currentDevice]systemVersion]];
    NSString *payloadFormat = [NSString stringWithFormat: @"{"
                               "\"pretend\": false,"
                               "\"udid\": \"%@\","
                               "\"os\": \"%@\","
                               "\"event_type\": \"%@\","
                               "\"devices\": [%@"
                               "]}", [NSString stringWithFormat: @"%@", udid], os, eventType, registerDeviceFormat];
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
    NSString *reseller_info_url = [NSString stringWithFormat: @"%@/api/v2/my/devices/register?token=%@&access_key_id=%@", DATA_URL, token, [public get_access_key_id]];
    debug(@"reseller_info_url = %@", reseller_info_url);
    NSURL *url = [NSURL URLWithString: reseller_info_url];
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
              debug(@"register device info = %@", json);
              
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
                  NSString *registerDeviceInfo = [[NSString alloc]initWithData: aes_decode_data encoding: enc];
                  debug(@"register device info = %@", registerDeviceInfo);
                  NSMutableDictionary *reseller_info_json = [NSJSONSerialization JSONObjectWithData: aes_decode_data options:kNilOptions error: nil];
                  NSArray *resellerListArr = [reseller_info_json objectForKey: @"devices"];
                  for (NSDictionary *device in resellerListArr)
                  {
                      NSString *name = [NSString stringWithFormat: @"%@", [device objectForKey: @"name"]];
                      NSString *mac = [NSString stringWithFormat: @"%@", [device objectForKey: @"mac_address"]];
                      NSData *return_status = [NSJSONSerialization dataWithJSONObject: [device objectForKey: @"return_status"] options: NSJSONWritingPrettyPrinted error: nil];
                      NSMutableDictionary *status = [NSJSONSerialization JSONObjectWithData: return_status options:kNilOptions error: nil];
                      NSString *return_code = [NSString stringWithFormat: @"%@", [status objectForKey: @"code"]];
                      NSString *return_message = [NSString stringWithFormat: @"%@", [status objectForKey: @"message"]];
                      [finalNameList addObject: name];
                      [finalMacList addObject: mac];
                      if ([return_code isEqualToString: @"0"])
                      {
                          // return result successed
                          dispatch_async(dispatch_get_main_queue(), ^() {
                              //[finalMessageList replaceObjectAtIndex: registerDeviceIndex withObject: @"Register succeeded."];
                              [finalMessageList addObject: @"Register succeeded."];
                          });
                      }
                      else
                      {
                          // return result failed
                          dispatch_async(dispatch_get_main_queue(), ^() {
                              NSString *errorMsg = [public checkErrorCode: return_code];
                              if ([errorMsg isEqualToString: @"unknow"])
                              {
                                  //[finalMessageList replaceObjectAtIndex: registerDeviceIndex withObject: return_message];
                                  [finalMessageList addObject: return_message];
                              }
                              else
                              {
                                  //[finalMessageList replaceObjectAtIndex: registerDeviceIndex withObject: errorMsg];
                                  [finalMessageList addObject: errorMsg];
                              }
                          });
                      }
                  }
                  dispatch_async(dispatch_get_main_queue(), ^() {
                      // end to run
                      if (registerDeviceIndex == ([registerNewDeviceNameList count]-1))
                      {
                          registerPage3Status =NO;
                          registerFinalStatus = YES;
                          [self showStatus];
                          [self.registerDeviceFinalSuccessMessage setText: [NSString stringWithFormat: @"%lu devices registered successfully", (unsigned long)[finalNameList count]]];
                          [self.registerDeviceFinalResellerName setText: self.resellerNameTxt.text];
                          [self.registerDeviceFinalRsellerMail setText: self.resellerMailTxt.text];
                          [self.registerDeviceFinalList reloadData];
                          dispatch_async(dispatch_get_main_queue(), ^() {
                              [self.registerDevicePage3View setHidden: YES];
                              [self.registerDeviceListView setHidden: NO];
                              [self.errorView setHidden: YES];
                              [m_HUD setHidden: YES];
                          });
                      }
                  });
              }
              else
              {
                  // resposne error
                  dispatch_async(dispatch_get_main_queue(), ^() {
                      debug(@"error message = %@", message);
                      [self.errorView setHidden: NO];
                      [m_HUD setHidden: YES];
                  });
              }
          }
          else
          {
              // no response data
              dispatch_async(dispatch_get_main_queue(), ^() {
                  [self.errorView setHidden: NO];
                  [m_HUD setHidden: YES];
              });
          }
      }] resume];
}
// API 6 REGISTER DEVICE FOR SKIP
- (void)registerNewDeviceSkip
{
    [m_HUD setHidden: NO];
    NSError *error;
    NSString *registerDeviceFormat = [[NSString alloc]init];
    for (int i=0; i<[registerNewDeviceNameList count]; i++)
    {
        NSString *name = [NSString stringWithFormat: @"%@", [registerNewDeviceNameList objectAtIndex: i]];
        NSString *mac = [NSString stringWithFormat: @"%@", [registerNewDeviceMacList objectAtIndex: i]];
        NSString *sn = [NSString stringWithFormat: @"%@", [registerNewDeviceSnList objectAtIndex: i]];
        if (i == ([registerNewDeviceNameList count]-1))
        {
            registerDeviceFormat = [registerDeviceFormat stringByAppendingFormat: @"{\"mac_address\":\"%@\",\"serial_number\":\"%@\",\"name\":\"%@\"}", mac, sn, name];
        }
        else
        {
            registerDeviceFormat = [registerDeviceFormat stringByAppendingFormat: @"{\"mac_address\":\"%@\",\"serial_number\":\"%@\",\"name\":\"%@\"},", mac, sn, name];
        }
    }
    NSString *payloadFormat = [NSString stringWithFormat: @"{"
                               "\"pretend\": false,"
                               "\"devices\": [%@"
                               "]}", registerDeviceFormat];
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
    NSString *reseller_info_url = [NSString stringWithFormat: @"%@/api/v2/my/devices/register?token=%@&access_key_id=%@", DATA_URL, token, [public get_access_key_id]];
    debug(@"reseller_info_url = %@", reseller_info_url);
    NSURL *url = [NSURL URLWithString: reseller_info_url];
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
              debug(@"register device info = %@", json);
              
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
                  NSString *registerDeviceInfo = [[NSString alloc]initWithData: aes_decode_data encoding: enc];
                  debug(@"register device info = %@", registerDeviceInfo);
                  NSMutableDictionary *reseller_info_json = [NSJSONSerialization JSONObjectWithData: aes_decode_data options:kNilOptions error: nil];
                  NSArray *resellerListArr = [reseller_info_json objectForKey: @"devices"];
                  for (NSDictionary *device in resellerListArr)
                  {
                      NSString *name = [NSString stringWithFormat: @"%@", [device objectForKey: @"name"]];
                      NSString *mac = [NSString stringWithFormat: @"%@", [device objectForKey: @"mac_address"]];
                      [finalNameList addObject: name];
                      [finalMacList addObject: mac];
                  }
                  dispatch_async(dispatch_get_main_queue(), ^() {
                      deviceListStatus = YES;
                      registerPage3Status = NO;
                      [self.registerDevicePage3View setHidden: YES];
                      [self.deviceView setHidden: NO];
                      [self.tabBarController.tabBar setHidden: NO];
                      action = ENTER_DEVICE;
                      [self getDeviceInfo];
                  });
              }
              else
              {
                  dispatch_async(dispatch_get_main_queue(), ^() {
                      NSString *errorMsg = [public checkErrorCode: code];
                      if ([errorMsg isEqualToString: @"unknow"])
                      {
                          [self.manualErrorMessage setText: message];
                          [self.scanErrorMessage setText: message];
                      }
                      else
                      {
                          [self.manualErrorMessage setText: errorMsg];
                          [self.scanErrorMessage setText: errorMsg];
                      }
                      [self.manualErrorMessage setHidden: NO];
                      [self.scanErrorMessage setHidden: NO];
                      [self.errorView setHidden: YES];
                      [m_HUD setHidden: YES];
                  });
              }
          }
          else
          {
              [self.errorView setHidden: NO];
              [m_HUD setHidden: YES];
          }
      }] resume];
}
// API 9 UPDATE DEVICE INFORMATION
- (void)updateDeviceInfo
{
    [m_HUD setHidden: NO];
    NSError *error;
    NSString *payloadFormat = [NSString stringWithFormat: @"{"
                               "\"device_id\": \"%@\","
                               "\"name\": \"%@\","
                               "\"reseller_search\": \"%@\""
                               "}", detailDeviceId, self.editViewDevieNameTxt.text, self.editViewResellerName.text];
    NSData *payloadJson = [payloadFormat dataUsingEncoding: NSUTF8StringEncoding];
    NSDictionary *payload = [NSJSONSerialization JSONObjectWithData: payloadJson options: kNilOptions error: &error];
    NSString *token = [Jwt encodeWithPayload: payload andKey: [public get_secret_access_key] andError:&error];
    if(token == nil)
    {
        debug(@"Code: %li", (long)[error code]);
        debug(@"Reason: %@", [error localizedFailureReason]);
    }
    else
    {
        debug(@"jwt token = %@", token);
    }
    NSString *update_device_info_url = [NSString stringWithFormat: @"%@/api/v2/my/device?token=%@&access_key_id=%@", DATA_URL, token, [public get_access_key_id]];
    debug(@"update_device_info_url = %@", update_device_info_url);
    NSURL *url = [NSURL URLWithString: update_device_info_url];
    NSMutableURLRequest *request_user_info = [NSMutableURLRequest requestWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 30];
    [request_user_info setHTTPMethod: @"PUT"];
    [request_user_info setValue: [public get_access_token] forHTTPHeaderField: @"Authorization"];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest: request_user_info
                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
      {
          if (data != nil)
          {
              NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData: data options: kNilOptions error: nil];
              debug(@"updateDeviceInfo = %@", json);
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
                  NSString *resellerInfo = [[NSString alloc]initWithData: aes_decode_data encoding: enc];
                  debug(@"update device info = %@", resellerInfo);
                  dispatch_async(dispatch_get_main_queue(), ^() {
                      [self getDeviceDetailInfo: detailDeviceId];
                  });
              }
              else
              {
                  dispatch_async(dispatch_get_main_queue(), ^() {
                      NSString *errorMsg = [public checkErrorCode: code];
                      if ([errorMsg isEqualToString: @"unknow"])
                      {
                          [self.editResellerInfoMessage setText: message];
                      }
                      else
                      {
                          [self.editResellerInfoMessage setText: errorMsg];
                      }
                      [self.editResellerInfoMessage setHidden: NO];
                      [self hiddeKeyboard];
                      [self.errorView setHidden: YES];
                      [m_HUD setHidden: YES];
                  });
              }
          }
          else
          {
              [self.errorView setHidden: NO];
              [m_HUD setHidden: YES];
          }
      }] resume];
}
// API 3 ACTIVATE SERVICE LICENSE
- (void)activeLicense:(NSString *)deviceId andServiceId:(NSString *)serviceId
{
    [m_HUD setHidden: NO];
    NSError *error;
    NSUUID *udid = [UIDevice currentDevice].identifierForVendor;
    NSString *os = [NSString stringWithFormat: @"ios %@", [[UIDevice currentDevice]systemVersion]];
    NSString *payloadFormat = [NSString stringWithFormat: @"{"
                               "\"udid\": \"%@\","
                               "\"os\": \"%@\","
                               "\"event_type\": \"exist\","
                               "\"device_id\": \"%@\","
                               "\"license_service_id\": \"%@\","
                               "}", [NSString stringWithFormat: @"%@", udid], os, deviceId, serviceId];
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
                  
                  debug(@"name = %@, expired_at = %@", name, expired_at);
                  dispatch_async(dispatch_get_main_queue(), ^() {
                      [self.addlicenseServiceName setText: name];
//                      [self.addlicenseServiceName setHidden: NO];
                      NSArray *dateStr = [expired_at componentsSeparatedByString: @"T"];
                      [self.addlicenseServiceExpiredDate setText: [NSString stringWithFormat: @"Expired at %@", [dateStr objectAtIndex: 0]]];
//                      [self.addlicenseServiceExpiredDate setHidden: NO];
//                      [self.addLicenseCancelBtn setHidden: YES];
//                      [self.addLicenseDoneBtn setHidden: NO];
//                      [m_HUD setHidden: YES];
                      NSString *deviceId = [NSString stringWithFormat: @"%ld", (long)self.detailAddLicenseBtn.tag];
                      [self getLicenseServiceInfo: deviceId];
                  });
              }
              else
              {
                  debug(@"message = %@", message);
                  [m_HUD setHidden: YES];
              }
          }
          else
          {
              [self.errorView setHidden: NO];
              [m_HUD setHidden: YES];
          }
      }] resume];
}
// API 8 LOG REGISTER AND ACTIVATE LICENSE FOR CHECK
- (void)addLicenseActivateValie:(NSString *)deviceId andKey:(NSString *)key andEventType:(NSString *)eventType
{
    [m_HUD setHidden: NO];
    NSError *error;
    NSString *payloadFormat = [NSString stringWithFormat: @"{"
                               "\"pretend\": true,"
                               "\"device_id\": \"%@\","
                               "\"licenses\": ["
                               "\{\"key\": \"%@\"},"
                               "]}", deviceId, key];
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
    NSString *get_activate_license_info_url = [NSString stringWithFormat: @"%@/api/v2/my/devices/licenses/activate?token=%@&access_key_id=%@", DATA_URL, token, [public get_access_key_id]];
    debug(@"add_license_varification_url = %@", get_activate_license_info_url);
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
                  NSString *addLicenseInfo = [[NSString alloc]initWithData: aes_decode_data encoding: enc];
                  debug(@"license verification info = %@", addLicenseInfo);
                  NSMutableDictionary *service_info_json = [NSJSONSerialization JSONObjectWithData: aes_decode_data options:kNilOptions error: nil];
                  NSArray *licenseListArr = [service_info_json objectForKey: @"licenses"];
                  for (NSDictionary *service in licenseListArr)
                  {
                      NSData *return_status = [NSJSONSerialization dataWithJSONObject: [service objectForKey: @"return_status"] options: NSJSONWritingPrettyPrinted error: nil];
                      NSMutableDictionary *status = [NSJSONSerialization JSONObjectWithData: return_status options:kNilOptions error: nil];
                      NSString *return_code = [NSString stringWithFormat: @"%@", [status objectForKey: @"code"]];
                      NSString *return_message = [NSString stringWithFormat: @"%@", [status objectForKey: @"message"]];
                      if ([return_code isEqualToString: @"0"])
                      {
                          [addLicenseEventTypeList addObject: eventType];
                          [addLicenseScanKeyList addObject: [service objectForKey: @"key"]];
                          NSData *services = [NSJSONSerialization dataWithJSONObject: [service objectForKey: @"services"] options: NSJSONWritingPrettyPrinted error: nil];
                          NSArray *getServiceArr = [NSJSONSerialization JSONObjectWithData: services options: NSJSONReadingMutableContainers error: nil];
                          for (NSDictionary *serviceInfo in getServiceArr)
                          {
                              NSString *serviceName = [NSString stringWithFormat: @"%@", [serviceInfo objectForKey: @"name"]];
                              [addLicenseScanNameList addObject: serviceName];
                          }
                          dispatch_async(dispatch_get_main_queue(), ^() {
                              [self.addlicenseScanMessage setHidden: YES];
                              [self.addlicenseManualMessage setHidden: YES];
                              [self.addLicenseManualViewTxt setText: @""];
                              if ([addLicenseScanNameList count] > 0)
                              {
                                  [self.addlicenseScanActivateBtn setEnabled: YES];
                                  [self.addlicenseManualActivateBtn setEnabled: YES];
                              }
                              [self.addLicenseManualList reloadData];
                              [self.addLicenseScanList reloadData];
                              [self.errorView setHidden: YES];
                              [m_HUD setHidden: YES];
                              _addLicenseScanStatus = YES;
                          });
                      }
                      else
                      {
                          dispatch_async(dispatch_get_main_queue(), ^() {
                              NSString *errorMsg = [public checkErrorCode: return_code];
                              if ([errorMsg isEqualToString: @"unknow"])
                              {
                                  [self.addlicenseScanMessage setText: return_message];
                                  [self.addlicenseManualMessage setText: return_message];
                              }
                              else
                              {
                                  [self.addlicenseScanMessage setText: errorMsg];
                                  [self.addlicenseManualMessage setText: errorMsg];
                              }
                              [self.addlicenseScanMessage setHidden: NO];
                              [self.addlicenseManualMessage setHidden: NO];
                              [self.errorView setHidden: YES];
                              [m_HUD setHidden: YES];
                              _addLicenseScanStatus = YES;
                          });
                      }
                  }
              }
              else
              {
                  NSString *errorMsg = [public checkErrorCode: code];
                  if ([errorMsg isEqualToString: @"unknow"])
                  {
                      [self.addlicenseScanMessage setText: message];
                      [self.addlicenseManualMessage setText: message];
                  }
                  else
                  {
                      [self.addlicenseScanMessage setText: errorMsg];
                      [self.addlicenseManualMessage setText: errorMsg];
                  }
                  [self.addlicenseScanMessage setHidden: NO];
                  [self.addlicenseManualMessage setHidden: NO];
                  [self.errorView setHidden: YES];
                  [m_HUD setHidden: YES];
                  _addLicenseScanStatus = YES;
              }
          }
          else
          {
              [self.errorView setHidden: NO];
              [m_HUD setHidden: YES];
          }
      }] resume];
}
// API 8 LOG REGISTER AND ACTIVATE LICENSE FOR REGISTER
- (void)addLicenseScanActivateInfo:(NSString *)deviceId andKey:(NSString *)keyFormat andEventType:(NSString *)eventType
{
    NSError *error;
    NSUUID *uuid = [UIDevice currentDevice].identifierForVendor;
    NSString *os = [NSString stringWithFormat: @"ios %@", [[UIDevice currentDevice]systemVersion]];
    NSString *payloadFormat = [NSString stringWithFormat: @"{"
                               "\"pretend\": false,"
                               "\"udid\": \"%@\","
                               "\"os\": \"%@\","
                               "\"event_type\": \"%@\","
                               "\"device_id\": \"%@\","
                               "\"licenses\": [%@]}", [NSString stringWithFormat: @"%@", uuid], os, eventType, deviceId, keyFormat];
    debug(@"payload = %@", payloadFormat);
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
    NSString *get_activate_license_info_url = [NSString stringWithFormat: @"%@/api/v2/my/devices/licenses/activate?token=%@&access_key_id=%@", DATA_URL, token, [public get_access_key_id]];
    debug(@"add_license_varification_url = %@", get_activate_license_info_url);
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
                  NSString *addLicenseInfo = [[NSString alloc]initWithData: aes_decode_data encoding: enc];
                  debug(@"license activate info = %@", addLicenseInfo);
                  NSMutableDictionary *service_info_json = [NSJSONSerialization JSONObjectWithData: aes_decode_data options:kNilOptions error: nil];
                  NSArray *licenseListArr = [service_info_json objectForKey: @"licenses"];
                  for (NSDictionary *service in licenseListArr)
                  {
                      NSData *return_status = [NSJSONSerialization dataWithJSONObject: [service objectForKey: @"return_status"] options: NSJSONWritingPrettyPrinted error: nil];
                      NSMutableDictionary *status = [NSJSONSerialization JSONObjectWithData: return_status options:kNilOptions error: nil];
                      NSString *return_code = [NSString stringWithFormat: @"%@", [status objectForKey: @"code"]];
                      NSString *return_message = [NSString stringWithFormat: @"%@", [status objectForKey: @"message"]];
                      if ([return_code isEqualToString: @"0"])
                      {
                          // return result successed
                          [activateMessageList addObject: @"Activate succeeded."];
                      }
                      else
                      {
                          // return result failed
                          NSString *errorMsg = [public checkErrorCode: return_code];
                          if ([errorMsg isEqualToString: @"unknow"])
                          {
                              [activateMessageList addObject: return_message];
                          }
                          else
                          {
                              [activateMessageList addObject: errorMsg];
                          }
                      }
                  }
                  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                      dispatch_async(dispatch_get_main_queue(), ^() {
                          [self.addlicenseScanMessage setHidden: YES];
                          [self.addlicenseManualMessage setHidden: YES];
                          if (registerindex == ([addLicenseScanKeyList count]-1))
                          {
                              debug(@"TEST1");
                              debug(@"scan name = %@", addLicenseScanNameList);
                              debug(@"scan key = %@", addLicenseScanKeyList);
                              debug(@"scan message = %@", activateMessageList);
                              addLicenseScanStatus = NO;
                              activateOkStatus = YES;
                              [self.activateOkList reloadData];
                              debug(@"TEST2");
                              [self.addLicenseScanView setHidden: YES];
                              [self.addLicenseManualView setHidden: YES];
                              [self.activateOkView setHidden: NO];
                              [m_HUD setHidden: YES];
                          }
                      });
                  });
              }
              else
              {
                  // response error
                  debug(@"error message = %@", message);
                  [self.errorView setHidden: NO];
                  [m_HUD setHidden: YES];
                  _addLicenseScanStatus = YES;
              }
          }
          else
          {
              // no response data
              [self.errorView setHidden: NO];
              [m_HUD setHidden: YES];
          }
      }] resume];
}
# pragma mark - FUNCTION EVENTS
- (void)setDeviceDetailFromDeviceList:(NSString *)name andMac:(NSString *)mac andModel:(NSString *)model andSerial:(NSString *)serial
{
    searchStatus = NO;
    deviceListStatus = NO;
    deviceDetailStatus = YES;
    [self.detailDeviceName setText: detailDeviceNames];
    [self.detailDeviceMacAddr setText: detailDeviceMac];
    [self.detailDeviceModel setText: detailDeviceModelCode];
    [self.detailSerialNo setText: detailSn];
    [self.detailDeviceResellerCompany setText: detailDeviceResellerCorp];
    [self.detailDeviceResellerMail setText: detailDeviceResellerEmail];
    [self.detailServiceList reloadData];
    [self.deviceView setHidden: YES];
    [self.searchDeviceView setHidden: YES];
    [self.editView setHidden: YES];
    [self.tabBarController.tabBar setHidden: YES];
    [self.deviceDetailView setHidden: NO];
    [self.errorView setHidden: YES];
    [m_HUD setHidden: YES];
}
- (void)setDeviceDetailFromAddLicense:(NSString *)name andMac:(NSString *)mac andModel:(NSString *)model andSerial:(NSString *)serial
{
    //deviceListStatus = NO;
    renewStatus = NO;
    deviceDetailStatus = YES;
    [self.detailDeviceMacAddr setText: detailDeviceMac];
    [self.detailDeviceModel setText: detailDeviceModelCode];
    [self.detailSerialNo setText: detailSn];
    [self.detailDeviceResellerCompany setText: detailDeviceResellerCorp];
    [self.detailDeviceResellerMail setText: detailDeviceResellerEmail];
    [self.detailServiceList reloadData];
    [self.addLicenseView setHidden: YES];
    [self.deviceDetailView setHidden: NO];
    [self.errorView setHidden: YES];
    [m_HUD setHidden: YES];
}
- (void)setDeviceDetailFromScanLicense:(NSString *)name andMac:(NSString *)mac andModel:(NSString *)model andSerial:(NSString *)serial
{
    addLicenseScanStatus = NO;
    deviceDetailStatus = YES;
    [self.detailDeviceMacAddr setText: detailDeviceMac];
    [self.detailDeviceModel setText: detailDeviceModelCode];
    [self.detailSerialNo setText: detailSn];
    [self.detailDeviceResellerCompany setText: detailDeviceResellerCorp];
    [self.detailDeviceResellerMail setText: detailDeviceResellerEmail];
    [self.detailServiceList reloadData];
    [self.addLicenseView setHidden: YES];
    [self.deviceDetailView setHidden: NO];
    [self.errorView setHidden: YES];
    [m_HUD setHidden: YES];
}
- (void)checkDeviceInfo
{
    NSString *mac = [self.manualMacAddress.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *sn = [self.manualSerialNumber.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([mac length] > 0 && [sn length] > 0)
    {
        action = REGISTER_CHECK_MANUAL_DEVICE;
        if ([public checkNetWorkConn])
        {
            [self checkNewDevice: self.manualMacAddress.text andSn: self.manualSerialNumber.text andEventType: @"manually"];
        }
        else
        {
            [self.errorView setHidden: NO];
        }
    }
    else
    {
        if ([mac length] <= 0 && [sn length] > 0)
        {
            [self.manualErrorMessage setText: @"Mac address can't be blank."];
            [self.manualErrorMessage setHidden: NO];
            [self.manualMacAddress setText: @""];
        }
        else if ([sn length] <= 0 && [mac length] > 0)
        {
            [self.manualErrorMessage setText: @"Serial number can't be blank."];
            [self.manualErrorMessage setHidden: NO];
            [self.manualSerialNumber setText: @""];
        }
        else
        {
            [self.manualErrorMessage setText: @"Mac address and serial number can't be blank."];
            [self.manualErrorMessage setHidden: NO];
            [self.manualMacAddress setText: @""];
            [self.manualSerialNumber setText: @""];
        }
    }
}
- (void)newDeviceDelBtn:(UIButton *)sender
{
    [registerNewDeviceNameList removeObjectAtIndex: sender.tag];
    [registerNewDeviceMacList removeObjectAtIndex: sender.tag];
    [registerNewDeviceSnList removeObjectAtIndex: sender.tag];
    [registerNewDeviceEventTypeList removeObjectAtIndex: sender.tag];
    
    [self.registerDeviceManualList reloadData];
    [self.registerDeviceScanList reloadData];
    
    if ([registerNewDeviceNameList count] == 0)
    {
        [self.registerDevicePage1ManualNextBtn setEnabled: NO];
        [self.registerDevicePage1ScanNextBtn setEnabled: NO];
    }
}
- (void)newDeviceEditDelBtn:(UIButton *)sender
{
    [registerNewDeviceNameList removeObjectAtIndex: sender.tag];
    [registerNewDeviceMacList removeObjectAtIndex: sender.tag];
    [registerNewDeviceSnList removeObjectAtIndex: sender.tag];
    [registerNewDeviceEventTypeList removeObjectAtIndex: sender.tag];
    
    [self.registerDeviceEditList reloadData];
    
    if ([registerNewDeviceNameList count] == 0)
    {
        [self.registerDevicePage2SaveBtn setEnabled: NO];
    }
}
- (void)hiddeKeyboard
{
    // hidde keyboard
    [[[UIApplication sharedApplication]keyWindow]endEditing: YES];
}
//- (void)checkLicense
//{
//    [self checkLicenseInfo: self.addLicenseManualViewTxt.text];
//}
- (void)searchReseller
{
    NSString *strFormat = [self.resellerNameTxt.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([strFormat length] > 0)
    {
        action = REGISTER_SEARCH_RESELLER;
        if ([public checkNetWorkConn])
        {
            [self searchResellerInfo];
        }
        else
        {
            [self.errorView setHidden: NO];
        }
    }
}
- (void)editSearchReseller
{
    NSString *strFormat = [self.editViewSearchTxt.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([strFormat length] > 0)
    {
        action = EDIT_SEARCH_RESELLER;
        if ([public checkNetWorkConn])
        {
            [self editSearchResellerInfo];
        }
        else
        {
            [self.errorView setHidden: NO];
        }
    }
}
- (void)verificationLicense
{
    NSString *key = [self.addLicenseManualViewTxt.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([key length] > 0)
    {
        if ([self.addLicenseManualViewTxt.text length] > 0)
        {
            BOOL repeated = NO;
            for (NSString *license in addLicenseScanKeyList) {
                if ([self.addLicenseManualViewTxt.text isEqualToString: license]) {
                    repeated = YES;
                    [self.addlicenseManualMessage setText: @"The license is already in the list for add license."];
                    [self.addlicenseManualMessage setHidden: NO];
                    break;
                }
            }
            if (repeated == NO)
            {
                action = DEVICE_CHECK_MANUAL_ADD_LICENSE;
                if ([public checkNetWorkConn])
                {
                    [self addLicenseActivateValie: detailDeviceId andKey: self.addLicenseManualViewTxt.text andEventType: @"manually"];
                }
                else
                {
                    [self.errorView setHidden: NO];
                }
            }
        }
    }
    else
    {
        [self.addlicenseManualMessage setText: @"License key can't be blank."];
        [self.addlicenseManualMessage setHidden: NO];
        [self.addLicenseManualViewTxt setText: @""];
    }
}
- (void)searchDeviceInfo
{
    [m_HUD setHidden: NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([deviceNameList count] > 0)
        {
            searchDeviceNameList = [[NSMutableArray alloc]init];
            searchDeviceMacList = [[NSMutableArray alloc]init];
            searchIdList = [[NSMutableArray alloc]init];
            searchExpireServiceList = [[NSMutableArray alloc]init];
            searchKeyWordStatus = NO;
            NSString *keyWord = [self.searchDeviceTxt.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if ([keyWord length] > 0)
            {
                for (int i=0; i<[deviceNameList count]; i++) {
                    NSRange searchName = [[deviceNameList objectAtIndex: i]rangeOfString: self.searchDeviceTxt.text];
                    NSRange searchMac = [[deviceMacAddrList objectAtIndex: i]rangeOfString: self.searchDeviceTxt.text];
                    if (searchName.location == NSNotFound && searchMac.location == NSNotFound)
                    {
                        // show message
                        [self.searchList setHidden: YES];
                        [self.searchNoResView setHidden: NO];
                    }
                    else
                    {
                        [searchDeviceNameList addObject: [deviceNameList objectAtIndex: i]];
                        [searchDeviceMacList addObject: [deviceMacAddrList objectAtIndex: i]];
                        [searchIdList addObject: [deviceIdList objectAtIndex: i]];
                        [searchExpireServiceList addObject: [deviceExpireServiceList objectAtIndex: i]];
                        [self.searchNoResView setHidden: YES];
                        searchKeyWordStatus = YES;
                    }
                }
                if (searchKeyWordStatus == YES)
                {
                    [self.searchList reloadData];
                    // show result
                    [self.searchNoResView setHidden: YES];
                    [self.searchList setHidden: NO];
                }
            }
            else
            {
                searchKeyWordStatus = NO;
                [self.searchList reloadData];
                [self.searchList setHidden: NO];
                [self.searchNoResView setHidden: YES];
            }
            [m_HUD setHidden: YES];
        }
        else
        {
            // show message
            [self.searchList setHidden: YES];
            [self.searchNoResView setHidden: NO];
            [m_HUD setHidden: YES];
        }
    });
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
- (void)resetDeviceName:(UITextField *)sender
{
    [self hiddeKeyboard];
    RegisterDeviceEditListCell *cell = (RegisterDeviceEditListCell *)[[sender superview]superview];
    NSIndexPath *idx = [self.registerDeviceEditList indexPathForCell: cell];
    [registerNewDeviceNameList replaceObjectAtIndex: idx.row withObject: cell.name.text];
    debug(@"device name list = %@", registerNewDeviceNameList);
}
- (void)showStatus
{
    debug(@"deviceListStatus = %d, deviceDetailStatus = %d, renewStatus = %d, registerPage1Status = %d, registerPage2Status = %d, registerFinalStatus = %d, _addLicenseScanStatus = %d, addLicenseScanStatus = %d, _scanStatus = %d, scanStatus = %d, activateOkStatus = %d, renewStatus = %d, searchStatus = %d, searchKeyWordStatus = %d", deviceListStatus, deviceDetailStatus, renewStatus, registerPage1Status, registerPage2Status, registerFinalStatus, _addLicenseScanStatus, addLicenseScanStatus, _scanStatus, scanStatus, activateOkStatus, renewStatus, searchStatus, searchKeyWordStatus);
}
# pragma mark - BUTTON EVENTS
- (IBAction)deviceAddDeviceBtn:(id)sender
{
    [m_HUD setHidden: NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        deviceListStatus = NO;
        registerPage1Status = YES;
        registerNewDeviceNameList = [[NSMutableArray alloc]init];
        registerNewDeviceMacList = [[NSMutableArray alloc]init];
        registerNewDeviceSnList = [[NSMutableArray alloc]init];
        registerNewDeviceEventTypeList = [[NSMutableArray alloc]init];
        [self.registerDeviceScanList reloadData];
        [self.registerDeviceManualList reloadData];
        _scanStatus = YES;
        scanStatus = YES;
        [self.registerDeviceScanList reloadData];
        [self.registerDeviceManualList reloadData];
        [self.registerDevicePage1ScanNextBtn setEnabled: NO];
        [self.registerDevicePage1ManualNextBtn setEnabled: NO];
        [self.registerDevicePage1ManualView setHidden: YES];
        [self.registerDevicePage2View setHidden: YES];
        [self.registerDevicePage3View setHidden: YES];
        [self.manualErrorMessage setHidden: YES];
        [self.scanErrorMessage setHidden: YES];
        [self.cancelMask setHidden: YES];
        [self.cancalView setHidden: YES];
        [self.resellerNameTxt setText: @""];
        [self.resellerMailTxt setText: @""];
        [self.resellerVatTxt setText: @""];
        [self.manualSerialNumber setText: @""];
        [self.manualMacAddress setText: @""];
        [self.manualMacAddress.layer setCornerRadius: self.manualMacAddress.frame.size.height/2];
        [self.manualSerialNumber.layer setCornerRadius: self.manualSerialNumber.frame.size.height/2];
//        [self.manualMacAddress setClearButtonMode: UITextFieldViewModeAlways];
//        [self.manualSerialNumber setClearButtonMode: UITextFieldViewModeAlways];
        [self scanCode];
        [self.tabBarController.tabBar setHidden: YES];
        [self.deviceView setHidden: YES];
        [self.registerDevicePage1ScanView setHidden: NO];
        [m_HUD setHidden: YES];
//        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {//相机权限
//            if (granted) {
//                debug(@"Authorized");
//            }else{
//                debug(@"Denied or Restricted");
//            }
//        }];
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    });
}
- (IBAction)registerDevicePage1NextBtn:(id)sender
{
    [m_HUD setHidden: NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        registerPage1Status = NO;
        registerPage2Status = YES;
        [self hiddeKeyboard];
        if ([registerNewDeviceNameList count] > 0)
        {
            [self.registerDevicePage2SaveBtn setEnabled: YES];
        }
        else
        {
            [self.registerDevicePage2SaveBtn setEnabled: NO];
        }
        [self.registerDevicePage2View setHidden: NO];
        [self.registerDeviceEditList reloadData];
        [self.registerDevicePage1ScanView setHidden: YES];
        [self.registerDevicePage1ManualView setHidden: YES];
        [self.registerDevicePage2View setHidden: NO];
        [m_HUD setHidden: YES];
    });
}
- (IBAction)registerDevicePage2SaveBtn:(id)sender
{
    [m_HUD setHidden: NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        registerPage2Status = NO;
        registerPage3Status = YES;
        [self hiddeKeyboard];
        [self.resellerNameTxt setText:@""];
        [self.resellerMailTxt setText: @""];
        [self.resellerVatTxt setText: @""];
        [self.registerDevicePage2View setHidden: YES];
        [self.registerDevicePage3View setHidden: NO];
        [self.resellerInfoMessage setHidden: YES];
        [self.resellerNameTxt.layer setCornerRadius: self.resellerNameTxt.frame.size.height/2];
        [self.resellerMailTxt.layer setCornerRadius: self.resellerMailTxt.frame.size.height/2];
        [self.resellerVatTxt.layer setCornerRadius: self.resellerVatTxt.frame.size.height/2];
        [m_HUD setHidden: YES];
    });
}

- (IBAction)registerDevicePage2BackBtn:(id)sender
{
    [m_HUD setHidden: NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        registerPage2Status = NO;
        registerPage1Status = YES;
        [self hiddeKeyboard];
        [self.registerDeviceManualList reloadData];
        [self.registerDeviceScanList reloadData];
        dispatch_async(dispatch_get_main_queue(), ^() {
            [self.registerDevicePage2View setHidden: YES];
            if (scanStatus == YES)
            {
                [self.registerDevicePage1ScanView setHidden: NO];
            }
            else
            {
                [self.registerDevicePage1ManualView setHidden: NO];
            }
        });
        [m_HUD setHidden: YES];
    });
}
- (IBAction)registerDevicePage3BackBtn:(id)sender
{
    [m_HUD setHidden: NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hiddeKeyboard];
        [self.registerDevicePage2View setHidden: NO];
        [self.registerDevicePage3View setHidden: YES];
        [m_HUD setHidden: YES];
    });
}
- (IBAction)registerDevicePage3SkipBtn:(id)sender
{
    [self hiddeKeyboard];
    action = REGISTER_SKIP;
    finalNameList = [[NSMutableArray alloc]init];
    finalMacList = [[NSMutableArray alloc]init];
    [self registerNewDeviceSkip];
}
- (IBAction)registerDevicepage1CancelBtn:(id)sender
{
    registerPage1Status = NO;
    deviceListStatus = YES;
    [self hiddeKeyboard];
    [self.cancelMask setHidden: NO];
    [self.cancalView setHidden: NO];
}
- (IBAction)registerDevicepage2CancelBtn:(id)sender
{
    registerPage2Status = NO;
    deviceListStatus = YES;
    [self hiddeKeyboard];
    [self.cancelMask setHidden: NO];
    [self.cancalView setHidden: NO];
}
- (IBAction)registerDevicepage3CancelBtn:(id)sender
{
    registerPage3Status = NO;
    deviceListStatus = YES;
    [self hiddeKeyboard];
    [self.cancelMask setHidden: NO];
    [self.cancalView setHidden: NO];
}
- (IBAction)registerDevicePage3RegisterBtn:(id)sender
{
    [m_HUD setHidden: NO];
    [self hiddeKeyboard];
    action = REGISTER_COMPLETE;
    finalNameList = [[NSMutableArray alloc]init];
    finalMacList = [[NSMutableArray alloc]init];
    finalMessageList = [[NSMutableArray alloc]init];
    for (int i=0; i<[registerNewDeviceNameList count]; i++)
    {
        NSString *registerDeviceFormat = [[NSString alloc]init];
        NSString *name = [NSString stringWithFormat: @"%@", [registerNewDeviceNameList objectAtIndex: i]];
        NSString *mac = [NSString stringWithFormat: @"%@", [registerNewDeviceMacList objectAtIndex: i]];
        NSString *sn = [NSString stringWithFormat: @"%@", [registerNewDeviceSnList objectAtIndex: i]];
        NSString *eventType = [NSString stringWithFormat: @"%@", [registerNewDeviceEventTypeList objectAtIndex: i]];
        NSString *resellerName = [self.resellerNameTxt.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        registerDeviceFormat = [registerDeviceFormat stringByAppendingFormat: @"{\"mac_address\":\"%@\",\"serial_number\":\"%@\",\"name\":\"%@\",\"reseller_search\":\"%@\"}", mac, sn, name, resellerName];
        registerDeviceIndex = i;
        if ([public checkNetWorkConn])
        {
            dispatch_async(dispatch_get_main_queue(), ^() {
                [self registerNewDevice: registerDeviceFormat andEventType: eventType];
            });
        }
        else
        {
            [self.errorView setHidden: NO];
        }
    }
}
- (IBAction)deviceDetailBackBtn:(id)sender
{
    deviceListStatus = YES;
    deviceDetailStatus = NO;
    action = ENTER_DEVICE;
    if ([public checkNetWorkConn])
    {
        [self getDeviceInfo];
    }
    else
    {
        [self.errorView setHidden: NO];
    }
}
- (IBAction)detailAddLicenseBtn:(id)sender
{
    [m_HUD setHidden: NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.addlicenseDeviceName setText: self.detailDeviceName.text];
        [self.addlicenseMacAddr setText: self.detailDeviceMacAddr.text];
        [self.addLicenseScanDeviceName setText: self.detailDeviceName.text];
        [self.addLicenseScanMac setText: self.detailDeviceMacAddr.text];
        [self.addLicenseManualDeviceName setText: self.detailDeviceName.text];
        [self.addLicenseManualMac setText: self.detailDeviceMacAddr.text];
        [self.addlicenseServiceName setHidden: YES];
        [self.addlicenseServiceExpiredDate setHidden: YES];
        [self.addLicenseCancelBtn setHidden: NO];
        [self.addLicenseDoneBtn setHidden: YES];
        NSString *deviceId = [NSString stringWithFormat: @"%ld", (long)self.detailAddLicenseBtn.tag];
        [self.addLicenseManualViewTxt setText: @""];
        action = ADD_LICENSE;
        if ([public checkNetWorkConn])
        {
            [self getLicenseServiceInfo: deviceId];
        }
        else
        {
            [self.errorView setHidden: NO];
        }
    });
}
- (IBAction)detailEditBtn:(id)sender
{
    [m_HUD setHidden: NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.editViewSearchTxt setText: @""];
        [self.deviceDetailView setHidden: YES];
        [self.editResellerInfoMessage setHidden: YES];
        [self.editViewDevieNameTxt setText: detailDeviceNames];
        [self.editViewMacAddr setText: detailDeviceMac];
        [self.editViewResellerName setText: detailDeviceResellerCorp];
        [self.editViewMail setText: detailDeviceResellerEmail];
        [self.editViewVatNumber setText: detailDeviceResellerVat];
        [self.editView setHidden: NO];
        [m_HUD setHidden: YES];
    });
}
- (void)addLicenseRenewActivateBtn:(UIButton *)sender
{
    action = DEVICE_ACTIVATE_LICENSE;
    debug(@"device id = %@ , service id = %@", detailDeviceId, [renewServiceId objectAtIndex: sender.tag]);
    selectServiceId = [renewServiceId objectAtIndex: sender.tag];
    if ([public checkNetWorkConn])
    {
        [self activeLicense: detailDeviceId andServiceId: selectServiceId];
    }
    else
    {
        [self.errorView setHidden: NO];
    }
}
- (IBAction)addLicenseCancelBtn:(id)sender
{
    [m_HUD setHidden: NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        renewStatus = NO;
        deviceDetailStatus = YES;
        [self.addLicenseView setHidden: YES];
        [self.deviceDetailView setHidden: NO];
        [m_HUD setHidden: YES];
    });
}
- (IBAction)addLicenseDoneBtn:(id)sender
{
    action = ENTER_DEVICE_DETAIL;
    if ([public checkNetWorkConn])
    {
        [self getDeviceDetailInfo: detailDeviceId];
    }
    else
    {
        [self.errorView setHidden: NO];
    }
}
- (IBAction)addLicenseScanActivateBtn:(id)sender
{
    [m_HUD setHidden: NO];
    NSString *eventType = [[NSString alloc]init];
    activateMessageList = [[NSMutableArray alloc]init];
    action = DEVICE_SCAN_MANUAL_ACTIVATE;
    for (int i=0; i<[addLicenseScanKeyList count]; i++)
    {
        NSString *keyFormat = [[NSString alloc]init];
        eventType = [NSString stringWithFormat: @"%@", [addLicenseEventTypeList objectAtIndex: i]];
        keyFormat = [keyFormat stringByAppendingFormat: @"{\"key\":\"%@\"}", [addLicenseScanKeyList objectAtIndex: i]];
        registerindex = i;
        if ([public checkNetWorkConn])
        {
            dispatch_async(dispatch_get_main_queue(), ^() {
                [self addLicenseScanActivateInfo: detailDeviceId andKey: keyFormat andEventType: eventType];
            });
        }
        else
        {
            [self.errorView setHidden: NO];
        }
    }
}
- (IBAction)addLicenseManualActivateBtn:(id)sender
{
    [m_HUD setHidden: NO];
    NSString *eventType = [[NSString alloc]init];
    activateMessageList = [[NSMutableArray alloc]init];
    action = DEVICE_SCAN_MANUAL_ACTIVATE;
    for (int i=0; i<[addLicenseScanKeyList count]; i++)
    {
        NSString *keyFormat = [[NSString alloc]init];
        eventType = [NSString stringWithFormat: @"%@", [addLicenseEventTypeList objectAtIndex: i]];
        keyFormat = [keyFormat stringByAppendingFormat: @"{\"key\":\"%@\"}", [addLicenseScanKeyList objectAtIndex: i]];
        registerindex = i;
        if ([public checkNetWorkConn])
        {
            dispatch_async(dispatch_get_main_queue(), ^() {
                [self addLicenseScanActivateInfo: detailDeviceId andKey: keyFormat andEventType: eventType];
            });
        }
        else
        {
            [self.errorView setHidden: NO];
        }
    }
}
- (IBAction)tryAgainBtn:(id)sender
{
    if ([public checkNetWorkConn])
    {
        if (action == ENTER_DEVICE)
        {
            [self getDeviceInfo];
        }
        else if (action == ENTER_DEVICE_DETAIL)
        {
            [self getDeviceDetailInfo: selectDetailDeviceId];
        }
        else if (action == EDIT_DEVICE)
        {
            [self updateDeviceInfo];
        }
        else if (action == ADD_LICENSE)
        {
            NSString *deviceId = [NSString stringWithFormat: @"%ld", (long)self.detailAddLicenseBtn.tag];
            [self getLicenseServiceInfo: deviceId];
        }
        else if (action == DEVICE_ACTIVATE_LICENSE)
        {
            [self activeLicense: detailDeviceId andServiceId: selectServiceId];
        }
        else if (action == DEVICE_CHECK_MANUAL_ADD_LICENSE)
        {
            [self addLicenseActivateValie: detailDeviceId andKey: self.addLicenseManualViewTxt.text andEventType: @"manually"];
        }
        else if (action == DEVICE_CHECK_SCAN_ADD_LICENSE)
        {
            [self addLicenseActivateValie: detailDeviceId andKey: scanStr andEventType: @"scan"];
        }
        else if (action == DEVICE_SCAN_MANUAL_ACTIVATE)
        {
            [m_HUD setHidden: NO];
            NSString *eventType = [[NSString alloc]init];
            action = DEVICE_SCAN_MANUAL_ACTIVATE;
            for (int i=(int)registerindex; i<[addLicenseScanKeyList count]; i++)
            {
                NSString *keyFormat = [[NSString alloc]init];
                eventType = [NSString stringWithFormat: @"%@", [addLicenseEventTypeList objectAtIndex: i]];
                keyFormat = [keyFormat stringByAppendingFormat: @"{\"key\":\"%@\"}", [addLicenseScanKeyList objectAtIndex: i]];
                registerindex = i;
                if ([public checkNetWorkConn])
                {
                    dispatch_async(dispatch_get_main_queue(), ^() {
                        [self addLicenseScanActivateInfo: detailDeviceId andKey: keyFormat andEventType: eventType];
                    });
                }
                else
                {
                    [self.errorView setHidden: NO];
                }
            }
        }
        else if (action == REGISTER_CHECK_MANUAL_DEVICE)
        {
            [self checkNewDevice: self.manualMacAddress.text andSn: self.manualSerialNumber.text andEventType: @"manually"];
        }
        else if (action == REGISTER_CHECK_SCAN_DEVICE)
        {
            [self checkNewDevice: scanMac andSn: scanSn andEventType: @"scan"];
        }
        else if (action == REGISTER_SEARCH_RESELLER)
        {
            [self searchResellerInfo];
        }
        else if (action == REGISTER_COMPLETE)
        {
            [m_HUD setHidden: NO];
            for (int i=(int)registerDeviceIndex; i<[registerNewDeviceNameList count]; i++)
            {
                NSString *registerDeviceFormat = [[NSString alloc]init];
                NSString *name = [NSString stringWithFormat: @"%@", [registerNewDeviceNameList objectAtIndex: i]];
                NSString *mac = [NSString stringWithFormat: @"%@", [registerNewDeviceMacList objectAtIndex: i]];
                NSString *sn = [NSString stringWithFormat: @"%@", [registerNewDeviceSnList objectAtIndex: i]];
                NSString *eventType = [NSString stringWithFormat: @"%@", [registerNewDeviceEventTypeList objectAtIndex: i]];
                NSString *resellerName = [self.resellerNameTxt.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
                if ([resellerName length] > 0)
                {
                    registerDeviceFormat = [registerDeviceFormat stringByAppendingFormat: @"{\"mac_address\":\"%@\",\"serial_number\":\"%@\",\"name\":\"%@\",\"reseller_search\":\"%@\"}", mac, sn, name, resellerName];
                }
                else
                {
                    registerDeviceFormat = [registerDeviceFormat stringByAppendingFormat: @"{\"mac_address\":\"%@\",\"serial_number\":\"%@\",\"name\":\"%@\"}", mac, sn, name];
                }
                registerDeviceIndex = i;
                if ([public checkNetWorkConn])
                {
                    dispatch_async(dispatch_get_main_queue(), ^() {
                        [self registerNewDevice: registerDeviceFormat andEventType: eventType];
                    });
                }
                else
                {
                    [self.errorView setHidden: NO];
                }
            }
        }
        else if (action == REGISTER_SKIP)
        {
            [self registerNewDeviceSkip];
        }
    }
    else
    {
        debug(@"No Internet.");
    }
}
- (IBAction)cancelViewContinueView:(id)sender
{
    [self.cancelMask setHidden: YES];
    [self.cancalView setHidden: YES];
}
- (IBAction)cancelViewExitView:(id)sender
{
    registerPage3Status = NO;
    deviceListStatus = YES;
    action = ENTER_DEVICE;
    if ([public checkNetWorkConn])
    {
        [self getDeviceInfo];
    }
    else
    {
        [self.errorView setHidden: NO];
    }
}
- (IBAction)searchDeviceCancelBtn:(id)sender {
    [m_HUD setHidden: NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        searchStatus = NO;
        deviceListStatus = YES;
        [self.searchDeviceView setHidden: YES];
        [self.tabBarController.tabBar setHidden: NO];
        [self.deviceView setHidden: NO];
        [m_HUD setHidden: YES];
    });
}
- (IBAction)deviceSearchBtn:(id)sender
{
    [m_HUD setHidden: NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        deviceListStatus = NO;
        searchKeyWordStatus = NO;
        searchStatus = YES;
        [self.searchDeviceTxt setText: @""];
        [self.searchList reloadData];
        [self.tabBarController.tabBar setHidden: YES];
        [self.deviceView setHidden: YES];
        [self.searchNoResView setHidden: YES];
        [self.searchDeviceView setHidden: NO];
        [m_HUD setHidden: YES];
    });
}

- (IBAction)activateOkBtn:(id)sender
{
    if ([public checkNetWorkConn])
    {
        [self getDeviceDetailInfo: detailDeviceId];
        _addLicenseScanStatus = YES;
    }
    else
    {
        [self.errorView setHidden: NO];
    }
}
- (IBAction)registerDeviceScanBtn:(id)sender
{
    scanStatus = YES;
    [self hiddeKeyboard];
    [self.registerDevicePage1ManualView setHidden: YES];
    [self.registerDevicePage1ScanView setHidden: NO];
}
- (IBAction)registerDeviceManualBtn:(id)sender
{
    scanStatus = NO;
    [self.registerDevicePage1ScanView setHidden: YES];
    [self.registerDevicePage1ManualView setHidden: NO];
}
- (IBAction)editViewSaveBtn:(id)sender
{
    NSString *strFormat = [self.editViewDevieNameTxt.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([strFormat length] > 0)
    {
        action = EDIT_DEVICE;
        if ([public checkNetWorkConn])
        {
            [self updateDeviceInfo];
        }
        else
        {
            [self.errorView setHidden: NO];
        }
    }
    else
    {
        [self.editResellerInfoMessage setText: @"Device can't be blank."];
        [self.editResellerInfoMessage setHidden: NO];
    }
}
- (IBAction)editViewCancelBtn:(id)sender
{
    [m_HUD setHidden: NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.editView setHidden: YES];
        [self.deviceDetailView setHidden: NO];
        [m_HUD setHidden: YES];
    });
}
- (IBAction)editViewExitDeviceNameTxt:(id)sender
{
    [self hiddeKeyboard];
}
- (void)registerDeviceFinaOkBtn:(id)sender
{
    dispatch_async(dispatch_get_main_queue(), ^() {
        deviceListStatus = YES;
        registerFinalStatus = NO;
        action = ENTER_DEVICE;
        if ([public checkNetWorkConn])
        {
            [self getDeviceInfo];
        }
        else
        {
            [self.errorView setHidden: NO];
        }
    });
}
// change scan mode
- (IBAction)addLicenseViewBtn:(id)sender
{
    renewStatus = NO;
    addLicenseScanStatus = YES;
    _addLicenseScanStatus = YES;
    addLicenseScanKeyList = [[NSMutableArray alloc]init];
    addLicenseScanNameList = [[NSMutableArray alloc]init];
    addLicenseEventTypeList = [[NSMutableArray alloc]init];
    [self.addLicenseScanList reloadData];
    [self.addLicenseManualList reloadData];
    [self.addlicenseManualActivateBtn setEnabled: NO];
    [self.addlicenseScanActivateBtn setEnabled: NO];
    [self.addLicenseManualViewTxt.layer setCornerRadius: self.addLicenseManualViewTxt.frame.size.height/2];
    [self.addLicenseView setHidden: YES];
    [self.addLicenseScanView setHidden: NO];
    [self.addlicenseManualMessage setHidden: YES];
    [self.addlicenseScanMessage setHidden: YES];
    [self scanCodeAddLicense];
    [self showStatus];
}
- (IBAction)addLicenseScanViewBtn:(id)sender
{
    [self.addLicenseScanView setHidden: YES];
    [self.addLicenseManualView setHidden: NO];
    [_session2 stopRunning];
}
- (IBAction)addLicenseManualViewBtn:(id)sender
{
    [self hiddeKeyboard];
    [self.addLicenseScanView setHidden: NO];
    [self.addLicenseManualView setHidden: YES];
    [_session2 startRunning];
}
- (IBAction)addLicenseManualViewCancelBtn:(id)sender
{
    addLicenseScanStatus = NO;
    renewStatus = YES;
    [self hiddeKeyboard];
    [self.addLicenseManualView setHidden: YES];
    [self.addLicenseView setHidden: NO];
    [_session2 stopRunning];
}
- (IBAction)addLicenseScanViewCancelBtn:(id)sender
{
    addLicenseScanStatus = NO;
    renewStatus = YES;
    [self.addLicenseScanView setHidden: YES];
    [self.addLicenseView setHidden: NO];
    [_session2 stopRunning];
}
- (void)addLicenseDelBtn:(UIButton *)sender
{
    [addLicenseScanNameList removeObjectAtIndex: sender.tag];
    [addLicenseEventTypeList removeObjectAtIndex: sender.tag];
    [addLicenseScanKeyList removeObjectAtIndex: sender.tag];
    if ([addLicenseScanNameList count] == 0)
    {
        [self.addlicenseManualActivateBtn setEnabled: NO];
        [self.addlicenseScanActivateBtn setEnabled: NO];
    }
    [self.addLicenseScanList reloadData];
    [self.addLicenseManualList reloadData];
}
#pragma mark - SCAN EVENTS
- (void)scanCode
{
    if (_session == nil)
    {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
        if (!input) return;
        AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc]init];
        [output setMetadataObjectsDelegate: self queue: dispatch_get_main_queue()];
        CGRect scanCrop=[self getScanCrop: self.scanF.bounds readerViewBounds: self.view.frame];
        output.rectOfInterest = scanCrop;
        _session = [[AVCaptureSession alloc]init];
        [_session setSessionPreset:AVCaptureSessionPresetHigh];
        [_session addInput:input];
        [_session addOutput:output];
        output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode];
        AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession: _session];
        layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
        layer.frame = self.scanF.layer.bounds;
        [self.scanF.layer insertSublayer: layer atIndex:0];
        [_session startRunning];
    }
}
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
#ifdef RELEASE
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex : 0];
        if ([[metadataObject type]isEqualToString: AVMetadataObjectTypeQRCode]) {
            if (addLicenseScanStatus)
            {
                if (_addLicenseScanStatus)
                {
                    _addLicenseScanStatus = NO;
                    BOOL repeated = NO;
                    debug(@"add license scan data = %@", metadataObject.stringValue);
                    for (NSString *license in addLicenseScanKeyList)
                    {
                        if ([license isEqualToString: metadataObject.stringValue])
                        {
                            repeated = YES;
                            [self.addlicenseScanMessage setText: @"The license is already in the list for add license."];
                            [self.addlicenseScanMessage setHidden: NO];
                            break;
                        }
                    }
                    if (repeated == NO)
                    {
                        scanStr = metadataObject.stringValue;
                        [self.addlicenseScanMessage setHidden: YES];
                        [self.addlicenseManualMessage setHidden: YES];
                        action = DEVICE_CHECK_SCAN_ADD_LICENSE;
                        if ([public checkNetWorkConn])
                        {
                            [self addLicenseActivateValie: detailDeviceId andKey: metadataObject.stringValue andEventType: @"scan"];
                        }
                        else
                        {
                            [self.errorView setHidden: NO];
                        }
                    }
                }
            }
            else
            {
                if (_scanStatus)
                {
                    _scanStatus = NO;
                    debug(@"reigster device scan data = %@", metadataObject.stringValue);
                    scanDeviceInfo = [DecodeDevicebyQRcode decodeDeviceInfo: metadataObject.stringValue];
                    debug(@"sn = %@, mac = %@", scanDeviceInfo.SN, scanDeviceInfo.MAC);
                    if (![scanDeviceInfo.SN isEqualToString: @"ERROR"] && ![scanDeviceInfo.MAC isEqualToString: @"ERROR"])
                    {
                        action = REGISTER_CHECK_SCAN_DEVICE;
                        if ([public checkNetWorkConn])
                        {
                            [self checkNewDevice: scanDeviceInfo.MAC andSn: scanDeviceInfo.SN andEventType: @"scan"];
                            [self.scanErrorMessage setHidden: YES];
                        }
                        else
                        {
                            [self.errorView setHidden: NO];
                        }
                    }
                    else
                    {
                        if ([metadataObject.stringValue length] == 33)
                        {
                            _scanStatus = NO;
                            NSString *snKey, *macKey;
                            snKey = [metadataObject.stringValue substringToIndex: 3];
                            macKey = [metadataObject.stringValue substringWithRange: NSMakeRange(17, 4)];
                            NSString *dataConvert = [metadataObject.stringValue stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
                            if ([snKey isEqualToString: @"SN:"] && [macKey isEqualToString: @"MAC:"] && ([dataConvert length] == 33))
                            {
                                NSString *macConvert = [[NSString alloc]init];
                                NSString *snFormat = [dataConvert substringToIndex: 16];
                                debug(@"%@", snFormat);
                                NSArray *sn = [snFormat componentsSeparatedByString: @":"];
                                NSString *macFormat = [dataConvert substringWithRange: NSMakeRange(17, 16)];
                                debug(@"%@", macFormat);
                                NSArray *mac = [macFormat componentsSeparatedByString: @":"];
                                NSString *macStr = [NSString stringWithFormat: @"%@", [mac objectAtIndex: 1]];
                                const char *macCstr = [macStr cStringUsingEncoding: NSUTF8StringEncoding];
                                for (int i=0; i<12; i++)
                                {
                                    if (i == 0)
                                    {
                                        macConvert = [NSString stringWithFormat: @"%c", macCstr[i]];
                                    }
                                    else if ((i%2) == 0)
                                    {
                                        macConvert = [macConvert stringByAppendingFormat: @":%@", [NSString stringWithFormat: @"%c", macCstr[i]]];
                                    }
                                    else
                                    {
                                        macConvert = [macConvert stringByAppendingFormat: @"%@", [NSString stringWithFormat: @"%c", macCstr[i]]];
                                    }
                                }
                                scanSn = [sn objectAtIndex: 1];
                                scanMac = macConvert;
                                action = REGISTER_CHECK_SCAN_DEVICE;
                                if ([public checkNetWorkConn])
                                {
                                    [self checkNewDevice: scanMac andSn: scanSn andEventType: @"scan"];
                                    [self.scanErrorMessage setHidden: YES];
                                }
                                else
                                {
                                    [self.errorView setHidden: NO];
                                }
                            }
                        }
                        else
                        {
                            [self.scanErrorMessage setText: @"Doesn't match with device format."];
                            [self.scanErrorMessage setHidden: NO];
                            _scanStatus = YES;
                        }
                    }
                }
            }
        }
    }
#endif
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
- (void)scanCodeAddLicense
{
    if (_session2 == nil)
    {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
        if (!input) return;
        AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc]init];
        [output setMetadataObjectsDelegate: self queue: dispatch_get_main_queue()];
        CGRect scanCrop=[self getScanCrop: self.addLicenseScanViewScanF.bounds readerViewBounds: self.view.frame];
        output.rectOfInterest = scanCrop;
        _session2 = [[AVCaptureSession alloc]init];
        [_session2 setSessionPreset:AVCaptureSessionPresetHigh];
        [_session2 addInput:input];
        [_session2 addOutput:output];
        output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode];
        AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession: _session2];
        layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
        layer.frame = self.addLicenseScanViewScanF.layer.bounds;
        [self.addLicenseScanViewScanF.layer insertSublayer: layer atIndex:0];
        [_session2 startRunning];
    }
    else
    {
        [_session2 startRunning];
    }
}
# pragma mark - TABLEVIEW CALLBACK
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 0;
    if (deviceListStatus == YES)
    {
        count = deviceCount;
    }
    else if (deviceDetailStatus == YES)
    {
        count = [detailServiceNameList count];
    }
    else if (renewStatus == YES)
    {
        count = [renewServiceNameList count];
    }
    else if (registerPage1Status == YES)
    {
        count = [registerNewDeviceNameList count];
    }
    else if (registerPage2Status == YES)
    {
        count = [registerNewDeviceNameList count];
    }
    else if (registerFinalStatus == YES)
    {
        count = [finalNameList count];
    }
    else if (addLicenseScanStatus == YES)
    {
        count = [addLicenseScanNameList count];
    }
    else if (searchStatus == YES)
    {
        if (searchKeyWordStatus == YES)
        {
            count = [searchDeviceNameList count];
        }
        else
        {
            count = deviceCount;
        }
    }
    else if (activateOkStatus == YES)
    {
        count = [addLicenseScanNameList count];
    }
    return  count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (deviceListStatus == YES)
    {
        static NSString *CellIdentifier = @"deviceCell";
        if (indexPath.row < deviceCount)
        {
            DeviceListCell *deviceCell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
            if (deviceCell == nil)
            {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
            }
            else
            {
                if ([[deviceNewRegisterList objectAtIndex: indexPath.row] isEqualToString: @"YES"])
                {
                    [deviceCell.newlyRegister setHidden: NO];
                    [deviceCell.withExpireServices setHidden: YES];
                }
                else
                {
                    [deviceCell.newlyRegister setHidden: YES];
                    if ([[deviceExpireServiceList objectAtIndex: indexPath.row] isEqualToString: @"YES"])
                    {
                        [deviceCell.withExpireServices setHidden: NO];
                    }
                    else
                    {
                        [deviceCell.withExpireServices setHidden: YES];
                    }
                }
                if ([[deviceNameList objectAtIndex: indexPath.row] isEqualToString: @"<null>"])
                {
                    [deviceCell.name setText: @""];
                }
                else
                {
                    [deviceCell.name setText:[deviceNameList objectAtIndex: indexPath.row]];
                }
                NSInteger deviceId = [[deviceIdList objectAtIndex: indexPath.row]integerValue];
                [deviceCell.name setTag: deviceId];
                [deviceCell.macAddr setText: [deviceMacAddrList objectAtIndex: indexPath.row]];
                cell = deviceCell;
            }
        }
        else
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
        }
    }
    else if (deviceDetailStatus == YES) {
        static NSString *CellIdentifier = @"deviceDetailCell";
        if (indexPath.row < [detailServiceNameList count])
        {
            DetailServiceCell *detailCell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
            if (detailCell == nil)
            {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
            }
            else
            {
                [detailCell.serviceName setText: [detailServiceNameList objectAtIndex: indexPath.row]];
                NSString *status = [detailServiceStatusList objectAtIndex: indexPath.row];
                if ([status isEqualToString: @"expired"])
                {
                    [detailCell.serviceAmount setText: @"Expired"];
                    [detailCell.serviceGracePeriod setTextColor: [UIColor redColor]];
                }
                else
                {
                    NSString *expireAt = [detailServiceExpireAtList objectAtIndex: indexPath.row];
                    if (![expireAt isEqualToString: @"<null>"])
                    {
                        NSString *expireAtConver = [expireAt substringToIndex: 10];
                        NSString *expireAtReplace = [expireAtConver stringByReplacingOccurrencesOfString: @"-" withString: @"/"];
                        [detailCell.serviceAmount setText: [NSString stringWithFormat: @"%@", expireAtReplace]];
                    }
                    else
                    {
                        NSInteger pcsCount = [[detailServiceAmountList objectAtIndex: indexPath.row]integerValue];
                        [detailCell.serviceAmount setText: [NSString stringWithFormat: @"%ld PCs", (long)pcsCount]];
                    }
                }
                if ([[detailGracePeriodList objectAtIndex: indexPath.row] isEqualToString: @"YES"])
                {
                    [detailCell.serviceGracePeriod setText: [NSString stringWithFormat: @"Grace Period: %@ days", [detailGracePeriodAmountList objectAtIndex: indexPath.row]]];
                    [detailCell.serviceGracePeriod setTextColor: [UIColor redColor]];
                }
                else
                {
                    [detailCell.serviceGracePeriod setText: @"Grace Period: 0 days"];
                }
                cell = detailCell;
            }
        }
        else
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
        }
    }
    else if (renewStatus == YES)
    {
        static NSString *CellIdentifier = @"addLicenseCell";
        if (indexPath.row < [renewServiceNameList count])
        {
            AddLicenseCell *addLicenseCell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
            if (addLicenseCell == nil)
            {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
            }
            else
            {
                [addLicenseCell.serviceName setText: [renewServiceNameList objectAtIndex: indexPath.row]];
                NSInteger amountProc = [[renewServiceAmountList objectAtIndex: indexPath.row]integerValue];
                NSString *amountStr = [public getServiceTime: amountProc];
                [addLicenseCell.serviceAmount setText: amountStr];
                [addLicenseCell.count.layer setMasksToBounds: YES];
                [addLicenseCell.count.layer setCornerRadius: addLicenseCell.count.frame.size.width/2];
                [addLicenseCell.count setText: [renewServiceTotalList objectAtIndex: indexPath.row]];
                [addLicenseCell.activate setTag: indexPath.row];
                [addLicenseCell.activate addTarget: self action: @selector(addLicenseRenewActivateBtn:) forControlEvents: UIControlEventTouchUpInside];
                debug(@"sss = %f", addLicenseCell.bounds.size.height);
                cell = addLicenseCell;
            }
        }
        else
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
        }
    }
    else if (registerPage1Status == YES)
    {
        static NSString *CellIdentifier = @"registerDeviceListCell";
        if (indexPath.row < [registerNewDeviceNameList count])
        {
            RegisterDeviceListCell *registerDeviceCell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
            [registerDeviceCell.manualName setText: [registerNewDeviceNameList objectAtIndex: indexPath.row]];
            [registerDeviceCell.manualMac setText: [registerNewDeviceMacList objectAtIndex: indexPath.row]];
            [registerDeviceCell.manualSn setText: [registerNewDeviceSnList objectAtIndex: indexPath.row]];
            [registerDeviceCell.manualBtn setTag: indexPath.row];
            [registerDeviceCell.manualBtn addTarget: self action: @selector(newDeviceDelBtn:) forControlEvents: UIControlEventTouchUpInside];
            [registerDeviceCell.manualBtn setHitTestEdgeInsets: UIEdgeInsetsMake(50, 50, 50, 50)];
            
            [registerDeviceCell.scanName setText: [registerNewDeviceNameList objectAtIndex: indexPath.row]];
            [registerDeviceCell.scanMac setText: [registerNewDeviceMacList objectAtIndex: indexPath.row]];
            [registerDeviceCell.scanSn setText: [registerNewDeviceSnList objectAtIndex: indexPath.row]];
            [registerDeviceCell.scanBtn addTarget: self action: @selector(newDeviceDelBtn:) forControlEvents: UIControlEventTouchUpInside];
            [registerDeviceCell.scanBtn setHitTestEdgeInsets: UIEdgeInsetsMake(50, 50, 50, 50)];
            cell = registerDeviceCell;
        }
        else
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
        }
    }
    else if (registerPage2Status == YES)
    {
        static NSString *CellIdentifier = @"registerDeviceEditListCell";
        if (indexPath.row < [registerNewDeviceNameList count])
        {
            RegisterDeviceEditListCell *registerDeviceEditCell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
            UIView *vi = [[UIView alloc]initWithFrame: CGRectMake(0, 0, 10, registerDeviceEditCell.name.frame.size.height)];
            [registerDeviceEditCell.name setTag: indexPath.row];
            [registerDeviceEditCell.name addTarget: self action: @selector(resetDeviceName:) forControlEvents: UIControlEventEditingDidEndOnExit];
            [registerDeviceEditCell.name setLeftView: vi];
            [registerDeviceEditCell.name setLeftViewMode: UITextFieldViewModeAlways];
            [registerDeviceEditCell.name.layer setCornerRadius: registerDeviceEditCell.name.frame.size.height/2];
            [registerDeviceEditCell.name setText: [registerNewDeviceNameList objectAtIndex: indexPath.row]];
            [registerDeviceEditCell.mac setText: [registerNewDeviceMacList objectAtIndex: indexPath.row]];
            [registerDeviceEditCell.sn  setText: [registerNewDeviceSnList objectAtIndex: indexPath.row]];
            [registerDeviceEditCell.delBtn setTag: indexPath.row];
            [registerDeviceEditCell.delBtn addTarget: self action: @selector(newDeviceEditDelBtn:) forControlEvents: UIControlEventTouchUpInside];
            [registerDeviceEditCell.delBtn setHitTestEdgeInsets: UIEdgeInsetsMake(50, 50, 50, 50)];
            cell = registerDeviceEditCell;
        }
        else
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
        }
    }
    else if (registerFinalStatus == YES)
    {
        static NSString *CellIdentifier = @"registerDeviceFinalListCell";
        if (indexPath.row < [finalNameList count])
        {
            RegisterDeviceFinalListCell *registerDeviceFinalCell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
            if (registerDeviceFinalCell == nil)
            {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
            }
            else
            {
                [registerDeviceFinalCell.name setText: [finalNameList objectAtIndex: indexPath.row]];
                [registerDeviceFinalCell.mac setText: [finalMacList objectAtIndex: indexPath.row]];
                [registerDeviceFinalCell.message setText: [finalMessageList objectAtIndex: indexPath.row]];
                if ([registerDeviceFinalCell.message.text isEqualToString: @"Register succeeded."])
                {
                    [registerDeviceFinalCell.message setTextColor: [UIColor blueColor]];
                }
                cell = registerDeviceFinalCell;
            }
        }
        else
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
        }
    }
    else if (addLicenseScanStatus == YES)
    {
        static NSString *CellIdentifier = @"deviceAddLicenseCell";
        if (indexPath.row < [addLicenseScanNameList count])
        {
            DeviceAddLicenseListCell *deviceAddlicenseCell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
            if (deviceAddlicenseCell == nil)
            {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
            }
            else
            {
                [deviceAddlicenseCell.manualLicenseKey setText: [addLicenseScanKeyList objectAtIndex: indexPath.row]];
                [deviceAddlicenseCell.manualServiceName setText: [addLicenseScanNameList objectAtIndex: indexPath.row]];
                [deviceAddlicenseCell.manualDelBtn setTag: indexPath.row];
                [deviceAddlicenseCell.manualDelBtn addTarget: self action: @selector(addLicenseDelBtn:) forControlEvents: UIControlEventTouchUpInside];
                [deviceAddlicenseCell.manualDelBtn setHitTestEdgeInsets: UIEdgeInsetsMake(50, 50, 50, 50)];
                [deviceAddlicenseCell.scanLicenseKey setText: [addLicenseScanKeyList objectAtIndex: indexPath.row]];
                [deviceAddlicenseCell.scanServiceName setText: [addLicenseScanNameList objectAtIndex: indexPath.row]];
                [deviceAddlicenseCell.scanDelBtn setTag: indexPath.row];
                [deviceAddlicenseCell.scanDelBtn addTarget: self action: @selector(addLicenseDelBtn:) forControlEvents: UIControlEventTouchUpInside];
                [deviceAddlicenseCell.scanDelBtn setHitTestEdgeInsets: UIEdgeInsetsMake(50, 50, 50, 50)];
                cell = deviceAddlicenseCell;
            }
        }
        else
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
        }
    }
    else if (searchStatus == YES)
    {
        static NSString *CellIdentifier = @"searchListCell";
        if (searchKeyWordStatus == YES)
        {
            if (indexPath.row < [searchDeviceNameList count])
            {
                SearchDeviceListCell *searchCell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
                if (searchCell == nil)
                {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
                }
                else
                {
                    if ([[searchExpireServiceList objectAtIndex: indexPath.row] isEqualToString: @"YES"])
                    {
                        [searchCell.withExpireServices setHidden: NO];
                    }
                    else
                    {
                        [searchCell.withExpireServices setHidden: YES];
                    }
                    if ([[searchDeviceNameList objectAtIndex: indexPath.row] isEqualToString: @"<null>"])
                    {
                        [searchCell.name setText: @""];
                    }
                    else
                    {
                        [searchCell.name setText:[searchDeviceNameList objectAtIndex: indexPath.row]];
                    }
                    NSInteger deviceId = [[searchIdList objectAtIndex: indexPath.row]integerValue];
                    [searchCell.name setTag: deviceId];
                    [searchCell.mac setText: [searchDeviceMacList objectAtIndex: indexPath.row]];
                    cell = searchCell;
                }
            }
            else
            {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
            }
        }
        else
        {
            if (indexPath.row < deviceCount)
            {
                SearchDeviceListCell *searchCell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
                if (searchCell == nil)
                {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
                }
                else
                {
                    if ([[deviceExpireServiceList objectAtIndex: indexPath.row] isEqualToString: @"YES"])
                    {
                        [searchCell.withExpireServices setHidden: NO];
                    }
                    else
                    {
                        [searchCell.withExpireServices setHidden: YES];
                    }
                    //[searchCell.name setText:[deviceNameList objectAtIndex: indexPath.row]];
                    NSInteger deviceId = [[deviceIdList objectAtIndex: indexPath.row]integerValue];
                    [searchCell.name setTag: deviceId];
                    if ([[deviceNameList objectAtIndex: indexPath.row] isEqualToString: @"<null>"])
                    {
                        [searchCell.name setText: @""];
                    }
                    else
                    {
                        [searchCell.name setText:[deviceNameList objectAtIndex: indexPath.row]];
                    }
                    [searchCell.mac setText: [deviceMacAddrList objectAtIndex: indexPath.row]];
                    cell = searchCell;
                }
            }
            else
            {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
            }
        }
    }
    else if (activateOkStatus == YES)
    {
        static NSString *CellIdentifier = @"activateOkCell";
        if (indexPath.row < [addLicenseScanNameList count])
        {
            ActivateOkListCell *activateOkListCell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
            if (activateOkListCell == nil)
            {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
            }
            else
            {
                [activateOkListCell.key setText: [addLicenseScanKeyList objectAtIndex: indexPath.row]];
                [activateOkListCell.name setText: [addLicenseScanNameList objectAtIndex: indexPath.row]];
                [activateOkListCell.message setText: [activateMessageList objectAtIndex: indexPath.row]];
                if ([activateOkListCell.message.text isEqualToString: @"Activate succeeded."])
                {
                    [activateOkListCell.message setTextColor: [UIColor blueColor]];
                }
                cell = activateOkListCell;
            }
        }
        else
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
        }
    }
    return cell;
}
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (deviceListStatus == YES) {
        action = ENTER_DEVICE_DETAIL;
        DeviceListCell *deviceCell = [self.devicesList cellForRowAtIndexPath: indexPath];
        NSString *select = deviceCell.name.text;
        debug(@"select index = %ld, text = %@", (long)indexPath.row, select);
        debug(@"id = %ld", (long)deviceCell.name.tag);
        [self.detailDeviceName setText: select];
        [self.detailAddLicenseBtn setTag: deviceCell.name.tag];
        selectDetailDeviceId = [NSString stringWithFormat: @"%ld", (long)deviceCell.name.tag];
        dispatch_async(dispatch_get_main_queue(), ^() {
            if ([public checkNetWorkConn])
            {
//                debug(@"selected parsed module code = %@", [deviceParsedModuleCodeList objectAtIndex: indexPath.row]);
                [self getDeviceDetailInfo: selectDetailDeviceId];
            }
            else
            {
                [self.errorView setHidden: NO];
            }
        });
    }
    if (searchStatus == YES)
    {
        action = ENTER_DEVICE_DETAIL;
        SearchDeviceListCell *searchDeviceCell = [self.searchList cellForRowAtIndexPath: indexPath];
        NSString *select = searchDeviceCell.name.text;
        debug(@"select index = %ld, text = %@", (long)indexPath.row, select);
        debug(@"id = %ld", (long)searchDeviceCell.name.tag);
        [self.detailDeviceName setText: select];
        [self.detailAddLicenseBtn setTag: searchDeviceCell.name.tag];
        selectDetailDeviceId = [NSString stringWithFormat: @"%ld", (long)searchDeviceCell.name.tag];
        dispatch_async(dispatch_get_main_queue(), ^() {
            if ([public checkNetWorkConn])
            {
                [self getDeviceDetailInfo: selectDetailDeviceId];
            }
            else
            {
                [self.errorView setHidden: NO];
            }
        });
    }
    return indexPath;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
@end
