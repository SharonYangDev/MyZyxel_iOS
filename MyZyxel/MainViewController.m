//
//  MainViewController.m
//  ZYXEL
//
//  Created by 曾偉亮 on 2017/3/23.
//  Copyright © 2017年 Nick. All rights reserved.
//

#import "MainViewController.h"
#import "WaveAnimation.h"
#import "APDeviceView.h"
#import "UIViewController+ECSlidingViewController.h"
#import "ZyxelWiFiSystem+Zapi.h"
#import "ZyxelProtal.h"
#import "ViewController.h"


@interface MainViewController ()  <UITableViewDelegate,UITableViewDataSource,ZyxelWiFiSystemDelegate,CheckingNetWorkDelegate>

@property (strong, nonatomic) IBOutlet UILabel *wifiSystemName_label; ///顯示 wifi System 名稱

@property (strong, nonatomic) IBOutlet UILabel *connect_label; ///顯示是否連線中

@property (strong, nonatomic) IBOutlet UIButton *changeWiFi_btn; ///選擇不同 wifi system 的按鍵

@property (strong, nonatomic) IBOutlet UILabel *connectingDeviceTitle_label;///顯示幾台裝置連接

@property (strong, nonatomic) IBOutlet UILabel *downloadTitle_label;  ///下載速度標題

@property (strong, nonatomic) IBOutlet UILabel *download_speed_label;  ///顯示下載速度

@property (strong, nonatomic) IBOutlet UILabel *uploadTitle_label;  ///上傳速度標題

@property (strong, nonatomic) IBOutlet UILabel *upload_speed_label;  ///上傳速度

@property (strong, nonatomic) IBOutlet UIView *baseView;

@property (strong, nonatomic) IBOutlet UIImageView *mainPic;///主頁圖片

@property (strong, nonatomic) IBOutlet UITableView *mainVC_tableView;

@property (strong, nonatomic) IBOutlet UIView *waveAnimationView; ///波浪

@property (strong, nonatomic) IBOutlet UIScrollView *mainVC_scrollView;

@property (strong, nonatomic) IBOutlet UIPageControl *mainVC_pageControl;

@property (strong, nonatomic) IBOutlet UIView *NoWiFiSystemView; ///無WiFiSystem時顯示

@property (strong, nonatomic) IBOutlet UILabel *NoWiFiSystem_label; ///無WiFiSystem時顯示

@property (strong, nonatomic) IBOutlet UIButton *addWiFiSystem_btn; ///增加 WiFiSystem 的按鈕

@property (strong, atomic) NSString *contactJID; //聯絡中的jid;

@end


#pragma mark - type define  ********************
typedef enum {
    
    download_speed,
    upload_speed,
    
}DownloadOrUploadSpeed;


typedef enum {
    
    Status_Connecting,
    Status_breaking
    
}WiFiSystemConnectStatus;




@implementation MainViewController {
    
    //ScrollView，每分頁的Device數
    NSMutableArray *scrollViewPage;
    NSMutableArray <MultyRouter *> *multyAry;
    NSMutableArray *ary_page;
    
    //check network
    CheckingNetWork *checkingNetWork;
    
    NSTimer *update_timer;
    
    ZyxelWiFiSystem *_wifiSystem;
    
    AppDelegate *m_delegate;
    
    //無網路頁面
    UIView *noNetWorkView;
    
    //DataBase
    MULTYDataBase *multyDataBase;
    
    int connectDeviceCount;
    
}

