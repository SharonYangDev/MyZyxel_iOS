//
//  NewDeviceInstallViewController.m
//  ZYXEL
//
//  Created by 曾偉亮 on 2017/4/13.
//  Copyright © 2017年 Nick. All rights reserved.
//

#import "NewDeviceInstallViewController.h"
#import "DetectionBarCalculate.h"
#import "ZyxelSSO.h"
#import "ZyxelWiFiSystem+Zapi.h"
#import "FirmwareUpdateViewController.h"
#import "BLEConnectViewController.h"

typedef NS_ENUM(NSUInteger, SiteSurveyFlowType)
{
    SiteSurveyFlowType_StartEchoServer  = 0,
    SiteSurveyFlowType_GetRouterIp,
    SiteSurveyFlowType_GetNetworkDeviceInfo
};


@interface NewDeviceInstallViewController () <ZyxelWiFiSystemDelegate,ZyxelSSODelegate>
@property (strong, nonatomic) ZyxelSSO *sso;
@property (strong, nonatomic) IBOutlet UILabel *signal_status_label;

@property (strong, nonatomic) IBOutlet UILabel *description_label;

@property (strong, nonatomic) IBOutlet UIButton *start_long_btn;

@property (strong, nonatomic) IBOutlet UIButton *start_btn;

@property (strong, nonatomic) IBOutlet UIButton *reset_btn;

@property (strong, nonatomic) NSString *routerIP;
@property (strong, nonatomic) NSString *mobileMAC;
@property (nonatomic) SiteSurveyFlowType *currentFlow;
@property (strong, nonatomic) IBOutlet UILabel *tooClose_label;
@property (strong, nonatomic) IBOutlet UILabel *tooFar_label;
@property (strong, nonatomic) IBOutlet UIImageView *neddle;
@property (strong, nonatomic) IBOutlet UIImageView *statusBar;

@end


typedef enum {
    
    Signal_Excellent,
    Signal_Normal,
    Signal_Bad
    
}SignalStatus;



@implementation NewDeviceInstallViewController {
    
    ZyxelWiFiSystem *_wifiSystem;
    NSString *softwareVersion;
    NSString *serverFirmwareVersion;
    NSTimer *siteSurvey_timer;
    
    MBProgressHUD *hud;
    
    int timerCount;
    
    int XmppErrorCount;
}

#pragma mark - Normal Function  **********
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initWithNavigationBar];
    
    [self initWithUIObjects];
    

}


-(void)viewWillAppear:(BOOL)animated {
    
    self.start_long_btn.hidden = YES;
    
    self.start_btn.hidden = NO;
    
    self.reset_btn.hidden = NO;
    
    timerCount = 0;

    if(_wifiSystem.connected) {
        
        [self sendSiteSurveyRequestWithTimer];
    }
    else{
        
        [_wifiSystem ZapiConnectToXMPPServerWithAccessToken:[AppDelegate readNSUserDefaults:TheAccessToken]];
    }
    
}



-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
}


-(void)viewWillDisappear:(BOOL)animated {
    

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - initialize  ***************
-(void)initWithNavigationBar {
    
    UIView *theTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.navigationController.navigationBar.frame.size.width*0.75, self.navigationController.navigationBar.frame.size.height)];
    theTitleView.backgroundColor = [UIColor clearColor];
    
    //titleLabel
//    UILabel *navtitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, theTitleView.frame.size.width, theTitleView.frame.size.height)];
//    navtitleLabel.font = [UIFont boldSystemFontOfSize:20];
//    navtitleLabel.text = NSLocalizedString(@"Signal Status Connected to the First Multy", nil);
//    navtitleLabel.adjustsFontSizeToFitWidth = YES;
//    navtitleLabel.textAlignment = NSTextAlignmentCenter;
//    [theTitleView addSubview:navtitleLabel];
//    self.navigationItem.titleView = theTitleView;
    self.navigationItem.title = NSLocalizedString(@"Signal Status Connected to the First Multy", nil);
}


