//
//  license.h
//  MyZyxel
//
//  Created by line on 2017/5/16.
//  Copyright © 2017年 Zyxel. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "common.h"
#import "public.h"
#import "LicenseListCell.h"
#import "LicenseRegisteredServicesCell.h"
#import "ToDeviceListCell.h"
#import "RegisterLicenseListCell.h"
#import "ShowRegisteredLicenseCell.h"

@interface license : UIViewController
@property (weak, nonatomic) IBOutlet UIView *licenseView;
@property (weak, nonatomic) IBOutlet UIView *scanView;
@property (weak, nonatomic) IBOutlet UIView *manualView;
@property (strong, nonatomic) IBOutlet UIView *licenseDetailView;
@property (weak, nonatomic) IBOutlet UIView *toDeviceView;
@property (weak, nonatomic) IBOutlet UIView *scanF;
@property (weak, nonatomic) IBOutlet UIView *showView;
@property (weak, nonatomic) IBOutlet UIView *noLicenseView;
@property (weak, nonatomic) IBOutlet UIView *errorView;
@property (weak, nonatomic) IBOutlet UITableView *licenseList;
@property (weak, nonatomic) IBOutlet UITableView *scanLicenseList;
@property (weak, nonatomic) IBOutlet UITableView *manualLicenseList;
@property (weak, nonatomic) IBOutlet UITableView *licenseRegisteredServicesList;
@property (weak, nonatomic) IBOutlet UITableView *toDeviceList;
@property (weak, nonatomic) IBOutlet UITableView *showRegisteredServicesList;
@property (weak, nonatomic) IBOutlet UIButton *registerNewLicensesBtn;
@property (weak, nonatomic) IBOutlet UIButton *scanViewBtn;
@property (weak, nonatomic) IBOutlet UIButton *scanViewCancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *manualViewBtn;
@property (weak, nonatomic) IBOutlet UIButton *manualViewCancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *licenseDetailCancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *toDeviceCancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *toDeviceConfirmBtn;
@property (weak, nonatomic) IBOutlet UIButton *showDoneBtn;
@property (weak, nonatomic) IBOutlet UIButton *scanRegisterBtn;
@property (weak, nonatomic) IBOutlet UIButton *manualRegisterBtn;
@property (weak, nonatomic) IBOutlet UIButton *tryAgainBtn;
@property (weak, nonatomic) IBOutlet UITextField *manualLicenseKeyTxt;
@property (weak, nonatomic) IBOutlet UILabel *manualViewErrorMessage;
@property (weak, nonatomic) IBOutlet UILabel *scanViewErrorMessage;
@property (weak, nonatomic) IBOutlet UILabel *licenseDetailModuleCodeName;
@property (weak, nonatomic) IBOutlet UILabel *toDeviceCount;
@property (weak, nonatomic) IBOutlet UISlider *activateCountSlider;
@property (weak, nonatomic) IBOutlet UILabel *activateCount;
@property (weak, nonatomic) IBOutlet UILabel *toDeviceName;
@property (weak, nonatomic) IBOutlet UILabel *toDeviceAmount;
@property (weak, nonatomic) IBOutlet UILabel *showModuleCodeName;
@property (weak, nonatomic) IBOutlet UILabel *toDeviceMessage;
@property (weak, nonatomic) IBOutlet UILabel *errorLbl;
- (IBAction)registerNewLicensesBtn:(id)sender;
- (IBAction)scanViewBtn:(id)sender;
- (IBAction)manualViewBtn:(id)sender;
- (IBAction)manualViewCancelBtn:(id)sender;
- (IBAction)scanViewCancelBtn:(id)sender;
- (IBAction)licenseDetailCancelBtn:(id)sender;
- (IBAction)toDeviceCancelBtn:(id)sender;
- (IBAction)activateCountSliderChange:(id)sender;
- (IBAction)activateCountSliderEnd:(id)sender;
- (IBAction)toDeviceConfirmBtn:(id)sender;
- (IBAction)showDoneBtn:(id)sender;
- (IBAction)scanRegisterBtn:(id)sender;
- (IBAction)manualRegisterBtn:(id)sender;
- (IBAction)tryAgainBtn:(id)sender;
@end
