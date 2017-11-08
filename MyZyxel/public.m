//
//  public.m
//  myZyxel
//
//  Created by line on 2017/6/2.
//  Copyright © 2017年 Zyxel. All rights reserved.
//

#import "public.h"

BOOL getRefreshRes;
NSString *code;
NSString *access_key_id;
NSString *secret_access_key;
NSString *access_token;
NSString *refresh_token;
NSString *user_account;
NSString *renewDeviceId;
NSString *deviceToken;
NSString *userId;
// push used
NSString *pushDeviceName;
NSString *pushOsVersion;
NSString *pushDeviceModel;
NSString *pushLanguage;
NSString *pushTimeZone;
NSString *pushAppVersion;
NSString *pushAppBuildNum;
NSString *pushUDID;
NSString *pushAppInfo;

NSInteger expired_count;
NSInteger updateStatus;
NSMutableArray *deviceNameList;
NSMutableArray *deviceMacAddrList;
NSMutableArray *deviceId;
NSMutableArray *deviceServicesList;
NSMutableArray *renewParsedModuleCodeList;

@implementation public

// parse query string
+ (NSDictionary *)parseQueryString:(NSString *)query
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:6];
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    
    for (NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        NSString *key = [[elements objectAtIndex:0]stringByAddingPercentEncodingWithAllowedCharacters: [NSCharacterSet URLQueryAllowedCharacterSet]];
        NSString *val = [[elements objectAtIndex:1] stringByAddingPercentEncodingWithAllowedCharacters: [NSCharacterSet URLQueryAllowedCharacterSet]];
        [dict setObject:val forKey:key];
    }
    return dict;
}

+ (NSString *)base64_encode:(NSString *)token
{
    NSData *plainData = [token dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [plainData base64EncodedStringWithOptions:0];
    return base64String;
}

+ (NSData *)base64_decode:(NSString *)token
{
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString: token options: 0];
    return decodedData;
}

