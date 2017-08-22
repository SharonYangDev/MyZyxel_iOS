//
//  DevicesExpiredListCell.h
//  myZyxel
//
//  Created by line on 10/06/2017.
//  Copyright © 2017 Zyxel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DevicesExpiredListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *page1ServiceName;
@property (weak, nonatomic) IBOutlet UILabel *page1ServiceRemainAmount;
@property (weak, nonatomic) IBOutlet UILabel *page2ServiceName;
@property (weak, nonatomic) IBOutlet UILabel *page2ServiceRemainAmount;
@property (weak, nonatomic) IBOutlet UILabel *page3ServiceName;
@property (weak, nonatomic) IBOutlet UILabel *page3ServiceRemainAmount;
@property (weak, nonatomic) IBOutlet UILabel *page4ServiceName;
@property (weak, nonatomic) IBOutlet UILabel *page4ServiceRemainAmount;
@end
