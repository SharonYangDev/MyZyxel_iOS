//
//  DetailServiceCell.h
//  myZyxel
//
//  Created by 為亮 黃 on 2017/6/22.
//  Copyright © 2017年 Zyxel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailServiceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *serviceName;
@property (weak, nonatomic) IBOutlet UILabel *serviceAmount;
@property (weak, nonatomic) IBOutlet UILabel *serviceGracePeriod;
@end
