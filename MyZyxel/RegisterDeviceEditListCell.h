//
//  RegisterDeviceEditListCell.h
//  myZyxel
//
//  Created by 為亮 黃 on 2017/6/28.
//  Copyright © 2017年 Zyxel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterDeviceEditListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UILabel *mac;
@property (weak, nonatomic) IBOutlet UILabel *sn;
@property (weak, nonatomic) IBOutlet UIButton *delBtn;
@end
