//
//  ViewController.m
//  WebViewInteractive
//
//  Created by shuoliu on 2018/5/14.
//  Copyright © 2018年 shuoliu. All rights reserved.
//

#import "ViewController.h"
#import "MyJSObject.h"
#import "WebViewController.h"
#import "WkWebViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"OC和WebView的通信";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat centerX = self.view.frame.size.width / 2;
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(centerX - 110 / 2, 120, 110, 50)];
    [btn1 setTitleColor:[UIColor blackColor]  forState:UIControlStateNormal];
    [btn1 setTitle:@"UIWebview" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(btn1Tap) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    btn1.backgroundColor = [UIColor redColor];
    btn1.layer.cornerRadius = 2.5;
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(centerX - 110 / 2, 180, 110, 50)];
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn2 setTitle:@"WkWebview" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(btn2Tap) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    btn2.backgroundColor = [UIColor purpleColor];
    btn2.layer.cornerRadius = 2.5;
    
}
-(void)btn1Tap
{
    WebViewController *webViewContrl = [[WebViewController alloc] init];
    [self.navigationController pushViewController:webViewContrl animated:YES];
}
-(void)btn2Tap
{
    WkWebViewController *webViewContrl = [[WkWebViewController alloc] init];
    [self.navigationController pushViewController:webViewContrl animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
