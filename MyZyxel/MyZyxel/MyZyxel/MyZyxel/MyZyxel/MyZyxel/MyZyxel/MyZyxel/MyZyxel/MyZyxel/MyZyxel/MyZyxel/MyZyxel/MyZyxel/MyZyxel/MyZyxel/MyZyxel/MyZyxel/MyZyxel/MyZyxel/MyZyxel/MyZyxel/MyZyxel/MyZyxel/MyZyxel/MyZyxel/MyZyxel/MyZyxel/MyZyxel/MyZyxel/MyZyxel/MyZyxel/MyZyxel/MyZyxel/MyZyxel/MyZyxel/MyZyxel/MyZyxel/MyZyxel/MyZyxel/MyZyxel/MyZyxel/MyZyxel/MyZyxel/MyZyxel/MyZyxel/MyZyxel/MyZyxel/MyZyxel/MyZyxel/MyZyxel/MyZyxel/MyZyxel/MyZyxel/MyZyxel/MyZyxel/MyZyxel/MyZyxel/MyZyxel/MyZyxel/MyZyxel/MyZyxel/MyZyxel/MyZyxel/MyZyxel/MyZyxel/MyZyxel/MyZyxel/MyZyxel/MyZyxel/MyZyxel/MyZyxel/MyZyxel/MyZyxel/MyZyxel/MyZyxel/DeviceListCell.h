//
//  DeviceListCell.h
//  myZyxel
//
//  Created by 為亮 黃 on 2017/6/16.
//  Copyright © 2017年 Zyxel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeviceListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *withExpireServices;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *macAddr;
@end