-(void)initWithUIObjects {
    
    //_wifiSystem init
    _wifiSystem = [ZyxelWiFiSystem sharedInstance];
    _wifiSystem.delegate = self;
    
    self.description_label.textColor = COLOR_Normal_Gray;
    
    self.start_long_btn.layer.cornerRadius = 3.0;
    [self.start_long_btn setTitle:NSLocalizedString(@"Start",nil) forState:UIControlStateNormal];
    
    self.start_btn.layer.cornerRadius = 3.0;
    [self.start_btn setTitle:NSLocalizedString(@"Start",nil) forState:UIControlStateNormal];
    
    self.reset_btn.layer.cornerRadius = 3.0;
    [self.reset_btn setTitle:NSLocalizedString(@"Change the\nLocation of Multy",nil) forState:UIControlStateNormal];
    self.reset_btn.titleLabel.numberOfLines = 0;
    self.reset_btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.reset_btn addTarget:self action:@selector(gotoNameDeviceViewController) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.start_btn addTarget:self action:@selector(checkDeviceAndSeverFirmwareVersion) forControlEvents:UIControlEventTouchUpInside];
    [self.start_long_btn addTarget:self action:@selector(checkDeviceAndSeverFirmwareVersion) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.tooClose_label.text = NSLocalizedString(@"Too Close", nil);
    self.tooFar_label.text = NSLocalizedString(@"Too Far", nil);
    
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud setMode:MBProgressHUDModeIndeterminate];
    
    XmppErrorCount = 3;
}


#pragma mark  - 根據不同訊號狀態改變UI顯示  *************
-(void)checkSignalStatus:(DetectionStatus)status {
    
    [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        
           self.neddle.center = [DetectionBarCalculate refreshDetectionResult:self.statusBar.frame needleCenterPoint:CGPointMake(CGRectGetMidX(self.neddle.frame), CGRectGetMidY(self.neddle.frame)) status:status];
        
    } completion:nil];
    
    switch (status) {
            
        case DetectionStatus_Good:
            self.signal_status_label.text = NSLocalizedString(@"Good Signal Strength", nil);
            self.signal_status_label.textColor = [UIColor greenColor];
            self.description_label.text = NSLocalizedString(@"Enjoy a fast wireless network!", nil);
            [self showOrHiddenBtn:status];
            break;
        case DetectionStatus_Close_Normal:
        case DetectionStatus_Far_Normal:
            self.signal_status_label.text = NSLocalizedString(@"Fair Signal Strength", nil);
            self.signal_status_label.textColor = [UIColor orangeColor];
            self.description_label.text = NSLocalizedString(@"For better network quality,\nplease find a new location for Multy.", nil);
            [self showOrHiddenBtn:status];
            break;
        case DetectionStatus_Far_Bad:
        case DetectionStatus_Close_Bad:
            self.signal_status_label.text = NSLocalizedString(@"Poor Signal Strength", nil);
            self.signal_status_label.textColor = COLOR_Normal_Red;
            self.description_label.text = NSLocalizedString(@"For better network quality,\nplease find a new location for Multy.", nil);
            [self showOrHiddenBtn:status];
            break;
        default:
            break;
    
    }
    
    
}


-(void)showOrHiddenBtn:(DetectionStatus)status {
    
    if (status == DetectionStatus_Good) {
       
        self.start_long_btn.hidden = NO;
        self.start_btn.hidden = YES;
        self.reset_btn.hidden = YES;
    }
    else {
        
        self.start_long_btn.hidden = YES;
        self.start_btn.hidden = NO;
        self.reset_btn.hidden = NO;
    }
    
}



#pragma mark - btn Action 
-(void)gotoMainViewController {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"EnterMainMenu" bundle:nil];
    
    UIViewController *mainTabBarVC = [storyboard instantiateViewControllerWithIdentifier:@"root"];
    
    [self presentViewController:mainTabBarVC animated:YES completion:nil];

}


-(void)gotoBLEConnectViewController {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *nav = [storyboard instantiateViewControllerWithIdentifier:@"NameDeviceNavc"];
    BLEConnectViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"BLEConnectVC"];
    vc.isSearchingDeviece = YES;
    [nav setViewControllers:@[vc]];
    [self presentViewController:nav animated:YES completion:nil];

}

-(void)gotoNameDeviceViewController {
    
    [hud setHidden:YES];
    [siteSurvey_timer invalidate];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"NameDeviceVC"];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - XMPPP SiteSurvey  *******************
-(void)wifiSystem:(ZyxelWiFiSystem *)wifiSystem didChangeConnectionStatus:(ZyxelWiFiSystem_conn_status)status {
    
    if(status == ZyxelWiFiSystem_conn_status_connectted){
        _wifiSystem.connected = YES;
        [self sendSiteSurveyRequestWithTimer];
    }
    else{
        _wifiSystem.connected = NO;
        [_wifiSystem ZapiConnectToXMPPServerWithAccessToken:[AppDelegate readNSUserDefaults:TheAccessToken]];
    }
}


