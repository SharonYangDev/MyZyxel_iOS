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
    NSInteger deviceCount;
    NSInteger action;
    NSMutableArray *deviceNameList;
    NSMutableArray *deviceMacAddrList;
    NSMutableArray *deviceIdList;
    NSMutableArray *deviceExpireServiceList;
    NSMutableArray *detailServiceNameList;
    NSMutableArray *detailServiceAmountList;
    NSString *detailDeviceId;
    NSString *detailDeviceName;
    NSString *detailDeviceMacAddr;
    NSString *detailDeviceModel;
    NSString *detailSerialNo;
    NSString *detailDeviceResellerCompany;
    NSString *detailDeviceResellerMail;
    NSString *detailDeviceResellerVat;
    NSString *selectDetailDeviceId;
    NSString *selectServiceId;
    NSString *scanStr;
    NSString *scanMac;
    NSString *scanSn;
    NSMutableArray *renewServiceNameList;
    NSMutableArray *renewServiceAmountList;
    NSMutableArray *renewServiceTotalList;
    NSMutableArray *renewServiceId;
    NSMutableArray *registerNewDeviceNameList;
    NSMutableArray *registerNewDeviceMacList;
    NSMutableArray *registerNewDeviceSnList;
    NSMutableArray *finalNameList;
    NSMutableArray *finalMacList;
    NSMutableArray *addLicenseScanKeyList;
    NSMutableArray *addLicenseScanNameList;
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
    [self.detailAddLicenseBtn.layer setMasksToBounds: YES];
    [self.detailAddLicenseBtn.layer setCornerRadius: self.detailAddLicenseBtn.frame.size.height/2];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithString: self.addLicenseViewBtn.titleLabel.text];
    [attrString setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Oblique" size:15.0],NSForegroundColorAttributeName:[UIColor darkGrayColor],NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]} range:NSMakeRange(0,[attrString length])];
    [self.addLicenseViewBtn setAttributedTitle: attrString forState: UIControlStateNormal];
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
    [self.deviceDetailView setHidden: YES];
    [self.addLicenseView setHidden: YES];
    [self.editView setHidden: YES];
    [self.addLicenseView setHidden: YES];
    [self.addLicenseScanView setHidden: YES];
    [self.addLicenseManualView setHidden: YES];
    [self.noDeviceView setHidden: YES];
    [self.errorView setHidden: YES];
    [self.cancelMask setHidden: YES];
    [self.cancalView setHidden: YES];
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
    UITapGestureRecognizer *hiddeKeyBoard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editViewExitDeviceNameTxt:)];
    hiddeKeyBoard.cancelsTouchesInView = NO;
    [self.editView addGestureRecognizer: hiddeKeyBoard];
    [self.devicesList setSeparatorStyle: UITableViewCellSeparatorStyleNone];
    [self.detailServiceList setSeparatorStyle: UITableViewCellSeparatorStyleNone];
    [self.detailAddLicenseBtn.layer setBorderWidth: 1];
    [self.detailAddLicenseBtn.layer setBorderColor: [UIColor darkGrayColor].CGColor];
    [self getDeviceInfo];
}
#pragma mark - GET SERVER INFO
- (void)getDeviceInfo
{
    [m_HUD setHidden: NO];
    [m_HUD.label setText: @"Load device data ..."];
    selectDetailDeviceId = [[NSString alloc]init];
    NSError *error;
    NSDictionary *payload = @{};
    NSString *token = [Jwt encodeWithPayload: payload andKey: [public get_secret_access_key] andError:&error];
    if(token == nil)
    {
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
                  deviceNameList = [[NSMutableArray alloc]init];
                  deviceMacAddrList = [[NSMutableArray alloc]init];
                  deviceExpireServiceList = [[NSMutableArray alloc]init];
                  deviceIdList = [[NSMutableArray alloc]init];
                  NSMutableDictionary *devices_info_json = [NSJSONSerialization JSONObjectWithData: aes_decode_data options:kNilOptions error: nil];
                  deviceCount = [[devices_info_json objectForKey: @"total"]integerValue];
                  if (deviceCount > 0)
                  {
                      NSArray *deviceListArr = [devices_info_json objectForKey: @"devices"];
                      for (NSDictionary *device in deviceListArr)
                      {
                          NSString *withExpireServices = [NSString stringWithFormat: @"%@", [device objectForKey: @"with_expire_services"]];
                          if ([withExpireServices isEqualToString: @"1"])
                          {
                              [deviceExpireServiceList addObject: @"YES"];
                          }
                          else
                          {
                              [deviceExpireServiceList addObject: @"NO"];
                          }
                          NSString *name = [NSString stringWithFormat: @"%@", [device objectForKey: @"name"]];
                          [deviceNameList addObject: name];
                          NSString *mac_address = [NSString stringWithFormat: @"%@", [device objectForKey: @"mac_address"]];
                          [deviceMacAddrList addObject: mac_address];
                          NSString *id = [NSString stringWithFormat: @"%@", [device objectForKey: @"id"]];
                          [deviceIdList addObject: id];
                      }
                      
                      dispatch_async(dispatch_get_main_queue(), ^() {
                          if (deviceListStatus == YES)
                          {
                              [self.noDeviceView setHidden: YES];
                              [self.devicesList setHidden: NO];
                              [self.devicesList reloadData];
                              [self.errorView setHidden: YES];
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
                  debug(@"server response message = %@", message);
              }
          }
          else
          {
              [self.errorView setHidden: NO];
              [m_HUD setHidden: YES];
          }
      }] resume];
}
- (void)getDeviceDetailInfo:(NSString *)deviceId
{
    [m_HUD setHidden: NO];
    m_HUD.label.text = @"Load device detail ...";
    NSError *error;
    NSString *payloadFormat = [NSString stringWithFormat: @"{"
                               "\"device_id\": %@"
                               "}", deviceId];
    NSData *payloadJson = [payloadFormat dataUsingEncoding: NSUTF8StringEncoding];
    NSDictionary *payload = [NSJSONSerialization JSONObjectWithData: payloadJson options: kNilOptions error: &error];
    NSString *token = [Jwt encodeWithPayload: payload andKey: [public get_secret_access_key] andError:&error];
    if(token == nil)
    {
        if (DEBUG) debug(@"Code: %li", (long)[error code]);
        if (DEBUG) debug(@"Reason: %@", [error localizedFailureReason]);
    }
    else
    {
        if (DEBUG) debug(@"jwt token = %@", token);
    }
    NSString *get_devices_detail_info_url = [NSString stringWithFormat: @"%@/api/v2/my/device?token=%@&access_key_id=%@", DATA_URL, token, [public get_access_key_id]];
    if (DEBUG) debug(@"get_devices_detail_info_url = %@", get_devices_detail_info_url);
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
              if (DEBUG) debug(@"devicesDetailInfo = %@", json);
              
              NSString *encryptionCode = [json objectForKey: @"data"];
              NSString *iv = [encryptionCode substringWithRange: NSMakeRange(0, 16)];
              NSString *encrypted_data = [encryptionCode substringFromIndex: 16];
              NSString *sha256_decode_data = [public sha256: [public get_secret_access_key]];
              NSData *decode_key = [public hexToBytes: sha256_decode_data];
              NSData *base64_decode_data = [[NSData alloc]initWithData: (NSData *)[public base64_decode: encrypted_data]];
              NSData *aes_decode_data = [[NSData alloc]initWithData: [public aes_cbc_256: base64_decode_data andIv: iv andkey: decode_key andType: kCCDecrypt]];
              NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingUTF8);
              NSString *devicesDetailInfo = [[NSString alloc]initWithData: aes_decode_data encoding: enc];
              if (DEBUG) debug(@"devices Detail info = %@", devicesDetailInfo);
              detailServiceNameList = [[NSMutableArray alloc]init];
              detailServiceAmountList = [[NSMutableArray alloc]init];
              NSMutableDictionary *devices_detail_info_json = [NSJSONSerialization JSONObjectWithData: aes_decode_data options:kNilOptions error: nil];
              detailDeviceId = [NSString stringWithFormat: @"%@", [devices_detail_info_json objectForKey: @"device_id"]];
              detailDeviceName = [NSString stringWithFormat: @"%@", [devices_detail_info_json objectForKey: @"name"]];
              detailDeviceMacAddr = [NSString stringWithFormat: @"%@", [devices_detail_info_json objectForKey: @"mac_address"]];
              detailDeviceModel = [NSString stringWithFormat: @"%@", [devices_detail_info_json objectForKey: @"model"]];
              detailSerialNo = [NSString stringWithFormat: @"%@", [devices_detail_info_json objectForKey: @"serial_number"]];
              NSDictionary *resellerInfo = [devices_detail_info_json objectForKey: @"reseller_info"];
              if (DEBUG) debug(@"reseller info = %@", resellerInfo);
              if (resellerInfo != nil)
              {
                  detailDeviceResellerCompany = [NSString stringWithFormat: @"%@", [resellerInfo objectForKey: @"company_name"]];
                  detailDeviceResellerMail = [NSString stringWithFormat: @"%@", [resellerInfo objectForKey: @"email"]];
                  detailDeviceResellerVat = [NSString stringWithFormat: @"%@", [resellerInfo objectForKey: @"vat_number"]];
              }
              else
              {
                  detailDeviceResellerCompany = @"";
                  detailDeviceResellerMail = @"";
                  detailDeviceResellerVat = @"";
              }
              NSArray *deviceListArr = [devices_detail_info_json objectForKey: @"services"];
              for (NSDictionary *device in deviceListArr)
              {
                  NSString *name = [NSString stringWithFormat: @"%@", [device objectForKey: @"name"]];
                  // remove PKG_Update
                  if (![name isEqualToString: @"PKG_Update"])
                  {
                      [detailServiceNameList addObject: name];
                      NSNumber *amount = [device objectForKey: @"remain_amount"];
                      [detailServiceAmountList addObject: amount];
                  }
              }
              dispatch_async(dispatch_get_main_queue(), ^() {
                  if (deviceListStatus == YES || deviceDetailStatus == YES)
                  {
                      [self setDeviceDetailFromDeviceList: detailDeviceName andMac: detailDeviceMacAddr andModel: detailDeviceModel andSerial: detailSerialNo];
                  }
                  
                  if (renewStatus == YES)
                  {
                      [self setDeviceDetailFromAddLicense: detailDeviceName andMac: detailDeviceMacAddr andModel: detailDeviceModel andSerial: detailSerialNo];
                  }
                  if (addLicenseScanStatus == YES)
                  {
                      [self setDeviceDetailFromScanLicense: detailDeviceName andMac: detailDeviceMacAddr andModel: detailDeviceModel andSerial: detailSerialNo];
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
- (void)getLicenseServiceInfo:(NSString *)deviceId
{
    [m_HUD setHidden: NO];
    [m_HUD.label setText: @"Load license data ..."];
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
          if (data != nil)
          {
              NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData: data options: kNilOptions error: nil];
              if (DEBUG) debug(@"license service info = %@", json);
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
              
              NSMutableDictionary *status = [json objectForKey: @"return_status"];
              NSString *code = [NSString stringWithFormat: @"%@", [status objectForKey: @"code"]];
              NSString *message = [NSString stringWithFormat: @"%@", [status objectForKey: @"message"]];
              if ([code isEqualToString: @"0"])
              {
                  NSMutableDictionary *license_info_json = [NSJSONSerialization JSONObjectWithData: aes_decode_data options:kNilOptions error: nil];
                  NSArray *licenseListArr = [license_info_json objectForKey: @"services"];
                  
                  renewServiceNameList = [[NSMutableArray alloc]init];
                  renewServiceTotalList = [[NSMutableArray alloc]init];
                  renewServiceAmountList = [[NSMutableArray alloc]init];
                  renewServiceId = [[NSMutableArray alloc]init];
                  
                  for (NSDictionary *license in licenseListArr)
                  {
                      NSString *name = [NSString stringWithFormat: @"%@", [license objectForKey: @"name"]];
                      [renewServiceNameList addObject: name];
                      NSString *total = [NSString stringWithFormat: @"%@", [license objectForKey: @"total"]];
                      [renewServiceTotalList addObject: total];
                      NSString *amount = [NSString stringWithFormat: @"%@", [license objectForKey: @"amount"]];
                      [renewServiceAmountList addObject: amount];
                      NSString *serviceId = [NSString stringWithFormat: @"%@", [license objectForKey: @"license_service_id"]];
                      [renewServiceId addObject: serviceId];
                  }
                  
                  dispatch_async(dispatch_get_main_queue(), ^() {
                      deviceDetailStatus = NO;
                      renewStatus = YES;
                      [self.addLicenseServiceList reloadData];
                      [self.deviceDetailView setHidden: YES];
                      [self.addLicenseView setHidden: NO];
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
- (void)searchResellerInfo
{
    [m_HUD setHidden: NO];
    [m_HUD.label setText: @"Search reseller ..."];
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
            if (DEBUG) debug(@"Code: %li", (long)[error code]);
            if (DEBUG) debug(@"Reason: %@", [error localizedFailureReason]);
        }
        else
        {
            if (DEBUG) debug(@"jwt token = %@", token);
        }
        NSString *get_reseller_info_url = [NSString stringWithFormat: @"%@/api/v2/resellers/search?token=%@&access_key_id=%@", DATA_URL, token, [public get_access_key_id]];
        if (DEBUG) debug(@"get_reseller_info_url = %@", get_reseller_info_url);
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
                  if (DEBUG) debug(@"resellerInfo = %@", json);
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
                      if (DEBUG) debug(@"reseller info = %@", resellerInfo);
                      NSMutableDictionary *reseller_info_json = [NSJSONSerialization JSONObjectWithData: aes_decode_data options:kNilOptions error: nil];
                      NSMutableDictionary *resellerList = [reseller_info_json objectForKey: @"reseller_info"];
                      NSString *vatNumber = [NSString stringWithFormat: @"%@", [resellerList objectForKey: @"vat_number"]];
                      dispatch_async(dispatch_get_main_queue(), ^() {
                          [self.resellerInfoMessage setText: @""];
                          [self.resellerNameTxt setText: [resellerList objectForKey: @"company_name"]];
                          [self.resellerMailTxt setText: [resellerList objectForKey: @"email"]];
                          [self.resellerVatTxt setText: vatNumber];
                          [self.registerDevicePage3RegisterBtn setEnabled: YES];
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
                          [self.registerDevicePage3RegisterBtn setEnabled: NO];
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
- (void)editSearchResellerInfo
{
    [m_HUD setHidden: NO];
    [m_HUD.label setText: @"Search reseller data ..."];
    NSError *error;
    NSString *payloadFormat = [NSString stringWithFormat: @"{"
                               "\"reseller_search\": \"%@\""
                               "}", self.editViewSearchTxt.text];
    NSData *payloadJson = [payloadFormat dataUsingEncoding: NSUTF8StringEncoding];
    NSDictionary *payload = [NSJSONSerialization JSONObjectWithData: payloadJson options: kNilOptions error: &error];
    NSString *token = [Jwt encodeWithPayload: payload andKey: [public get_secret_access_key] andError:&error];
    if(token == nil)
    {
        if (DEBUG) debug(@"Code: %li", (long)[error code]);
        if (DEBUG) debug(@"Reason: %@", [error localizedFailureReason]);
    }
    else
    {
        if (DEBUG) debug(@"jwt token = %@", token);
    }
    NSString *get_reseller_info_url = [NSString stringWithFormat: @"%@/api/v2/resellers/search?token=%@&access_key_id=%@", DATA_URL, token, [public get_access_key_id]];
    if (DEBUG) debug(@"get_reseller_info_url = %@", get_reseller_info_url);
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
              if (DEBUG) debug(@"resellerInfo = %@", json);
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
                  if (DEBUG) debug(@"reseller info = %@", resellerInfo);
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
- (void)checkNewDevice:(NSString *)macAddr andSn:(NSString *)serialNum
{
    [m_HUD.label setText: @"Check device data ..."];
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
            [self.manualErrorMessage setText: @"MAC or SN repeted"];
            [self.scanErrorMessage setText: @"MAC or SN repeted"];
            [self.manualErrorMessage setHidden: NO];
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
            if (DEBUG) debug(@"Code: %li", (long)[error code]);
            if (DEBUG) debug(@"Reason: %@", [error localizedFailureReason]);
        }
        else
        {
            if (DEBUG) debug(@"jwt token = %@", token);
        }
        
        NSString *reseller_info_url = [NSString stringWithFormat: @"%@/api/v2/my/devices/register?token=%@&access_key_id=%@", DATA_URL, token, [public get_access_key_id]];
        if (DEBUG) debug(@"reseller_info_url = %@", reseller_info_url);
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
                  if (DEBUG) debug(@"device info = %@", json);
                  
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
                      if (DEBUG) debug(@"device info = %@", deviceInfo);
                      
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
- (void)registerNewDevice
{
    [m_HUD setHidden: NO];
    [m_HUD.label setText: @"Register device ..."];
    NSError *error;
    NSString *registerDeviceFormat = [[NSString alloc]init];
    for (int i=0; i<[registerNewDeviceNameList count]; i++)
    {
        NSString *name = [NSString stringWithFormat: @"%@", [registerNewDeviceNameList objectAtIndex: i]];
        NSString *mac = [NSString stringWithFormat: @"%@", [registerNewDeviceMacList objectAtIndex: i]];
        NSString *sn = [NSString stringWithFormat: @"%@", [registerNewDeviceSnList objectAtIndex: i]];
        NSString *resellerName =[[NSString alloc]initWithString: self.resellerNameTxt.text];
        if (i == ([registerNewDeviceNameList count]-1))
        {
            registerDeviceFormat = [registerDeviceFormat stringByAppendingFormat: @"{\"mac_address\":\"%@\",\"serial_number\":\"%@\",\"name\":\"%@\",\"reseller_search\":\"%@\"}", mac, sn, name, resellerName];
        }
        else
        {
            registerDeviceFormat = [registerDeviceFormat stringByAppendingFormat: @"{\"mac_address\":\"%@\",\"serial_number\":\"%@\",\"name\":\"%@\",\"reseller_search\":\"%@\"},", mac, sn, name, resellerName];
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
        if (DEBUG) debug(@"Code: %li", (long)[error code]);
        if (DEBUG) debug(@"Reason: %@", [error localizedFailureReason]);
    }
    else
    {
        if (DEBUG) debug(@"jwt token = %@", token);
    }
    NSString *reseller_info_url = [NSString stringWithFormat: @"%@/api/v2/my/devices/register?token=%@&access_key_id=%@", DATA_URL, token, [public get_access_key_id]];
    if (DEBUG) debug(@"reseller_info_url = %@", reseller_info_url);
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
              if (DEBUG) debug(@"register device info = %@", json);
              
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
                  if (DEBUG) debug(@"register device info = %@", registerDeviceInfo);
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
                      registerPage3Status =NO;
                      registerFinalStatus = YES;
                      [self.registerDeviceFinalSuccessMessage setText: [NSString stringWithFormat: @"%d devices registered successfully", [finalNameList count]]];
                      [self.registerDeviceFinalResellerName setText: self.resellerNameTxt.text];
                      [self.registerDeviceFinalRsellerMail setText: self.resellerMailTxt.text];
                      [self.registerDeviceFinalList reloadData];
                      dispatch_async(dispatch_get_main_queue(), ^() {
                          [self.registerDevicePage3View setHidden: YES];
                          [self.registerDeviceListView setHidden: NO];
                          [self.errorView setHidden: YES];
                          [m_HUD setHidden: YES];
                      });
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
- (void)registerNewDeviceSkip
{
    [m_HUD setHidden: NO];
    [m_HUD.label setText: @"Register device ..."];
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
        if (DEBUG) debug(@"Code: %li", (long)[error code]);
        if (DEBUG) debug(@"Reason: %@", [error localizedFailureReason]);
    }
    else
    {
        if (DEBUG) debug(@"jwt token = %@", token);
    }
    NSString *reseller_info_url = [NSString stringWithFormat: @"%@/api/v2/my/devices/register?token=%@&access_key_id=%@", DATA_URL, token, [public get_access_key_id]];
    if (DEBUG) debug(@"reseller_info_url = %@", reseller_info_url);
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
              if (DEBUG) debug(@"register device info = %@", json);
              
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
                  if (DEBUG) debug(@"register device info = %@", registerDeviceInfo);
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
- (void)updateDeviceInfo
{
    [m_HUD setHidden: NO];
    [m_HUD.label setText: @"Save data ..."];
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
        if (DEBUG) debug(@"Code: %li", (long)[error code]);
        if (DEBUG) debug(@"Reason: %@", [error localizedFailureReason]);
    }
    else
    {
        if (DEBUG) debug(@"jwt token = %@", token);
    }
    NSString *update_device_info_url = [NSString stringWithFormat: @"%@/api/v2/my/device?token=%@&access_key_id=%@", DATA_URL, token, [public get_access_key_id]];
    if (DEBUG) debug(@"update_device_info_url = %@", update_device_info_url);
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
              if (DEBUG) debug(@"updateDeviceInfo = %@", json);
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
                  if (DEBUG) debug(@"update device info = %@", resellerInfo);
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
- (void)activeLicense:(NSString *)deviceId andServiceId:(NSString *)serviceId
{
    [m_HUD setHidden: NO];
    [m_HUD.label setText: @"Activating license ..."];
    NSError *error;
    NSString *payloadFormat = [NSString stringWithFormat: @"{"
                               "\"device_id\": \"%@\","
                               "\"license_service_id\": \"%@\","
                               "}", deviceId, serviceId];
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
          if (data != nil)
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
                  
                  if (DEBUG) debug(@"name = %@, expired_at = %@", name, expired_at);
                  dispatch_async(dispatch_get_main_queue(), ^() {
                      [self.addlicenseServiceName setText: name];
                      [self.addlicenseServiceName setHidden: NO];
                      [self.addlicenseServiceExpiredDate setText: expired_at];
                      [self.addlicenseServiceExpiredDate setHidden: NO];
                      [self.addLicenseCancelBtn setHidden: YES];
                      [self.addLicenseDoneBtn setHidden: NO];
                      [m_HUD setHidden: YES];
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
- (void)addLicenseActivateValie:(NSString *)deviceId andKey:(NSString *)key
{
    [m_HUD setHidden: NO];
    [m_HUD.label setText: @"Check license ..."];
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
        if (DEBUG) debug(@"Code: %li", (long)[error code]);
        if (DEBUG) debug(@"Reason: %@", [error localizedFailureReason]);
    }
    else
    {
        if (DEBUG) debug(@"jwt token = %@", token);
    }
    NSString *get_activate_license_info_url = [NSString stringWithFormat: @"%@/api/v2/my/devices/licenses/activate?token=%@&access_key_id=%@", DATA_URL, token, [public get_access_key_id]];
    if (DEBUG) debug(@"add_license_varification_url = %@", get_activate_license_info_url);
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
                  NSString *addLicenseInfo = [[NSString alloc]initWithData: aes_decode_data encoding: enc];
                  if (DEBUG) debug(@"license verification info = %@", addLicenseInfo);
                  
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
- (void)addLicenseScanActivateInfo:(NSString *)deviceId
{
    [m_HUD setHidden: NO];
    [m_HUD.label setText: @"Activate license ..."];
    NSString *keyFormat = [[NSString alloc]init];
    for (int i=0; i<[addLicenseScanKeyList count]; i++)
    {
        if (i == ([addLicenseScanKeyList count]-1))
        {
            keyFormat = [keyFormat stringByAppendingFormat: @"{\"key\":\"%@\"}", [addLicenseScanKeyList objectAtIndex: i]];
        }
        else
        {
            keyFormat = [keyFormat stringByAppendingFormat: @"{\"key\":\"%@\"},", [addLicenseScanKeyList objectAtIndex: i]];
        }
    }
    NSError *error;
    NSString *payloadFormat = [NSString stringWithFormat: @"{"
                               "\"pretend\": true,"
                               "\"device_id\": \"%@\","
                               "\"licenses\": [%@]}", deviceId, keyFormat];
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
    NSString *get_activate_license_info_url = [NSString stringWithFormat: @"%@/api/v2/my/devices/licenses/activate?token=%@&access_key_id=%@", DATA_URL, token, [public get_access_key_id]];
    if (DEBUG) debug(@"add_license_varification_url = %@", get_activate_license_info_url);
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
                  NSString *addLicenseInfo = [[NSString alloc]initWithData: aes_decode_data encoding: enc];
                  if (DEBUG) debug(@"license activate info = %@", addLicenseInfo);
                  dispatch_async(dispatch_get_main_queue(), ^() {
                      [self getDeviceDetailInfo: detailDeviceId];
                      [self.addlicenseScanMessage setHidden: YES];
                      [self.addlicenseManualMessage setHidden: YES];
                      [self.errorView setHidden: YES];
                      [m_HUD setHidden: YES];
                      _addLicenseScanStatus = YES;
                  });
                  
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
# pragma mark - FUNCTION EVENTS
- (void)setDeviceDetailFromDeviceList:(NSString *)name andMac:(NSString *)mac andModel:(NSString *)model andSerial:(NSString *)serial
{
    deviceListStatus = NO;
    deviceDetailStatus = YES;
    [self.detailDeviceName setText: detailDeviceName];
    [self.detailDeviceMacAddr setText: detailDeviceMacAddr];
    [self.detailDeviceModel setText: detailDeviceModel];
    [self.detailSerialNo setText: detailSerialNo];
    [self.detailDeviceResellerCompany setText: detailDeviceResellerCompany];
    [self.detailDeviceResellerMail setText: detailDeviceResellerMail];
    [self.detailServiceList reloadData];
    [self.deviceView setHidden: YES];
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
    [self.detailDeviceMacAddr setText: detailDeviceMacAddr];
    [self.detailDeviceModel setText: detailDeviceModel];
    [self.detailSerialNo setText: detailSerialNo];
    [self.detailDeviceResellerCompany setText: detailDeviceResellerCompany];
    [self.detailDeviceResellerMail setText: detailDeviceResellerMail];
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
    [self.detailDeviceMacAddr setText: detailDeviceMacAddr];
    [self.detailDeviceModel setText: detailDeviceModel];
    [self.detailSerialNo setText: detailSerialNo];
    [self.detailDeviceResellerCompany setText: detailDeviceResellerCompany];
    [self.detailDeviceResellerMail setText: detailDeviceResellerMail];
    [self.detailServiceList reloadData];
    [self.addLicenseView setHidden: YES];
    [self.deviceDetailView setHidden: NO];
    [self.errorView setHidden: YES];
    [m_HUD setHidden: YES];
}
- (void)checkDeviceInfo
{
    if ([self.manualMacAddress.text length] > 0 && [self.manualSerialNumber.text length] > 0)
    {
        action = REGISTER_CHECK_MANUAL_DEVICE;
        [self checkNewDevice: self.manualMacAddress.text andSn: self.manualSerialNumber.text];
    }
}
- (void)newDeviceDelBtn:(UIButton *)sender
{
    [registerNewDeviceNameList removeObjectAtIndex: sender.tag];
    [registerNewDeviceMacList removeObjectAtIndex: sender.tag];
    [registerNewDeviceSnList removeObjectAtIndex: sender.tag];
    
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
        [self searchResellerInfo];
    }
}
- (void)editSearchReseller
{
    NSString *strFormat = [self.editViewSearchTxt.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([strFormat length] > 0)
    {
        action = EDIT_SEARCH_RESELLER;
        [self editSearchResellerInfo];
    }
}
- (void)verificationLicense
{
    if ([self.addLicenseManualViewTxt.text length] > 0)
    {
        action = DEVICE_CHECK_MANUAL_ADD_LICENSE;
        [self addLicenseActivateValie: detailDeviceId andKey: self.addLicenseManualViewTxt.text];
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
# pragma mark - BUTTON EVENTS
- (IBAction)deviceAddDeviceBtn:(id)sender
{
    [m_HUD setHidden: NO];
    [m_HUD.label setText: @"Add Devices ..."];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        deviceListStatus = NO;
        registerPage1Status = YES;
        registerNewDeviceNameList = [[NSMutableArray alloc]init];
        registerNewDeviceMacList = [[NSMutableArray alloc]init];
        registerNewDeviceSnList = [[NSMutableArray alloc]init];
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
        [self.resellerNameTxt setText: @""];
        [self.resellerMailTxt setText: @""];
        [self.resellerVatTxt setText: @""];
        [self.manualSerialNumber setText: @""];
        [self.manualMacAddress setText: @""];
        [self.manualMacAddress.layer setCornerRadius: self.manualMacAddress.frame.size.height/2];
        [self.manualSerialNumber.layer setCornerRadius: self.manualSerialNumber.frame.size.height/2];
        [self.manualMacAddress setClearButtonMode: UITextFieldViewModeAlways];
        [self.manualSerialNumber setClearButtonMode: UITextFieldViewModeAlways];
        [self scanCode];
        [self.tabBarController.tabBar setHidden: YES];
        [self.deviceView setHidden: YES];
        [self.registerDevicePage1ScanView setHidden: NO];
        [m_HUD setHidden: YES];
//        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {//相机权限
//            if (granted) {
//                NSLog(@"Authorized");
//            }else{
//                NSLog(@"Denied or Restricted");
//            }
//        }];
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    });
}
- (IBAction)registerDevicePage1NextBtn:(id)sender
{
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
}
- (IBAction)registerDevicePage2SaveBtn:(id)sender
{
    registerPage2Status = NO;
    registerPage3Status = YES;
    [self hiddeKeyboard];
    [self.registerDevicePage3RegisterBtn setEnabled: NO];
    [self.registerDevicePage2View setHidden: YES];
    [self.registerDevicePage3View setHidden: NO];
    [self.resellerInfoMessage setHidden: YES];
    [self.resellerNameTxt setClearButtonMode: UITextFieldViewModeAlways];
    [self.resellerMailTxt setClearButtonMode: UITextFieldViewModeAlways];
    [self.resellerVatTxt setClearButtonMode: UITextFieldViewModeAlways];
    [self.resellerNameTxt.layer setCornerRadius: self.resellerNameTxt.frame.size.height/2];
    [self.resellerMailTxt.layer setCornerRadius: self.resellerMailTxt.frame.size.height/2];
    [self.resellerVatTxt.layer setCornerRadius: self.resellerVatTxt.frame.size.height/2];
}

- (IBAction)registerDevicePage2BackBtn:(id)sender
{
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
}
- (IBAction)registerDevicePage3BackBtn:(id)sender
{
    [self hiddeKeyboard];
    [self.registerDevicePage2View setHidden: NO];
    [self.registerDevicePage3View setHidden: YES];
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
//    [self.registerDevicePage1ScanView setHidden: YES];
//    [self.registerDevicePage1ManualView setHidden: YES];
//    [self.tabBarController.tabBar setHidden: NO];
//    [self.deviceView setHidden: NO];
    [self hiddeKeyboard];
    action = ENTER_DEVICE;
    [self getDeviceInfo];
}
- (IBAction)registerDevicepage2CancelBtn:(id)sender
{
    registerPage2Status = NO;
    deviceListStatus = YES;
//    [self.registerDevicePage2View setHidden: YES];
//    [self.tabBarController.tabBar setHidden: NO];
//    [self.deviceView setHidden: NO];
    //action = ENTER_DEVICE;
    //[self getDeviceInfo];
    [self hiddeKeyboard];
    [self.cancelMask setHidden: NO];
    [self.cancalView setHidden: NO];
}
- (IBAction)registerDevicepage3CancelBtn:(id)sender
{
//    [self.registerDevicePage3View setHidden: YES];
//    [self.tabBarController.tabBar setHidden: NO];
//    [self.deviceView setHidden: NO];
    [self hiddeKeyboard];
    [self.cancelMask setHidden: NO];
    [self.cancalView setHidden: NO];
}
- (IBAction)registerDevicePage3RegisterBtn:(id)sender
{
    [self hiddeKeyboard];
    action = REGISTER_COMPLETE;
    finalNameList = [[NSMutableArray alloc]init];
    finalMacList = [[NSMutableArray alloc]init];
    [self registerNewDevice];
}
- (IBAction)deviceDetailBackBtn:(id)sender
{
    deviceListStatus = YES;
    deviceDetailStatus = NO;
    [self.deviceDetailView setHidden: YES];
    [self.tabBarController.tabBar setHidden: NO];
    [self.deviceView setHidden: NO];
    [self getDeviceInfo];
}
- (IBAction)detailAddLicenseBtn:(id)sender
{
    [m_HUD setHidden: NO];
    [m_HUD.label setText: @"Add Licenses ..."];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        action = ADD_LICENSE;
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
        [self getLicenseServiceInfo: deviceId];
    });
}
- (IBAction)detailEditBtn:(id)sender
{
    [m_HUD setHidden: NO];
    [m_HUD .label setText: @"Edit device data ..."];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.editViewSearchTxt setText: @""];
        [self.deviceDetailView setHidden: YES];
        [self.editResellerInfoMessage setHidden: YES];
        [self.editViewDevieNameTxt setText: detailDeviceName];
        [self.editViewMacAddr setText: detailDeviceMacAddr];
        [self.editViewResellerName setText: detailDeviceResellerCompany];
        [self.editViewMail setText: detailDeviceResellerMail];
        [self.editViewVatNumber setText: detailDeviceResellerVat];
        [self.editView setHidden: NO];
        [m_HUD setHidden: YES];
    });
}
- (void)renewActivateBtn:(UIButton *)sender
{
    action = DEVICE_ACTIVATE_LICENSE;
    if (DEBUG) debug(@"device id = %@ , service id = %@", detailDeviceId, [renewServiceId objectAtIndex: sender.tag]);
    selectServiceId = [renewServiceId objectAtIndex: sender.tag];
    [self activeLicense: detailDeviceId andServiceId: selectServiceId];
}
- (IBAction)addLicenseCancelBtn:(id)sender
{
    renewStatus = NO;
    deviceDetailStatus = YES;
    [self.addLicenseView setHidden: YES];
    [self.deviceDetailView setHidden: NO];
}
- (IBAction)addLicenseDoneBtn:(id)sender
{
    action = ENTER_DEVICE_DETAIL;
    [self getDeviceDetailInfo: detailDeviceId];
}
- (IBAction)addLicenseScanActivateBtn:(id)sender
{
    action = DEVICE_SCAN_MANUAL_ACTIVATE;
    [self addLicenseScanActivateInfo: detailDeviceId];
}
- (IBAction)addLicenseManualActivateBtn:(id)sender
{
    action = DEVICE_SCAN_MANUAL_ACTIVATE;
    [self addLicenseScanActivateInfo: detailDeviceId];
}
- (IBAction)tryAgainBtn:(id)sender
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
        [self addLicenseActivateValie: detailDeviceId andKey: self.addLicenseManualViewTxt.text];
    }
    else if (action == DEVICE_CHECK_SCAN_ADD_LICENSE)
    {
        [self addLicenseActivateValie: detailDeviceId andKey: scanStr];
    }
    else if (action == DEVICE_SCAN_MANUAL_ACTIVATE)
    {
        [self addLicenseScanActivateInfo: detailDeviceId];
    }
    else if (action == REGISTER_CHECK_MANUAL_DEVICE)
    {
        [self checkNewDevice: self.manualMacAddress.text andSn: self.manualSerialNumber.text];
    }
    else if (action == REGISTER_CHECK_SCAN_DEVICE)
    {
        [self checkNewDevice: scanMac andSn: scanSn];
    }
    else if (action == REGISTER_SEARCH_RESELLER)
    {
        [self searchResellerInfo];
    }
    else if (action == REGISTER_COMPLETE)
    {
        [self registerNewDevice];
    }
    else if (action == REGISTER_SKIP)
    {
        [self registerNewDeviceSkip];
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
    [self getDeviceInfo];
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
    action = EDIT_DEVICE;
    NSString *strFormat = [self.editViewDevieNameTxt.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([strFormat length] > 0)
    {
        [self updateDeviceInfo];
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
    [m_HUD.label setText: @"Cancel Edit ..."];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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
        action = ENTER_DEVICE;
        deviceListStatus = YES;
        registerFinalStatus = NO;
        [self getDeviceInfo];
        dispatch_async(dispatch_get_main_queue(), ^() {
            [self.registerDeviceListView setHidden: YES];
            [self.deviceView setHidden: NO];
            [self.tabBarController.tabBar setHidden: NO];
        });
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
    [self hiddeKeyboard];
    [self.addLicenseManualView setHidden: YES];
    [self.addLicenseView setHidden: NO];
    [_session2 stopRunning];
}
- (IBAction)addLicenseScanViewCancelBtn:(id)sender
{
    [self.addLicenseScanView setHidden: YES];
    [self.addLicenseView setHidden: NO];
    [_session2 stopRunning];
}
- (void)addLicenseDelBtn:(UIButton *)sender
{
    [addLicenseScanNameList removeObjectAtIndex: sender.tag];
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
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex : 0];
        if ([[metadataObject type]isEqualToString: AVMetadataObjectTypeQRCode]) {
            if (addLicenseScanStatus)
            {
                if (_addLicenseScanStatus)
                {
                    _addLicenseScanStatus = NO;
                    NSInteger compareRes = 0;
                    if (DEBUG) debug(@"add license scan data = %@", metadataObject.stringValue);
                    for (NSString *data in addLicenseScanKeyList)
                    {
                        if ([data isEqualToString: metadataObject.stringValue])
                        {
                            compareRes = 1;
                            [self.addlicenseScanMessage setText: @"repeated data"];
                            [self.addlicenseScanMessage setHidden: NO];
                            [self.addlicenseManualMessage setText: @"repeated data"];
                            [self.addlicenseManualMessage setHidden: NO];
                            break;
                        }
                    }
                    if (compareRes == 0)
                    {
                        action = DEVICE_CHECK_SCAN_ADD_LICENSE;
                        scanStr = metadataObject.stringValue;
                        [self.addlicenseScanMessage setHidden: YES];
                        [self.addlicenseManualMessage setHidden: YES];
                        [self addLicenseActivateValie: detailDeviceId andKey: metadataObject.stringValue];
                    }
                }
            }
            else
            {
                if (_scanStatus)
                {
                    if (DEBUG) debug(@"reigster device scan data = %@ length = %lu", metadataObject.stringValue, (unsigned long)metadataObject.stringValue.length);
//                    if ([metadataObject.stringValue length] == 33)
//                    {
                    [DecodeDevicebyQRcode decodeDeviceInfo: metadataObject.stringValue];
                    
                   // debug(@"mac = %@, sn = %@", scanDeviceInfo.MAC, scanDeviceInfo.SN);
//                        NSString *snKey, *macKey;
//                        snKey = [metadataObject.stringValue substringToIndex: 3];
//                        macKey = [metadataObject.stringValue substringWithRange: NSMakeRange(17, 4)];
//                        NSString *dataConvert = [metadataObject.stringValue stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
//                        debug(@"length = %d", [dataConvert length]);
//                        if ([snKey isEqualToString: @"SN:"] && [macKey isEqualToString: @"MAC:"] && ([dataConvert length] == 33))
//                        {
//                            NSString *macConvert = [[NSString alloc]init];
//                            NSString *snFormat = [dataConvert substringToIndex: 16];
//                            if (DEBUG) debug(@"%@", snFormat);
//                            NSArray *sn = [snFormat componentsSeparatedByString: @":"];
//                            NSString *macFormat = [dataConvert substringWithRange: NSMakeRange(17, 16)];
//                            if (DEBUG) debug(@"%@", macFormat);
//                            NSArray *mac = [macFormat componentsSeparatedByString: @":"];
//                            NSString *macStr = [NSString stringWithFormat: @"%@", [mac objectAtIndex: 1]];
//                            const char *macCstr = [macStr cStringUsingEncoding: NSUTF8StringEncoding];
//                            for (int i=0; i<12; i++)
//                            {
//                                if (i == 0)
//                                {
//                                    macConvert = [NSString stringWithFormat: @"%c", macCstr[i]];
//                                }
//                                else if ((i%2) == 0)
//                                {
//                                    macConvert = [macConvert stringByAppendingFormat: @":%@", [NSString stringWithFormat: @"%c", macCstr[i]]];
//                                }
//                                else
//                                {
//                                    macConvert = [macConvert stringByAppendingFormat: @"%@", [NSString stringWithFormat: @"%c", macCstr[i]]];
//                                }
//                            }
//                            action = REGISTER_CHECK_SCAN_DEVICE;
//                            scanSn = [sn objectAtIndex: 1];
//                            scanMac = macConvert;
//                            [self checkNewDevice: scanMac andSn: scanSn];
//                            [self.scanErrorMessage setHidden: YES];
//                        }
//                    }
//                    else
//                    {
//                        [self.scanErrorMessage setText: @"Format Error"];
//                        [self.scanErrorMessage setHidden: NO];
//                    }
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
    if (deviceDetailStatus == YES)
    {
        count = [detailServiceNameList count];
    }
    if (renewStatus == YES)
    {
        count = [renewServiceNameList count];
    }
    if (registerPage1Status == YES)
    {
        count = [registerNewDeviceNameList count];
    }
    if (registerPage2Status == YES)
    {
        count = [registerNewDeviceNameList count];
    }
    if (registerFinalStatus == YES)
    {
        count = [finalNameList count];
    }
    if (addLicenseScanStatus == YES)
    {
        count = [addLicenseScanNameList count];
    }
    if (DEBUG_TABLE) debug(@"deviceListStatus = %d, deviceDetailStatus = %d, renewStatus = %d, registerPage1Status = %d, registerPage2Status = %d, registerFinalStatus = %d", deviceListStatus, deviceDetailStatus, renewStatus, registerPage1Status, registerPage2Status, registerFinalStatus);
    if (DEBUG_TABLE) debug(@"tableView numberOfRowsInSection count = %ld", (long)count);
    return  count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (DEBUG_TABLE) debug(@"tableView cellForRowAtIndexPath %d", indexPath.row);
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
                if ([[deviceExpireServiceList objectAtIndex: indexPath.row] isEqualToString: @"YES"])
                {
                    [deviceCell.withExpireServices setHidden: NO];
                }
                else
                {
                    [deviceCell.withExpireServices setHidden: YES];
                }
                
                [deviceCell.name setText:[deviceNameList objectAtIndex: indexPath.row]];
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
    if (deviceDetailStatus == YES) {
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
                NSInteger amount = [[detailServiceAmountList objectAtIndex: indexPath.row]integerValue];
                if (amount == 0)
                {
                    [detailCell.serviceAmount setText: @"Expired"];
                }
                else
                {
                    [detailCell.serviceAmount setText: [NSString stringWithFormat: @"Expire in %@ Days", [detailServiceAmountList objectAtIndex: indexPath.row]]];
                }
                cell = detailCell;
            }
        }
        else
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
        }
    }
    if (renewStatus == YES)
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
                NSString *amountStr = [[NSString alloc]init];
                int getYear = (int)amountProc/365;
                int getDay = amountProc%365;
                if (getYear == 0)
                {
                    amountStr = [NSString stringWithFormat: @"%d day service", getDay];
                }
                else
                {
                    amountStr = [NSString stringWithFormat: @"%d year service", getYear];
                }
                [addLicenseCell.serviceAmount setText: amountStr];
                [addLicenseCell.count.layer setMasksToBounds: YES];
                [addLicenseCell.count.layer setCornerRadius: addLicenseCell.count.frame.size.width/2];
                [addLicenseCell.count setText: [renewServiceTotalList objectAtIndex: indexPath.row]];
                [addLicenseCell.activate.layer setBorderColor: [UIColor colorWithRed: 235.0 green: 180.0 blue: 0.0 alpha: 1.0].CGColor];
                [addLicenseCell.activate setTag: indexPath.row];
                [addLicenseCell.activate addTarget: self action: @selector(renewActivateBtn:) forControlEvents: UIControlEventTouchUpInside];
                [addLicenseCell.activate.layer setBorderWidth: 1];
                [addLicenseCell.activate.layer setCornerRadius: addLicenseCell.activate.frame.size.height/2];
                cell = addLicenseCell;
            }
        }
        else
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
        }
    }
    if (registerPage1Status == YES)
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
            
            [registerDeviceCell.scanName setText: [registerNewDeviceNameList objectAtIndex: indexPath.row]];
            [registerDeviceCell.scanMac setText: [registerNewDeviceMacList objectAtIndex: indexPath.row]];
            [registerDeviceCell.scanSn setText: [registerNewDeviceSnList objectAtIndex: indexPath.row]];
            [registerDeviceCell.scanBtn addTarget: self action: @selector(newDeviceDelBtn:) forControlEvents: UIControlEventTouchUpInside];
            cell = registerDeviceCell;
        }
        else
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
        }
    }
    if (registerPage2Status == YES)
    {
        static NSString *CellIdentifier = @"registerDeviceEditListCell";
        if (indexPath.row < [registerNewDeviceNameList count])
        {
            RegisterDeviceEditListCell *registerDeviceEditCell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
            UIView *vi = [[UIView alloc]initWithFrame: CGRectMake(0, 0, 10, registerDeviceEditCell.name.frame.size.height)];
            [registerDeviceEditCell.name addTarget: self action: @selector(hiddeKeyboard) forControlEvents: UIControlEventEditingDidEndOnExit];
            [registerDeviceEditCell.name setLeftView: vi];
            [registerDeviceEditCell.name setLeftViewMode: UITextFieldViewModeAlways];
            [registerDeviceEditCell.name.layer setCornerRadius: registerDeviceEditCell.name.frame.size.height/2];
            [registerDeviceEditCell.name setText: [registerNewDeviceNameList objectAtIndex: indexPath.row]];
            [registerDeviceEditCell.mac setText: [registerNewDeviceMacList objectAtIndex: indexPath.row]];
            [registerDeviceEditCell.sn  setText: [registerNewDeviceSnList objectAtIndex: indexPath.row]];
            [registerDeviceEditCell.delBtn setTag: indexPath.row];
            [registerDeviceEditCell.delBtn addTarget: self action: @selector(newDeviceEditDelBtn:) forControlEvents: UIControlEventTouchUpInside];
            cell = registerDeviceEditCell;
        }
        else
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
        }
    }
    if (registerFinalStatus == YES)
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
                cell = registerDeviceFinalCell;
            }
        }
        else
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
        }
    }
    if (addLicenseScanStatus == YES)
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
                [deviceAddlicenseCell.scanLicenseKey setText: [addLicenseScanKeyList objectAtIndex: indexPath.row]];
                [deviceAddlicenseCell.scanServiceName setText: [addLicenseScanNameList objectAtIndex: indexPath.row]];
                cell = deviceAddlicenseCell;
                [deviceAddlicenseCell.scanDelBtn setTag: indexPath.row];
                [deviceAddlicenseCell.scanDelBtn addTarget: self action: @selector(addLicenseDelBtn:) forControlEvents: UIControlEventTouchUpInside];
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
        if (DEBUG) debug(@"select index = %ld, text = %@", (long)indexPath.row, select);
        if (DEBUG) debug(@"id = %ld", (long)deviceCell.name.tag);
        [self.detailDeviceName setText: select];
        [self.detailAddLicenseBtn setTag: deviceCell.name.tag];
        selectDetailDeviceId = [NSString stringWithFormat: @"%ld", (long)deviceCell.name.tag];
        dispatch_async(dispatch_get_main_queue(), ^() {
            [self getDeviceDetailInfo: selectDetailDeviceId];
        });
    }
    return indexPath;
}
@end
