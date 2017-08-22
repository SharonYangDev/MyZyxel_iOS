//
//  LicenseRegisteredServicesCell.h
//  myZyxel
//
//  Created by 為亮 黃 on 2017/7/1.
//  Copyright © 2017年 Zyxel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LicenseRegisteredServicesCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *count;
@property (weak, nonatomic) IBOutlet UILabel *amount;
@property (weak, nonatomic) IBOutlet UIButton *activate;
@property (weak, nonatomic) IBOutlet UILabel *message;

@end