#pragma mark - Normal Function  ********************
- (void)viewDidLoad {
    [super viewDidLoad];
    self.slidingViewController.topViewAnchoredGesture = ECSlidingViewControllerAnchoredGestureTapping | ECSlidingViewControllerAnchoredGesturePanning;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSLog(@"進入主畫面");
    
    [self addApplicationDidBecomeActiveObserver];
    
    [self initWithParamter];
    
    [self initWithNavigationBar];
    
    [self initWithUIObjects];
    
    
    self.mainVC_pageControl.hidden = YES;
    
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (![CheckNetwork isExistenceNetwork]) {
        
        //無網路
        [self stopMBProgressHUD];
        noNetWorkView.hidden = NO;
        [self.view bringSubviewToFront:noNetWorkView];
        return;
    }
    else {
        
        noNetWorkView.hidden = YES;
        [self removeApplicationDidBecomeActiveObserver];
        [self addApplicationDidBecomeActiveObserver];
        
        [self initWithcheckNetWork];
        
        self.mainVC_tableView.hidden = YES;
        
        if(_wifiSystem == nil){
            _wifiSystem = [ZyxelWiFiSystem sharedInstance];
            _wifiSystem.delegate = self;
        }
        
        [self checkConnectionToXMPPServer];
        
    }
    [self changeBackgroundPicAndSystemName];
}


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self getWiFiSystemList];
    
    CGRect viewFinalFrame = CGRectOffset(self.baseView.frame, 0, 0);
    CGRect waveAnimationFinalFrame = CGRectOffset(self.waveAnimationView.frame, 0, 0);
    self.baseView.frame = viewFinalFrame;
    self.waveAnimationView.frame = waveAnimationFinalFrame;
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [update_timer invalidate];
    update_timer = nil;
    
    [self stopMBProgressHUD];
    //[hud removeFromSuperview];
    
    if (checkingNetWork != nil) {
     
        [checkingNetWork removeNetWorkListen:self];
    }
    
    [self removeApplicationDidBecomeActiveObserver];
    
    
    if(_wifiSystem != nil){
        _wifiSystem.delegate = nil;
    }
    if (self.mainVC_tableView.hidden==NO) {
        [self replyAnimate];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



#pragma mark - initialize  *************************
-(void)initWithParamter {
    
    //scrollViewPage
    scrollViewPage = [NSMutableArray array];
    
    ary_page = [NSMutableArray array];
    
    
    //SCrollView reload
//    [self reloadScrollViewWithIndex: 0];
    
}

-(void)initWithNavigationBar {
    
    ///navigationBar title 設定
//    UILabel *navigationBar_title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.navigationController.navigationBar.frame.size.width/3, self.navigationController.navigationBar.frame.size.height)];
//    navigationBar_title.text = NSLocalizedString(@"My Wi-Fi System", nil);
//    navigationBar_title.textAlignment = NSTextAlignmentCenter;
//    self.navigationItem.titleView = navigationBar_title;
    self.navigationItem.title = NSLocalizedString(@"My Wi-Fi System", nil);
    
    ///leftBarButton
    UIButton *leftBarBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,30,30)];
    [leftBarBtn setImage:[UIImage imageNamed:@"e1_btn_a_menu_0"] forState:UIControlStateNormal];
    [leftBarBtn setImage:[UIImage imageNamed:@"e1_btn_a_menu_1"] forState:UIControlStateHighlighted];
    [leftBarBtn addTarget:self action:@selector(showMenuAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarBtn];
    
    
    ///rightBarButton
    UIButton *rightBarButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,30,30)];
    [rightBarButton setImage:[UIImage imageNamed:@"e1_btn_a_info_0"] forState:UIControlStateNormal];
    [rightBarButton setImage:[UIImage imageNamed:@"e1_btn_a_info_1"] forState:UIControlStateHighlighted];
    [rightBarButton addTarget:self action:@selector(showInfoAciton) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButton];

}


-(void)initWithUIObjects {
    
    //DataBase init
    multyDataBase = [[MULTYDataBase alloc] init];
    
    m_delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    _wifiSystem = [ZyxelWiFiSystem sharedInstance];
    _wifiSystem.delegate = self;
    
    self.connect_label.text = NSLocalizedString(@"Connecting", nil);
    self.connect_label.adjustsFontSizeToFitWidth = YES;
    self.connect_label.textAlignment = NSTextAlignmentCenter;
    
    connectDeviceCount = 0;
    self.connectingDeviceTitle_label.text = [self returnConnectDeviceCount:connectDeviceCount];
    self.connectingDeviceTitle_label.textAlignment = NSTextAlignmentCenter;
    
    self.downloadTitle_label.text = NSLocalizedString(@"Download Speed", nil);
    [self.downloadTitle_label sizeToFit];
    
    self.uploadTitle_label.text = NSLocalizedString(@"Upload Speed", nil);
    [self.uploadTitle_label sizeToFit];
    
    
    self.download_speed_label.text = @"0";
    
    self.upload_speed_label.text = @"0";
    
   // self.download_speed_label.textAlignment = NSTextAlignmentCenter;
    
   // self.upload_speed_label.textAlignment = NSTextAlignmentCenter;
    
    //wave animation
    WaveAnimation *viewtest = [[WaveAnimation alloc] initWithFrame:self.waveAnimationView.frame WaterColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.4]];
    [self.waveAnimationView addSubview:viewtest];
    
    
    //self.NoWiFiSystem_label
    self.NoWiFiSystem_label.text = NSLocalizedString(@"No Multys installed.\nTap the button below to begin the installation.", nil);
    self.NoWiFiSystem_label.textColor = COLOR_Normal_Gray;
    
    
    //self.addWiFiSystem_btn
    [self.addWiFiSystem_btn addTarget:self action:@selector(gotoNameDeviceViewController) forControlEvents:UIControlEventTouchUpInside];
    
    //轉圈圈動畫
    [self startMBProgressHUD];
    
    
    //無網路畫面
    noNetWorkView = [[UIView alloc] initWithFrame:self.view.frame];
    noNetWorkView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:noNetWorkView];
    noNetWorkView.hidden = YES;
    
    self.wifiSystemName_label.adjustsFontSizeToFitWidth = YES;
    
}


