//
//  public.m
//  myZyxel
//
//  Created by line on 2017/6/2.
//  Copyright © 2017年 Zyxel. All rights reserved.
//

#import "public.h"

NSString *code;
NSString *access_key_id;
NSString *secret_access_key;
NSString *access_token;
NSString *refresh_token;
NSString *user_account;
NSString *renewDeviceId;
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
    
    NSMutableString* output = [NSMutableString stringWithCapacity: CC_SHA256_DIGEST_LENGTH];
    
    for(int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++)
    {
        [output appendFormat:@"%02x", digest[i]];
    }
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
    switch (amount) {
        case 30:
            return @"30 days service";
            break;
        case 366:
            return @"1 year service";
            break;
        case 396:
            return @"1 year + 30 day service";
            break;
        case 731:
            return @"2 years service";
            break;
        default:
            if (amount < 365)
            {
                return [NSString stringWithFormat: @"unknow service %ld", (long)amount];
            }
            else
            {
                int getYear = (int)amount/365;
                if (getYear > 2)
                {
                    return [NSString stringWithFormat: @"%d years service", getYear];
                }
                else
                {
                    return @"1 year service";
                }
            }
            break;
    }
}
+ (NSString *)getExpiringTime: (NSInteger)day
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
@end