+ (NSString*)sha256:(NSString *)input
{
    const char *cstr = [input cStringUsingEncoding: NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes: cstr length: input.length];
    uint8_t digest[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(data.bytes, (unsigned int)data.length, digest);
    NSMutableString *output = [NSMutableString stringWithCapacity: CC_SHA256_DIGEST_LENGTH];
    for(int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++)
    {
        [output appendFormat:@"%02x", digest[i]];
    }
    return output;
}

+ (NSString *)sha224:(NSString *)input
{
    const char *cstr = [input cStringUsingEncoding: NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes: cstr length: input.length];
    uint8_t digest[CC_SHA224_DIGEST_LENGTH];
    CC_SHA224(data.bytes, (unsigned int)data.length, digest);
    NSMutableString *output = [NSMutableString stringWithCapacity: CC_SHA224_DIGEST_LENGTH];
    for(int i = 0; i < CC_SHA224_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    return output;
}

+ (NSData *)hexToBytes:(NSString *)str
{
    NSMutableData* data = [NSMutableData data];
    int idx;
    for (idx = 0; idx+2 <= str.length; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString *hexStr = [str substringWithRange: range];
        NSScanner *scanner = [NSScanner scannerWithString: hexStr];
        unsigned int intValue;
        [scanner scanHexInt: &intValue];
        [data appendBytes: &intValue length:1];
    }
    return data;
}

+ (NSString*)getHexStringFromNSData:(NSData*)data
{
    const unsigned char *dbytes = [data bytes];
    NSMutableString *hexStr = [NSMutableString stringWithCapacity:[data length] * 2];
    int i;
    for (i = 0; i < [data length]; i++)
    {
        [hexStr appendFormat:@"%02X", dbytes[i]];
    }
    return [NSString stringWithString: hexStr];
}

+ (NSData *)aes_cbc_256:(NSData *)inData andIv:(NSString *)iv andkey:(NSData *)key andType: (CCOperation)coType
{
    NSData *retData = nil;
    if (!inData || !key) {
        return nil;
    }
    
    if (key.length!=32) {
        return nil;
    }
    
    NSUInteger dataLength = [inData length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = 0;
    
    NSData *ivToData = [iv dataUsingEncoding: NSUTF8StringEncoding];
    NSString *dataToHex = [self getHexStringFromNSData: ivToData];
    NSData *hexToData = [self hexToBytes: dataToHex];
    
    if (coType==kCCEncrypt) {
        cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128,
                              kCCOptionPKCS7Padding,
                              key.bytes, kCCKeySizeAES256,
                              hexToData.bytes,
                              [inData bytes], dataLength,
                              buffer, bufferSize,
                              &numBytesEncrypted);
    }

    if(coType ==kCCDecrypt)
    {
        cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128,
                              kCCOptionPKCS7Padding,
                              key.bytes, kCCKeySizeAES256,
                              hexToData.bytes,
                              [inData bytes], dataLength,
                              buffer, bufferSize,
                              &numBytesEncrypted);
    }
    
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    free(buffer);
    
    return retData;
}
+ (int8_t)getDeviceType
{
    CGSize screenSize = [[UIScreen mainScreen]bounds].size;
    NSInteger deviceWidth = screenSize.width;
    NSInteger deviceHeight = screenSize.height;
    
    if (deviceWidth == 320 && deviceHeight == 568)
    {
        return 1;
    }
    else if (deviceWidth == 375 && deviceHeight == 667)
    {
        return 2;
    }
    else if (deviceWidth == 414 && deviceHeight == 736)
    {
        return 3;
    }
    else
    {
        return 0;
    }
}
+ (NSString *)checkErrorCode:(NSString *)code
{
    if ([code isEqualToString: @"400.3.1"])
    {
        return @"Mac address can't be blank.";
    }
    else if ([code isEqualToString: @"400.3.2"])
    {
        return @"Serial number can't be blank.";
    }
    else if ([code isEqualToString: @"400.3.3"])
    {
        return @"Device doesn't exist.";
    }
    else if ([code isEqualToString: @"400.3.4"])
    {
        return @"Device has not been registered.";
    }
    else if ([code isEqualToString: @"400.3.5"])
    {
        return @"Device ID can't be blank.";
    }
    else if ([code isEqualToString: @"400.3.6"])
    {
        return @"Devices info can't be blank.";
    }
    else if ([code isEqualToString: @"400.3.7"])
    {
        return @"Device has already been registered.";
    }
    else if ([code isEqualToString: @"400.3.8"])
    {
        return @"Device can not be registered in {Country}.";
    }
    else if ([code isEqualToString: @"400.3.9"])
    {
        return @"Please register your Nebula devices via Nebula Control Center ( nebula.zyxel.com).";
    }
    else if ([code isEqualToString: @"400.4.1"])
    {
        return @"Module code can't be blank.";
    }
    else if ([code isEqualToString: @"400.4.2"])
    {
        return @"Status can't be blank.";
    }
    else if ([code isEqualToString: @"400.4.3"])
    {
        return @"Status is invalid.";
    }
    else if ([code isEqualToString: @"400.4.4"])
    {
        return @"Parsed_module_code can't be blank.";
    }
    else if ([code isEqualToString: @"400.5.1"])
    {
        return @"License key can't be blank.";
    }
    else if ([code isEqualToString: @"400.5.2"])
    {
        return @"License key doesn't exist.";
    }
    else if ([code isEqualToString: @"400.5.3"])
    {
        return @"License key has already been registered.";
    }
    else if ([code isEqualToString: @"400.5.4"])
    {
        return @"SecuManager license registration is not supported.";
    }
    else if ([code isEqualToString: @"400.5.5"])
    {
        return @"License is expired.";
    }
    else if ([code isEqualToString: @"400.5.6"])
    {
        return @"License can't be registered in {Country}.";
    }
    else if ([code isEqualToString: @"400.5.7"])
    {
        return @"License registration of HA Pro service is only supported in myZyxel service portal.";
    }
    else if ([code isEqualToString: @"400.5.8"])
    {
        return @"License registration of Nebula service is only supported in myZyxel portal.";
    }
    else if ([code isEqualToString: @"400.5.9"])
    {
        return @"Device isn't compatible for the license.";
    }
    else if ([code isEqualToString: @"400.5.10"])
    {
        return @"The license cannot be added to your device since there is already one activated.";
    }
    else if ([code isEqualToString: @"400.5.11"])
    {
        return @"The license cannot be added to your device since there is already one activated.";
    }
    else if ([code isEqualToString: @"400.5.12"])
    {
        return @"The license cannot be added to your device since there is already one activated.";
    }
    else if ([code isEqualToString: @"400.5.13"])
    {
        return @"Please activate Nebula service in Nebula Cloud Center (nebula.zyxel.com).";
    }
    else if ([code isEqualToString: @"400.5.14"])
    {
        return @"The device has reached the limit of this service.";
    }
    else if ([code isEqualToString: @"400.5.15"])
    {
        return @"Registration denied. The total of years supported by both activated and new NBDD licenses is no more than 5.";
    }
    else if ([code isEqualToString: @"400.5.16"])
    {
        return @"license isn't a single service license.";
    }
    else if ([code isEqualToString: @"400.5.17"])
    {
        return @"License key is invalid. Please contact local support.";
    }
    else if ([code isEqualToString: @"400.5.18"])
    {
        return @"Licenses key can't be blank.";
    }
    else if ([code isEqualToString: @"400.5.19"])
    {
        return @"Not all licenses are activated. Please check the licenses again.";
    }
    else if ([code isEqualToString: @"400.5.20"])
    {
        return @"One-time and 1-year hotspot service can't be registered at the same time.";
    }
    else if ([code isEqualToString: @"400.5.21"])
    {
        return @"Not all licenses are registered. Please check the licenses again.";
    }
    else if ([code isEqualToString: @"400.6.1"])
    {
        return @"License key can't be blank.";
    }
    else if ([code isEqualToString: @"400.6.2"])
    {
        return @"License key doesn't exist.";
    }
    else if ([code isEqualToString: @"400.6.3"])
    {
        return @"This license has been linked to another device.";
    }
    else if ([code isEqualToString: @"400.6.4"])
    {
        return @"The device is incompatible with the device.";
    }
    else if ([code isEqualToString: @"400.6.5"])
    {
        return @"he license cannot be added to your device since there is already one activated.";
    }
    else if ([code isEqualToString: @"400.6.6"])
    {
        return @"The license cannot be added to your device since there is already one activated.";
    }
    else if ([code isEqualToString: @"400.6.7"])
    {
        return @"The license cannot be added to your device since there is already one activated.";
    }
    else if ([code isEqualToString: @"400.6.8"])
    {
        return @"Please activate Nebula service in Nebula Cloud Center (nebula.zyxel.com).";
    }
    else if ([code isEqualToString: @"400.6.9"])
    {
        return @"The device has reached the limit of this service.";
    }
    else if ([code isEqualToString: @"400.6.10"])
    {
        return @"Registration denied. The total of years supported by both activated and new NBDD licenses is no more than 5.";
    }
    else if ([code isEqualToString: @"400.6.11"])
    {
        return @"License key can't be blank.";
    }
    else if ([code isEqualToString: @"400.6.12"])
    {
        return @"License key is invalid.";
    }
    else if ([code isEqualToString: @"400.6.13"])
    {
        return @"Not all licenses are activated. Please check the licenses again.";
    }
    else if ([code isEqualToString: @"400.7.1"])
    {
        return @"Enter reseller name, email or VAT number.";
    }
    else if ([code isEqualToString: @"400.7.2"])
    {
        return @"The reseller information is not correct. Please check again.";
    }
    else if ([code isEqualToString: @"400.7.3"])
    {
        return @"Reseller and customer names must not be identical.";
    }
    else if ([code isEqualToString: @"401.1.1"])
    {
        return @"The access token is invalid.";
    }
    else if ([code isEqualToString: @"401.1.2"])
    {
        return @"The access token expired.";
    }
    else if ([code isEqualToString: @"401.1.3"])
    {
        return @"The access token has been revoked.";
    }
    else if ([code isEqualToString: @"401.2.1"])
    {
        return @"The access token has been revoked.";
    }
    else if ([code isEqualToString: @"401.2.2"])
    {
        return @"token can't be blank.";
    }
    else if ([code isEqualToString: @"401.2.3"])
    {
        return @"access_key_id is invalid.";
    }
    else if ([code isEqualToString: @"401.2.4"])
    {
        return @"access key has been revoked.";
    }
    else if ([code isEqualToString: @"401.2.5"])
    {
        return @"Jwt error: Not enough or too many segments.";
    }
    else if ([code isEqualToString: @"401.2.6"])
    {
        return @"Jwt error: Invalid segment encoding.";
    }
    else if ([code isEqualToString: @"401.2.7"])
    {
        return @"Jwt error: Signature has expired.";
    }
    else if ([code isEqualToString: @"401.2.8"])
    {
        return @"Jwt error: Signature verification raised.";
    }
    else if ([code isEqualToString: @"401.2.9"])
    {
        return @"The access token owner doesn't match the access key owner.";
    }
    else if ([code isEqualToString: @"1"])
    {
        return  @"Not found.";
    }
    else
    {
        return @"unknow";
    }
}
+ (NSString *)getServiceTime:(NSInteger)amount
{
    if (amount < 365)
    {
        return [NSString stringWithFormat: @"%ld days service", (long)amount];
    }
    else
    {
        int getYear = (int)amount/365;
//        int getDay = (int)amount%365;
        if (getYear < 2)
        {
//            if (getDay == 0 || getDay == 1)
//            {
                return [NSString stringWithFormat: @"%d year service", getYear];
//            }
//            else
//            {
//                return [NSString stringWithFormat: @"%d year + %d days service", getYear, getDay];
//            }
        }
        else
        {
//            if (getDay == 0 || getDay == 1)
//            {
                return [NSString stringWithFormat: @"%d years service", getYear];
//            }
//            else
//            {
//                return [NSString stringWithFormat: @"%d years + %d days service", getYear, getDay];
//            }
        }
    }
}
+ (NSString *)getExpiringTime:(NSInteger)day
{
    NSDate *now = [NSDate date];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay: day];
    NSDate *thirtyDaysLatter = [[NSCalendar currentCalendar]dateByAddingComponents: dateComponents toDate: now options: 0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    return [dateFormatter stringFromDate: thirtyDaysLatter];
}
+ (BOOL)checkNetWorkConn
{
    Reachability *reach = [Reachability reachabilityWithHostName: @"www.apple.com"];
    NetworkStatus netStatus = [reach currentReachabilityStatus];
    if (netStatus == NotReachable)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

+ (BOOL)refreshToken
{
    getRefreshRes = NO;
    NSString *access_token_url = [NSString stringWithFormat: @"%@/oauth/token", SITE_URL];
    if (DEBUG) debug(@"access token url = %@", access_token_url);
    NSURL *url = [NSURL URLWithString: access_token_url];
    NSMutableURLRequest *request_access_token = [NSMutableURLRequest requestWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 30];
    
    [request_access_token setHTTPMethod: @"POST"];
    [request_access_token setValue: @"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField: @"Content-Type"];
    NSString *stringData = [NSString stringWithFormat: @"grant_type=refresh_token&refresh_token=%@", refresh_token];
    NSData *postData = [stringData dataUsingEncoding: NSUTF8StringEncoding];
    [request_access_token setHTTPBody: postData];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest: request_access_token
                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                    if (data != nil)
                    {
                        NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData: data options: kNilOptions error: nil];
                        [public set_access_token: [NSString stringWithFormat: @"Bearer %@", [json valueForKey: @"access_token"]]];
                        [public set_refresh_token: [json valueForKey: @"refresh_token"]];
                        getRefreshRes = YES;
                    }
    }] resume];
    debug(@"access_token = %@, refresh_token = %@", [public get_access_token], [public get_refresh_token]);
    return  getRefreshRes;
}
+ (NSString*)deviceModelName
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //iPhone 系列
    if ([deviceModel isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceModel isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceModel isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceModel isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceModel isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceModel isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceModel isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([deviceModel isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([deviceModel isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([deviceModel isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceModel isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceModel isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceModel isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceModel isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceModel isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    if ([deviceModel isEqualToString:@"iPhone9,1"])    return @"iPhone 7 (CDMA)";
    if ([deviceModel isEqualToString:@"iPhone9,3"])    return @"iPhone 7 (GSM)";
    if ([deviceModel isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus (CDMA)";
    if ([deviceModel isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus (GSM)";
    
    //iPod 系列
    if ([deviceModel isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceModel isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceModel isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceModel isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceModel isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    
    //iPad 系列
    if ([deviceModel isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceModel isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceModel isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceModel isEqualToString:@"iPad2,4"])      return @"iPad 2 (32nm)";
    if ([deviceModel isEqualToString:@"iPad2,5"])      return @"iPad mini (WiFi)";
    if ([deviceModel isEqualToString:@"iPad2,6"])      return @"iPad mini (GSM)";
    if ([deviceModel isEqualToString:@"iPad2,7"])      return @"iPad mini (CDMA)";
    
    if ([deviceModel isEqualToString:@"iPad3,1"])      return @"iPad 3(WiFi)";
    if ([deviceModel isEqualToString:@"iPad3,2"])      return @"iPad 3(CDMA)";
    if ([deviceModel isEqualToString:@"iPad3,3"])      return @"iPad 3(4G)";
    if ([deviceModel isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad3,5"])      return @"iPad 4 (4G)";
    if ([deviceModel isEqualToString:@"iPad3,6"])      return @"iPad 4 (CDMA)";
    
    if ([deviceModel isEqualToString:@"iPad4,1"])      return @"iPad Air";
    if ([deviceModel isEqualToString:@"iPad4,2"])      return @"iPad Air";
    if ([deviceModel isEqualToString:@"iPad4,3"])      return @"iPad Air";
    if ([deviceModel isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceModel isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([deviceModel isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceModel isEqualToString:@"x86_64"])       return @"Simulator";
    
    if ([deviceModel isEqualToString:@"iPad4,4"]
        ||[deviceModel isEqualToString:@"iPad4,5"]
        ||[deviceModel isEqualToString:@"iPad4,6"])      return @"iPad mini 2";
    
    if ([deviceModel isEqualToString:@"iPad4,7"]
        ||[deviceModel isEqualToString:@"iPad4,8"]
        ||[deviceModel isEqualToString:@"iPad4,9"])      return @"iPad mini 3";
    
    return deviceModel;
}

+ (BOOL)checkDisplayStatus:(NSString *)moduleCode
{
    BOOL display = YES;
    if ([moduleCode isEqualToString: @"PKG_ZYXEL_S"])
    {
        display = YES;
    }
    else if ([moduleCode isEqualToString: @"UTMSW_ZYXEL_S"])
    {
        display = YES;
    }
    else if ([moduleCode isEqualToString: @"HOTSQ_ZYXEL_S"])
    {
        display = YES;
    }
    else if ([moduleCode isEqualToString: @"FW_ZYXEL_S"])
    {
        display = YES;
    }
    else if ([moduleCode isEqualToString: @"FWQ_ZYXEL_S"])
    {
        display = YES;
    }
    else if ([moduleCode isEqualToString: @"PSP_ZYXEL_T"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"PSP_ZYXEL_S"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"PRMSP_ZYXEL_T"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"PRMSP_ZYXEL_S"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"TSP_ZYXEL_T"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"TSP_ZYXEL_S"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"WEBSEC_ZYXEL_T"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"WEBSEC_ZYXEL_S"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"APP_QM_T"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"APP_QM_S"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"MB_KA_T"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"MB_KA_S"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"IPS_AH_T"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"IPS_AH_S"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"GE_MM_T"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"GE_MM_S"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"SBX_LL_T"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"SBX_LL_S"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"APC_ZYXEL_S"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"SECUR_ZYXEL_T"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"SECUR_ZYXEL_S"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"FBWIFI_ZYXEL_S"])
    {
        display = YES;
    }
    else if ([moduleCode isEqualToString: @"CNMS_ZYXEL_S"])
    {
        display = YES;
    }
    else if ([moduleCode isEqualToString: @"CNMN_ZYXEL_S"])
    {
        display = YES;
    }
    else if ([moduleCode isEqualToString: @"GEOLOC_ZYXEL_S"])
    {
        display = YES;
    }
    else if ([moduleCode isEqualToString: @"SECUD_ZYXEL_T"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"SECUD_ZYXEL_S"])
    {
        display = NO;
    }
    return display;
}
+ (BOOL)checkActivateStatus:(NSString *)moduleCode
{
    BOOL display = YES;
    if ([moduleCode isEqualToString: @"PKG_ZYXEL"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"UTMSW_ZYXEL_S"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"HOTSQ_ZYXEL_S"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"FW_ZYXEL_S"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"FWQ_ZYXEL_S"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"PSP_ZYXEL_T"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"PSP_ZYXEL_S"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"PRMSP_ZYXEL_T"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"PRMSP_ZYXEL_S"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"TSP_ZYXEL_T"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"TSP_ZYXEL_S"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"WEBSEC_ZYXEL_T"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"WEBSEC_ZYXEL_S"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"APP_QM_T"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"APP_QM_S"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"MB_KA_T"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"MB_KA_S"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"IPS_AH_T"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"IPS_AH_S"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"GE_MM_T"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"GE_MM_S"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"SBX_LL_T"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"SBX_LL_S"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"APC_ZYXEL_S"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"SECUR_ZYXEL_T"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"SECUR_ZYXEL_S"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"FBWIFI_ZYXEL_S"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"CNMS_ZYXEL_S"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"CNMN_ZYXEL_S"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"GEOLOC_ZYXEL_S"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"SECUD_ZYXEL_T"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"SECUD_ZYXEL_S"])
    {
        display = NO;
    }
    return display;
}
+ (BOOL)checkRegisterStatus:(NSString *)moduleCode
{
    BOOL display = YES;
    if ([moduleCode isEqualToString: @"PKG_ZYXEL"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"UTMSW_ZYXEL_S"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"HOTSQ_ZYXEL_S"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"FW_ZYXEL_S"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"FWQ_ZYXEL_S"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"PSP_ZYXEL_T"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"PSP_ZYXEL_S"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"PRMSP_ZYXEL_T"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"PRMSP_ZYXEL_S"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"TSP_ZYXEL_T"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"TSP_ZYXEL_S"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"WEBSEC_ZYXEL_T"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"WEBSEC_ZYXEL_S"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"APP_QM_T"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"APP_QM_S"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"MB_KA_T"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"MB_KA_S"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"IPS_AH_T"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"IPS_AH_S"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"GE_MM_T"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"GE_MM_S"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"SBX_LL_T"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"SBX_LL_S"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"APC_ZYXEL_S"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"SECUR_ZYXEL_T"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"SECUR_ZYXEL_S"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"FBWIFI_ZYXEL_S"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"CNMS_ZYXEL_S"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"CNMN_ZYXEL_S"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"GEOLOC_ZYXEL_S"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"SECUD_ZYXEL_T"])
    {
        display = NO;
    }
    else if ([moduleCode isEqualToString: @"SECUD_ZYXEL_S"])
    {
        display = NO;
    }
    return display;
}
+ (BOOL)checkSpecialStr:(NSString *)str
{
    NSString *string = @"%, ~, ￥, #, &, *, <, >, 《, 》, (, ), [, ], {, }, 【, 】, ^, @, /, \\, ￡, ¤, |, §, ¨, 「, 」, 『, 』, ￠, ￢, ￣, （, ）, ——, +, |, $, €, ¥";
    NSArray *specialStrArr = [string componentsSeparatedByString: @","];
    for (int i=0; i<[specialStrArr count]; i++) {
        if ([str rangeOfString: [specialStrArr objectAtIndex: i]].location != NSNotFound)
        {
            return YES;
        }
    }
    return NO;
}

RSA* createPrivateRSA(NSString *key) {
    RSA *rsa = NULL;
    const char* c_string = [key UTF8String];
    BIO * keybio = BIO_new_mem_buf((void*)c_string, -1);
    if (keybio==NULL) {
        return 0;
    }
    rsa = PEM_read_bio_RSAPrivateKey(keybio, &rsa,NULL, NULL);
    return rsa;
}

bool RSASign( RSA* rsa,
             const unsigned char* Msg,
             size_t MsgLen,
             unsigned char** EncMsg,
             size_t* MsgLenEnc)
{
    EVP_MD_CTX* m_RSASignCtx = EVP_MD_CTX_create();
    EVP_PKEY* priKey  = EVP_PKEY_new();
    EVP_PKEY_assign_RSA(priKey, rsa);
    if (EVP_DigestSignInit(m_RSASignCtx,NULL, EVP_sha224(), NULL,priKey)<=0) {
        return false;
    }
    if (EVP_DigestSignUpdate(m_RSASignCtx, Msg, MsgLen) <= 0) {
        return false;
    }
    if (EVP_DigestSignFinal(m_RSASignCtx, NULL, MsgLenEnc) <=0) {
        return false;
    }
    *EncMsg = (unsigned char*)malloc(*MsgLenEnc);
    if (EVP_DigestSignFinal(m_RSASignCtx, *EncMsg, MsgLenEnc) <= 0) {
        return false;
    }
    EVP_MD_CTX_cleanup(m_RSASignCtx);
    return true;
}

void Base64Encode( const unsigned char* buffer,
                  size_t length,
                  char** base64Text)
{
    BIO *bio, *b64;
    BUF_MEM *bufferPtr;
    
    b64 = BIO_new(BIO_f_base64());
    bio = BIO_new(BIO_s_mem());
    bio = BIO_push(b64, bio);
    
    BIO_write(bio, buffer, (int)length);
    BIO_flush(bio);
    BIO_get_mem_ptr(bio, &bufferPtr);
    BIO_set_close(bio, BIO_NOCLOSE);
    BIO_free_all(bio);
    
    *base64Text=(*bufferPtr).data;
}

+ (NSString *) signMessage:(NSString *)privateKey and:(NSString *)plainText
{
    RSA* privateRSA = createPrivateRSA(privateKey);
    unsigned char* encMessage;
    char *base64Text;
    size_t encMessageLength;
    RSASign(privateRSA, (unsigned char *)[plainText UTF8String], [plainText length], &encMessage, &encMessageLength);
    Base64Encode(encMessage, encMessageLength, &base64Text);
    free(encMessage);
    return [NSString stringWithFormat: @"%s", base64Text];
}

+ (NSString *)stringByAddingPercentEscapesForURLParameter:(NSString *)str
{
    CFStringRef buffer =
    CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                            (__bridge CFStringRef)str,
                                            NULL,
                                            (__bridge CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                            kCFStringEncodingUTF8);
    NSString *result = [NSString stringWithString:(__bridge NSString *)buffer];
    CFRelease(buffer);
    return result;
}

+ (NSString *)getAppInfo
{
    pushDeviceName = [NSString stringWithFormat: @"%@", [[UIDevice currentDevice]model]];
    pushOsVersion = [NSString stringWithFormat: @"%@", [[UIDevice currentDevice]systemVersion]];
    pushDeviceModel = [public deviceModelName];
    pushLanguage = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSTimeZone* timeZone = [NSTimeZone localTimeZone];
    NSInteger offset = (([timeZone secondsFromGMT]/60)/60);
    pushTimeZone = [NSString stringWithFormat: @"+%ld00", (long)offset];
    pushAppVersion = [[[NSBundle mainBundle]infoDictionary]objectForKey: @"CFBundleShortVersionString"];
    pushAppBuildNum = [[[NSBundle mainBundle]infoDictionary]objectForKey: @"CFBundleVersion"];
    NSUUID *uuid = [UIDevice currentDevice].identifierForVendor;
    pushUDID = [NSString stringWithFormat: @"%@", uuid];
    NSMutableDictionary *body = [[NSMutableDictionary alloc]init];
    [body setValue: pushDeviceName forKey: @"device_name"];
    [body setValue: pushAppVersion forKey: @"app_version"];
    [body setValue: pushAppBuildNum forKey: @"app_build"];
    [body setValue: pushTimeZone forKey: @"timezone"];
    [body setValue: pushLanguage forKey: @"language"];
    [body setValue: pushOsVersion forKey: @"os_version"];
    [body setValue: pushDeviceModel forKey: @"device_model"];
    if ([NSJSONSerialization isValidJSONObject: body])
    {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject: body options: NSJSONWritingPrettyPrinted error: nil];
        pushAppInfo = [[[NSString alloc]initWithData: jsonData encoding: NSUTF8StringEncoding]stringByReplacingOccurrencesOfString: @"\n" withString: @""];
    }
    return pushAppInfo;
}
+ (NSString *)getTimeStamp
{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time=[date timeIntervalSince1970];
    return [NSString stringWithFormat:@"%.0f", time];
}
+ (NSString *)generateSign:(NSInteger)option andTimeStamp:(NSString *)timeStamp andInboxId:(NSString *)inboxId
{
    NSMutableDictionary *parameter =[[NSMutableDictionary alloc]init];
    NSString *appInfo = [self getAppInfo];
    if (option == REGISTER_DEVICE || option == UPDATE_DEVICE)
    {
        [parameter setValue: timeStamp forKey: @"X-Timestamp"];
        [parameter setValue: AKID forKey: @"access_key_id"];
        [parameter setValue: pushUDID forKey: @"udid"];
        [parameter setValue: [public get_device_token] forKey: @"push_token"];
        [parameter setValue: appInfo forKey: @"app_info"];
    }
    else if (option == BINDING_DEVICE || option == UNBINDING_DEVICE)
    {
        [parameter setValue: timeStamp forKey: @"X-Timestamp"];
        [parameter setValue: AKID forKey: @"access_key_id"];
        [parameter setValue: pushUDID forKey: @"udid"];
        [parameter setValue: userId forKey: @"user_id"];
    }
    else if (option == GET_MESSAGE_LIST)
    {
        [parameter setValue: timeStamp forKey: @"X-Timestamp"];
        [parameter setValue: AKID forKey: @"access_key_id"];
        [parameter setValue: userId forKey: @"user_id"];
        [parameter setValue: [self messageRange: @"from"] forKey: @"from"];
        [parameter setValue: [self messageRange: @"to"] forKey: @"to"];
    }
    else if (option == GET_MESSAGE_DETAIL)
    {
        [parameter setValue: timeStamp forKey: @"X-Timestamp"];
        [parameter setValue: AKID forKey: @"access_key_id"];
        [parameter setValue: userId forKey: @"user_id"];
        [parameter setValue: inboxId forKey: @"inbox_id"];
    }
    NSArray *keyArr = [parameter allKeys];
    NSArray *keySort = [keyArr sortedArrayUsingSelector: @selector(compare:)];
    NSString *strFormat = [[NSString alloc]init];
    for (int i=0; i<[keySort count]; i++)
    {
        strFormat = [strFormat stringByAppendingString: [parameter objectForKey: [keySort objectAtIndex: i]]];
    }
    push_debug(@"sign data = %@", strFormat);
    return [NSString stringWithFormat: @"%@", [[public signMessage: PRIVATE_KEY and: strFormat]stringByReplacingOccurrencesOfString:@"\n" withString: @""]];
}
+ (NSString *)messageRange:(NSString *)action
{
    NSDate *currentDateandTime = [NSDate date];
#ifdef __IPHONE_8_0
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
#else
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar];
#endif
    NSDateComponents *offsetComps = [[NSDateComponents alloc] init];
    offsetComps.month = -2;
    NSDate *newDate = [calendar dateByAddingComponents:offsetComps toDate: currentDateandTime options:0];
    
    NSDateFormatter *date_formater=[[NSDateFormatter alloc]init];
    [date_formater setDateFormat:@"YYYYMM"];
    NSString *dateStr = nil;
    if ([action isEqualToString: @"from"])
    {
        dateStr = [date_formater stringFromDate: newDate];
    }
    else if ([action isEqualToString: @"to"])
    {
        dateStr = [date_formater stringFromDate: currentDateandTime];
    }
    return dateStr;
}

+ (void)set_device_token:(NSString *)input
{
    deviceToken = input;
}
+ (NSString *)get_device_token
{
    return deviceToken;
}

+ (void)set_access_token:(NSString *)input
{
    access_token = input;
}
+ (NSString *)get_access_token
{
    return access_token;
}

+ (void)set_refresh_token:(NSString *)input
{
    refresh_token = input;
}
+ (NSString *)get_refresh_token
{
    return refresh_token;
}

+ (void)set_access_key_id:(NSString *)input
{
    access_key_id = input;
}
+ (NSString *)get_access_key_id
{
    return access_key_id;
}

+ (void)set_secret_access_key:(NSString *)input
{
    secret_access_key = input;
}
+ (NSString *)get_secret_access_key
{
    return secret_access_key;
}

+ (void)set_code:(NSString *)input
{
    code = input;
}
+ (NSString *)get_code
{
    return code;
}

+ (void)set_user_account:(NSString *)input
{
    user_account = input;
}
+ (NSString *)get_user_account
{
    return user_account;
}

+ (void)set_expired_count:(NSInteger)input
{
    expired_count = input;
}
+ (NSInteger)get_expired_count
{
    return expired_count;
}

+ (void)set_update_status:(NSInteger)input
{
    updateStatus = input;
}
+ (NSInteger)get_update_status
{
    return updateStatus;
}

+ (void)set_device_name:(NSMutableArray *)input
{
    deviceNameList = input;
}
+ (NSMutableArray *)get_device_name
{
    return deviceNameList;
}
+ (void)set_device_mac_addr:(NSMutableArray *)input
{
    deviceMacAddrList = input;
}
+ (NSMutableArray *)get_device_mac_addr
{
    return deviceMacAddrList;
}
+ (void)set_device_id:(NSMutableArray *)input
{
    deviceId = input;
}
+ (NSMutableArray *)get_device_id
{
    return deviceId;
}
+ (void)set_device_services:(NSMutableArray *)input
{
    deviceServicesList = input;
}
+ (NSMutableArray *)get_device_services
{
    return deviceServicesList;
}
//push used
+ (void)set_user_id:(NSString *)input
{
    userId = input;
}
+ (NSString *)get_user_id
{
    return userId;
}
+ (void)set_pushUDID:(NSString *)input
{
    pushUDID = input;
}
+ (NSString *)get_pushUDID
{
    return pushUDID;
}
+ (NSString *)getOsVersion
{
    return pushOsVersion;
}
@end
