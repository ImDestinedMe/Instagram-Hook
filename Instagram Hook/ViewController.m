//
//  ViewController.m
//  Instagram Hook
//
//  Created by Destiny Bonavita on 6/22/15.
//  Copyright (c) 2015 Fading Eclipse LLC. All rights reserved.
//

#import "ViewController.h"

#define kAPIURl @"https://api.instagram.com/v1/users/self/followed-by?access_token="

@interface ViewController ()

@property (nonatomic, retain) NSArray *followers;

@end

@implementation ViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!self.access_token) {
        UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"instagram"];
        
        [self presentViewController:vc animated:NO completion:nil];
    }
}

#pragma mark - Instagram

- (void)getFollowers {
    NSString *url = [NSString stringWithFormat:@"%@%@", kAPIURl, self.access_token];
    NSArray *data = [self dataWithURL:[NSURL URLWithString:url]][@"data"];
    
    //Prints your followers to the log
    self.followers = data;
    [self.tableView reloadData];
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

#pragma mark - Properties

- (void)setAccess_token:(NSString *)access_token
{
    if (_access_token != access_token) {
        _access_token = access_token;
        
        [self getFollowers];
    }
}

#pragma mark - UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.followers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"usercell"];
    
    NSDictionary *user = self.followers[indexPath.row];
    cell.textLabel.text = user[@"username"];
    
    return cell;
}

@end
