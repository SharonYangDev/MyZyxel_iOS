//
//  DeviceAddLicenseListCell.h
//  myZyxel
//
//  Created by 為亮 黃 on 2017/7/12.
//  Copyright © 2017年 Zyxel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeviceAddLicenseListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *manualLicenseKey;
@property (weak, nonatomic) IBOutlet UILabel *manualServiceName;
@property (weak, nonatomic) IBOutlet UIButton *manualDelBtn;
@property (weak, nonatomic) IBOutlet UILabel *scanLicenseKey;
@property (weak, nonatomic) IBOutlet UILabel *scanServiceName;
@property (weak, nonatomic) IBOutlet UIButton *scanDelBtn;

@end
