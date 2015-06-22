//
//  Instagram.m
//  InstaFix
//
//  Created by Destiny Dawn on 12/30/14.
//  Copyright (c) 2014 Young and Strong Productions. All rights reserved.
//

#import "Instagram.h"
#import "SocialImageCollectionViewController.h"

#define KAUTHURL @"https://api.instagram.com/oauth/authorize/?client_id="
#define kAPIURl @"https://api.instagram.com/v1/users/self/media/recent?access_token="
#define KCLIENTID @"e8dfe6f8a56c478cae4f462abc09ea2d"
#define KCLIENTSERCRET @"54f593c451634ee1b07055a2b5508825"
#define kREDIRECTURI @"http://flashfix.fadingeclipsellc.com"

@implementation Instagram

+ (instancetype)instance
{
    static Instagram *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[Instagram alloc] init];
    });
    
    return instance;
}

- (NSDictionary *)photosFromAccount:(NSString *)url
{
    NSDictionary *dict = [[NSDictionary alloc] init];
    if (self.authKey)
    {
        NSURL *urlObj = [NSURL URLWithString:url];
        NSData *dat = [NSData dataWithContentsOfURL:urlObj];
        if (!dat) return dict;
        
        dict = [NSJSONSerialization JSONObjectWithData:dat options:NSJSONReadingAllowFragments error:nil];
    }
    
    return dict;
}

@end


@implementation InstagramAuth

#pragma mark - UIView Life Cycle

- (void)viewDidLoad
{
    //Create UIWebView
    self.webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    self.webView.delegate = self;
    
    [self.view addSubview:self.webView];
    
    
    //Create Instagram Request
    NSString *fullURL = [NSString stringWithFormat:@"%@%@&redirect_uri=%@&response_type=token",KAUTHURL,KCLIENTID,kREDIRECTURI];
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestObj];
    
    [super viewDidLoad];
}

#pragma mark - Instagram Handling

- (void)setupInstagramPhotos
{
    // Undo UIWebView
    [self.webView removeFromSuperview];
    self.webView = nil;
    
    //Get Social View Controller
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0.0f;
    layout.minimumInteritemSpacing = 0.0f;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    SocialImageCollectionViewController *vc = [[SocialImageCollectionViewController alloc] initWithCollectionViewLayout:layout];
    vc.navigationItem.title = @"Instagram";
    vc.delegate = self.delegate;
    vc.network = InstagramNet;
    
    NSString *url = [NSString stringWithFormat:@"%@%@", kAPIURl, [Instagram instance].authKey];
    NSDictionary *photosJSON = [[Instagram instance] photosFromAccount:url];
    NSArray *photosData = photosJSON[@"data"];
    NSMutableArray *photoUrls = [[NSMutableArray alloc] init];
    for (NSDictionary *photo in photosData)
        [photoUrls addObject:photo[@"images"]];
    vc.urls = photoUrls;
    
    NSDictionary *pagaton = photosJSON[@"pagination"];
    if (pagaton) vc.cursor = pagaton[@"next_url"];
    
    [self.navigationController pushViewController:vc animated:NO];
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
            NSString *strToken = [urlStr substringFromIndex:NSMaxRange(token)];
            [Instagram instance].authKey = strToken;
            [self setupInstagramPhotos];
        }
        
        return NO;
    }
    
    return YES;
}

@end