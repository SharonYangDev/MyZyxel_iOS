//
//  APInfoTableViewController.m
//  ZYXEL
//
//  Created by san on 2017/6/15.
//  Copyright © 2017年 Nick. All rights reserved.
//

#import "APInfoTableViewController.h"
#import "SettingTableViewCell.h"
#import "UPnPSwitchCell.h"

@implementation APInfoTableViewController
{
    StructDeviceElementDevice *getApData;
    ZyxelWiFiSystem *wifisystem;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self initWithNavigationBar];
    [self initInterface];
    [self initData];
    
}

-(void)viewWillAppear:(BOOL)animated
{
//    [self.navigationController.navigationBar setTranslucent: NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getApData:(StructDeviceElementDevice*)apData
{
    NSLog(@"apData:%@",apData);
    getApData=apData;
}

#pragma mark - initialize  ********************
-(void)initWithNavigationBar {
    
    self.navigationItem.title = NSLocalizedString(@"Multy Information", nil);
    
    UIButton *left_btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [left_btn setImage:[UIImage imageNamed:@"all_btn_a_back"] forState:UIControlStateNormal];
    [left_btn addTarget:self action:@selector(backToPreviewAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left_btn];
}

-(void)initInterface
{
    //去除UITableView中空白Cell之間的橫線
    [self.apInfoTableView setTableFooterView: [[UIView alloc] initWithFrame: CGRectZero]];
    //tableView 全屏分隔線
    [self.apInfoTableView setSeparatorInset: UIEdgeInsetsZero];
    [self.apInfoTableView setLayoutMargins: UIEdgeInsetsZero];
    
    //不捲動
    [self.apInfoTableView setScrollEnabled:NO];
    
    [_apName setText:[getApData getName]];
    [_apStatus setText:NSLocalizedString(@"Connecting", nil)];
}

-(void)initData
{
    wifisystem=[ZyxelWiFiSystem sharedInstance];
    wifisystem.delegate=self;
    
    NSLog(@"LED.State:%d",getApData.led.getSwitch);
}

#pragma mark - NavigationBar Btn Action  ***************
-(void)backToPreviewAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if(section == 1)
        return nil;
    
    UIView *section_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/18)];
    section_view.backgroundColor = COLOR_Normal_BackgroundGray;
    
    ///infoLabel
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, section_view.frame.size.width, section_view.frame.size.height)];
    
    infoLabel.text = NSLocalizedString(@"Information", nil);
    [infoLabel setTextColor: [UIColor colorWithRed:126.0/255.0 green:142.0/255.0 blue:150.0/255.0 alpha:1.0]];
    [section_view addSubview:infoLabel];
    
    return section_view;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 0)
    {
        switch (indexPath.row) {
            case 0:
            {
                [tableView registerNib:[UINib nibWithNibName:@"SettingTableViewCell" bundle: nil] forCellReuseIdentifier:@"settingTableViewCell"];
                SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"settingTableViewCell" forIndexPath: indexPath];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                //tableView 全屏分隔線
                cell.layoutMargins = UIEdgeInsetsZero;

                [cell.settingTableViewCellTitle setTextColor: COLOR_Setting_Gray];
                
                cell.settingTableViewCellTitle.text = NSLocalizedString(@"IP Address", nil);
                
                //假資料
                cell.settingTableViewCellName.text = [getApData getIp];
                
                return cell;
            }
                break;
            case 1:
            {
                [tableView registerNib:[UINib nibWithNibName:@"SettingTableViewCell" bundle: nil] forCellReuseIdentifier:@"settingTableViewCell"];
                SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"settingTableViewCell" forIndexPath: indexPath];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                //tableView 全屏分隔線
                cell.layoutMargins = UIEdgeInsetsZero;
                
                [cell.settingTableViewCellTitle setTextColor: COLOR_Setting_Gray];
                
                cell.settingTableViewCellTitle.text = NSLocalizedString(@"Firmware Version", nil);
                
        
                cell.settingTableViewCellName.text = [getApData getFirmwareVersion];
                cell.settingTableViewCellName.adjustsFontSizeToFitWidth = YES;
                
                return cell;
            }
                break;
            case 2:
            {
                [tableView registerNib:[UINib nibWithNibName:@"SettingTableViewCell" bundle: nil] forCellReuseIdentifier:@"settingTableViewCell"];
                SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"settingTableViewCell" forIndexPath: indexPath];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                //tableView 全屏分隔線
                cell.layoutMargins = UIEdgeInsetsZero;

                [cell.settingTableViewCellTitle setTextColor: COLOR_Setting_Gray];
                
                cell.settingTableViewCellTitle.text = NSLocalizedString(@"ＭAC Address", nil);
                
                //假資料
                cell.settingTableViewCellName.text = [getApData getRepresentMac];
                
                return cell;
            }
                break;
            case 3:
            {
                [tableView registerNib:[UINib nibWithNibName:@"UPnPSwitchCell" bundle: nil] forCellReuseIdentifier:@"uPnPSwitchCell"];
                UPnPSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier: @"uPnPSwitchCell" forIndexPath: indexPath];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                //tableView 全屏分隔線
                cell.layoutMargins = UIEdgeInsetsZero;
                
                [cell.upnpTitle setTextColor: COLOR_Setting_Gray];
                
                cell.upnpTitle.text = NSLocalizedString(@"LED", nil);
                
                [cell.upnpSwitch setOn:!getApData.led.getSwitch];
                
                [cell.upnpSwitch addTarget:self action:@selector(ledSwitchState:) forControlEvents:UIControlEventValueChanged];
                
                return cell;
            }
                break;
                
            default:
            {
                UITableViewCell *cell = [[UITableViewCell alloc] init];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                //tableView 全屏分隔線
                cell.layoutMargins = UIEdgeInsetsZero;
                
                [cell.textLabel setTextColor: COLOR_Setting_Gray];
                cell.textLabel.text = NSLocalizedString(@"Restart", nil);
                [cell setAccessoryType: UITableViewCellAccessoryDisclosureIndicator];
                
                return cell;
            }
                break;
        }
    }
    else
    {
        UIImage *image = [self scaleToSize: [UIImage imageNamed:@"e2_icon_a_delete"] size: CGSizeMake(25, 30)];
        
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //tableView 全屏分隔線
        cell.layoutMargins = UIEdgeInsetsZero;
        
        [cell.imageView setImage: image];
        cell.textLabel.text = NSLocalizedString(@"Remove This Multy", nil);
        [cell.textLabel setTextColor: COLOR_Devicelist_Blue];
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        if(indexPath.row == 4)  //重新啟動
        {
            [self showRestartAlert];
        }
    }
    else    //刪除AP
    {
        BOOL isRouter = YES;
        [self deleteMULTYWithIsRouter: isRouter];
    }
}