-(void)sendSiteSurveyRequestWithTimer {
    
    siteSurvey_timer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(sendSiteSurveyRequest) userInfo:nil repeats:YES];
}


-(void)sendSiteSurveyRequest {
    //先看StructSystemDevicesState.device.getRole()為Gateway再找
    //StructSystemDevicesState.device.neighborList.getRssi()
    
    if(timerCount >= 30){
        [hud setHidden:YES];
        timerCount = 0;
        [siteSurvey_timer invalidate];
        //[AppDelegate showAlert:@"Dection Error" message:@"" superVC:self];
        [self checkSignalStatus:DetectionStatus_Far_Bad];
        return;
    }
    
    timerCount += 1;
    
    [_wifiSystem ZapiSendDection:[AppDelegate readNSUserDefaults:XMPP_JID] completion:^(StructSystemDevicesState *obj, NSError *error) {
        
        if(error) {
            [hud setHidden:YES];
            NSLog(@"ZapiSendDection Error:%@",[error description]);
            return ;
        }
        
        if(obj.device.count>0){
            
            NSLog(@"obj.device:%@",obj.device);
            
            for (StructDeviceElementDevice *m_device in obj.device){
                
                NSLog(@"Extender_Device_MAC:%@",[AppDelegate readNSUserDefaults:Extender_Device_MAC]);
                NSLog(@"m_device getRole:%lu",(unsigned long)[m_device getRole]);
                NSLog(@"m_device getMac: %@",[m_device getMac]);
                
                if([m_device getRole] == EnumOperationMode_EXTENDER && [[m_device getMac] isEqualToString:[AppDelegate readNSUserDefaults:Extender_Device_MAC]]) {
                    
                    for (StructNeighborListElement *list in m_device.neighborList) {
                        
                        if ([[list getMyStaMac] isEqualToString:[AppDelegate readNSUserDefaults:Router_Device_MAC]] || [[list getPeerAlMac] isEqualToString:[AppDelegate readNSUserDefaults:Router_Device_MAC]]) {
                            
                            NSLog(@"list getMyStaMac: %@",[list getMyStaMac]);
                            NSLog(@"list getPeerAlMac: %@",[list getPeerAlMac]);
                            
                            NSInteger theRSSI = [list getRssi];
                            
                            NSLog(@"theRSSI:%ld",(long)theRSSI);
                            
                            [siteSurvey_timer invalidate];
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                [self checkSignalStatus:[self tranformRSSIToStatus:(int)theRSSI]];
                                
                                [hud setHidden:YES];
                            
                            });
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
    }];
    
}


-(DetectionStatus)tranformRSSIToStatus:(int)rssi {
    
    if (rssi > 30) {
        
        return DetectionStatus_Close_Bad;
    }
    else if (rssi > 25) {
        
        return DetectionStatus_Close_Normal;
    }
    else if (rssi >= 15 && rssi <= 25) {
        
        return DetectionStatus_Good;
    }
    else if (rssi < 15 && rssi >= 10) {
        
        return DetectionStatus_Far_Normal;
    }
    else {
        
        return DetectionStatus_Far_Bad;
    }
    
}


#pragma mark - Firmware Upgrade  ************
///checkDeviceAndSeverFirmwareVersion
-(void)checkDeviceAndSeverFirmwareVersion {
    [hud setHidden:YES];
    [siteSurvey_timer invalidate];
    [self loginOrSkip];
//    [self checkDeviceFirmwareVersion];
}

///判斷是否登入
-(void)loginOrSkip {
    
    if (![[AppDelegate readNSUserDefaults:LoginOrNot] isEqualToString:@"YES"]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"You are not logged in yet", nil) message:NSLocalizedString(@"Do you want to log in?", nil) preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *logInAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Login", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _sso = [[ZyxelSSO alloc] init];
            _sso.isInSSOVC = NO;
            _sso.delegate = self;
            [_sso loginAction:self];
        }];
        
        UIAlertAction *skipAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Skip", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self checkDeviceFirmwareVersion];
        }];
        
        [alert addAction:logInAction];
        [alert addAction:skipAction];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        [self checkDeviceFirmwareVersion];
    }
}

