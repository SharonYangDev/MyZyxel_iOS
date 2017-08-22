//
//  SearchDeviceListCell.h
//  myZyxel
//
//  Created by 黃為亮 on 09/08/2017.
//  Copyright © 2017 Zyxel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchDeviceListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *withExpireServices;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *mac;

@end
