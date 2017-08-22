//
//  AddLicenseCell.h
//  myZyxel
//
//  Created by 為亮 黃 on 2017/6/23.
//  Copyright © 2017年 Zyxel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddLicenseCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *serviceName;
@property (weak, nonatomic) IBOutlet UILabel *serviceAmount;
@property (weak, nonatomic) IBOutlet UILabel *count;
@property (weak, nonatomic) IBOutlet UIButton *activate;
@end
