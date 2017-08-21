//
//  SearchDevicesListCell.h
//  myZyxel
//
//  Created by line on 12/06/2017.
//  Copyright © 2017 Zyxel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchDevicesListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *deviceName;
@property (weak, nonatomic) IBOutlet UILabel *macAddress;
@end
