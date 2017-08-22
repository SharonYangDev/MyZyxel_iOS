//
//  license.m
//  MyZyxel
//
//  Created by line on 2017/5/16.
//  Copyright © 2017年 Zyxel. All rights reserved.
//

#import "license.h"

@interface license ()
{
    MBProgressHUD *m_HUD;
    BOOL licenseListStatus;
    BOOL scanStatus;
    BOOL licenseDetailStatus;
    BOOL toDeviceStatus;
    BOOL showStatus;
    BOOL _scanStatus;
    NSInteger serviceCount;
    NSInteger detailServiceCount;
    NSInteger toDeviceIndex;
    NSIndexPath *cancelIndexPath;
    NSInteger showCount;
    NSInteger action;
    NSMutableArray *licenseNameList;
    NSMutableArray *licenseTotalList;
    NSMutableArray *licenseParsedModuleCodeList;
    NSMutableArray *detailAmountList;
    NSMutableArray *detailTotalList;
    NSMutableArray *toDeviceNameList;
    NSMutableArray *toDeviceMacList;
    NSMutableArray *toDeviceIdList;
    NSMutableArray *detailIdsListArr;
    NSMutableArray *activateServiceIdsList;
    NSMutableArray *scanServiceNameList;
    NSMutableArray *scanServiceKeyList;
    NSMutableArray *scanServiceAmountList;
    NSArray *detailIdsList;
    NSString *detailModuleCode;
    NSString *licenseParsedModuleCode;
    NSString *activateDeviceId;
    NSString *selectServiceName;
    NSString *inputLicenseKey;
    NSString *inputRegisterLicenseKey;
    AVCaptureSession *_session;
}
@end

