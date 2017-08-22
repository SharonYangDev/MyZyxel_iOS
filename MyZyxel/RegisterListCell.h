//
//  RegisterListCell.h
//  myZyxel
//
//  Created by 黃為亮 on 08/08/2017.
//  Copyright © 2017 Zyxel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *serviceName;
@property (weak, nonatomic) IBOutlet UILabel *licenseKey;
@property (weak, nonatomic) IBOutlet UILabel *amount;
@property (weak, nonatomic) IBOutlet UILabel *message;
@end
