//
//  SecondViewController.h
//  MyZyxel
//
//  Created by line on 2017/5/12.
//  Copyright © 2017年 Zyxel. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "common.h"
#import "public.h"
#import "DeviceListCell.h"
#import "DetailServiceCell.h"
#import "AddLicenseCell.h"
#import "RegisterDeviceListCell.h"
#import "RegisterDeviceEditListCell.h"
#import "RegisterDeviceFinalListCell.h"
#import "DeviceAddLicenseListCell.h"
#import "SearchDeviceListCell.h"
#import "ActivateOkListCell.h"

@interface device : UIViewController
@property (weak, nonatomic) IBOutlet UIView *deviceView;
@property (weak, nonatomic) IBOutlet UIView *registerDevicePage1ScanView;
@property (weak, nonatomic) IBOutlet UIView *registerDevicePage1ManualView;
@property (weak, nonatomic) IBOutlet UIView *registerDevicePage2View;
@property (weak, nonatomic) IBOutlet UIView *registerDevicePage3View;
@property (weak, nonatomic) IBOutlet UIView *registerDeviceListView;
@property (weak, nonatomic) IBOutlet UIView *deviceDetailView;
@property (weak, nonatomic) IBOutlet UIView *editView;
@property (weak, nonatomic) IBOutlet UIView *addLicenseView;
@property (weak, nonatomic) IBOutlet UIView *scanF;
@property (weak, nonatomic) IBOutlet UIView *addLicenseScanViewScanF;
@property (weak, nonatomic) IBOutlet UIView *addLicenseManualView;
@property (weak, nonatomic) IBOutlet UIView *addLicenseScanView;
@property (weak, nonatomic) IBOutlet UIView *noDeviceView;
@property (weak, nonatomic) IBOutlet UIView *errorView;
@property (weak, nonatomic) IBOutlet UIView *cancelMask;
@property (weak, nonatomic) IBOutlet UIView *cancalView;
@property (weak, nonatomic) IBOutlet UIView *searchDeviceView;
@property (weak, nonatomic) IBOutlet UIView *searchNoResView;
@property (weak, nonatomic) IBOutlet UIView *activateOkView;
@property (weak, nonatomic) IBOutlet UIView *tutoriaDeviceMTView;
@property (weak, nonatomic) IBOutlet UIView *tutoriaDeviceRTView;
@property (weak, nonatomic) IBOutlet UITableView *devicesList;
@property (weak, nonatomic) IBOutlet UITableView *detailServiceList;
@property (weak, nonatomic) IBOutlet UITableView *addLicenseServiceList;
@property (weak, nonatomic) IBOutlet UITableView *registerDeviceScanList;
@property (weak, nonatomic) IBOutlet UITableView *registerDeviceManualList;
@property (weak, nonatomic) IBOutlet UITableView *registerDeviceEditList;
@property (weak, nonatomic) IBOutlet UITableView *registerDeviceFinalList;
@property (weak, nonatomic) IBOutlet UITableView *addLicenseManualList;
@property (weak, nonatomic) IBOutlet UITableView *addLicenseScanList;
@property (weak, nonatomic) IBOutlet UITableView *searchList;
@property (weak, nonatomic) IBOutlet UITableView *activateOkList;
@property (weak, nonatomic) IBOutlet UIButton *registerDevicePage3RegisterBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerDevicepage1ScanCancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerDevicepage1ManualCancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerDevicePage2CancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerDevicePage3CancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *deviceAddDeviceBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerDevicePage2BackBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerDevicePage3BackBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerDevicePage1ScanNextBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerDevicePage1ManualNextBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerDevicePage2SaveBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerDevicePage3SkipBtn;
@property (weak, nonatomic) IBOutlet UIButton *deviceDetailBackBtn;
@property (weak, nonatomic) IBOutlet UIButton *detailAddLicenseBtn;
@property (weak, nonatomic) IBOutlet UIButton *detailEditBtn;
@property (weak, nonatomic) IBOutlet UIButton *addLicenseCancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *addLicenseDoneBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerDeviceScanBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerDeviceManualBtn;
@property (weak, nonatomic) IBOutlet UIButton *editViewSaveBtn;
@property (weak, nonatomic) IBOutlet UIButton *editViewCancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerDeiveFinalOkBtn;
@property (weak, nonatomic) IBOutlet UIButton *addLicenseScanViewBtn;
@property (weak, nonatomic) IBOutlet UIButton *addlicenseManualViewBtn;
@property (weak, nonatomic) IBOutlet UIButton *addLicenseViewBtn;
@property (weak, nonatomic) IBOutlet UIButton *addLicenseManualViewCancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *addLicenseScanViewCancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *addlicenseManualActivateBtn;
@property (weak, nonatomic) IBOutlet UIButton *addlicenseScanActivateBtn;
@property (weak, nonatomic) IBOutlet UIButton *tryAgainBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelViewContinueBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelViewExitBtn;
@property (weak, nonatomic) IBOutlet UIButton *searchDeviceCancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *deviceSearchBtn;
@property (weak, nonatomic) IBOutlet UIButton *activateOkBtn;
@property (weak, nonatomic) IBOutlet UIButton *deviceMTBtn;
@property (weak, nonatomic) IBOutlet UIButton *deviceRTBtn;
@property (weak, nonatomic) IBOutlet UILabel *detailDeviceName;
@property (weak, nonatomic) IBOutlet UILabel *detailDeviceMacAddr;
@property (weak, nonatomic) IBOutlet UILabel *detailDeviceModel;
@property (weak, nonatomic) IBOutlet UILabel *detailSerialNo;
@property (weak, nonatomic) IBOutlet UILabel *detailDeviceResellerCompany;
@property (weak, nonatomic) IBOutlet UILabel *detailDeviceResellerMail;
@property (weak, nonatomic) IBOutlet UILabel *addlicenseDeviceName;
@property (weak, nonatomic) IBOutlet UILabel *addlicenseMacAddr;
@property (weak, nonatomic) IBOutlet UILabel *addlicenseServiceName;
@property (weak, nonatomic) IBOutlet UILabel *addlicenseServiceExpiredDate;
@property (weak, nonatomic) IBOutlet UILabel *resellerInfoMessage;
@property (weak, nonatomic) IBOutlet UILabel *editViewMacAddr;
@property (weak, nonatomic) IBOutlet UILabel *editViewMail;
@property (weak, nonatomic) IBOutlet UILabel *editViewVatNumber;
@property (weak, nonatomic) IBOutlet UILabel *editViewResellerName;
@property (weak, nonatomic) IBOutlet UILabel *manualErrorMessage;
@property (weak, nonatomic) IBOutlet UILabel *scanErrorMessage;
@property (weak, nonatomic) IBOutlet UILabel *registerDeviceFinalResellerName;
@property (weak, nonatomic) IBOutlet UILabel *registerDeviceFinalRsellerMail;
@property (weak, nonatomic) IBOutlet UILabel *registerDeviceFinalSuccessMessage;
@property (weak, nonatomic) IBOutlet UILabel *editResellerInfoMessage;
@property (weak, nonatomic) IBOutlet UILabel *addlicenseManualMessage;
@property (weak, nonatomic) IBOutlet UILabel *addlicenseScanMessage;
@property (weak, nonatomic) IBOutlet UILabel *addLicenseScanDeviceName;
@property (weak, nonatomic) IBOutlet UILabel *addLicenseScanMac;
@property (weak, nonatomic) IBOutlet UILabel *addLicenseManualDeviceName;
@property (weak, nonatomic) IBOutlet UILabel *addLicenseManualMac;
@property (weak, nonatomic) IBOutlet UILabel *errorLbl;
@property (weak, nonatomic) IBOutlet UILabel *resellerMailTxt;
@property (weak, nonatomic) IBOutlet UILabel *resellerVatTxt;
@property (weak, nonatomic) IBOutlet UITextField *resellerNameTxt;
@property (weak, nonatomic) IBOutlet UITextField *editViewSearchTxt;
@property (weak, nonatomic) IBOutlet UITextField *editViewDevieNameTxt;
@property (weak, nonatomic) IBOutlet UITextField *manualMacAddress;
@property (weak, nonatomic) IBOutlet UITextField *manualSerialNumber;
@property (weak, nonatomic) IBOutlet UITextField *addLicenseManualViewTxt;
@property (weak, nonatomic) IBOutlet UITextField *searchDeviceTxt;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *HiddeKeyboardGesture;
- (IBAction)registerDevicepage1CancelBtn:(id)sender;
- (IBAction)registerDevicepage2CancelBtn:(id)sender;
- (IBAction)registerDevicepage3CancelBtn:(id)sender;
- (IBAction)deviceAddDeviceBtn:(id)sender;
- (IBAction)registerDevicePage2BackBtn:(id)sender;
- (IBAction)registerDevicePage3BackBtn:(id)sender;
- (IBAction)registerDevicePage1NextBtn:(id)sender;
- (IBAction)registerDevicePage2SaveBtn:(id)sender;
- (IBAction)registerDevicePage3SkipBtn:(id)sender;
- (IBAction)deviceDetailBackBtn:(id)sender;
- (IBAction)detailAddLicenseBtn:(id)sender;
- (IBAction)detailEditBtn:(id)sender;
- (IBAction)addLicenseCancelBtn:(id)sender;
- (IBAction)registerDeviceScanBtn:(id)sender;
- (IBAction)registerDeviceManualBtn:(id)sender;
- (IBAction)editViewSaveBtn:(id)sender;
- (IBAction)editViewCancelBtn:(id)sender;
- (IBAction)editViewExitDeviceNameTxt:(id)sender;
- (IBAction)registerDevicePage3RegisterBtn:(id)sender;
- (IBAction)registerDeviceFinaOkBtn:(id)sender;
- (IBAction)addLicenseScanViewBtn:(id)sender;
- (IBAction)addLicenseManualViewBtn:(id)sender;
- (IBAction)addLicenseViewBtn:(id)sender;
- (IBAction)addLicenseManualViewCancelBtn:(id)sender;
- (IBAction)addLicenseScanViewCancelBtn:(id)sender;
- (IBAction)addLicenseDoneBtn:(id)sender;
- (IBAction)addLicenseScanActivateBtn:(id)sender;
- (IBAction)addLicenseManualActivateBtn:(id)sender;
- (IBAction)tryAgainBtn:(id)sender;
- (IBAction)cancelViewContinueView:(id)sender;
- (IBAction)cancelViewExitView:(id)sender;
- (IBAction)searchDeviceCancelBtn:(id)sender;
- (IBAction)deviceSearchBtn:(id)sender;
- (IBAction)activateOkBtn:(id)sender;
- (IBAction)deviceMTBtn:(id)sender;
- (IBAction)deviceRTBtn:(id)sender;
@end