#pragma mark - ZyxelSSO delegate
-(void)ZyxelSSODidLoginRedirectToApp{

}
-(void)ZyxelSSODidAuthorizedSucessufllWithAccessToken:(NSString *)accessToken andRefreshToken:(NSString *)refreshToken{
    [MBProgressHUD startMBProgressHUD];
    [ZyxelProtal protalSignWithAccessToken:accessToken withCompletion:^(NSMutableArray *ary, NSString *serverIP, NSString *account, NSString *password, NSString *authenticationToken, NSString *cloudID, NSError *error) {
        [AppDelegate pairMulty:accessToken withAuthenToken:authenticationToken andCloudID:cloudID completion:^{
            [MBProgressHUD stopMBProgressHUD];
            [self checkDeviceFirmwareVersion];
        }];
        [AppDelegate uploadLocalInfoToCloud];
    }];
}
-(void)ZyxelSSODidAuthorizedFail{
}


///判斷 FirmwareVersion 是否需要更新
-(void)checkFirmwareVersion {
    
    if (softwareVersion != nil && serverFirmwareVersion != nil) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ([softwareVersion isEqualToString:serverFirmwareVersion]) {
                
                [self gotoMainViewController];
            }
            else {
                //更新
                
                FirmwareUpdateViewController *firmwareUpdateVC = [[FirmwareUpdateViewController alloc] init];
                
                [self.navigationController pushViewController:firmwareUpdateVC animated:YES];
            }
            
        });
        
    }
    else {
        
        [self gotoMainViewController];
    }
}


///檢查 Router FirmwareVersion
-(void)checkDeviceFirmwareVersion {
    
    __block MBProgressHUD *hud;
    dispatch_async(dispatch_get_main_queue(), ^{
        [siteSurvey_timer invalidate];
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [hud setMode:MBProgressHUDModeIndeterminate];
    });

    [_wifiSystem ZapiCheckDeviceFirmwareVersion:[AppDelegate readNSUserDefaults:XMPP_JID] completion:^(StructSystemState *obj, NSError *error) {
        
        [hud setHidden:YES];
        
        if (error) {
            
            NSLog(@"CheckDeviceFirmwareVersion error:%@",[error description]);
            
            if(XmppErrorCount != 0){
                XmppErrorCount --;
                [self checkDeviceFirmwareVersion];
                return ;
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    XmppErrorCount = 3;
                    [self gotoMainViewController];
                    //[self showFTPServerErrorAlert:NSLocalizedString(@"Can't Connect to FTP Server", nil) meaasge:@""];
                });
                
                return ;
            }
            
        }
        
        XmppErrorCount = 3;
        
        softwareVersion = [obj.platform getSoftwareVersion];
        
        NSLog(@"softwareVersion:%@",softwareVersion);
        
        [self checkSeverFirmwareVersion];
        
    }];
    
}

///檢查 Sever FirmwareVersion
-(void)checkSeverFirmwareVersion {
    
    __block MBProgressHUD *hud;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [hud setMode:MBProgressHUDModeIndeterminate];
    });
    
    [_wifiSystem ZapiCheckServerFirmwareVersion:[AppDelegate readNSUserDefaults:XMPP_JID] completion:^(StructOnLineCheck *obj, NSError *error) {
        
        [hud setHidden:YES];
        
        if (error) {
            NSLog(@"CheckServerFirmwareVersion error:%@",[error description]);
            if(XmppErrorCount!=0){
                XmppErrorCount --;
                
                [self checkSeverFirmwareVersion];
                return ;
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    XmppErrorCount = 3;
                    [self gotoMainViewController];
                    // [self showFTPServerErrorAlert:NSLocalizedString(@"Can't Connect to FTP Server", nil) meaasge:@""];
                });
                
                return ;
            }

        }
        
        XmppErrorCount = 3;
        
        serverFirmwareVersion = [obj.output getVersion];
        
        NSLog(@"ServerFirmwareVersion:%@",serverFirmwareVersion);
        
        [self checkFirmwareVersion];
        
    }];
}


-(void)showFTPServerErrorAlert:(NSString *)title meaasge:(NSString *)message {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *skipAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Skip", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self gotoMainViewController];
        
    }];
    
    UIAlertAction *tryAgainAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Try again", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self checkDeviceAndSeverFirmwareVersion];
    }];
    
    
    [alert addAction:skipAction];
    
    [alert addAction:tryAgainAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}




@end
