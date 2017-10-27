//
//  notification.h
//  MyZyxel
//
//  Created by line on 2017/5/16.
//  Copyright © 2017年 Zyxel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "common.h"
#import "public.h"
//#import "openssl/crypto.h"
#import "MessageListCell.h"

@interface notification : UIViewController
@property (weak, nonatomic) IBOutlet UIView* listView;
@property (weak, nonatomic) IBOutlet UIView* contentView;
@property (weak, nonatomic) IBOutlet UIView *errorView;
@property (weak, nonatomic) IBOutlet UITableView *messageList;
@property (weak, nonatomic) IBOutlet UILabel *messageTitle;
@property (weak, nonatomic) IBOutlet UILabel *messageTime;
@property (weak, nonatomic) IBOutlet UILabel *errorLbl;
@property (weak, nonatomic) IBOutlet UIWebView *messageContent;
@property (weak, nonatomic) IBOutlet UIButton *messageDetailBackBtn;
@property (weak, nonatomic) IBOutlet UIButton *tryAgainBtn;
- (IBAction)messageDetailBackBtn:(id)sender;
- (IBAction)tryAgainBtn:(id)sender;
@end
