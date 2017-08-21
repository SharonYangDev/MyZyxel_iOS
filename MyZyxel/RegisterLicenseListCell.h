//
//  RegisterLicenseListCell.h
//  myZyxel
//
//  Created by 為亮 黃 on 2017/7/6.
//  Copyright © 2017年 Zyxel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterLicenseListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *manualServiceName;
@property (weak, nonatomic) IBOutlet UILabel *manualServiceKey;
@property (weak, nonatomic) IBOutlet UILabel *manualServiceAmount;
@property (weak, nonatomic) IBOutlet UIButton *manualDel;
@property (weak, nonatomic) IBOutlet UILabel *scanServiceName;
@property (weak, nonatomic) IBOutlet UILabel *scanServiceKey;
@property (weak, nonatomic) IBOutlet UILabel *scanServiceAmount;
@property (weak, nonatomic) IBOutlet UIButton *scanDel;
@end
