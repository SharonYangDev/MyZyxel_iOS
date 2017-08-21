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
