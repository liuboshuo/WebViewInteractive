#import "WebViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "MyJSObject.h"

@interface WebViewController ()<UIWebViewDelegate>

@property(nonatomic,weak)UIWebView *webView;
@property(nonatomic,strong)JSContext *context;
@property(nonatomic , weak)UILabel *text;
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIWebView *webView = [[UIWebView alloc] init];
    webView.frame = CGRectMake(0, 64, self.view.frame.size.width, 300);
    // 此处替换你本机的ip
    NSURL *url = [NSURL URLWithString:@"http://172.26.233.156:3001/webView"];
    webView.delegate = self;
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [webView loadRequest:request];
    [self.view addSubview:webView];
    self.webView = webView;
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 365, 320, 20);
    [self.view addSubview:label];
    label.textColor = [UIColor blackColor];
    label.text = @"我是native的Label哦";
    label.textAlignment = NSTextAlignmentCenter;
    self.text = label;
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(100, 390, 100, 50)];
    [btn1 setTitleColor:[UIColor blackColor]  forState:UIControlStateNormal];
    [btn1 setTitle:@"oc调用js" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(btn1Tap) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    self.view.backgroundColor = [UIColor whiteColor];
}
-(void)btn1Tap
{
    [self.webView stringByEvaluatingJavaScriptFromString:@"printLog('123')"];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    NSLog(@"context=%@",context);
    self.context = context;
    // 为js增加log方法
    context[@"log"] = ^(NSString *str){
        NSLog(@"log:%@",str);
    };
    // 为js增加obj对象 遵循该协议jsExport
    MyJSObject *obj = [[MyJSObject alloc] init];
    context[@"obj"] = obj;
    // 为js增加changeLabel的函数
    context[@"changeLabel"] = ^(NSString *str){
        self.text.text = str;
    };
    
    context.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        NSLog(@"异常%@",exception);
    };
    
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *url = request.URL.absoluteString;
    if ([url rangeOfString:@"myProtocol://"
         ].location != NSNotFound) {
        NSLog(@"拦截成功了");
        return NO;
    }
    return YES;
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"%@",error);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
