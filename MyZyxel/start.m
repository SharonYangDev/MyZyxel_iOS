//
//  start.m
//  MyZyxel
//
//  Created by line on 2017/5/17.
//  Copyright © 2017年 Zyxel. All rights reserved.
//

#import "start.h"

@interface start ()
{
    Reachability *reach;
    NetworkStatus netStatus;
}
@end

@implementation start

- (void)viewDidLoad {
    [super viewDidLoad];
    reach = [Reachability reachabilityWithHostName: @"www.apple.com"];
}
- (void)viewWillAppear:(BOOL)animated
{
    [self.errorView setHidden: YES];
    [self selfLayout];
    [super viewWillDisappear: animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    BOOL result = NO;
    if([identifier isEqualToString: @"SignIn"])
    {
        netStatus = [reach currentReachabilityStatus];
        if (netStatus == NotReachable)
        {
            [self.errorView setHidden: NO];
            result = NO;
        }
        else
        {
            result = YES;
        }
    }
    return result;
}
- (void)selfLayout
{
    switch (public.getDeviceType)
    {
        case 1:
            [self.tryAgainBtn setFrame: CGRectMake(124, 360, 73, 30)];
            [self.errorLbl setFrame: CGRectMake(60, 54, 200, 21)];
            break;
        case 2:
            [self.tryAgainBtn setFrame: CGRectMake(144, 424, 87, 33)];
            [self.errorLbl setFrame: CGRectMake(87, 66, 200, 21)];
            break;
        case 3:
            [self.tryAgainBtn setFrame: CGRectMake(160, 468, 93, 35)];
            [self.errorLbl setFrame: CGRectMake(107, 74, 200, 21)];
            break;
        default:
            // other size
            break;
    }
}
- (IBAction)tryAgainBtn:(id)sender
{
    [self.signBtn sendActionsForControlEvents: UIControlEventTouchUpInside];
}
@end