-(void)initWithcheckNetWork {
    
    if(checkingNetWork != nil){
        [checkingNetWork removeNetWorkListen:self];
        checkingNetWork = nil;
    }
    
    checkingNetWork = [[CheckingNetWork alloc] initWithCheckingNetWork:self frame:self.view.frame];
    checkingNetWork.delegate = self;
}



-(void)initWithTimer {
    
    [self updateTimerAction];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if(update_timer != nil)
        {
            [update_timer invalidate];
            update_timer = nil;
        }
        
        update_timer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(updateTimerAction) userInfo:nil repeats:YES];
    });

}


#pragma mark - Btn Action  ***************
-(void)showMenuAction{
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}


-(void)showInfoAciton {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Info" bundle:nil];
    UIViewController *infoNav = [storyboard instantiateViewControllerWithIdentifier:@"InfoNav"];
    
    [self presentViewController:infoNav animated:YES completion:nil];
}



- (IBAction)changeWiFiSystemAction:(id)sender {
    
    if(multyAry.count > 0)
        [self startAnimate];
}


///跳到設備命名頁面
-(void)gotoNameDeviceViewController {
    
    //改成設置Router
    [AppDelegate saveNSUserDefaults:@"YES" Key:Router_Setting];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UINavigationController *nav =[storyboard instantiateViewControllerWithIdentifier:@"NameDeviceNavc"];
    
    UIViewController *nameDeviceVC = [storyboard instantiateViewControllerWithIdentifier:@"NameDeviceVC"];
    
    [nav setViewControllers:@[nameDeviceVC] animated:YES];
    
    [self presentViewController:nav animated:YES completion:nil];

}




#pragma mark - refresh Data  ********************
-(void)checkWiFiConnectStatus:(WiFiSystemConnectStatus)status {
    
    switch (status) {
            
            case Status_Connecting:
            self.connect_label.text = NSLocalizedString(@"Connecting", nil);
            self.connect_label.textColor = COLOR_Normal_Blue;
            break;
            
            case Status_breaking:
            self.connect_label.text = NSLocalizedString(@"Offline", nil);
            self.connect_label.textColor = COLOR_Normal_Red;
            break;
            
        default:
            break;
    }
    
}




#pragma mark - TableView DataSource & Delegate  *****************
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return multyAry.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cell_id = @"MainVC_Cell_ID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    MultyRouter *router = multyAry[indexPath.row];
    
    
    //背景圖片
    __block UIImage *systemImg;
    [router readPictureFormLocal:^(UIImage *image, ImageFileExtension extension) {
        systemImg = image;
    }];

    UIImageView *bg_imgView = [cell.contentView viewWithTag:10];
    bg_imgView.image = systemImg;
    
    
    
    //正在使用
    UIButton *using_btn = [cell.contentView viewWithTag:11];
//    using_btn.hidden = router.isUsing == 1;
    using_btn.hidden = ![self.contactJID isEqualToString:router.Router_JID];
    
    
    //systemNameLabel
    UILabel *systemNameLabel = [cell.contentView viewWithTag:12];
    systemNameLabel.text = router.wifisystem_name;
    
    
    //warningImgView
    UIImageView *waringImgView = [cell.contentView viewWithTag:13];
    waringImgView.hidden = router.isOnLine;
    
    
    //異常標籤
    UILabel *abnormal_label = [cell.contentView viewWithTag:14];
    abnormal_label.hidden = waringImgView.isHidden;
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self startMBProgressHUD];
    
    MULTYDataBase *m_multyDataBase = [[MULTYDataBase alloc] init];
    MultyRouter *router = [m_multyDataBase getAllMULTYDataBase][indexPath.row];
    
    __block UIImage *bg;
    [router readPictureFormLocal:^(UIImage *image, ImageFileExtension extension) {
        bg = image;
    }];
    self.mainPic.image = bg;
    
    //需要將JID更新 Parker - 2017/07/04
    NSString *jid = router.Router_JID;
    [AppDelegate saveNSUserDefaults: jid Key: XMPP_JID];
    self.contactJID = jid;
    self.wifiSystemName_label.text = router.wifisystem_name;
    self.wifiSystemName_label.adjustsFontSizeToFitWidth = YES;
    
    [self.mainVC_tableView reloadData];
    
    [self performSelector:@selector(replyAnimate) withObject:nil afterDelay:0.15];
    
    self.mainVC_scrollView.delegate = self;
    
    //SCrollView reload
    [self reloadScrollViewWithIndex:indexPath.row];
    
    [self changeBackgroundPicAndSystemName];
    
    [self checkConnectionToXMPPServer];
    
    [self stopMBProgressHUD];
}


