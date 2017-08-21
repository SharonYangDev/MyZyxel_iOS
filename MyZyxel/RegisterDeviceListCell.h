//
//  RegisterDeviceListCell.h
//  myZyxel
//
//  Created by 為亮 黃 on 2017/6/28.
//  Copyright © 2017年 Zyxel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterDeviceListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *scanName;
@property (weak, nonatomic) IBOutlet UILabel *scanMac;
@property (weak, nonatomic) IBOutlet UILabel *scanSn;
@property (weak, nonatomic) IBOutlet UIButton *scanBtn;
@property (weak, nonatomic) IBOutlet UILabel *manualName;
@property (weak, nonatomic) IBOutlet UILabel *manualMac;
@property (weak, nonatomic) IBOutlet UILabel *manualSn;
@property (weak, nonatomic) IBOutlet UIButton *manualBtn;
@end
