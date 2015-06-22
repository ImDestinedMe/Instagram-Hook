//
//  ViewController.m
//  Instagram Hook
//
//  Created by Destiny Bonavita on 6/22/15.
//  Copyright (c) 2015 Fading Eclipse LLC. All rights reserved.
//

#import "ViewController.h"

#define KAUTHURL @"https://api.instagram.com/oauth/authorize/?client_id="
#define kAPIURl @"https://api.instagram.com/v1/users/self/followed-by?access_token="
#define KCLIENTID @"USE_YOUR_CLIENT_ID"
#define KCLIENTSERCRET @"USE_YOUR_CLIENT_SECRET"
#define kREDIRECTURI @"USE_YOUR_REDIRECT_URI"

@interface ViewController () <UIWebViewDelegate>

@property (nonatomic, retain) NSString *access_token;
@property (nonatomic, weak) IBOutlet UIWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //Use the below code to display the login hook for Instagram
    NSString *fullURL = [NSString stringWithFormat:@"%@%@&redirect_uri=%@&response_type=token", KAUTHURL, KCLIENTID, kREDIRECTURI];
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    [self.webView loadRequest:requestObj];
}

#pragma mark - Private

- (void)getFollowers
{
    NSString *url = [NSString stringWithFormat:@"%@%@", kAPIURl, self.access_token];
    NSDictionary *data = [self dataWithURL:[NSURL URLWithString:url]][@"data"];
    
    //Prints your followers to the log
    NSLog(@"%@", data);
}

- (NSDictionary *)dataWithURL:(NSURL *)url
{
    NSDictionary *dict = [[NSDictionary alloc] init];
    if (self.access_token)
    {
        NSData *dat = [NSData dataWithContentsOfURL:url];
        if (!dat) return dict;
        
        dict = [NSJSONSerialization JSONObjectWithData:dat options:NSJSONReadingAllowFragments error:nil];
    }
    
    return dict;
}

#pragma mark - UIWebView Delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlStr = [request.URL absoluteString];
    NSArray *urlParts = [urlStr componentsSeparatedByString:[NSString stringWithFormat:@"%@/", kREDIRECTURI]];
    if (urlParts.count > 1) {
        urlStr = urlParts[1];
        NSRange token = [urlStr rangeOfString:@"#access_token="];
        if (token.location != NSNotFound)
        {
            //Store the access_token for later
            self.access_token = [urlStr substringFromIndex:NSMaxRange(token)];
            
            //Get the followers
            [self getFollowers];
        }
        
        return NO;
    }
    
    return YES;
}

@end
