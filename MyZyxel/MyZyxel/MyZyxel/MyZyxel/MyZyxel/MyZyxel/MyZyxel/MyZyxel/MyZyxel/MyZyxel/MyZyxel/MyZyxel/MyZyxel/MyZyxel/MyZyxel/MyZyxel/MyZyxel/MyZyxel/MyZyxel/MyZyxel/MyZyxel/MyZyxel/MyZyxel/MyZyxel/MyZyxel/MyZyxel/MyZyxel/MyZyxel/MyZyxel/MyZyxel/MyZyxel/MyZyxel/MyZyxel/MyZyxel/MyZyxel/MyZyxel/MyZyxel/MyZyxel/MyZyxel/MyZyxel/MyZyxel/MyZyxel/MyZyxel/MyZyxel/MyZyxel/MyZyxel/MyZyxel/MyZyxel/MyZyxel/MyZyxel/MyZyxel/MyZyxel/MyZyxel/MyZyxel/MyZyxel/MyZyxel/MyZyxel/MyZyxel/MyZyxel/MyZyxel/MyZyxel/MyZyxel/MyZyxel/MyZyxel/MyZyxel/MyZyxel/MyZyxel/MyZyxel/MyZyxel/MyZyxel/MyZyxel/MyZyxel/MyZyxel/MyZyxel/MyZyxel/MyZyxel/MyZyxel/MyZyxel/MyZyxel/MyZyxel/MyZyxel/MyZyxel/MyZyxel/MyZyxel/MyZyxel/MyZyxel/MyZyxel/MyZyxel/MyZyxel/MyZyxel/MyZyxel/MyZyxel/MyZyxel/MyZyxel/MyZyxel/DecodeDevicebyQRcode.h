//
//  DecodeDevicebyQRcode.h
//  DecodeDevicebyQRcode
//
//  Created by Sharon on 7/18/17.
//  Copyright © 2017 Sharon. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct ST_DeviceInfo{
    __unsafe_unretained NSString* MAC;
    __unsafe_unretained NSString* SN;
}ST_DeviceInfo;

@interface DecodeDevicebyQRcode : NSObject
+ (NSString*) sayHello;
//+ (NSString*) encodeDevice:(NSString*)mac Info:(NSString*)sn;
+ (ST_DeviceInfo) decodeDeviceInfo:(NSString*)qrcode;
//***********************************************************************************************************
//  Function      : decodeDeviceInfo
//
//  Description   : Get a struct ST_DeviceInfo using QR code string
//
//  Declaration   : (ST_DeviceInfo) decodeDeviceInfo:(NSString*)qrcode;
//
//  Parameters    : qrcode
//                    the content of QR code
//
//  Return Value  : ST_DeviceInfo
//                      the struct ST_DeviceInfo including MAC and serial number of device
//***********************************************************************************************************
@end
