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
//    Reachability *reach;
//    NetworkStatus netStatus;
}
@end

@implementation start
#pragma mark - SYSTEM FUNCTION
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self selfLayout];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    if ([public checkNetWorkConn])
    {
        [self.errorView setHidden: YES];
        // check APP version
        if (CHECK_VERSION)
        {
            if ([public checkAppVerFromServerCompare])
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"New Version Notice" message:@"A new version for myZyxel app is available. Update it now!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertView show];
            }
        }
    }
    else
    {
        [self.errorView setHidden: NO];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
#pragma mark - FUNCTION EVENTS
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
        case 4:
            [self.tryAgainBtn setFrame: CGRectMake(144, 516, 87, 40)];
            [self.errorLbl setFrame: CGRectMake(87, 82, 200, 22)];
            break;
        default:
            // other size
            break;
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://itunes.apple.com/us/app/myzyxel/id1256930682?l=zh&ls=1&mt=8"]];
        exit(0);
    }
}
#pragma mark - BUTTON EVENTS
- (IBAction)tryAgainBtn:(id)sender
{
    if ([public checkNetWorkConn])
    {
        [self.signBtn sendActionsForControlEvents: UIControlEventTouchUpInside];
    }
}
@end