#pragma mark - Private Method
//取得AP圖片，根據是否連線
-(UIImage *)getAPImageWithConnection:(BOOL)isConnection
{
    UIImage *image;
    
    if(isConnection)
    {
        image = [UIImage imageNamed:@"g3_logo_a_ap_0"];
    }
    else
    {
        image = [UIImage imageNamed:@"g3_logo_a_ap_1"];
    }
    
    return image;
}

//取得AP的狀態
-(NSString *)getAPStatusWithConnection:(BOOL)isConnection
{
    NSString *status;
    
    if(isConnection)
    {
        status = NSLocalizedString(@"Connecting", nil);
    }
    else
    {
        status = NSLocalizedString(@"Offline", nil);
    }
    
    return status;
}
//壓縮圖片
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    
    // 設置成為當前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 繪製改變大小的圖片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 從當前context中創建一個改變大小後的圖片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 關閉繪圖環境
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

-(void)ledSwitchState:(UISwitch *)switchState
{
    [wifisystem ZapiSetLed:[AppDelegate readNSUserDefaults:XMPP_JID] DeviceID:[getApData getMac] LedState:!switchState.on completion:^(BOOL successful, NSError *error) {
        NSLog(@"ZapiSetLed[%@] successful:%d error:%@",[getApData getMac], successful,error);
    }];
}
//重新啟動AP
-(void)showRestartAlert
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"Are you sure you want to restart this Multy?", nil) preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Confirm", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self restartAP];
    }];
    
    UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:OKAction];
    
    [alert addAction:CancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];

}
-(void)restartAP
{
    
    [wifisystem ZapiRestartDevice:[AppDelegate readNSUserDefaults:XMPP_JID] DeviceID:[getApData getMac] completion:^(BOOL successful, NSError *error) {
         NSLog(@"successful:%d  error:%@",successful,error);
    }];
}

//Remove This MULTY
-(void)deleteMULTYWithIsRouter:(BOOL)isRouter
{
    NSString *title = isRouter ? NSLocalizedString(@"Are you sure you want to remove the first MULTY?", nil) : NSLocalizedString(@"Are you sure you want to remove this MULTY?", nil);
    NSString *message = isRouter ? NSLocalizedString(@"This is the first MULTY.If you remove this MULTY, the whole Wi-Fi system will be removed.", nil) : NSLocalizedString(@"This MULTY will be removed.", nil);

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle: title message: message preferredStyle: UIAlertControllerStyleAlert];
    
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle: NSLocalizedString(@"Delete",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if(isRouter)    //Router
        {
            NSLog(@"刪除Router");
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD startMBProgressHUD];
            });
            [wifisystem ZapiResetWiFiSystem:[AppDelegate readNSUserDefaults:XMPP_JID] completion:^(id obj, NSError *error) {
#warning del database and stroage data
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD stopMBProgressHUD];
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }];
        }
        else
        {
            NSLog(@"刪除AP");
            [wifisystem ZapiUnauthorizeDevice:[AppDelegate readNSUserDefaults:XMPP_JID] DeviceID:[getApData getMac] completion:^(BOOL successful, NSError *error) {
                NSLog(@"successful:%d  error:%@",successful,error);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD stopMBProgressHUD];
                   [self.navigationController popViewControllerAnimated:YES];
                });
            }];
        }
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle: NSLocalizedString(@"Cancel",nil) style:UIAlertActionStyleDefault handler: nil];
    
    [alertController addAction: deleteAction];
    [alertController addAction: cancelAction];
    
    [self presentViewController: alertController animated:YES completion:nil];
}

@end