#pragma mark - 本頁動畫效果  ***************
//baseView由上往下消失
-(void)startAnimate {
    
    CGRect bounds = self.baseView.bounds;
    CGRect finalFrame = CGRectOffset(self.baseView.frame, 0, bounds.size.height); //偏移效果
    
    CGRect waveBounds = self.waveAnimationView.bounds;
    CGRect waveFinalFrame = CGRectOffset(self.waveAnimationView.frame, 0, waveBounds.size.height); //偏移效果
    
    [UIView animateKeyframesWithDuration: 1.0 delay: 0.0 options: UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
        
        [UIView addKeyframeWithRelativeStartTime:0.1 relativeDuration:1.5 animations:^{
            self.baseView.frame = finalFrame;
            self.waveAnimationView.frame = waveFinalFrame;
        }];
        
    }completion:^(BOOL finished){
        //動畫完成的處理
        
        [self.mainVC_tableView setHidden: NO];
        
        [self animateTableView];
    }];
}

//UITableViewCell，緩慢由下往上升
-(void)animateTableView {
    
    [self.mainVC_tableView reloadData];
    
    NSArray *cells = [self.mainVC_tableView visibleCells];
    
    CGFloat tableHeight = self.mainVC_tableView.bounds.size.height;
    
    for(UITableViewCell *cell in cells) {
        
        cell.transform = CGAffineTransformMakeTranslation(0, tableHeight);
    }
    
    float index = 0;
    
    for(UITableViewCell *cell in cells) {
        
        [UIView animateWithDuration:1.0 delay: 0.2*index options: UIViewAnimationOptionCurveEaseOut animations:^{
            
            cell.transform = CGAffineTransformMakeTranslation(0, 0);
        }
        completion:nil];
        
        index +=1;
    }
}


//TableViewCell，點擊後的動畫
-(void)replyAnimate
{
    CGRect bounds = self.mainVC_tableView.bounds;
    CGRect finalFrame = CGRectOffset(self.mainVC_tableView.frame, 0, bounds.size.height);      //偏移效果
    
    [UIView animateKeyframesWithDuration: 1.5 delay: 0.0 options: UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
        
        [UIView addKeyframeWithRelativeStartTime:0.1 relativeDuration:1.4 animations:^{
            self.mainVC_tableView.frame = finalFrame;
        }];
        
        [UIView animateWithDuration:1.0 animations:^{           //改變alpha值，畫面變淡
            self.mainVC_tableView.alpha = 0;
        }];
        
    }completion:^(BOOL finished){                               //動畫完成的處理
        
        [self.mainVC_tableView setHidden: YES];
        
        //View回復原狀，要偏移回來
        CGRect viewBounds = self.baseView.bounds;
        CGRect viewFinalFrame = CGRectOffset(self.baseView.frame, 0, -viewBounds.size.height);
        
        //TableView回復原狀，要偏移回來
        CGRect tableViewBounds = self.mainVC_tableView.bounds;
        CGRect tableviewFinalFrame = CGRectOffset(self.mainVC_tableView.frame, 0, -tableViewBounds.size.height);
        
        //waveAnimationView回復原狀，要偏移回來
        CGRect waveAnimationBounds = self.waveAnimationView.bounds;
        CGRect waveAnimationFinalFrame = CGRectOffset(self.waveAnimationView.frame, 0, -waveAnimationBounds.size.height);
    
        [UIView animateKeyframesWithDuration: 1.0 delay: 0.0 options: UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
            
            [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.5 animations:^{
                self.baseView.frame = viewFinalFrame;
                self.mainVC_tableView.frame = tableviewFinalFrame;
            }];
            
            [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:0.5 animations:^{
                self.waveAnimationView.frame = waveAnimationFinalFrame;
            }];
            
            [UIView animateWithDuration:1.0 animations:^{
                
                self.mainVC_tableView.alpha = 1;
            }];
            
        }completion:nil];
        
    }];
}

#pragma mark - 顯示AP與UIScrollView相關設定
-(void)reloadScrollViewWithIndex:(NSInteger)index
{
    //屬於APDeviceView的SubView，要移除
    for(UIView *view in [self.mainVC_scrollView subviews])
    {
        if([view isKindOfClass: [APDeviceView class]])
        {
#warning BAD ACCESS
            [view removeFromSuperview];
        }
    }
    [self setTotalDevice: (int)index]; //[[ary_data[index] objectForKey: @"deviceCount"]intValue]
    [self setSCrollViewFromSubView];
}

