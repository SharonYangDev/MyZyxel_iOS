//
//  license.m
//  MyZyxel
//
//  Created by line on 2017/5/16.
//  Copyright © 2017年 Zyxel. All rights reserved.
//

#import "license.h"

@interface license ()<AVCaptureMetadataOutputObjectsDelegate>
{
    MBProgressHUD *m_HUD;
    BOOL licenseListStatus;
    BOOL scanStatus;
    BOOL licenseDetailStatus;
    BOOL toDeviceStatus;
    BOOL showStatus;
    BOOL _scanStatus;
    BOOL registerListStatus;
    BOOL searchStatus;
    BOOL searchKeyWordStatus;
    NSInteger serviceCount;
    NSInteger detailServiceCount;
    NSInteger toDeviceIndex;
    NSIndexPath *cancelIndexPath;
    NSInteger showCount;
    NSInteger action;
    NSInteger registerIndex;
    NSMutableArray *licenseNameList;
    NSMutableArray *licenseTotalList;
    NSMutableArray *licenseParsedModuleCodeList;
    NSMutableArray *detailAmountList;
    NSMutableArray *detailTotalList;
    NSMutableArray *detailErrorMessageList;
    NSMutableArray *toDeviceNameList;
    NSMutableArray *toDeviceMacList;
    NSMutableArray *toDeviceIdList;
    NSMutableArray *toDeviceIdsListFromDevice;
    NSMutableArray *selectIdsListFromDevice;
    NSMutableArray *detailIdsListArr;
    NSMutableArray *toDeviceIdsListArr;
    NSMutableArray *activateServiceIdsList;
    NSMutableArray *scanServiceNameList;
    NSMutableArray *scanServiceKeyList;
    NSMutableArray *scanServiceAmountList;
    NSMutableArray *scanServiceEventTypeList;
    NSMutableArray *registerMessageList;
    NSMutableArray *searchServiceList;
    NSMutableArray *searchServiceTotalList;
    NSMutableArray *searchParsedModuleCodeList;
    NSArray *detailIdsList;
    NSString *detailModuleCode;
    NSString *licenseParsedModuleCode;
    NSString *activateDeviceId;
    NSString *selectServiceName;
    NSString *inputLicenseKey;
    NSString *scanSn;
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
    NSThread *tutoriaThread = [[NSThread alloc]initWithTarget: self selector: @selector(checkTutoriaInfo) object: nil];
    [tutoriaThread start];
    
