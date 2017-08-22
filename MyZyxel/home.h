//
//  FirstViewController.h
//  MyZyxel
//
//  Created by line on 2017/5/12.
//  Copyright © 2017年 Zyxel. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "common.h"
#import "public.h"
#import "DevicesExpiredListCell.h"
#import "SearchDevicesListCell.h"
#import "RegisteredLicenseListCell.h"
#import "CompleteServiceCell.h"

@interface home : UIViewController
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIScrollView *displayView;
@property (weak, nonatomic) IBOutlet UIView* maskView;
@property (weak, nonatomic) IBOutlet UIView* homeView;
@property (weak, nonatomic) IBOutlet UIView* profileView;
@property (weak, nonatomic) IBOutlet UIView* searchView;
@property (weak, nonatomic) IBOutlet UIView* errorView;
@property (weak, nonatomic) IBOutlet UIView* renewView;
@property (weak, nonatomic) IBOutlet UIView *scanView;
@property (weak, nonatomic) IBOutlet UIView *mutiView;
@property (weak, nonatomic) IBOutlet UIView *mutiLicenseMaskView;
@property (weak, nonatomic) IBOutlet UIView *mutiLicenseView;
@property (weak, nonatomic) IBOutlet UIView *noWorkView;
@property (weak, nonatomic) IBOutlet UIView *scanF;
@property (weak, nonatomic) IBOutlet UIView *completeView;
@property (weak, nonatomic) IBOutlet UIView *searchNoResView;
@property (weak, nonatomic) IBOutlet UIButton* profileBtn;
@property (weak, nonatomic) IBOutlet UIButton* searchBtn;
@property (weak, nonatomic) IBOutlet UIButton* searchCancelBtn;
@property (weak, nonatomic) IBOutlet UIButton* renewCancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *logout;
@property (weak, nonatomic) IBOutlet UIButton *renewScanCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *scanCancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *renewUseRegisteredLicenseBtn;
@property (weak, nonatomic) IBOutlet UIButton *completeViewOkBtn;
@property (weak, nonatomic) IBOutlet UIButton *renewDoneBtn;
@property (weak, nonatomic) IBOutlet UIButton *scanDoneBtn;
@property (weak, nonatomic) IBOutlet UIButton *mutiViewActivateBtn;
@property (weak, nonatomic) IBOutlet UIButton *mutiViewCancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *tryAgainBtn;
@property (weak, nonatomic) IBOutlet UIButton *helpBtn;
@property (weak, nonatomic) IBOutlet UITextField* searchDevicesText;
@property (weak, nonatomic) IBOutlet UITextField *scanViewEnterLicenseTxt;
@property (weak, nonatomic) IBOutlet UILabel* userAccountLbl;
@property (weak, nonatomic) IBOutlet UILabel* expiredCountLbl;
@property (weak, nonatomic) IBOutlet UILabel* renewServiceName;
@property (weak, nonatomic) IBOutlet UILabel* renewServiceMacAddress;
@property (weak, nonatomic) IBOutlet UILabel *scanDeviceName;
@property (weak, nonatomic) IBOutlet UILabel *scanMacAddress;
@property (weak, nonatomic) IBOutlet UILabel *activageServiceName;
@property (weak, nonatomic) IBOutlet UILabel *activateExpireDate;
@property (weak, nonatomic) IBOutlet UILabel *scanViewMessage;
@property (weak, nonatomic) IBOutlet UILabel *completeDeviceName;
@property (weak, nonatomic) IBOutlet UILabel *completeMacAddress;
@property (weak, nonatomic) IBOutlet UILabel *mutiServiceName;
@property (weak, nonatomic) IBOutlet UILabel *mutiServiceMac;
@property (weak, nonatomic) IBOutlet UILabel *errorLbl;
@property (weak, nonatomic) IBOutlet UITableView* searchDeviceExpiredList;
@property (weak, nonatomic) IBOutlet UITableView *completeLicenseList;
@property (weak, nonatomic) IBOutlet UITableView *renewRegisteredLicenseList;
@property (weak, nonatomic) IBOutlet UIScrollView *mutiScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *scanScrollView;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *maskViewTapGesture;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *profileViewLeftSwipeGesture;
- (IBAction)profileBtn:(id)sender;
- (IBAction)searchBtn:(id)sender;
- (IBAction)searchCancelBtn:(id)sender;
- (IBAction)logout:(id)sender;
- (IBAction)renewCancelBtn:(id)sender;
- (IBAction)scanCancelBtn:(id)sender;
- (IBAction)renewScanCodeBtn:(id)sender;
- (IBAction)renewUseRegisteredLicenseBtn:(id)sender;
- (IBAction)completeViewOKBtn:(id)sender;
- (IBAction)renewDoneBtn:(id)sender;
- (IBAction)scanDoneBtn:(id)sender;
- (IBAction)mutiViewActivateBtn:(id)sender;
- (IBAction)mutiViewCancelBtn:(id)sender;
- (IBAction)tryAgainBtn:(id)sender;
- (IBAction)helpBtn:(id)sender;
@end