//設定總Device
-(void)setTotalDevice:(int)totalDevice
{
    CGSize baseSize = self.mainPic.bounds.size;                             //基本size
    
    int multiple = (totalDevice / 4) + ((totalDevice % 4) > 0 ? 1 : 0);     //倍數
    
    self.mainVC_scrollView.contentSize = CGSizeMake(baseSize.width * multiple, 0);
    
    //ScrollViewPage，記錄每分頁Device個數
    if(scrollViewPage.count > 0)
        [scrollViewPage removeAllObjects];
    
    for(int i=0; i < (totalDevice / 4); i++)
    {
        [scrollViewPage addObject:[NSNumber numberWithInt: 4]];
    }
    
    if((totalDevice % 4) > 0)
        [scrollViewPage addObject:[NSNumber numberWithInt: (totalDevice % 4)]];
    
    [self.mainVC_pageControl setHidden: [scrollViewPage count] == 1];
    self.mainVC_pageControl.numberOfPages = [scrollViewPage count];
}

-(void)setSCrollViewFromSubView
{
    if(ary_page.count >0)
        [ary_page removeAllObjects];
    
    for(int i = 0; i < scrollViewPage.count ; i++)
    {
        int deviceCount = [scrollViewPage[i] intValue];
        
        CGSize baseSize = self.mainPic.bounds.size;
        CGRect rect = CGRectMake(baseSize.width * i, 0, baseSize.width, baseSize.height);
        
        APDeviceView *apDeviceView = [[APDeviceView alloc] initWithFrame: rect DeviceCount: deviceCount];
        [self.mainVC_scrollView addSubview:apDeviceView];
        
        [ary_page addObject: apDeviceView];
    }
}

//取得image，來自Device狀態 0:ON，1:OFF
-(UIImage *)getImageWithDeviceStatus:(int)status
{
    UIImage *image;
    
    switch (status) {
        case 0:
            image = [UIImage imageNamed: @"e1_bg_a_ap_0"];
            break;
        case 1:
            image = [UIImage imageNamed: @"e1_bg_a_ap_1"];
            break;
        default:
            break;
    }
    
    return image;
}

#pragma mark - ScrolleView Delegate  ****************************
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    int currentPage = (int)(round(scrollView.contentOffset.x / scrollView.frame.size.width));
    
    self.mainVC_pageControl.currentPage = currentPage;
}




#pragma mark - check WiFiSystem 數量  ***************************
-(AnyWiFiSystem)checkWiFiSystemCount:(int)count {
    
    AnyWiFiSystem anyWiFiSystem;

    anyWiFiSystem = count > 0 ? HasWiFiSystem : NoWiFiSystem;
    if (multyAry.count && anyWiFiSystem==NoWiFiSystem) {
        return WiFiSystemDisconnected;
    }else{
        return anyWiFiSystem;
    }
}


-(void)showNoWiFiSystem:(AnyWiFiSystem)anyWiFiSystem {
    
    if (anyWiFiSystem == NoWiFiSystem) {
        
        self.NoWiFiSystemView.hidden = NO;
        
        self.addWiFiSystem_btn.hidden = NO;
        
        self.mainPic.image = [UIImage imageNamed:@"e1_img_a_home"];
        
        self.mainVC_scrollView.hidden = YES;
        
        self.waveAnimationView.hidden = YES;
        
        self.mainVC_pageControl.hidden = YES;
        
    }else if(anyWiFiSystem==WiFiSystemDisconnected){
        
        self.NoWiFiSystemView.hidden = YES;
        
        self.addWiFiSystem_btn.hidden = YES;
        
        //self.mainPic.image = [UIImage imageNamed:@""];
        
        self.mainVC_scrollView.hidden = NO;
        
        self.waveAnimationView.hidden = NO;
        
        self.mainVC_pageControl.hidden = YES;
        
        [self checkWiFiConnectStatus:Status_breaking];
    }else {
        
        self.NoWiFiSystemView.hidden = YES;
        
        self.addWiFiSystem_btn.hidden = YES;
        
        //self.mainPic.image = [UIImage imageNamed:@""];
        
        self.mainVC_scrollView.hidden = NO;
        
        self.waveAnimationView.hidden = NO;
        
        self.mainVC_pageControl.hidden = NO;
        
        [self checkWiFiConnectStatus:Status_Connecting];
    }
    
}



#pragma mark - 取得下載/上傳的速度，經過轉換，預設來源為bp
-(NSString *)getMbps:(float)source{
    
    float mbps ;
    
    mbps = source / 1024 / 1024;
    
    NSString *mbpsString;
    
    NSString *first = [[NSString stringWithFormat:@"%.1f",mbps] substringWithRange:NSMakeRange(2, 1)];
    
    if(first.intValue != 0)
    {
        mbpsString = [NSString stringWithFormat:@"%.1f",mbps];
    }
    else
    {
        mbpsString = [NSString stringWithFormat:@"%.0f",mbps];
    }
    
    return mbpsString;
}