    [self.manualLicenseKeyTxt addTarget: self action: @selector(checkLicense) forControlEvents: UIControlEventEditingDidEndOnExit];
    [self.manualLicenseKeyTxt.layer setCornerRadius: self.manualLicenseKeyTxt.frame.size.height/2];
    [self.searchServiceTxt addTarget: self action: @selector(searchServiceInfo) forControlEvents: UIControlEventEditingDidEndOnExit];
    [self.toDeviceCount.layer setMasksToBounds: YES];
    [self.toDeviceCount.layer setCornerRadius: self.toDeviceCount.frame.size.height/2];
    [self.manualRegisterBtn.layer setMasksToBounds: YES];
    [self.manualRegisterBtn.layer setCornerRadius: self.manualRegisterBtn.frame.size.height/2];
    [self.toDeviceConfirmBtn.layer setMasksToBounds: YES];
    [self.toDeviceConfirmBtn.layer setCornerRadius: self.toDeviceConfirmBtn.frame.size.height/2];
    [self.scanRegisterBtn.layer setMasksToBounds: YES];
    [self.registerListOkBtn.layer setMasksToBounds: YES];
    [self.registerListOkBtn.layer setCornerRadius: self.registerListOkBtn.frame.size.height/2];
    [self.scanRegisterBtn.layer setCornerRadius: self.scanRegisterBtn.frame.size.height/2];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithString: self.manualViewBtn.titleLabel.text];
    [attrString setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Oblique" size:15.0],NSForegroundColorAttributeName:[UIColor darkGrayColor],NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]} range:NSMakeRange(0,[attrString length])];
    [self.manualViewBtn setAttributedTitle: attrString forState: UIControlStateNormal];
    attrString = [[NSMutableAttributedString alloc]initWithString: self.scanViewBtn.titleLabel.text];
    [attrString setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Oblique" size:15.0],NSForegroundColorAttributeName:[UIColor darkGrayColor],NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]} range:NSMakeRange(0,[attrString length])];
    [self.scanViewBtn setAttributedTitle: attrString forState: UIControlStateNormal];
    self.licenseRegisteredServicesList.rowHeight = UITableViewAutomaticDimension;
    self.licenseRegisteredServicesList.estimatedRowHeight = 74;
    [self.registerNewLicensesBtn setHitTestEdgeInsets: UIEdgeInsetsMake(60, 60, 60, 60)];
    [self.scanViewCancelBtn setHitTestEdgeInsets: UIEdgeInsetsMake(60, 60, 60, 60)];
    [self.manualViewCancelBtn setHitTestEdgeInsets: UIEdgeInsetsMake(60, 60, 60, 60)];
    [self.licenseDetailCancelBtn setHitTestEdgeInsets: UIEdgeInsetsMake(60, 60, 80, 60)];
    [self.toDeviceCancelBtn setHitTestEdgeInsets: UIEdgeInsetsMake(60, 60, 60, 60)];
    [self.showDoneBtn setHitTestEdgeInsets: UIEdgeInsetsMake(60, 60, 60, 60)];
    [self.licenseSearchBtn setHitTestEdgeInsets: UIEdgeInsetsMake(60, 60, 60, 60)];
    [self.searchServiceCancelBtn setHitTestEdgeInsets: UIEdgeInsetsMake(60, 60, 60, 60)];
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
    [self.registerListView setHidden: YES];
    [self.searchListView setHidden: YES];
    [self selfLayout];
    if (m_HUD == nil)
    {
        m_HUD = [[MBProgressHUD alloc]initWithView: self.view];
        [m_HUD setContentColor: [UIColor whiteColor]];
        [m_HUD.bezelView setBackgroundColor: [UIColor blackColor]];
        [m_HUD showAnimated: YES];
        [m_HUD setMinShowTime: 15];
    }
    [self.tabBarController.tabBar setUserInteractionEnabled: NO];
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
    UITapGestureRecognizer *hiddeKeyBoardManualView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddeKeyboard)];
    hiddeKeyBoardManualView.cancelsTouchesInView = NO;
    [self.manualView addGestureRecognizer: hiddeKeyBoardManualView];
    [self.toDeviceList setAllowsSelection: YES];
    [self.toDeviceList setEditing: YES];
    if ([public checkNetWorkConn])
    {
        [self getLicenseInfo];
    }
    else
    {
        [self.licenseView setHidden: YES];
        [self.tabBarController.tabBar setHidden: YES];
        [self.errorView setHidden: NO];
        [m_HUD setHidden: YES];
    }
}
#pragma mark - GET SERVER INFO
// API 10 GET SERVICE FROM CURRENT USERNAME
- (void)getLicenseInfo
{
    [m_HUD setHidden: NO];
    NSError *error;
    NSDictionary *payload = @{};
    NSString *token = [Jwt encodeWithPayload: payload andKey: [public get_secret_access_key]andError:&error];
    if(token == nil)
    {
        // Print error
        service_debug(@"Code: %li", (long)[error code]);
        service_debug(@"Reason: %@", [error localizedFailureReason]);
    }
    else
    {
        service_debug(@"jwt token = %@", token);
    }
    NSString *get_license_info_url = [NSString stringWithFormat: @"%@/api/v2/my/licenses?token=%@&access_key_id=%@", DATA_URL, token, [public get_access_key_id]];
    NSLog(@"get_license_info_url = %@", get_license_info_url);
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
              service_debug(@"licenseInfo = %@", json);
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
                  NSLog(@"license info = %@", licenseInfo);
                  licenseNameList = [[NSMutableArray alloc]init];
                  licenseTotalList = [[NSMutableArray alloc]init];
                  licenseParsedModuleCodeList = [[NSMutableArray alloc]init];
                  NSMutableDictionary *license_info_json = [NSJSONSerialization JSONObjectWithData: aes_decode_data options:kNilOptions error: nil];
                  NSInteger licenseCount = [[license_info_json objectForKey: @"total"]integerValue];
                  if (licenseCount > 0)
                  {
                      NSMutableArray *all = [[NSMutableArray alloc]init];
                      NSString *strFormat = [[NSString alloc]init];
                      NSArray *deviceListArr = [license_info_json objectForKey: @"services"];
                      for (NSDictionary *device in deviceListArr)
                      {
                          strFormat = @"";
                          NSString *module_code = [NSString stringWithFormat: @"%@", [device objectForKey: @"parsed_module_code"]];
                          if ([public checkDisplayStatus: module_code])
                          {
                              NSString *name = [NSString stringWithFormat: @"%@", [device objectForKey: @"name"]];
                              //                              [licenseNameList addObject: name];
                              strFormat = [strFormat stringByAppendingString: name];
                              NSString *total = [NSString stringWithFormat: @"%@", [device objectForKey: @"total"]];
                              //                              [licenseTotalList addObject: total];
                              strFormat = [strFormat stringByAppendingString: [NSString stringWithFormat: @"|%@", total]];
                              //                              [licenseParsedModuleCodeList addObject: module_code];
                              strFormat = [strFormat stringByAppendingString: [NSString stringWithFormat: @"|%@", module_code]];
                              [all addObject: strFormat];
                          }
                      }
                      // sort
                      NSArray *sort = [all sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
                      service_debug(@"sort = %@", sort);
                      for (NSString *str in sort)
                      {
                          NSArray *cutArr = [str componentsSeparatedByString: @"|"];
                          [licenseNameList addObject: cutArr[0]];
                          [licenseTotalList addObject: cutArr[1]];
                          [licenseParsedModuleCodeList addObject:cutArr[2]];
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
                              [self.registerListView setHidden: YES];
                              [self.tabBarController.tabBar setHidden: NO];
                              [self.licenseView setHidden: NO];
                              [self.errorView setHidden: YES];
                              [m_HUD setHidden: YES];
                          }
                      });
                  }
                  else
                  {
                      // no license data
                      dispatch_async(dispatch_get_main_queue(), ^() {
                          // show no license view
                          [self.licenseDetailView setHidden: YES];
                          [self.scanView setHidden: YES];
                          [self.manualView setHidden: YES];
                          [self.showView setHidden: YES];
                          [self.licenseList setHidden: YES];
                          [self.registerListView setHidden: YES];
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
                  // reponse error
                  response_debug(@"error code = %@, error meesage = %@", code, message);
                  [self.tabBarController.tabBar setHidden: YES];
                  [self.errorView setHidden: NO];
                  [m_HUD setHidden: YES];
              }
          }
          else
          {
              // no response data
              response_debug(@"No response data");
              [self.tabBarController.tabBar setHidden: YES];
              [self.errorView setHidden: NO];
              [m_HUD setHidden: YES];
          }
          dispatch_async(dispatch_get_main_queue(), ^() {
              [self.tabBarController.tabBar setUserInteractionEnabled: YES];
          });
      }] resume];
}
// API 12 GET LIECNSE FROM CHIOCE SERVICE
- (void)getLicenseDetail:(NSString *)module_code andServiceName:(NSString *)service_name
{
    [m_HUD setHidden: NO];
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
        service_debug(@"Code: %li", (long)[error code]);
        service_debug(@"Reason: %@", [error localizedFailureReason]);
    }
    else
    {
        service_debug(@"jwt token = %@", token);
    }
    NSString *get_license_info_url = [NSString stringWithFormat: @"%@/api/v2/my/license?token=%@&access_key_id=%@", DATA_URL, token, [public get_access_key_id]];
    service_debug(@"get_license_info_url = %@", get_license_info_url);
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
              service_debug(@"serviceInfo = %@", json);
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
                  service_debug(@"service info = %@", serviceInfo);
                  detailTotalList = [[NSMutableArray alloc]init];
                  detailAmountList = [[NSMutableArray alloc]init];
                  detailIdsList = [[NSMutableArray alloc]init];
                  detailIdsListArr = [[NSMutableArray alloc]init];
                  detailErrorMessageList = [[NSMutableArray alloc]init];
                  NSMutableDictionary *service_info_json = [NSJSONSerialization JSONObjectWithData: aes_decode_data options:kNilOptions error: nil];
                  detailModuleCode = [NSString stringWithFormat: @"%@", [service_info_json objectForKey: @"parsed_module_code"]];
                  serviceCount = [[service_info_json objectForKey: @"total"]integerValue];
                  if (serviceCount > 0)
                  {
                      NSArray *licenseListArr = [service_info_json objectForKey: @"services"];
                      for (NSDictionary *service in licenseListArr)
                      {
                          NSString *serviceType = [NSString stringWithFormat: @"%@", [service objectForKey: @"type"]];
                          NSInteger amountProc = [[service objectForKey: @"amount"]integerValue];
                          NSString *amount = nil;
                          if ([serviceType isEqualToString: @"TimeService"])
                          {
                              amount = [public getServiceTime: amountProc];
                          }
                          else
                          {
                              amount = [NSString stringWithFormat: @"%d Pcs", amountProc];
                          }
                          [detailAmountList addObject: amount];
                          NSString *total = [NSString stringWithFormat: @"%@", [service objectForKey: @"total"]];
                          [detailTotalList addObject: total];
                          [detailErrorMessageList addObject: @"NULL"];
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
                              [self.licenseDetailModuleCodeName setText: service_name];
                              [self.licenseRegisteredServicesList reloadData];
                              [self.searchListView setHidden: YES];
                              [self.licenseView setHidden: YES];
                              [self.tabBarController.tabBar setHidden: YES];
                              [self.licenseDetailView setHidden: NO];
                              [self.errorView setHidden: YES];
                              [m_HUD setHidden: YES];
                          }
                      });
                  }
                  else
                  {
                      service_debug(@"No service data");
                  }
              }
              else
              {
                  // request error
                  response_debug(@"error code = %@, error message = %@", code, message);
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
// API 13 GET DEVICE FOR LICENSE
- (void)toDeviceInfo:(NSInteger)index andAmount:(NSString *)service_date
{
    [m_HUD setHidden: NO];
    NSString *payloadFormat = [[NSString alloc]init];
    NSArray *getIdsList = [detailIdsListArr objectAtIndex: index];
    service_debug(@"list = %@", [detailIdsListArr objectAtIndex: index]);
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
        service_debug(@"Code: %li", (long)[error code]);
        service_debug(@"Reason: %@", [error localizedFailureReason]);
    }
    else
    {
        service_debug(@"jwt token = %@", token);
    }
    NSString *to_device_info_url = [NSString stringWithFormat: @"%@/api/v2/my/license/devices?token=%@&access_key_id=%@", DATA_URL, token, [public get_access_key_id]];
    service_debug(@"to_device_info_url = %@", to_device_info_url);
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
              service_debug(@"toDeviceInfo = %@", json);
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
                  service_debug(@"to device info = %@", serviceInfo);
                  toDeviceNameList = [[NSMutableArray alloc]init];
                  toDeviceMacList = [[NSMutableArray alloc]init];
                  toDeviceIdList = [[NSMutableArray alloc]init];
                  toDeviceIdsListFromDevice = [[NSMutableArray alloc]init];
                  NSMutableDictionary *to_device_info_json = [NSJSONSerialization JSONObjectWithData: aes_decode_data options:kNilOptions error: nil];
                  NSString *ids = [NSString stringWithFormat: @"%@", [to_device_info_json objectForKey: @"license_service_ids"]];
                  ids = [ids stringByReplacingOccurrencesOfString: @" " withString: @""];
                  ids = [ids stringByReplacingOccurrencesOfString: @"(" withString: @""];
                  ids = [ids stringByReplacingOccurrencesOfString: @")" withString: @""];
                  ids = [ids stringByReplacingOccurrencesOfString: @"\n" withString: @""];
                  NSArray *idsArr = [ids componentsSeparatedByString: @","];
                  toDeviceIdsListArr = [[NSMutableArray alloc]initWithArray: idsArr];
                  service_debug(@"toDeviceIdsListArr = %@", toDeviceIdsListArr);
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
                          NSString *ids = [NSString stringWithFormat: @"%@", [device objectForKey: @"license_service_ids"]];
                          ids = [ids stringByReplacingOccurrencesOfString: @" " withString: @""];
                          ids = [ids stringByReplacingOccurrencesOfString: @"(" withString: @""];
                          ids = [ids stringByReplacingOccurrencesOfString: @")" withString: @""];
                          ids = [ids stringByReplacingOccurrencesOfString: @"\n" withString: @""];
                          [toDeviceIdsListFromDevice addObject: ids];
                          service_debug(@"IDs from device = %@", ids);
                      }
                      dispatch_async(dispatch_get_main_queue(), ^() {
                          if (toDeviceStatus == YES)
                          {
                              // set slider attribute
                              if (detailServiceCount > 1)
                              {
                                  [self.activateCountSlider setMinimumValue: 1];
                                  [self.activateCountSlider setMaximumValue: detailServiceCount];
                                  [self.activateCountSlider setEnabled: YES];
                              }
                              else
                              {
                                  [self.activateCountSlider setMinimumValue: 0];
                                  [self.activateCountSlider setMaximumValue: detailServiceCount];
                                  [self.activateCountSlider setEnabled: NO];
                              }
                              [self.activateCount setText: @"1"];
                              [self.toDeviceCount setText: [NSString stringWithFormat: @"%ld", (long)detailServiceCount]];
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
                  else
                  {
                      // no device
                      dispatch_async(dispatch_get_main_queue(), ^() {
                          licenseDetailStatus = YES;
                          toDeviceStatus = NO;
                          [detailErrorMessageList replaceObjectAtIndex: toDeviceIndex withObject: @"Please register a device first to proceed the license activation."];
                          [self.licenseRegisteredServicesList reloadData];
                          dispatch_async(dispatch_get_main_queue(), ^() {
                              [self.errorView setHidden: YES];
                              [m_HUD setHidden: YES];
                          });
                      });
                  }
              }
              else
              {
                  // response error
                  dispatch_async(dispatch_get_main_queue(), ^() {
                      response_debug(@"error code = %@, error message = %@", code, message);
                      [self.errorView setHidden: YES];
                      [m_HUD setHidden: YES];
                  });
              }
          }
          else
          {
              // no response
              dispatch_async(dispatch_get_main_queue(), ^() {
                  response_debug(@"No response data");
                  [self.errorView setHidden: NO];
                  [m_HUD setHidden: YES];
              });
          }
      }] resume];
}
// API 3 LOG ACTIVATE SERVICE LICENSE
- (void)activateLicenseInfo:(NSString *)deviceId andServcieList:(NSMutableArray *)idsList
{
    [m_HUD setHidden: NO];
    NSString *payloadFormat = [[NSString alloc]init];
    NSError *error;
    NSUUID *uuid = [UIDevice currentDevice].identifierForVendor;
    NSString *os = [NSString stringWithFormat: @"ios %@", [[UIDevice currentDevice]systemVersion]];
    payloadFormat = [NSString stringWithFormat: @"{"
                     "\"udid\": \"%@\","
                     "\"os\": \"%@\","
                     "\"event_type\": \"exist\","
                    "\"device_id\": %@,"
                    "\"license_service_ids\": [", [NSString stringWithFormat: @"%@", uuid], os, deviceId];
    for (int i=0; i<[idsList count]; i++) {
        if (i == ([idsList count]-1)) {
            payloadFormat = [payloadFormat stringByAppendingFormat: @"%@]}", [idsList objectAtIndex: i]];
        }
        else
        {
            payloadFormat = [payloadFormat stringByAppendingFormat: @"%@,", [idsList objectAtIndex: i]];
        }
    }
    service_debug(@"payloadFormat = %@", payloadFormat);
    NSData *payloadJson = [payloadFormat dataUsingEncoding: NSUTF8StringEncoding];
    NSDictionary *payload = [NSJSONSerialization JSONObjectWithData: payloadJson options: kNilOptions error: &error];
    NSString *token = [Jwt encodeWithPayload: payload andKey: [public get_secret_access_key] andError:&error];
    if(token == nil)
    {
        // Print error
        service_debug(@"Code: %li", (long)[error code]);
        service_debug(@"Reason: %@", [error localizedFailureReason]);
    }
    else
    {
        service_debug(@"jwt token = %@", token);
    }
    NSString *to_device_info_url = [NSString stringWithFormat: @"%@/api/v2/my/license/license_services/activate?token=%@&access_key_id=%@", DATA_URL, token, [public get_access_key_id]];
    service_debug(@"to_device_info_url = %@", to_device_info_url);
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
              service_debug(@"toDeviceInfo = %@", json);
              
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
                  // request error
                  dispatch_async(dispatch_get_main_queue(), ^() {
                      response_debug(@"error code = %@, error message = %@", code, message);
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
                  });
              }
          }
          else
          {
              // no response data
              dispatch_async(dispatch_get_main_queue(), ^() {
                  response_debug(@"No response data");
                  [self.errorView setHidden: NO];
                  [m_HUD setHidden: YES];
              });
          }
      }] resume];
}
// API 11 LOG REGISTER LICENSE FOR CHECK
- (void)checkLicenseInfo:(NSString *)licenseKey andEventType:(NSString *)eventType
{
    service_debug(@"license key = %@", licenseKey);
    [m_HUD setHidden: NO];
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
        service_debug(@"Code: %li", (long)[error code]);
        service_debug(@"Reason: %@", [error localizedFailureReason]);
    }
    else
    {
        service_debug(@"jwt token = %@", token);
    }

    NSString *get_license_info_url = [NSString stringWithFormat: @"%@/api/v2/my/licenses/register?token=%@&access_key_id=%@", DATA_URL, token, [public get_access_key_id]];
    service_debug(@"check_license_info_url = %@", get_license_info_url);
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
              service_debug(@"checkLicenseInfo = %@", json);
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
                  service_debug(@"check license info = %@", checkLicenseInfo);
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
                          // check succeeded and to capital
                          NSString *key = [NSString stringWithFormat: @"%@", [service objectForKey: @"key"]];
                          [scanServiceKeyList addObject: [key uppercaseString]];
                          NSData *services = [NSJSONSerialization dataWithJSONObject: [service objectForKey: @"services"] options: NSJSONWritingPrettyPrinted error: nil];
                          NSArray *getServiceArr = [NSJSONSerialization JSONObjectWithData: services options: NSJSONReadingMutableContainers error: nil];
                          for (NSDictionary *serviceInfo in getServiceArr)
                          {
                              NSString *serviceName = [NSString stringWithFormat: @"%@", [serviceInfo objectForKey: @"name"]];
                              NSInteger amountProc = [[serviceInfo objectForKey: @"amount"]integerValue];
                              NSString *amount = [public getServiceTime: amountProc];
                              [scanServiceNameList addObject: serviceName];
                              [scanServiceAmountList addObject: amount];
                              [scanServiceEventTypeList addObject: eventType];
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
                          // check failed
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
                  // response error
                  dispatch_async(dispatch_get_main_queue(), ^() {
                      response_debug(@"error code = %@, error message = %@", code, message);
                      [self.errorView setHidden: NO];
                      [m_HUD setHidden: YES];
                  });
              }
          }
          else
          {
              //no resonse data
              dispatch_async(dispatch_get_main_queue(), ^() {
                  response_debug(@"no response data");
                  [self.errorView setHidden: NO];
                  [m_HUD setHidden: YES];
              });
          }
      }] resume];
}
// API 11 LOG REGISTER LICENSE FOR REGISTER
- (void)registerLicenseInfo:(NSString *)licenseKey andIndex:(NSInteger)index andEventType:(NSString *)eventType
{
    NSError *error;
    NSUUID *udid = [UIDevice currentDevice].identifierForVendor;
    NSString *os = [NSString stringWithFormat: @"ios %@", [[UIDevice currentDevice]systemVersion]];
    NSString *payloadFormat = [NSString stringWithFormat: @"{"
                               "\"pretend\": false,"
                               "\"udid\": \"%@\","
                               "\"os\": \"%@\","
                               "\"event_type\": \"%@\","
                               "\"licenses\": [%@]}", [NSString stringWithFormat: @"%@", udid], os, eventType, licenseKey];
    NSData *payloadJson = [payloadFormat dataUsingEncoding: NSUTF8StringEncoding];
    NSDictionary *payload = [NSJSONSerialization JSONObjectWithData: payloadJson options: kNilOptions error: &error];
    NSString *token = [Jwt encodeWithPayload: payload andKey: [public get_secret_access_key]andError:&error];
    if(token == nil)
    {
        // Print error
        service_debug(@"Code: %li", (long)[error code]);
        service_debug(@"Reason: %@", [error localizedFailureReason]);
    }
    else
    {
        service_debug(@"jwt token = %@", token);
    }
    NSString *get_license_info_url = [NSString stringWithFormat: @"%@/api/v2/my/licenses/register?token=%@&access_key_id=%@", DATA_URL, token, [public get_access_key_id]];
    service_debug(@"register_license_info_url = %@", get_license_info_url);
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
              service_debug(@"registerLicenseInfo = %@", json);
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
                  service_debug(@"register license info = %@", registerLicenseInfo);
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
                          [registerMessageList addObject: @"Register succeeded."];
                      }
                      else
                      {
                          // return result failed
                          NSString *errorMsg = [public checkErrorCode: return_code];
                          if ([errorMsg isEqualToString: @"unknow"])
                          {
                              [registerMessageList addObject: return_message];
                          }
                          else
                          {
                              [registerMessageList addObject: errorMsg];
                          }
                      }
                  }
                  dispatch_async(dispatch_get_main_queue(), ^() {
                      if ([registerMessageList count] == [scanServiceKeyList count]) {
                          scanStatus = NO;
                          registerListStatus = YES;
                          [self.registerList reloadData];
                          [self.scanView setHidden: YES];
                          [self.manualView setHidden: YES];
                          [self.errorView setHidden: YES];
                          _scanStatus = YES;
                          [self stopReading];
                          [self.registerListView setHidden: NO];
                          [m_HUD setHidden: YES];
                      }
                  });
              }
              else
              {
                  // response error
                  dispatch_async(dispatch_get_main_queue(), ^() {
                      response_debug(@"error code = %@, error message = %@", code, message);
                      [self.errorView setHidden: NO];
                      [m_HUD setHidden: YES];
                  });
              }
          }
          else
          {
              // no response data
              dispatch_async(dispatch_get_main_queue(), ^() {
                  response_debug(@"No reponse data");
                  [self.errorView setHidden: NO];
                  [m_HUD setHidden: YES];
              });
          }
      }] resume];
}
#pragma mark - FUNCTION EVENTS
- (void)checkLicense
{
    NSString *key = [self.manualLicenseKeyTxt.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([key length] > 0)
    {
        BOOL repeated = NO;
        for (NSString *license in scanServiceKeyList) {
            if ([self.manualLicenseKeyTxt.text isEqualToString: license]) {
                repeated = YES;
                [self.manualViewErrorMessage setText: @"The license is already in the list for add license."];
                [self.manualViewErrorMessage setHidden: NO];
                break;
            }
        }
        if (repeated == NO)
        {
            action = SERVICE_CHECK_MANUAL_LICENSE;
            if ([public checkNetWorkConn])
            {
                [self checkLicenseInfo: self.manualLicenseKeyTxt.text andEventType: @"manually"];
            }
            else
            {
                [self.errorView setHidden: NO];
            }
        }
    }
    else
    {
        [self.manualViewErrorMessage setText: @"License key can't be blank."];
        [self.manualViewErrorMessage setHidden: NO];
    }
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
- (void)searchServiceInfo
{
    [m_HUD setHidden: NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([licenseNameList count] > 0)
        {
            searchServiceList = [[NSMutableArray alloc]init];
            searchServiceTotalList = [[NSMutableArray alloc]init];
            searchParsedModuleCodeList = [[NSMutableArray alloc]init];
            searchKeyWordStatus = NO;
            NSString *keyWord = [self.searchServiceTxt.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if ([keyWord length] > 0)
            {
                for (int i=0; i<[licenseNameList count]; i++) {
                    NSRange searchName = [[licenseNameList objectAtIndex: i]rangeOfString: self.searchServiceTxt.text options: NSCaseInsensitiveSearch];
                    if (searchName.location == NSNotFound)
                    {
                        // show message
                        [self.searchList setHidden: YES];
                        [self.searchNoResView setHidden: NO];
                    }
                    else
                    {
                        [searchServiceList addObject: [licenseNameList objectAtIndex: i]];
                        [searchServiceTotalList addObject: [licenseTotalList objectAtIndex: i]];
                        [searchParsedModuleCodeList addObject: [licenseParsedModuleCodeList objectAtIndex: i]];
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
- (void)hiddeKeyboard
{
    // hidde keyboard
    [[[UIApplication sharedApplication]keyWindow]endEditing: YES];
}
- (void)showStatus
{
    service_debug(@"licenseListStatus = %d, licenseDetailStatus = %d, toDeviceStatus = %d, scanStatus = %d, registerListStatus = %d, searchStatus = %d", licenseListStatus, licenseDetailStatus, toDeviceStatus, scanStatus, registerListStatus, searchStatus);
}
- (void)checkTutoriaInfo
{
    if([public checkTutoriaInfo: @"serviceMT"]) [self.tutoriaServiceMTView setHidden: YES];
}
#pragma mark - BUTTON EVENTS
- (IBAction)registerNewLicensesBtn:(id)sender
{
    [m_HUD setHidden: NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tabBarController.tabBar setHidden: YES];
        licenseListStatus = NO;
        scanStatus = YES;
        scanServiceNameList = [[NSMutableArray alloc]init];
        scanServiceKeyList = [[NSMutableArray alloc]init];
        scanServiceAmountList = [[NSMutableArray alloc]init];
        scanServiceEventTypeList = [[NSMutableArray alloc]init];
        registerMessageList = [[NSMutableArray alloc]init];
        [self.manualViewErrorMessage setText: @""];
        [self.scanViewErrorMessage setText: @""];
        [self.manualLicenseKeyTxt setText: @""];
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
    if ([public checkNetWorkConn])
    {
        [self getLicenseInfo];
    }
    else
    {
        [self.errorView setHidden: NO];
    }
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
    action = ENTER_SERVICE;
    if ([public checkNetWorkConn])
    {
        [self getLicenseInfo];
    }
    else
    {
        [self.errorView setHidden: NO];
    }
}
- (IBAction)licenseDetailCancelBtn:(id)sender
{
    licenseListStatus = YES;
    licenseDetailStatus = NO;
    action = ENTER_SERVICE;
    if ([public checkNetWorkConn])
    {
        [self getLicenseInfo];
    }
    else
    {
        [self.errorView setHidden: NO];
    }
}
- (void)detailActivateBtn:(UIButton *)sender
{
    [self.toDeviceConfirmBtn setEnabled: NO];
    licenseDetailStatus = NO;
    toDeviceStatus = YES;
    detailServiceCount = [[detailTotalList objectAtIndex: sender.tag]integerValue];
    toDeviceIndex = sender.tag;
    cancelIndexPath = nil;
    // set slider init value
    [self.activateCountSlider setValue: 1];
    action = SERVICE_GET_DEVICE;
    if ([public checkNetWorkConn])
    {
        [self toDeviceInfo: toDeviceIndex andAmount: [detailAmountList objectAtIndex: toDeviceIndex]];
    }
    else
    {
        [self.errorView setHidden: NO];
    }
}
- (void)toDeviceCancelBtn:(id)sender
{
    toDeviceStatus = NO;
    licenseDetailStatus = YES;
    action = SERVICE_GET_LICENSE;
    if ([public checkNetWorkConn])
    {
        [self getLicenseDetail: licenseParsedModuleCode andServiceName: self.licenseDetailModuleCodeName.text];
    }
    else
    {
        [self.errorView setHidden: NO];
    }
}
- (IBAction)activateCountSliderChange:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    if (slider == self.activateCountSlider)
    {
        NSString *value = [NSString stringWithFormat: @"%.1f", slider.value];
        float getValue = [value floatValue];
        if ((getValue-(int)slider.value)>=0.5)
        {
            [self.activateCount setText: [NSString stringWithFormat: @"%d", ((int)slider.value)+1]];
        }
        else
        {
            [self.activateCount setText: [NSString stringWithFormat: @"%d", (int)slider.value]];
        }
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
    service_debug(@"device id = %@", activateDeviceId);
    activateServiceIdsList = [[NSMutableArray alloc]init];
    NSInteger selectCount = [self.activateCount.text integerValue];
    //NSArray *getServiceIdsList = [detailIdsListArr objectAtIndex: toDeviceIndex];
    for (int i=0; i<selectCount; i++) {
        //[activateServiceIdsList addObject: [getServiceIdsList objectAtIndex: i]];
        NSString *serviceId = [selectIdsListFromDevice objectAtIndex: i];
        [activateServiceIdsList addObject: serviceId];
    }
    service_debug(@"service id = %@", activateServiceIdsList);
    showCount = selectCount;
    action = SERVICE_ACTIVATE_LICENSE;
    if ([public checkNetWorkConn])
    {
        [self activateLicenseInfo: activateDeviceId andServcieList: activateServiceIdsList];
    }
    else
    {
        [self.errorView setHidden: NO];
    }
}
- (void)newLicenseDelBtn:(UIButton *)sender
{
    [scanServiceNameList removeObjectAtIndex: sender.tag];
    [scanServiceKeyList removeObjectAtIndex: sender.tag];
    [scanServiceAmountList removeObjectAtIndex: sender.tag];
    [scanServiceEventTypeList removeObjectAtIndex: sender.tag];
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
    service_debug(@"scan register licenses = %@", scanServiceKeyList);
    [m_HUD setHidden: NO];
    NSString *licenseKey = [[NSString alloc]init];
    for (int i=0; i<[scanServiceKeyList count]; i++) {
        NSString *eventType = [NSString stringWithFormat: @"%@", [scanServiceEventTypeList objectAtIndex: i]];
        licenseKey = [NSString stringWithFormat: @"{\"key\":\"%@\"}", [scanServiceKeyList objectAtIndex: i]];
        action = SERVICE_REGISTER_LICENSE;
        registerIndex = i;
        if ([public checkNetWorkConn])
        {
            dispatch_async(dispatch_get_main_queue(), ^() {
                [self registerLicenseInfo: licenseKey andIndex: i andEventType: eventType];
            });
        }
        else
        {
            [self.errorView setHidden: NO];
        }
    }
}
- (IBAction)manualRegisterBtn:(id)sender
{
    service_debug(@"manual register licenses.");
    [m_HUD setHidden: NO];
    NSString *licenseKey = [[NSString alloc]init];
    for (int i=0; i<[scanServiceKeyList count]; i++) {
        NSString *eventType = [NSString stringWithFormat: @"%@", [scanServiceEventTypeList objectAtIndex: i]];
        licenseKey = [NSString stringWithFormat: @"{\"key\":\"%@\"}", [scanServiceKeyList objectAtIndex: i]];
        action = SERVICE_REGISTER_LICENSE;
        registerIndex = i;
        if ([public checkNetWorkConn])
        {
            dispatch_async(dispatch_get_main_queue(), ^() {
                [self registerLicenseInfo: licenseKey andIndex: i andEventType: eventType];
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
        else if (action == SERVICE_CHECK_MANUAL_LICENSE)
        {
            [self checkLicenseInfo: self.manualLicenseKeyTxt.text andEventType: @"manually"];
        }
        else if (action == SERVICE_CHECK_SCAN_LICENSE)
        {
            [self checkLicenseInfo: scanSn andEventType: @"scan"];
        }
        else if (action == SERVICE_REGISTER_LICENSE)
        {
            [m_HUD setHidden: NO];
            NSString *licenseKey = [[NSString alloc]init];
            for (int i=(int)registerIndex; i<[scanServiceKeyList count]; i++) {
                NSString *eventType = [NSString stringWithFormat: @"%@", [scanServiceEventTypeList objectAtIndex: i]];
                licenseKey = [NSString stringWithFormat: @"{\"key\":\"%@\"}", [scanServiceKeyList objectAtIndex: i]];
                action = SERVICE_REGISTER_LICENSE;
                registerIndex = i;
                if ([public checkNetWorkConn])
                {
                    dispatch_async(dispatch_get_main_queue(), ^() {
                        [self registerLicenseInfo: licenseKey andIndex: i andEventType: eventType];
                    });
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
        service_debug(@"No Internet.");
    }
}

- (IBAction)registerListOkBtn:(id)sender
{
    registerListStatus = NO;
    licenseListStatus = YES;
    [self.licenseList reloadData];
    dispatch_async(dispatch_get_main_queue(), ^() {
        action = ENTER_SERVICE;
        if ([public checkNetWorkConn])
        {
            [self getLicenseInfo];
        }
        else
        {
            [self.errorView setHidden: NO];
        }
    });
}

- (IBAction)licenseSearchBtn:(id)sender
{
    [m_HUD setHidden: NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        licenseListStatus = NO;
        searchKeyWordStatus = NO;
        searchStatus = YES;
        [self.searchServiceTxt setText: @""];
        [self.searchList reloadData];
        [self.licenseView setHidden: YES];
        [self.tabBarController.tabBar setHidden: YES];
        [self.searchNoResView setHidden: YES];
        [self.searchListView setHidden: NO];
        [m_HUD setHidden: YES];
    });
}
- (void)showDoneBtn:(id)sender
{
    showStatus = NO;
    licenseListStatus = YES;
    action = ENTER_SERVICE;
    if ([public checkNetWorkConn])
    {
        [self getLicenseInfo];
    }
    else
    {
        [self.errorView setHidden: NO];
    }
}
- (IBAction)searchServiceCancelBtn:(id)sender {
    [m_HUD setHidden: NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        searchStatus = NO;
        licenseListStatus = YES;
        [self.searchListView setHidden: YES];
        [self.tabBarController.tabBar setHidden: NO];
        [self.licenseView setHidden: NO];
        [m_HUD setHidden: YES];
    });
}
- (IBAction)serviceMTBtn:(id)sender
{
    [self.tutoriaServiceMTView setHidden: YES];
    [public recordTutoriaInfo: @"serviceMT"];
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
                _scanStatus = NO;
                BOOL repeated = NO;
                for (NSString *license in scanServiceKeyList) {
                    if ([metadataObject.stringValue isEqualToString: license]) {
                        repeated = YES;
                        [self.scanViewErrorMessage setText: @"The license is already in the list for add license."];
                        [self.scanViewErrorMessage setHidden: NO];
                        break;
                    }
                }
                service_debug(@"scan data = %@", metadataObject.stringValue);
                if (repeated == NO)
                {
                    [self.scanViewErrorMessage setHidden: YES];
                    action = SERVICE_CHECK_SCAN_LICENSE;
                    scanSn = metadataObject.stringValue;
                    if ([public checkNetWorkConn])
                    {
                        [self checkLicenseInfo: metadataObject.stringValue andEventType: @"scan"];
                    }
                    else
                    {
                        [self.errorView setHidden: NO];
                    }
                }
                else
                {
                    _scanStatus = YES;
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
    else if (licenseDetailStatus == YES)
    {
        count = [detailTotalList count];
    }
    else if (toDeviceStatus == YES)
    {
        count = [toDeviceNameList count];
    }
    else if (scanStatus == YES)
    {
        count = [scanServiceKeyList count];
    }
    else if (showStatus == YES)
    {
        count = [detailTotalList count];
    }
    else if (registerListStatus == YES)
    {
        count = [scanServiceKeyList count];
    }
    else if (searchStatus == YES)
    {
        if (searchKeyWordStatus == YES)
        {
            count = [searchServiceList count];
        }
        else
        {
            count = [licenseNameList count];
        }
    }
    return  count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
                [licenseDetailCell.activate.layer setMasksToBounds: YES];
                [licenseDetailCell.activate.layer setCornerRadius: licenseDetailCell.activate.frame.size.height/2];
                [licenseDetailCell.activate setTag: indexPath.row];
                [licenseDetailCell.activate addTarget: self action: @selector(detailActivateBtn:) forControlEvents: UIControlEventTouchUpInside];
                // filter module code
                NSLog(@"license detail license module code = %@", detailModuleCode);
                if ([public checkActivateStatus: detailModuleCode])
                {
                    [licenseDetailCell.activate setHidden: NO];
                }
                else
                {
                    [licenseDetailCell.activate setHidden: YES];
                }
                [licenseDetailCell.count setText: [detailTotalList objectAtIndex: indexPath.row]];
                [licenseDetailCell.amount setText: [detailAmountList objectAtIndex: indexPath.row]];
                // set error message
                [licenseDetailCell.message setText: [detailErrorMessageList objectAtIndex: indexPath.row]];
                if ([[detailErrorMessageList objectAtIndex: indexPath.row] isEqualToString: @"NULL"])
                {
                    [licenseDetailCell.message setHidden: YES];
                }
                else
                {
                    [licenseDetailCell.message setHidden: NO];
                }
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
                [registerLicenseListCell.scanDel setHitTestEdgeInsets: UIEdgeInsetsMake(60, 60, 60, 60)];
                [registerLicenseListCell.manualServiceName setText: [scanServiceNameList objectAtIndex: indexPath.row]];
                [registerLicenseListCell.manualServiceKey setText: [scanServiceKeyList objectAtIndex: indexPath.row]];
                [registerLicenseListCell.manualServiceAmount setText: [scanServiceAmountList objectAtIndex: indexPath.row]];
                [registerLicenseListCell.manualDel addTarget: self action: @selector(newLicenseDelBtn:) forControlEvents: UIControlEventTouchUpInside];
                [registerLicenseListCell.manualDel setHitTestEdgeInsets: UIEdgeInsetsMake(60, 60, 60, 60)];
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
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
            }
            else
            {
                [showRegisteredLicenseCell.count.layer setMasksToBounds: YES];
                [showRegisteredLicenseCell.count.layer setCornerRadius: showRegisteredLicenseCell.count.frame.size.height/2];
                [showRegisteredLicenseCell.count setText: [detailTotalList objectAtIndex: indexPath.row]];
                [showRegisteredLicenseCell.amount setText: [detailAmountList objectAtIndex: indexPath.row]];
                if (indexPath.row == toDeviceIndex) {
                    [showRegisteredLicenseCell.activateCount setText:[NSString stringWithFormat: @"%ld Activated", (long)showCount]];
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
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
        }
    }
    if (registerListStatus == YES)
    {
        static NSString *CellIdentifier = @"registerListCell";
        if (indexPath.row < [scanServiceKeyList count])
        {
            RegisterListCell *registerListCell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
            if (registerListCell == nil)
            {
                registerListCell = [[RegisterListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
            }
            else
            {
                [registerListCell.serviceName setText: [scanServiceNameList objectAtIndex: indexPath.row]];
                [registerListCell.licenseKey setText: [scanServiceKeyList objectAtIndex: indexPath.row]];
                [registerListCell.amount setText: [scanServiceAmountList objectAtIndex: indexPath.row]];
                [registerListCell.message setText: [registerMessageList objectAtIndex: indexPath.row]];
                if ([registerListCell.message.text isEqualToString: @"Register succeeded."])
                {
                    [registerListCell.message setTextColor: [UIColor blueColor]];
                }
            }
            cell = registerListCell;
        }
        else
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
        }
    }
    if (searchStatus == YES)
    {
        static NSString *CellIdentifier = @"searchListCell";
        if (searchKeyWordStatus == YES)
        {
            if (indexPath.row < [searchServiceList count])
            {
                SearchServiceListCell *searchCell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
                if (searchCell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
                }
                else
                {
                    [searchCell.name setText:[searchServiceList objectAtIndex: indexPath.row]];
                    NSString *total = [NSString stringWithFormat: @"%@ Registered", [searchServiceTotalList objectAtIndex: indexPath.row]];
                    [searchCell.amount setText: total];
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
            if (indexPath.row < [licenseNameList count])
            {
                SearchServiceListCell *searchCell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
                if (searchCell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
                }
                else
                {
                    [searchCell.name setText:[licenseNameList objectAtIndex: indexPath.row]];
                    NSString *total = [NSString stringWithFormat: @"%@ Registered", [licenseTotalList objectAtIndex: indexPath.row]];
                    [searchCell.amount setText: total];
                    cell = searchCell;
                }
            }
            else
            {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
            }
        }
    }
    return cell;
}
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (licenseListStatus == YES)
    {
        licenseListStatus = NO;
        licenseDetailStatus = YES;
        licenseParsedModuleCode = [licenseParsedModuleCodeList objectAtIndex: indexPath.row];
        LicenseListCell *cell = [tableView cellForRowAtIndexPath: indexPath];
        selectServiceName = cell.name.text;
        service_debug(@"module code = %@ service name = %@", licenseParsedModuleCode, selectServiceName);
        action = SERVICE_GET_LICENSE;
        if ([public checkNetWorkConn])
        {
            [self getLicenseDetail: licenseParsedModuleCode andServiceName: selectServiceName];
        }
        else
        {
            [self.errorView setHidden: NO];
        }
    }
    else if (searchStatus == YES)
    {
        if (searchKeyWordStatus == NO)
        {
            [self hiddeKeyboard];
            searchStatus = NO;
            licenseDetailStatus = YES;
            licenseParsedModuleCode = [licenseParsedModuleCodeList objectAtIndex: indexPath.row];
            LicenseListCell *cell = [tableView cellForRowAtIndexPath: indexPath];
            selectServiceName = cell.name.text;
            service_debug(@"module code = %@ service name = %@", licenseParsedModuleCode, selectServiceName);
            action = SERVICE_GET_LICENSE;
            if ([public checkNetWorkConn])
            {
                [self getLicenseDetail: licenseParsedModuleCode andServiceName: selectServiceName];
            }
            else
            {
                [self.errorView setHidden: NO];
            }
        }
        else
        {
            searchStatus = NO;
            licenseDetailStatus = YES;
            licenseParsedModuleCode = [searchParsedModuleCodeList objectAtIndex: indexPath.row];
            SearchServiceListCell *cell = [tableView cellForRowAtIndexPath: indexPath];
            selectServiceName = cell.name.text;
            service_debug(@"module code = %@ service name = %@", licenseParsedModuleCode, selectServiceName);
            action = SERVICE_GET_LICENSE;
            if ([public checkNetWorkConn])
            {
                [self getLicenseDetail: licenseParsedModuleCode andServiceName: selectServiceName];
            }
            else
            {
                [self.errorView setHidden: NO];
            }
        }
    }
    else if (toDeviceStatus == YES)
    {
        service_debug(@"IDs = %@", [toDeviceIdsListFromDevice objectAtIndex: indexPath.row]);
        NSArray *idsArr = [[toDeviceIdsListFromDevice objectAtIndex: indexPath.row] componentsSeparatedByString: @","];
        selectIdsListFromDevice = [[NSMutableArray alloc]initWithArray: idsArr];
        if ([idsArr count] > 1)
        {
            [self.toDeviceCount setText: [NSString stringWithFormat: @"%lu", (unsigned long)[idsArr count]]];
            [self.activateCount setText: @"1"];
            // set slider init value
            [self.activateCountSlider setMinimumValue: 1];
            [self.activateCountSlider setMaximumValue: [idsArr count]];
            [self.activateCountSlider setValue: 1];
            [self.activateCountSlider setEnabled: YES];
        }
        else
        {
            [self.toDeviceCount setText: @"1"];
            [self.activateCount setText: @"1"];
            // set slider init value
            [self.activateCountSlider setMinimumValue: 0];
            [self.activateCountSlider setMaximumValue: 1];
            [self.activateCountSlider setValue: 1];
            [self.activateCountSlider setEnabled: NO];
        }
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
    else
    {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (toDeviceStatus == YES)
    {
        [self.toDeviceList selectRowAtIndexPath: indexPath animated:NO scrollPosition: UITableViewScrollPositionNone];
    }
}
@end
