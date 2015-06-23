//
//  InstagramViewController.m
//  Instagram Hook
//
//  Created by Destiny Bonavita on 6/22/15.
//  Copyright (c) 2015 Fading Eclipse LLC. All rights reserved.
//

#import "ViewController.h"
#import "InstagramViewController.h"

#define KAUTHURL @"https://api.instagram.com/oauth/authorize/?client_id="
#define KCLIENTID @""
#define KCLIENTSERCRET @""
#define kREDIRECTURI @""

@interface InstagramViewController () <UIWebViewDelegate>

@property (nonatomic, retain) NSString *access_token;
@property (nonatomic, weak) IBOutlet UIWebView *webView;

@end

@implementation InstagramViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Use the below code to display the login hook for Instagram
    NSString *fullURL = [NSString stringWithFormat:@"%@%@&redirect_uri=%@&response_type=token", KAUTHURL, KCLIENTID, kREDIRECTURI];
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    [self.webView loadRequest:requestObj];
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
            [self dismissViewControllerAnimated:YES completion:^{
                ViewController *vc = (ViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
                
                vc.access_token = [urlStr substringFromIndex:NSMaxRange(token)];
            }];
        }
        
        return NO;
    }
    
    return YES;
}

@end
