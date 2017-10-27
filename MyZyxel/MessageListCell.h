//
//  MessageListCell.h
//  MyZyxel
//
//  Created by 黃為亮 on 02/10/2017.
//  Copyright © 2017 Zyxel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *newly;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *time;

@end
