//
//  login.m
//  MyZyxel
//
//  Created by line on 2017/5/16.
//  Copyright © 2017年 Zyxel. All rights reserved.
//

#import "login.h"

@interface login ()
{
    MBProgressHUD *m_HUD;
    NetworkStatus netStatus;
}
@end

@implementation login
- (void)dealloc
{
    m_HUD = nil;
    [self.loginPage setDelegate: nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.loginPage.scrollView setBounces: NO];
    Reachability *reach = [Reachability reachabilityWithHostName: @"www.apple.com"];
    netStatus = [reach currentReachabilityStatus];
    
    if (m_HUD == nil)
    {
        m_HUD = [[MBProgressHUD alloc]initWithView: self.view];
        [m_HUD setContentColor: [UIColor whiteColor]];
        [m_HUD.bezelView setBackgroundColor: [UIColor blackColor]];
        [m_HUD showAnimated: YES];
        [m_HUD setMinShowTime: 15];
        [self.view addSubview: m_HUD];
    }
    // call get_authorization fun
    if (netStatus == NotReachable) {
        debug(@"no internet!");
    }
    else
    {
        //[m_HUD showWhileExecuting:@selector(get_authorization) onTarget:self withObject:nil animated:YES];
        [self get_authorization];
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    [self.errorView setHidden: YES];
    [self selfLayout];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - GET SERVER INFO
- (void) get_authorization
{
    [m_HUD setHidden: NO];
    [m_HUD.label setText: @"Login ..."];
    NSString *oauth_url = [NSString stringWithFormat: @"%@/oauth/authorize?client_id=%@&redirect_uri=%@&response_type=code&state=line", SITE_URL, CLIENT_ID, REDIRECT_URI];
    if (DEBUG) debug(@"oauth url = %@", oauth_url);
    NSURL *url = [NSURL URLWithString: oauth_url];
    //NSURLRequest *request_auth = [NSURLRequest requestWithURL: url];
    NSURLRequest *request_auth = [NSURLRequest requestWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 60];
    [self.loginPage loadRequest: request_auth];
}
- (void)get_access_token:(NSString *)auth_grant_code
{
    [m_HUD setHidden: NO];
    [m_HUD.label setText: @"Login ..."];
    NSString *access_token_url = [NSString stringWithFormat: @"%@/oauth/token", SITE_URL];
    if (DEBUG) debug(@"access token url = %@", access_token_url);
    NSURL *url = [NSURL URLWithString: access_token_url];
    NSMutableURLRequest *request_access_token = [NSMutableURLRequest requestWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 30];
    
    [request_access_token setHTTPMethod: @"POST"];
    [request_access_token setValue: @"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField: @"Content-Type"];
    
    NSString *stringData = [NSString stringWithFormat: @"grant_type=authorization_code&code=%@&client_id=%@&client_secret=%@&redirect_uri=%@", auth_grant_code, CLIENT_ID, CLIENT_SECRET, REDIRECT_URI];
    
    NSData *postData = [stringData dataUsingEncoding: NSUTF8StringEncoding];
    
    [request_access_token setHTTPBody: postData];

    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    [[session dataTaskWithRequest: request_access_token
                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                    if (data != nil)
                    {
                        NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData: data options: kNilOptions error: nil];
                        [public set_access_token: [NSString stringWithFormat: @"Bearer %@", [json valueForKey: @"access_token"]]];
                        [public set_refresh_token: [json valueForKey: @"refresh_token"]];
                        [self get_user_info];
                    }
                    else
                    {
                        [m_HUD setHidden: YES];
                        [self.errorView setHidden: NO];
                    }
                }] resume];
}
- (void)get_user_info
{
    NSString *get_user_info_url = [NSString stringWithFormat: @"%@/api/v1/my/info", SITE_URL];
    if (DEBUG) debug(@"get_user_info_url = %@", get_user_info_url);
    NSURL *url = [NSURL URLWithString: get_user_info_url];
    NSMutableURLRequest *request_user_info = [NSMutableURLRequest requestWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 30];
    [request_user_info setHTTPMethod: @"GET"];
    [request_user_info setValue: [public get_access_token] forHTTPHeaderField: @"Authorization"];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest: request_user_info
                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                {
                    if (data != nil)
                    {
                        if (DEBUG) debug(@"access token = %@", [public get_access_token]);
                        NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData: data options: kNilOptions error: nil];
                        if (DEBUG) debug(@"userInfo = %@", [json objectForKey: @"result"]);
                        NSString *encryptionCode = [json objectForKey: @"result"];
                        NSString *iv = [encryptionCode substringWithRange: NSMakeRange(0, 16)];
                        NSString *encrypted_data = [encryptionCode substringFromIndex: 16];
                        NSString *sha256_decode_data = [public sha256: CLIENT_SECRET];
                        NSData *decode_key = [public hexToBytes: sha256_decode_data];
                        if (DEBUG) debug(@"encryption = %@", encryptionCode);
                        if (DEBUG) debug(@"iv = %@", iv);
                        if (DEBUG) debug(@"base64_encode = %@", encrypted_data);
                        // Decryption base64 aes256-cbc sha256-digest
                        NSData *base64_decode_data = (NSData *)[public base64_decode: encrypted_data];
                        if (DEBUG) debug(@"base64_decode = %@", base64_decode_data);
                        NSData *aes_decode_data = [public aes_cbc_256: base64_decode_data andIv: iv andkey: decode_key andType: kCCDecrypt];
                        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingUTF8);
                        NSString *userInfo = [[NSString alloc]initWithData: aes_decode_data encoding: enc];
                        if (DEBUG) debug(@"user info = %@", userInfo);
                        NSMutableDictionary *userInfo_json = [NSJSONSerialization JSONObjectWithData: aes_decode_data options:kNilOptions error: nil];
                        if (DEBUG) debug(@"info = %@", [userInfo_json objectForKey: @"info"]);
                        NSDictionary *emailInfo = [userInfo_json objectForKey: @"info"];
                        // get user account
                        [public set_user_account: [emailInfo objectForKey: @"email"]];
                        if (DEBUG) debug(@"access_key = %@", [userInfo_json objectForKey: @"access_key"]);
                        NSDictionary *accessKeyInfo = [userInfo_json objectForKey: @"access_key"];
                        // get access key info
                        [public set_access_key_id: [accessKeyInfo objectForKey: @"access_key_id"]];
                        [public set_secret_access_key: [accessKeyInfo objectForKey: @"secret_access_key"]];
                        if (DEBUG) debug(@"access key id = %@ : secret access key = %@", [public get_access_key_id], [public get_secret_access_key]);
                        if ([[json objectForKey: @"result"]length] > 0)
                        {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [m_HUD setHidden: YES];
                                [self changeView:@"main"];
                            });
                        }
                    }
                    else
                    {
                        [m_HUD setHidden: YES];
                        [self.errorView setHidden: NO];
                    }
                }] resume];
}
#pragma mark - UIWebView Delegate Methods
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    if (DEBUG) debug(@"loading...");
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    // get response header fields
    NSCachedURLResponse *resp = [[NSURLCache sharedURLCache] cachedResponseForRequest:webView.request];
    if (DEBUG) debug(@"status = %ld", (long)[(NSHTTPURLResponse*)resp.response statusCode]);
    //if ((long)[(NSHTTPURLResponse*)resp.response statusCode])
    //{
        dispatch_async(dispatch_get_main_queue(), ^() {
            [m_HUD setHidden: YES];
        });
    //}
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSDictionary *serverInfo = [error userInfo];
    if (DEBUG) debug(@"serverInfo = %@", serverInfo);
    NSString *urlKey = [NSString stringWithFormat: @"NSErrorFailingURLKey = %@", [serverInfo objectForKey: @"NSErrorFailingURLKey"]];

    NSArray *auth_grant_code = [urlKey componentsSeparatedByString: @"?"];

    if (DEBUG) debug(@"auth_grant_code = %@", [auth_grant_code objectAtIndex: 1]);
    
    NSDictionary *query_str = [public parseQueryString: [auth_grant_code objectAtIndex: 1]];
    
    [public set_code: [NSString stringWithFormat: @"%@", [query_str objectForKey: @"code"]]];
    if (![[public get_code] isEqualToString: @"(null)"])
    {
        [self get_access_token: [public get_code]];
    }
    else
    {
        if (DEBUG) debug(@"timeout");
        [m_HUD setHidden: YES];
        [self.errorView setHidden: NO];
    }
}
#pragma mark - FUNCTION
- (void) changeView:(NSString *)pageName
{
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:pageName];
    [self presentViewController:vc animated:YES completion:nil];
}
- (void)selfLayout
{
    debug(@"layout");
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
#pragma mark - BUTTON EVENTS
- (IBAction)tryAgainBtn:(id)sender
{
    [m_HUD setHidden: NO];
    [self.loginPage stopLoading];
    [self.errorView setHidden: YES];
    [self get_authorization];
}
@end