#pragma mark - XMPP  **************
-(void)updateTimerAction {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self checkContactJID];
        
        [self getWiFiSystemSpeedAction];
        
        [self getWiFiSystemStatus];
        
        [self getNetWorkDeviceInfo];
    });
}

-(void)checkContactJID{
    if([AppDelegate determineNSUserDefaultExist:XMPP_JID] == NO) {
        NSMutableArray <MultyRouter *> *routerAry = [[NSMutableArray alloc] initWithArray:[multyDataBase getAllMULTYDataBase]];
        if (routerAry.count > 0) {
            self.contactJID = routerAry[0].Router_JID;
            [AppDelegate saveNSUserDefaults:XMPP_JID Key:self.contactJID];
        }else{
//             [update_timer invalidate];
        }
    }
    else {
        self.contactJID = [AppDelegate readNSUserDefaults:XMPP_JID];
    }
}
-(void)getWiFiSystemSpeedAction {
    
    [_wifiSystem ZapiGetWiFiSystemSpeed:self.contactJID completion:^(StructCurrentBandWidth *obj, NSError *error) {
        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            [hud setHidden:YES];
//        });
        [self stopMBProgressHUD];
        
        ZyxelWiFiSystem_Error errorCode = error.code;
        
        if (errorCode != ZapiErrorCode_OK) {
            
            if(errorCode == ZyxelWiFiSystem_Error_Timeout) {
                
                NSLog(@"Speed time Out");
            }
            
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.download_speed_label.text = [self getMbps:obj.output.getDownload];
            self.upload_speed_label.text = [self getMbps:obj.output.getUpload];
            
            NSLog(@"getDownload:%ld",(long)obj.output.getDownload);
            NSLog(@"getUpload:%ld",(long)obj.output.getUpload);
            
            NSLog(@"getDownload: %@",[self getMbps:obj.output.getDownload]);
            NSLog(@"getUpload: %@",[self getMbps:obj.output.getUpload]);
            
        });
        
    }];



}


-(void)getNetWorkDeviceInfo
{
    
    [_wifiSystem ZapiGetNetworkDeviceInfo:self.contactJID completion:^(StructNetworkDevices *obj, NSError *error) {
        
        if(error) {
            return ;
        }
        
        connectDeviceCount = 0;
        
        for (StructDeviceElement *elemet in obj.device) {
            
            //過濾掉ExtenderAP
            if ([elemet getDeviceType]==EnumDeviceType_CLIENT && [elemet getAliveStatus]) {
                connectDeviceCount++;
            }
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            self.connectingDeviceTitle_label.text = [self returnConnectDeviceCount:connectDeviceCount];
        });
        
    }];
}



-(void)getWiFiSystemStatus {
    
    [_wifiSystem ZapiGetStructSystemDevicesState:self.contactJID completion:^(StructSystemDevicesState *obj, NSError *error) {
        
        NSMutableArray <StructDeviceElementDevice *> *ary_device = [[NSMutableArray alloc] init];
        
        if (!error){
            ary_device = obj.device;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLog(@"count:: %d",(int)ary_device.count);
            
            if ((int)ary_device.count == 0) {
                
                [self showNoWiFiSystem:[self checkWiFiSystemCount:0]];
                
                return ;
            }
            
            [self showNoWiFiSystem:[self checkWiFiSystemCount:(int)ary_device.count]];
            
            [self reloadScrollViewWithIndex: (int)ary_device.count];
            
            NSMutableArray <StructDeviceElementDevice *> *m_device = [[NSMutableArray alloc] init];
            
            //先找到router，丟進m_device陣列裡
            for (int i = 0; i < ary_device.count; i++) {
                
                if([ary_device[i] getRole] == EnumOperationMode_ROUTER){
                    [m_device addObject: ary_device[i]];
                }
            }
            
            
            if (ary_device.count > 1) {
                
                //剩下的ap，都丟進去m_device陣列裡
                for (int i = 0; i < ary_device.count; i++) {
                    
                    if([ary_device[i] getRole] == EnumOperationMode_EXTENDER){
                        [m_device addObject: ary_device[i]];
                    }
                }
            }
            
            

            int i = 0;
            
            for(int j = 0 ; j < ary_page.count ; j++)
            {
                APDeviceView *apDeviceView = ary_page[j];
                
                for(int y = 0 ; y < [[scrollViewPage objectAtIndex: j] intValue]; y++)
                {
                    EnumOnOffLine onoffLine = [m_device[i] getOnOffLine];
                    
                    NSLog(@"name = %@,MAC = %@",[m_device[i] getName],[m_device[i] getMac]);
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        switch (y) {
                            case 0:
                            {
                                if([m_device[i] getRole] == EnumOperationMode_ROUTER)
                                {
                                    //Router的圖片與其他AP不同，也要區分有無連線
                                    if(onoffLine == EnumOnOffLine_ON)
                                    {
                                        [apDeviceView.deviceImageView1 setImage: [UIImage imageNamed: @"e1_bg_a_ap_0"]];
                                    }
                                    else
                                    {
                                        [apDeviceView.deviceImageView1 setImage: [self getImageWithDeviceStatus: onoffLine]];
                                    }
                                    apDeviceView.deviceLabel1.text = [m_device[i] getName];
                                }
                                else
                                {
                                    [apDeviceView.deviceImageView1 setImage: [self getImageWithDeviceStatus: onoffLine]];
                                    apDeviceView.deviceLabel1.text = [m_device[i] getName];
                                }
                            }
                                break;
                            case 1:
                            {
                                [apDeviceView.deviceImageView2 setImage: [self getImageWithDeviceStatus: onoffLine]];
                                apDeviceView.deviceLabel2.text = [m_device[i] getName];
                            }
                                break;
                            case 2:
                            {
                                [apDeviceView.deviceImageView3 setImage: [self getImageWithDeviceStatus: onoffLine]];
                                apDeviceView.deviceLabel3.text = [m_device[i] getName];
                            }
                                break;
                            case 3:
                            {
                                [apDeviceView.deviceImageView4 setImage: [self getImageWithDeviceStatus: onoffLine]];
                                apDeviceView.deviceLabel4.text = [m_device[i] getName];
                            }
                                break;
                                
                            default:
                                break;
                        }
                        
                        
                    });
                    i++;
                }
            }
        });
    }];
}

