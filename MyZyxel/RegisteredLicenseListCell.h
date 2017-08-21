//
//  RegisteredLicenseListCell.h
//  myZyxel
//
//  Created by 為亮 黃 on 2017/6/15.
//  Copyright © 2017年 Zyxel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisteredLicenseListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel* count;
@property (weak, nonatomic) IBOutlet UIButton *activate;
@property (weak, nonatomic) IBOutlet UILabel* serviceName;
@property (weak, nonatomic) IBOutlet UILabel* serviceAmount;
@property (weak, nonatomic) IBOutlet UIImageView *link;
@property (weak, nonatomic) IBOutlet UILabel *message;
@end
