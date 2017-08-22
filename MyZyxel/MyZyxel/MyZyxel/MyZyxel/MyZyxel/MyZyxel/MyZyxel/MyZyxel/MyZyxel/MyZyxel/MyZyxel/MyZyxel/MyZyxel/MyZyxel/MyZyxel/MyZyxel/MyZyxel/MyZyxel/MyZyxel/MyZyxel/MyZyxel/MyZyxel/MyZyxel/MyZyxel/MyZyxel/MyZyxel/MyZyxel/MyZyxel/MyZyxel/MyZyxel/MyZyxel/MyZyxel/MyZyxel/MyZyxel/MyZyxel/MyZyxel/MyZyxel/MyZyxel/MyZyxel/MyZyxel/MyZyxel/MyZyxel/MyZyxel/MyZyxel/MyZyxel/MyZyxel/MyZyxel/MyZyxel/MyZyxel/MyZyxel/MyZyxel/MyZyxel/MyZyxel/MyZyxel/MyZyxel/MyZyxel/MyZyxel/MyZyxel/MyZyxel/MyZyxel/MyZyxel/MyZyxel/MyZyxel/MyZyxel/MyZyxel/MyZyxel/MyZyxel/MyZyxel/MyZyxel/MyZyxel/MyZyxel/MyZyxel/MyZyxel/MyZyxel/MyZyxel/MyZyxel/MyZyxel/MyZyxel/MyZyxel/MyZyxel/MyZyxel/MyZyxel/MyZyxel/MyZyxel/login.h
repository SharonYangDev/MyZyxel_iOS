//
//  login.h
//  MyZyxel
//
//  Created by line on 2017/5/16.
//  Copyright © 2017年 Zyxel. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "common.h"
#import "public.h"

@interface login : UIViewController<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView* loginPage;
@property (weak, nonatomic) IBOutlet UIView *errorView;
@property (weak, nonatomic) IBOutlet UILabel *errorLbl;
@property (weak, nonatomic) IBOutlet UIButton *tryAgainBtn;
- (IBAction)tryAgainBtn:(id)sender;
@end