#pragma mark - ZyxelWiFiSystemDelegate  *****************
-(void)wifiSystem:(ZyxelWiFiSystem *)wifiSystem didChangeConnectionStatus:(ZyxelWiFiSystem_conn_status)status {

    if (status == ZyxelWiFiSystem_conn_status_connectted) {
        
        //[AppDelegate saveNSUserDefaults:@"YES" Key:LoginOrNot];
        _wifiSystem.connected = YES;
        [self initWithTimer];
        [self getWiFiSystemList];
    }
    else {
        _wifiSystem.connected= NO;
        [self checkConnectionToXMPPServer];
        //[AppDelegate saveNSUserDefaults:@"NO" Key:LoginOrNot];
    }

}


-(void)checkConnectionToXMPPServer {
    if (_wifiSystem.connected == YES) {
//    if (_wifiSystem.connected == YES && [[AppDelegate readNSUserDefaults:LoginOrNot] isEqualToString:@"YES"]) {
        //如果已經連上XMPP Server,開始取 Wifisystem data
        [self initWithTimer];
        [self getWiFiSystemList];
    }
    else {
        
        if ([AppDelegate determineNSUserDefaultExist:TheAccessToken] == NO) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self connectToXMPPUnlogIn];
            });
        }
        else {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self protalSignIn];
            });
        }
        
    }
}


-(void)protalSignIn {
    NSString *accessToken = [AppDelegate readNSUserDefaults:TheAccessToken];
    NSLog(@"MainView accessToken:%@", accessToken);
    [ZyxelProtal protalSignWithAccessToken:accessToken withCompletion:^(NSMutableArray *ary, NSString *serverIP, NSString *account, NSString *password, NSString *authenticationToken, NSString *cloudID, NSError *error) {
        
        if(error){
            NSLog(@"error:%@",[error description]);
            return ;
        }
        
        m_delegate.globalWiFiSystemAry = [ary mutableCopy];
        
        if (m_delegate.globalWiFiSystemAry.count == 0 || m_delegate.globalWiFiSystemAry == nil) {
            
            [self stopMBProgressHUD];
            NSLog(@"無 任 何 WiFiSystem");
            return;
        }
        
        NSLog(@"m_delegate.globalWiFiSystemAry: %@",m_delegate.globalWiFiSystemAry[0].xmppAccount);
        NSLog(@"m_delegate.globalWiFiSystemAry: %@",m_delegate.globalWiFiSystemAry[0].macAddress);
        
        [AppDelegate saveNSUserDefaults:m_delegate.globalWiFiSystemAry[0].xmppAccount Key:XMPP_JID];
        [AppDelegate saveNSUserDefaults:cloudID Key:Cloud_ID];
        [_wifiSystem setAutentication:authenticationToken andCloudID:cloudID];
        
        [_wifiSystem connectToServer:serverIP withAccount:account andPassword:password];
    
    }];
    
}



