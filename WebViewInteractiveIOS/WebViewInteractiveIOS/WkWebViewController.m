//
//  WkWebViewController.m
//  WebViewInteractive
//
//  Created by shuoliu on 2018/5/14.
//  Copyright © 2018年 shuoliu. All rights reserved.
//

#import "WkWebViewController.h"
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@interface WkWebViewController ()<WKNavigationDelegate,WKScriptMessageHandler,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic,weak)WKWebView *webView;
@property(nonatomic,strong)JSContext *context;
@property(nonatomic,strong)WKUserContentController *userContentController;

@end

@implementation WkWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 创建配置对象
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    
    // 为WKWebViewConfiguration设置偏好设置
    WKPreferences *preferences = [[WKPreferences alloc] init];
    configuration.preferences = preferences;
    
    // 允许native和js交互
    preferences.javaScriptEnabled = YES;
    
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    [userContentController addScriptMessageHandler:self name:@"event"];
    configuration.userContentController = userContentController;
    self.userContentController = userContentController;
    
    // 初始化webview
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 300) configuration:configuration];
    // 此处替换你本机的ip
    NSURL *url = [NSURL URLWithString:@"http://172.26.233.156:3001/wkWebView"];
    webView.navigationDelegate = self;
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [webView loadRequest:request];
    [self.view addSubview:webView];
    self.webView = webView;
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(100, 390, 100, 50)];
    [btn1 setTitleColor:[UIColor blackColor]  forState:UIControlStateNormal];
    [btn1 setTitle:@"oc调用js" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(btn1Tap) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    self.view.backgroundColor = [UIColor whiteColor];
}


-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    // 执行js脚本
    [webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable data, NSError * _Nullable error) {
        self.title = data;
    }];
}
-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"%@",error);
}

-(void)btn1Tap
{
    // 执行js脚本
    [self.webView evaluateJavaScript:@"testLog('123')" completionHandler:^(id _Nullable data, NSError * _Nullable error) {
        NSLog(@"%@",data);
    }];
}
// 接受js发送的消息
-(void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    NSLog(@"%@,%@",message.name,message.body);
    NSString *name = message.name;
    if ([name isEqualToString:@"event"]) {
        // 打开相册
        if ([message.body isEqualToString:@"打开相册"]) {
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.delegate = self;
            [self.navigationController presentViewController:imagePickerController animated:YES completion:nil];
        }else {
            
        }
    }
}
-(void)dealloc{
    // 必须和add一起出现，否则导致内存泄漏
    [self.userContentController removeScriptMessageHandlerForName:@"event"];
}
@end
