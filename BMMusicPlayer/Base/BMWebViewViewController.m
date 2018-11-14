//
//  BMWebViewViewController.m
//  Calm
//
//  Created by BirdMichael on 2018/11/7.
//  Copyright © 2018 BirdMichael. All rights reserved.
//

#import "BMWebViewViewController.h"

@interface BMWebViewViewController ()

@property (nonatomic, strong) NSURL* url;
@property (nonatomic, strong) UIWebView* webView;

@end

@implementation BMWebViewViewController

- (instancetype)initWithURL:(NSURL *)url {
    self = [super init];
    if (self) {
        _url = [NSURL URLWithString:url.absoluteString];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.url];
    [self.webView loadRequest:request];
    // Do any additional setup after loading the view.
}

- (void)initUI {
    self.webView = [[UIWebView alloc] init];
    self.webView.scalesPageToFit = YES;
    self.webView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.webView];
    self.webView.frame =  CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - kBMNavBarHeight - kBMStatusBarHeight);
}

@end