#pragma mark - 監聽 applicationDidBecomeActive
-(void)addApplicationDidBecomeActiveObserver {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActiveAction) name:UIApplicationDidBecomeActiveNotification object:nil];
}


-(void)removeApplicationDidBecomeActiveObserver {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}


-(void)applicationDidBecomeActiveAction {
    
    //step1:先確認有無網路
    if (![CheckNetwork isExistenceNetwork]) {
        //無網路
        noNetWorkView.hidden = NO;
        [self.view bringSubviewToFront:noNetWorkView];
        [AppDelegate showAlert:NSLocalizedString(@"Warning", nil) message:NSLocalizedString(@"Please Check Your Network", nil) superVC:self];
        return;
    }
    else {
        //有網路
        //step2:判斷是否登入
        noNetWorkView.hidden = YES;
        [self initWithcheckNetWork];
        [self checkConnectionToXMPPServer];
    }
    
}


#pragma mark - Checking NetWork Delegate ************
-(void)checkNetWorkStatus:(NetworkStatus)networkStatus {
    
    if(networkStatus == NotReachable) {
        [update_timer invalidate];
        update_timer = nil;
        noNetWorkView.hidden = NO;
        [AppDelegate showAlert:NSLocalizedString(@"Warning", nil) message:NSLocalizedString(@"Please Check Your Network", nil) superVC:self];
        return;
    }
    else {
        noNetWorkView.hidden = YES;
    }
}


#pragma mark - N個設備正在使用字串  *********
-(NSString *)returnConnectDeviceCount:(int)count {
    
    NSString *countStr = [NSString stringWithFormat:@"%d ",count];
    
    NSString *titleStr = NSLocalizedString(@"Wi-Fi Clients Are Connected", nil);
    
    NSString *finalStr = [countStr stringByAppendingString:titleStr];
    
    return finalStr;
}

//未登入曾安裝過
-(void)connectToXMPPUnlogIn {
    
    //未曾登入過
    NSMutableArray <MultyRouter *> *multyAry = [[NSMutableArray alloc] initWithArray:[multyDataBase getAllMULTYDataBase]];
    if(multyAry.count <= 0) {
        //沒安裝過
        [self stopMBProgressHUD];
        //[hud hide:YES];
        [self.mainVC_pageControl setHidden:YES];
        return;
    }
    else {
        //有安裝過
        NSString *certificate = multyAry[0].Router_certificate;
        NSString *sercetKey = multyAry[0].Router_secretKey;
        [ZyxelProtal getUserXMPPInfoWithCompletion:^(NSString *account, NSString *password, NSString *serverIP, NSError *error) {
            [_wifiSystem setCertificate:certificate andSecretKey:sercetKey];
            [_wifiSystem connectToServer:serverIP withAccount:account andPassword:password];
            
        }];
        
    }
}

#pragma mark - 串接WiFi System(來自DataBase)
-(void)getWiFiSystemList
{
    multyAry = [[NSMutableArray alloc] initWithArray: [multyDataBase getAllMULTYDataBase]];
    
    for(int i = 0; i < multyAry.count ;i++)
    {
        MultyRouter *multy = [multyAry objectAtIndex: i];
        
        //取得onoffLine
        [_wifiSystem ZapiGetStructSystemDevicesState: multy.Router_JID completion:^(StructSystemDevicesState *obj, NSError *error) {
        
            if (obj) {
                NSLog(@"MULTY %@ online!", multy.wifisystem_name);
                multy.isOnLine = YES;
//                for (StructDeviceElementDevice *device in [obj device]) {
//                    [[device getRepresentMac] isEqualToString:multy.mac_Address];
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [self checkWiFiConnectStatus:Status_breaking];
//                    });
//                }
            }else{
                NSLog(@"MULTY %@ offline!", multy.wifisystem_name);
                multy.isOnLine = NO;
            }
            
        }];
    }
    
    [self.mainVC_tableView reloadData];
}


#pragma mark - 即時更換wifiSystem背景圖
-(void)changeBackgroundPicAndSystemName{
    
    MULTYDataBase *m_multyDataBase = [[MULTYDataBase alloc] init];
    MultyRouter *multy = [m_multyDataBase getUnitMULTYData:[AppDelegate readNSUserDefaults:XMPP_JID]];
    if (multy.Router_JID) {
        __block UIImage *bg;
        [multy readPictureFormLocal:^(UIImage *image, ImageFileExtension extension) {
            bg = image;
        }];
        self.mainPic.image = bg;
        self.wifiSystemName_label.text = multy.wifisystem_name;
    }else{

        UIImage *image = [UIImage imageWithContentsOfFile: [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Default_all_img_a_home.jpg"]];
        self.mainPic.image = image;
    }
}

@end
