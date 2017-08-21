//
//  start.h
//  MyZyxel
//
//  Created by line on 2017/5/17.
//  Copyright © 2017年 Zyxel. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "common.h"
#import "public.h"

@interface start : UIViewController
@property (weak, nonatomic) IBOutlet UIView *errorView;
@property (weak, nonatomic) IBOutlet UIButton *tryAgainBtn;
@property (weak, nonatomic) IBOutlet UIButton *signBtn;
@property (weak, nonatomic) IBOutlet UILabel *errorLbl;
- (IBAction)tryAgainBtn:(id)sender;
@end