@implementation license
- (void)dealloc
{
    m_HUD = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.manualLicenseKeyTxt addTarget: self action: @selector(checkLicense) forControlEvents: UIControlEventEditingDidEndOnExit];
    [self.manualLicenseKeyTxt.layer setCornerRadius: self.manualLicenseKeyTxt.frame.size.height/2];
    [self.toDeviceCount.layer setMasksToBounds: YES];
    [self.toDeviceCount.layer setCornerRadius: self.toDeviceCount.frame.size.height/2];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    [self.noLicenseView setHidden: YES];
    [self.scanView setHidden: YES];
    [self.manualView setHidden: YES];
    [self.scanViewErrorMessage setHidden: YES];
    [self.manualViewErrorMessage setHidden: YES];
    [self.toDeviceView setHidden: YES];
    [self.errorView setHidden: YES];
    [self selfLayout];
    if (m_HUD == nil)
    {
        m_HUD = [[MBProgressHUD alloc]initWithView: self.view];
        [m_HUD setContentColor: [UIColor whiteColor]];
        [m_HUD.bezelView setBackgroundColor: [UIColor blackColor]];
        [m_HUD showAnimated: YES];
        [m_HUD setMinShowTime: 15];
    }
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
    licenseListStatus = YES;
    [self.view addSubview: m_HUD];
    action = ENTER_SERVICE;
    [self initEnv];
}
- (void)initEnv
{
    [self.toDeviceList setAllowsSelection: YES];
    [self.toDeviceList setEditing: YES];
    [self getLicenseInfo];
}
#pragma mark - GET SERVER INFO
- (void)getLicenseInfo
{
    [m_HUD setHidden: NO];
    [m_HUD.label setText: @"Load license data ..."];
    NSError *error;
    NSDictionary *payload = @{};
    NSString *token = [Jwt encodeWithPayload: payload andKey: [public get_secret_access_key]andError:&error];
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
    NSString *get_license_info_url = [NSString stringWithFormat: @"%@/api/v2/my/licenses?token=%@&access_key_id=%@", DATA_URL, token, [public get_access_key_id]];
    if (DEBUG) debug(@"get_license_info_url = %@", get_license_info_url);
    NSURL *url = [NSURL URLWithString: get_license_info_url];
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
              if (DEBUG) debug(@"licenseInfo = %@", json);
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
                  NSString *licenseInfo = [[NSString alloc]initWithData: aes_decode_data encoding: enc];
                  if (DEBUG) debug(@"license info = %@", licenseInfo);
                  licenseNameList = [[NSMutableArray alloc]init];
                  licenseTotalList = [[NSMutableArray alloc]init];
                  licenseParsedModuleCodeList = [[NSMutableArray alloc]init];
                  NSMutableDictionary *license_info_json = [NSJSONSerialization JSONObjectWithData: aes_decode_data options:kNilOptions error: nil];
                  NSInteger licenseCount = [[license_info_json objectForKey: @"total"]integerValue];
                  if (licenseCount > 0)
                  {
                      NSArray *deviceListArr = [license_info_json objectForKey: @"services"];
                      for (NSDictionary *device in deviceListArr)
                      {
                          NSString *name = [NSString stringWithFormat: @"%@", [device objectForKey: @"name"]];
                          [licenseNameList addObject: name];
                          NSString *total = [NSString stringWithFormat: @"%@", [device objectForKey: @"total"]];
                          [licenseTotalList addObject: total];
                          NSString *module_code = [NSString stringWithFormat: @"%@", [device objectForKey: @"parsed_module_code"]];
                          [licenseParsedModuleCodeList addObject: module_code];
                      }
                      dispatch_async(dispatch_get_main_queue(), ^() {
                          if (licenseListStatus == YES)
                          {
                              [self.licenseList setHidden: NO];
                              [self.noLicenseView setHidden: YES];
                              [self.licenseList reloadData];
                              [self.licenseDetailView setHidden: YES];
                              [self.scanView setHidden: YES];
                              [self.manualView setHidden: YES];
                              [self.showView setHidden: YES];
                              [self.tabBarController.tabBar setHidden: NO];
                              [self.licenseView setHidden: NO];
                              [self.errorView setHidden: YES];
                              [m_HUD setHidden: YES];
                          }
                      });
                  }
                  else
                  {
                      dispatch_async(dispatch_get_main_queue(), ^() {
                          // show no license view
                          [self.licenseDetailView setHidden: YES];
                          [self.scanView setHidden: YES];
                          [self.manualView setHidden: YES];
                          [self.showView setHidden: YES];
                          [self.licenseList setHidden: YES];
                          [self.tabBarController.tabBar setHidden: NO];
                          [self.noLicenseView setHidden: NO];
                          [self.licenseView setHidden: NO];
                          [self.errorView setHidden: YES];
                          [m_HUD setHidden: YES];
                      });
                  }
              }
              else
              {
                  debug(@"server response meesage = %@", message);
                  [self.errorView setHidden: YES];
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
- (void)getLicenseDetail:(NSString *)module_code andServiceName:(NSString *)service_name
{
    [m_HUD setHidden: NO];
    [m_HUD.label setText: @"Load service data ..."];
    NSError *error;
    NSString *payloadFormat = [NSString stringWithFormat: @"{"
                               "\"parsed_module_code\": \"%@\""
                               "}", module_code];
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
    NSString *get_license_info_url = [NSString stringWithFormat: @"%@/api/v2/my/license?token=%@&access_key_id=%@", DATA_URL, token, [public get_access_key_id]];
    if (DEBUG) debug(@"get_license_info_url = %@", get_license_info_url);
    NSURL *url = [NSURL URLWithString: get_license_info_url];
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
              if (DEBUG) debug(@"serviceInfo = %@", json);
              
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
                  NSString *serviceInfo = [[NSString alloc]initWithData: aes_decode_data encoding: enc];
                  if (DEBUG) debug(@"service info = %@", serviceInfo);
                  
                  detailTotalList = [[NSMutableArray alloc]init];
                  detailAmountList = [[NSMutableArray alloc]init];
                  detailIdsList = [[NSMutableArray alloc]init];
                  detailIdsListArr = [[NSMutableArray alloc]init];
                  
                  NSMutableDictionary *service_info_json = [NSJSONSerialization JSONObjectWithData: aes_decode_data options:kNilOptions error: nil];
                  detailModuleCode = [NSString stringWithFormat: @"%@", [service_info_json objectForKey: @"parsed_module_code"]];
                  serviceCount = [[service_info_json objectForKey: @"total"]integerValue];
                  if (serviceCount > 0)
                  {
                      NSArray *licenseListArr = [service_info_json objectForKey: @"services"];
                      for (NSDictionary *service in licenseListArr)
                      {
                          NSInteger amountProc = [[service objectForKey: @"amount"]integerValue];
                          int getYear = (int)amountProc/365;
                          NSString *amount = [[NSString alloc]init];
                          if (getYear > 1)
                          {
                              amount = [NSString stringWithFormat: @"%d years service", getYear];
                          }
                          else
                          {
                              amount = [NSString stringWithFormat: @"%d year service", getYear];
                          }
                          [detailAmountList addObject: amount];
                          NSString *total = [NSString stringWithFormat: @"%@", [service objectForKey: @"total"]];
                          [detailTotalList addObject: total];
                          
                          NSString *ids = [NSString stringWithFormat: @"%@", [service objectForKey: @"license_service_ids"]];
                          ids = [ids stringByReplacingOccurrencesOfString: @" " withString: @""];
                          ids = [ids stringByReplacingOccurrencesOfString: @"(" withString: @""];
                          ids = [ids stringByReplacingOccurrencesOfString: @")" withString: @""];
                          ids = [ids stringByReplacingOccurrencesOfString: @"\n" withString: @""];
                          
                          detailIdsList = [ids componentsSeparatedByString: @","];
                          [detailIdsListArr addObject: detailIdsList];
                      }
                      
                      dispatch_async(dispatch_get_main_queue(), ^() {
                          if (licenseDetailStatus == YES)
                          {
                              //[self.licenseDetailModuleCodeName setText: detailModuleCode];
                              [self.licenseDetailModuleCodeName setText: service_name];
                              [self.licenseRegisteredServicesList reloadData];
                              [self.licenseView setHidden: YES];
                              [self.tabBarController.tabBar setHidden: YES];
                              [self.licenseDetailView setHidden: NO];
                              [self.errorView setHidden: YES];
                              [m_HUD setHidden: YES];
                          }
                      });
                  }
              }
              else
              {
                  // error
                  [self.errorView setHidden: YES];
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
- (void)toDeviceInfo:(NSInteger)index andAmount:(NSString *)service_date
{
    [m_HUD setHidden: NO];
    [m_HUD.label setText: @"Load device data ..."];
    NSString *payloadFormat = [[NSString alloc]init];
    NSArray *getIdsList = [detailIdsListArr objectAtIndex: index];
    debug(@"list = %@", detailIdsListArr);
    NSError *error;
    payloadFormat = @"{\"license_service_ids\": [";
    for (int i=0; i<[getIdsList count]; i++) {
        if (i == ([getIdsList count]-1)) {
            payloadFormat = [payloadFormat stringByAppendingFormat: @"%@]}", [getIdsList objectAtIndex: i]];
        }
        else
        {
            payloadFormat = [payloadFormat stringByAppendingFormat: @"%@,", [getIdsList objectAtIndex: i]];
        }
    }
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
    NSString *to_device_info_url = [NSString stringWithFormat: @"%@/api/v2/my/license/devices?token=%@&access_key_id=%@", DATA_URL, token, [public get_access_key_id]];
    if (DEBUG) debug(@"to_device_info_url = %@", to_device_info_url);
    NSURL *url = [NSURL URLWithString: to_device_info_url];
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
              if (DEBUG) debug(@"toDeviceInfo = %@", json);
              
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
                  NSString *serviceInfo = [[NSString alloc]initWithData: aes_decode_data encoding: enc];
                  if (DEBUG) debug(@"to device info = %@", serviceInfo);
                  toDeviceNameList = [[NSMutableArray alloc]init];
                  toDeviceMacList = [[NSMutableArray alloc]init];
                  toDeviceIdList = [[NSMutableArray alloc]init];
                  NSMutableDictionary *to_device_info_json = [NSJSONSerialization JSONObjectWithData: aes_decode_data options:kNilOptions error: nil];
                  NSString *ids = [NSString stringWithFormat: @"%@", [to_device_info_json objectForKey: @"license_service_ids"]];
                  ids = [ids stringByReplacingOccurrencesOfString: @" " withString: @""];
                  ids = [ids stringByReplacingOccurrencesOfString: @"(" withString: @""];
                  ids = [ids stringByReplacingOccurrencesOfString: @")" withString: @""];
                  ids = [ids stringByReplacingOccurrencesOfString: @"\n" withString: @""];
                  NSInteger deviceCount = [[to_device_info_json objectForKey: @"total"]integerValue];
                  if (deviceCount > 0)
                  {
                      NSArray *toDeviceListArr = [to_device_info_json objectForKey: @"devices"];
                      for (NSDictionary *device in toDeviceListArr)
                      {
                          NSString *name = [NSString stringWithFormat: @"%@", [device objectForKey: @"name"]];
                          [toDeviceNameList addObject: name];
                          NSString *mac = [NSString stringWithFormat: @"%@", [device objectForKey: @"mac_address"]];
                          [toDeviceMacList addObject: mac];
                          NSString *deviceId = [NSString stringWithFormat: @"%@", [device objectForKey: @"id"]];
                          [toDeviceIdList addObject: deviceId];
                      }
                      dispatch_async(dispatch_get_main_queue(), ^() {
                          if (toDeviceStatus == YES)
                          {
                              [self.activateCountSlider setMaximumValue: detailServiceCount];
                              [self.activateCount setText: @"1"];
                              [self.toDeviceCount setText: [NSString stringWithFormat: @"%ld", detailServiceCount]];
                              [self.toDeviceName setText: self.licenseDetailModuleCodeName.text];
                              [self.toDeviceAmount setText: service_date];
                              [self.toDeviceList reloadData];
                              [self.toDeviceMessage setHidden: YES];
                              [self.licenseDetailView setHidden: YES];
                              [self.toDeviceView setHidden: NO];
                              [self.errorView setHidden: YES];
                              [m_HUD setHidden: YES];
                          }
                      });
                  }
              }
              else
              {
                  // error
                  [self.errorView setHidden: YES];
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
- (void)activateLicenseInfo:(NSString *)deviceId andServcieList:(NSMutableArray *)idsList
{
    [m_HUD setHidden: NO];
    [m_HUD.label setText: @"Activate license ..."];
    NSString *payloadFormat = [[NSString alloc]init];
    NSError *error;
    payloadFormat = [NSString stringWithFormat: @"{"
                    "\"device_id\": %@,"
                    "\"license_service_ids\": [", deviceId];
    for (int i=0; i<[idsList count]; i++) {
        if (i == ([idsList count]-1)) {
            payloadFormat = [payloadFormat stringByAppendingFormat: @"%@]}", [idsList objectAtIndex: i]];
        }
        else
        {
            payloadFormat = [payloadFormat stringByAppendingFormat: @"%@,", [idsList objectAtIndex: i]];
        }
    }
    debug(@"payloadFormat = %@", payloadFormat);
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
    NSString *to_device_info_url = [NSString stringWithFormat: @"%@/api/v2/my/license/license_services/activate?token=%@&access_key_id=%@", DATA_URL, token, [public get_access_key_id]];
    if (DEBUG) debug(@"to_device_info_url = %@", to_device_info_url);
    NSURL *url = [NSURL URLWithString: to_device_info_url];
    NSMutableURLRequest *request_user_info = [NSMutableURLRequest requestWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 15];
    [request_user_info setHTTPMethod: @"POST"];
    [request_user_info setValue: [public get_access_token] forHTTPHeaderField: @"Authorization"];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest: request_user_info
                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
      {
          if (data != nil)
          {
              NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData: data options: kNilOptions error: nil];
              if (DEBUG) debug(@"toDeviceInfo = %@", json);
              
              NSMutableDictionary *status = [json objectForKey: @"return_status"];
              NSString *code = [NSString stringWithFormat: @"%@", [status objectForKey: @"code"]];
              NSString *message = [NSString stringWithFormat: @"%@", [status objectForKey: @"message"]];
              if ([code isEqualToString: @"0"])
              {
                  dispatch_async(dispatch_get_main_queue(), ^() {
                      toDeviceStatus = NO;
                      showStatus = YES;
                      [self.showRegisteredServicesList reloadData];
                      dispatch_async(dispatch_get_main_queue(), ^() {
                          [self.toDeviceMessage setHidden: YES];
                          [self.toDeviceView setHidden: YES];
                          [self.showView setHidden: NO];
                          [self.errorView setHidden: YES];
                          [m_HUD setHidden: YES];
                      });
                  });
              }
              else
              {
                  NSString *errorMsg = [public checkErrorCode: code];
                  if ([errorMsg isEqualToString: @"unknow"])
                  {
                      [self.toDeviceMessage setText: message];
                  }
                  else
                  {
                      [self.toDeviceMessage setText: errorMsg];
                  }
                  [self.toDeviceMessage setHidden: NO];
                  [self.errorView setHidden: YES];
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
- (void)checkLicenseInfo:(NSString *)licenseKey
{
    [m_HUD setHidden: NO];
    [m_HUD.label setText: @"check license data ..."];
    NSError *error;
    NSString *payloadFormat = [NSString stringWithFormat: @"{"
                               "\"pretend\": true,"
                               "\"licenses\": ["
                               "{\"key\": \"%@\"}"
                               "]}", licenseKey];
    NSData *payloadJson = [payloadFormat dataUsingEncoding: NSUTF8StringEncoding];
    NSDictionary *payload = [NSJSONSerialization JSONObjectWithData: payloadJson options: kNilOptions error: &error];
    NSString *token = [Jwt encodeWithPayload: payload andKey: [public get_secret_access_key]andError:&error];
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

    NSString *get_license_info_url = [NSString stringWithFormat: @"%@/api/v2/my/licenses/register?token=%@&access_key_id=%@", DATA_URL, token, [public get_access_key_id]];
    if (DEBUG) debug(@"check_license_info_url = %@", get_license_info_url);
    NSURL *url = [NSURL URLWithString: get_license_info_url];
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
              if (DEBUG) debug(@"checkLicenseInfo = %@", json);
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
                  NSString *checkLicenseInfo = [[NSString alloc]initWithData: aes_decode_data encoding: enc];
                  if (DEBUG) debug(@"check license info = %@", checkLicenseInfo);
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
                          [scanServiceKeyList addObject: [service objectForKey: @"key"]];
                          NSData *services = [NSJSONSerialization dataWithJSONObject: [service objectForKey: @"services"] options: NSJSONWritingPrettyPrinted error: nil];
                          NSArray *getServiceArr = [NSJSONSerialization JSONObjectWithData: services options: NSJSONReadingMutableContainers error: nil];
                          for (NSDictionary *serviceInfo in getServiceArr)
                          {
                              NSString *serviceName = [NSString stringWithFormat: @"%@", [serviceInfo objectForKey: @"name"]];
                              NSInteger amountProc = [[serviceInfo objectForKey: @"amount"]integerValue];
                              int getYear = (int)amountProc/365;
                              int getDay = amountProc%365;
                              NSString *amount = [NSString stringWithFormat: @"%d year service +  %d days", getYear, getDay];
                              [scanServiceNameList addObject: serviceName];
                              [scanServiceAmountList addObject: amount];
                          }
                          dispatch_async(dispatch_get_main_queue(), ^() {
                              [self.scanLicenseList reloadData];
                              [self.manualLicenseList reloadData];
                              [self.manualViewErrorMessage setHidden: YES];
                              [self.scanViewErrorMessage setHidden: YES];
                              [self.manualLicenseKeyTxt setText: @""];
                              [self.errorView setHidden: YES];
                              [m_HUD setHidden: YES];
                              _scanStatus = YES;
                              if ([scanServiceKeyList count] > 0)
                              {
                                  [self.scanRegisterBtn setEnabled: YES];
                                  [self.manualRegisterBtn setEnabled: YES];
                              }
                          });
                      }
                      else
                      {
                          dispatch_async(dispatch_get_main_queue(), ^() {
                              NSString *errorMsg = [public checkErrorCode: return_code];
                              if ([errorMsg isEqualToString: @"unknow"])
                              {
                                  [self.manualViewErrorMessage setText: return_message];
                                  [self.scanViewErrorMessage setText: return_message];
                              }
                              else
                              {
                                  [self.manualViewErrorMessage setText: errorMsg];
                                  [self.scanViewErrorMessage setText: errorMsg];
                              }
                              [self.manualViewErrorMessage setHidden: NO];
                              [self.scanViewErrorMessage setHidden: NO];
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
                          [self.manualViewErrorMessage setText: message];
                          [self.scanViewErrorMessage setText: message];
                      }
                      else
                      {
                          [self.manualViewErrorMessage setText: errorMsg];
                          [self.scanViewErrorMessage setText: errorMsg];
                      }
                      [self.manualViewErrorMessage setHidden: NO];
                      [self.scanViewErrorMessage setHidden: NO];
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
- (void)registerLicenseInfo:(NSString *)licenseKey
{
    [m_HUD setHidden: NO];
    [m_HUD.label setText: @"register license data ..."];
    NSError *error;
    NSString *payloadFormat = [NSString stringWithFormat: @"{"
                               "\"pretend\": false,"
                               "\"licenses\": [%@]}", licenseKey];
    NSData *payloadJson = [payloadFormat dataUsingEncoding: NSUTF8StringEncoding];
    NSDictionary *payload = [NSJSONSerialization JSONObjectWithData: payloadJson options: kNilOptions error: &error];
    NSString *token = [Jwt encodeWithPayload: payload andKey: [public get_secret_access_key]andError:&error];
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
    NSString *get_license_info_url = [NSString stringWithFormat: @"%@/api/v2/my/licenses/register?token=%@&access_key_id=%@", DATA_URL, token, [public get_access_key_id]];
    if (DEBUG) debug(@"register_license_info_url = %@", get_license_info_url);
    NSURL *url = [NSURL URLWithString: get_license_info_url];
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
              if (DEBUG) debug(@"registerLicenseInfo = %@", json);
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
                  NSString *registerLicenseInfo = [[NSString alloc]initWithData: aes_decode_data encoding: enc];
                  if (DEBUG) debug(@"register license info = %@", registerLicenseInfo);
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
                          dispatch_async(dispatch_get_main_queue(), ^() {
                              scanStatus = NO;
                              licenseListStatus = YES;
                              [self.licenseList reloadData];
                              dispatch_async(dispatch_get_main_queue(), ^() {
                                  [self.scanView setHidden: YES];
                                  [self.manualView setHidden: YES];
                                  [self.licenseView setHidden: NO];
                                  [self.errorView setHidden: YES];
                                  [m_HUD setHidden: YES];
                                  _scanStatus = YES;
                                  [self stopReading];
                                  [self getLicenseInfo];
                              });
                          });
                      }
                      else
                      {
                          dispatch_async(dispatch_get_main_queue(), ^() {
                              NSString *errorMsg = [public checkErrorCode: return_code];
                              if ([errorMsg isEqualToString: @"unknow"])
                              {
                                  [self.manualViewErrorMessage setText: return_message];
                                  [self.scanViewErrorMessage setText: return_message];
                              }
                              else
                              {
                                  [self.manualViewErrorMessage setText: errorMsg];
                                  [self.scanViewErrorMessage setText: errorMsg];
                              }
                              [self.manualViewErrorMessage setHidden: NO];
                              [self.scanViewErrorMessage setHidden: NO];
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
                          [self.manualViewErrorMessage setText: message];
                          [self.scanViewErrorMessage setText: message];
                      }
                      else
                      {
                          [self.manualViewErrorMessage setText: errorMsg];
                          [self.scanViewErrorMessage setText: errorMsg];
                      }
                      [self.manualViewErrorMessage setHidden: NO];
                      [self.scanViewErrorMessage setHidden: NO];
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
#pragma mark - FUNCTION EVENTS
- (void)checkLicense
{
    action = SERVICE_CHECK_LICENSE;
    [self checkLicenseInfo: self.manualLicenseKeyTxt.text];
}
- (void)stopReading
{
    [_session stopRunning];
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
- (void)hiddeKeyboard
{
    // hidde keyboard
    [[[UIApplication sharedApplication]keyWindow]endEditing: YES];
}
#pragma mark - BUTTON EVENTS
- (IBAction)registerNewLicensesBtn:(id)sender
{
    [m_HUD setHidden: NO];
    [m_HUD.label setText: @"Add Licenses ..."];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tabBarController.tabBar setHidden: YES];
        licenseListStatus = NO;
        scanStatus = YES;
        scanServiceNameList = [[NSMutableArray alloc]init];
        scanServiceKeyList = [[NSMutableArray alloc]init];
        scanServiceAmountList = [[NSMutableArray alloc]init];
        [self.scanRegisterBtn setEnabled: NO];
        [self.manualRegisterBtn setEnabled: NO];
        [self.scanLicenseList reloadData];
        [self.manualLicenseList reloadData];
        [self.licenseView setHidden: YES];
        [self.scanView setHidden: NO];
        _scanStatus = YES;
        [self scanCode];
        [m_HUD setHidden: YES];
    });
}
- (IBAction)scanViewBtn:(id)sender
{
    [self.scanView setHidden: YES];
    [self.manualView setHidden: NO];
}
- (IBAction)manualViewBtn:(id)sender
{
    [self hiddeKeyboard];
    [self.manualView setHidden: YES];
    [self.scanView setHidden: NO];
}
- (IBAction)scanViewCancelBtn:(id)sender
{
    licenseListStatus = YES;
    scanStatus = NO;
    //[self.scanView setHidden: YES];
    //[self.licenseView setHidden: NO];
    //[self.tabBarController.tabBar setHidden: NO];
    [self stopReading];
    action = ENTER_SERVICE;
    [self getLicenseInfo];
}
- (IBAction)manualViewCancelBtn:(id)sender
{
    licenseListStatus = YES;
    scanStatus = NO;
    [self hiddeKeyboard];
    [self.manualView setHidden: YES];
    [self.licenseView setHidden: NO];
    [self.tabBarController.tabBar setHidden: NO];
    [self stopReading];
}
- (IBAction)licenseDetailCancelBtn:(id)sender
{
    licenseListStatus = YES;
    licenseDetailStatus = NO;
    action = ENTER_SERVICE;
    [self getLicenseInfo];
}
- (void)detailActivateBtn:(UIButton *)sender
{
    [self.toDeviceConfirmBtn setEnabled: NO];
    licenseDetailStatus = NO;
    toDeviceStatus = YES;
    detailServiceCount = [[detailTotalList objectAtIndex: sender.tag]integerValue];
    toDeviceIndex = sender.tag;
    cancelIndexPath = nil;
    action = SERVICE_GET_DEVICE;
    [self toDeviceInfo: toDeviceIndex andAmount: [detailAmountList objectAtIndex: toDeviceIndex]];
}
- (void)toDeviceCancelBtn:(id)sender
{
    toDeviceStatus = NO;
    licenseDetailStatus = YES;
    action = SERVICE_GET_LICENSE;
    [self getLicenseDetail: licenseParsedModuleCode andServiceName: self.licenseDetailModuleCodeName.text];
}

- (IBAction)activateCountSliderChange:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    if (slider == self.activateCountSlider)
    {
        [self.activateCount setText: [NSString stringWithFormat: @"%d", (int)slider.value]];
    }
}
- (IBAction)activateCountSliderEnd:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    if (slider == self.activateCountSlider)
    {
        NSString *value = [NSString stringWithFormat: @"%.1f", slider.value];
        float getValue = [value floatValue];
        if ((getValue-(int)slider.value)>=0.5)
        {
            [self.activateCountSlider setValue: ((int)slider.value)+1];
            [self.activateCount setText: [NSString stringWithFormat: @"%d", (int)self.activateCountSlider.value]];
        }
        else
        {
            [self.activateCountSlider setValue: (int)slider.value];
            [self.activateCount setText: [NSString stringWithFormat: @"%d", (int)self.activateCountSlider.value]];
        }
    }
}
- (IBAction)toDeviceConfirmBtn:(id)sender
{
    if (DEBUG) debug(@"device id = %@", activateDeviceId);
    action = SERVICE_ACTIVATE_LICENSE;
    activateServiceIdsList = [[NSMutableArray alloc]init];
    NSInteger selectCount = [self.activateCount.text integerValue];
    NSArray *getServiceIdsList = [detailIdsListArr objectAtIndex: toDeviceIndex];
    for (int i=0; i<selectCount; i++) {
        [activateServiceIdsList addObject: [getServiceIdsList objectAtIndex: i]];
    }
    if (DEBUG) debug(@"service id = %@", activateServiceIdsList);
    showCount = selectCount;
    [self activateLicenseInfo: activateDeviceId andServcieList: activateServiceIdsList];
}
- (void)newLicenseDelBtn:(UIButton *)sender
{
    [scanServiceNameList removeObjectAtIndex: sender.tag];
    [scanServiceKeyList removeObjectAtIndex: sender.tag];
    [scanServiceAmountList removeObjectAtIndex: sender.tag];
    [self.scanLicenseList reloadData];
    [self.manualLicenseList reloadData];
    if ([scanServiceKeyList count] == 0)
    {
        [self.scanRegisterBtn setEnabled: NO];
        [self.manualRegisterBtn setEnabled: NO];
    }
}
- (IBAction)scanRegisterBtn:(id)sender
{
    NSString *licenseKey = [[NSString alloc]init];
    for (int i=0; i<[scanServiceKeyList count]; i++) {
        if (i == ([scanServiceKeyList count]-1))
        {
            licenseKey = [licenseKey stringByAppendingFormat: @"{\"key\":\"%@\"}", [scanServiceKeyList objectAtIndex: i]];
        }
        else
        {
            licenseKey = [licenseKey stringByAppendingFormat: @"{\"key\":\"%@\"},", [scanServiceKeyList objectAtIndex: i]];
        }
    }
    inputRegisterLicenseKey = licenseKey;
    action = SERVICE_REGISTER_LICENSE;
    if(DEBUG) debug(@"license key = %@", licenseKey);
    [self registerLicenseInfo: licenseKey];
}
- (IBAction)manualRegisterBtn:(id)sender
{
    NSString *licenseKey = [[NSString alloc]init];
    for (int i=0; i<[scanServiceKeyList count]; i++) {
        if (i == ([scanServiceKeyList count]-1))
        {
            licenseKey = [licenseKey stringByAppendingFormat: @"{\"key\":\"%@\"}", [scanServiceKeyList objectAtIndex: i]];
        }
        else
        {
            licenseKey = [licenseKey stringByAppendingFormat: @"{\"key\":\"%@\"},", [scanServiceKeyList objectAtIndex: i]];
        }
    }
    inputRegisterLicenseKey = licenseKey;
    action = SERVICE_REGISTER_LICENSE;
    if(DEBUG) debug(@"license key = %@", licenseKey);
    [self registerLicenseInfo: licenseKey];
}

- (IBAction)tryAgainBtn:(id)sender
{
    if (action == ENTER_SERVICE)
    {
        [self getLicenseInfo];
    }
    else if (action == SERVICE_GET_LICENSE)
    {
        [self getLicenseDetail: licenseParsedModuleCode andServiceName: selectServiceName];
    }
    else if (action == SERVICE_GET_DEVICE)
    {
        [self toDeviceInfo: toDeviceIndex andAmount: [detailAmountList objectAtIndex: toDeviceIndex]];
    }
    else if (action == SERVICE_ACTIVATE_LICENSE)
    {
        [self activateLicenseInfo: activateDeviceId andServcieList: activateServiceIdsList];
    }
    else if (action == SERVICE_REGISTER_LICENSE)
    {
        [self registerLicenseInfo: inputRegisterLicenseKey];
    }
}
- (void)showDoneBtn:(id)sender
{
    showStatus = NO;
    licenseListStatus = YES;
    [self getLicenseInfo];
}
#pragma mark - SCAN EVENTS
- (void)scanCode
{
    if (_session == nil)
    {
        AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
        if (!input) return;
        AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
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
    else
    {
        [_session startRunning];
    }
}
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex : 0];
        if ([[metadataObject type]isEqualToString: AVMetadataObjectTypeQRCode])
        {
            if (_scanStatus)
            {
                if (DEBUG) debug(@"scan data = %@", metadataObject.stringValue);
                action = SERVICE_CHECK_LICENSE;
                [self checkLicenseInfo: metadataObject.stringValue];
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
#pragma mark - TABELVIEW CALLBACK
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (toDeviceStatus == YES)
    {
        return YES;
    }
    return  NO;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 0;
    
    if (licenseListStatus == YES)
    {
        count = [licenseNameList count];
    }
    if (licenseDetailStatus == YES)
    {
        count = [detailTotalList count];
    }
    if (toDeviceStatus == YES)
    {
        count = [toDeviceNameList count];
    }
    if (scanStatus == YES)
    {
        count = [scanServiceKeyList count];
    }
    if (showStatus == YES)
    {
        count = [detailTotalList count];
    }
    if (DEBUG_TABLE) debug(@"count = %ld", (long)count);
    if (DEBUG_TABLE) debug(@"licenseListStatus = %d, licenseDetailStatus = %d, toDeviceStatus = %d", licenseListStatus, licenseDetailStatus, toDeviceStatus);
    return  count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (DEBUG_TABLE) debug(@"tableView cellForRowAtIndexPath %d", indexPath.row);
    UITableViewCell *cell;
    if (licenseListStatus == YES)
    {
        static NSString *CellIdentifier = @"licenseCell";
        if (indexPath.row < [licenseNameList count])
        {
            LicenseListCell *licenseCell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
            if (licenseCell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            else
            {
                [licenseCell.name setText:[licenseNameList objectAtIndex: indexPath.row]];
                NSString *total = [NSString stringWithFormat: @"%@ Registered", [licenseTotalList objectAtIndex: indexPath.row]];
                [licenseCell.total setText: total];
                cell = licenseCell;
            }
        }
        else
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
        }
    }
    if (licenseDetailStatus == YES)
    {
        static NSString *CellIdentifier = @"licenseRegisteredServicesCell";
        if (indexPath.row < [detailTotalList count])
        {
            LicenseRegisteredServicesCell *licenseDetailCell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
            if (licenseDetailCell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle: UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
            }
            else
            {
                [licenseDetailCell.count.layer setMasksToBounds: YES];
                [licenseDetailCell.count.layer setCornerRadius: licenseDetailCell.count.frame.size.height/2];
                [licenseDetailCell.activate.layer setCornerRadius: licenseDetailCell.activate.frame.size.height/2];
                [licenseDetailCell.activate.layer setBorderWidth: 1];
                [licenseDetailCell.activate.layer setBorderColor: [UIColor colorWithRed: 235.0 green: 180.0 blue: 0.0 alpha: 1.0].CGColor];
                [licenseDetailCell.activate setTag: indexPath.row];
                [licenseDetailCell.activate addTarget: self action: @selector(detailActivateBtn:) forControlEvents: UIControlEventTouchUpInside];
                [licenseDetailCell.count setText: [detailTotalList objectAtIndex: indexPath.row]];
                [licenseDetailCell.amount setText: [detailAmountList objectAtIndex: indexPath.row]];
                cell = licenseDetailCell;
            }
        }
        else
        {
            cell = [[UITableViewCell alloc]initWithStyle: UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
        }
    }
    if (toDeviceStatus == YES)
    {
        static NSString *CellIdentifier = @"toDeviceListCell";
        if (indexPath.row < [toDeviceNameList count])
        {
            ToDeviceListCell *toDeviceListCell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
            if (toDeviceListCell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            else
            {
                [toDeviceListCell.deviceName setText: [toDeviceNameList objectAtIndex: indexPath.row]];
                [toDeviceListCell.macAddr setText: [toDeviceMacList objectAtIndex: indexPath.row]];
                cell = toDeviceListCell;
            }
        }
        else
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
    }
    if (scanStatus == YES)
    {
        static NSString *CellIdentifier = @"registerLicenseCell";
        if (indexPath.row < [scanServiceKeyList count])
        {
            RegisterLicenseListCell *registerLicenseListCell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
            if (registerLicenseListCell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            else
            {
                [registerLicenseListCell.scanServiceName setText: [scanServiceNameList objectAtIndex: indexPath.row]];
                [registerLicenseListCell.scanServiceKey setText: [scanServiceKeyList objectAtIndex: indexPath.row]];
                [registerLicenseListCell.scanServiceAmount setText: [scanServiceAmountList objectAtIndex: indexPath.row]];
                [registerLicenseListCell.scanDel addTarget: self action: @selector(newLicenseDelBtn:) forControlEvents: UIControlEventTouchUpInside];
                [registerLicenseListCell.manualServiceName setText: [scanServiceNameList objectAtIndex: indexPath.row]];
                [registerLicenseListCell.manualServiceKey setText: [scanServiceKeyList objectAtIndex: indexPath.row]];
                [registerLicenseListCell.manualServiceAmount setText: [scanServiceAmountList objectAtIndex: indexPath.row]];
                [registerLicenseListCell.manualDel addTarget: self action: @selector(newLicenseDelBtn:) forControlEvents: UIControlEventTouchUpInside];
                cell = registerLicenseListCell;
            }
        }
        else
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
    }
    if (showStatus == YES)
    {
        static NSString *CellIdentifier = @"showRegisteredLicenseCell";
        if (indexPath.row < [detailTotalList count])
        {
            ShowRegisteredLicenseCell *showRegisteredLicenseCell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
            if (showRegisteredLicenseCell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            else
            {
                [showRegisteredLicenseCell.count.layer setMasksToBounds: YES];
                [showRegisteredLicenseCell.count.layer setCornerRadius: showRegisteredLicenseCell.count.frame.size.height/2];
                [showRegisteredLicenseCell.count setText: [detailTotalList objectAtIndex: indexPath.row]];
                [showRegisteredLicenseCell.amount setText: [detailAmountList objectAtIndex: indexPath.row]];
                if (indexPath.row == toDeviceIndex) {
                    [showRegisteredLicenseCell.activateCount setText:[NSString stringWithFormat: @"%d Activated", showCount]];
                }
                else
                {
                    [showRegisteredLicenseCell.activateCount setText:@""];
                }
                cell = showRegisteredLicenseCell;
            }
        }
        else
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
    }
    return cell;
}
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (licenseListStatus == YES)
    {
        action = SERVICE_GET_LICENSE;
        licenseListStatus = NO;
        licenseDetailStatus = YES;
        licenseParsedModuleCode = [licenseParsedModuleCodeList objectAtIndex: indexPath.row];
        LicenseListCell *cell = [tableView cellForRowAtIndexPath: indexPath];
        selectServiceName = cell.name.text;
        [self getLicenseDetail: licenseParsedModuleCode andServiceName: selectServiceName];
    }
    return indexPath;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (toDeviceStatus == YES)
    {
        return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
    }
    return UITableViewCellEditingStyleNone;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (toDeviceStatus == YES)
    {
        if (cancelIndexPath != nil)
        {
            [self.toDeviceList deselectRowAtIndexPath: cancelIndexPath animated: NO];
        }
        activateDeviceId = [toDeviceIdList objectAtIndex: indexPath.row];
        cancelIndexPath = indexPath;

        [self.toDeviceConfirmBtn setEnabled: YES];
    }
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (toDeviceStatus == YES)
    {
        [self.toDeviceList selectRowAtIndexPath:indexPath animated:NO scrollPosition: UITableViewScrollPositionNone];
    }
}
@end
