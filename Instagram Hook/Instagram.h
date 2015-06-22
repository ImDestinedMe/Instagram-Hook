//
//  Instagram.h
//  InstaFix
//
//  Created by Destiny Dawn on 12/30/14.
//  Copyright (c) 2014 Young and Strong Productions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotoSelectorDelegate.h"

@interface Instagram : NSObject

+ (instancetype) instance;
- (NSDictionary *)photosFromAccount:(NSString *)url;

@property (nonatomic, retain) NSString *authKey;

@end

@interface InstagramAuth : UIViewController <UIWebViewDelegate>

@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) id<PhotoSelectorDelegate> delegate;

@end
