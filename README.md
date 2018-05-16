## iOS 和 H5的交互

### 前言

现在web前端发展越来越快，为了追求应用的快速开发和迭代，许多产品都会选择混合开发，在手机端嵌入web页面，那么这就会导致一个问题，
原生代码怎么和js交互？那么下边我们共同学习一下iOS和web是怎么交互的。


### 概述

1. 首先我们要知道JavaScriptCore这个框架，这个框架是在iOS7之后，apple官方才加入这个框架。
2. UIWebView和WKWebView的使用，在iOS8之后WKWebView在iOS开发中才出现，而UIWebView不论在哪个iOS版本都可以使用。

我们还需要先了解一下JavaScriptCore框架的基本使用
> [基本使用](https://www.jianshu.com/p/a329cd4a67ee)

### UIWebView和js的交互

iOS7之前，我们只能使用`UIWebview`的`stringByEvaluatingJavaScriptFromString`方法执行js代码，想要js调用OC代码我们只能通过拦截的方式，代码如下：

```
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
```

在iOS7之后我们可以使用JavaScriptCore进行和js的通信

效果图

![](https://github.com/liuboshuo/WebViewInteractive/blob/master/images/webview.gif)

先创建一个JSProtocol协议，遵循JSExport协议，添加一个打印方法

``` 

@protocol JSProtocol <JSExport>

-(void)print:(NSString *)str;

@end

```
创建一个MyJSObject对象，遵循JSProtocol，实现print方法

``` 
-(void)print:(NSString *)str
{
    NSLog(@"log=%@",str);
}

```

然后当web页面加载完毕的时候，通过`[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"]`获取`JSContext`对象
OC代码如下:

``` 
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
```
这里为js增加了log方法和changeLabel方法，当js调用log或者changeLabel方法时会执行block内的代码，当传入相应的参数，就可以达到js想OC传递参数和交互。

### WKWebView和js的交互

效果图

![](https://github.com/liuboshuo/WebViewInteractive/blob/master/images/wkwebview.gif)

WKWebView是iOS8之后才有，所以如果你的app最低支持iOS可以尽情使用。

要想WKWebView和js交互，需要用到`WKUserContentController`，下面我们来看一下如何初始化WKWebView

``` 
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
```

首先我们先创建`WKWebViewConfiguration`配置对象，然后创建`WKUserContentController`对象，然后我们使用`WKUserContentController`的`addScriptMessageHandler`
注册要接收消息的名称，这样我们才可以在js代码中通过`window.webkit.messageHandlers.名称.postMessage`发送消息，那么OC怎么接收消息呢？

下边是接收消息的代理
```
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
```
一定要记得在dealloc方法移除监听名称
```
[self.userContentController removeScriptMessageHandlerForName:@"event"];
```

### 源码

>[源码](https://github.com/liuboshuo/WebViewInteractive)


这里边有两个工程，一个是iOS工程，一个是node工程，用来创建一个web服务器模拟加载远程的web项目

WebViewInteractiveIOS 目录是iOS
WebViewInteractiveWeb web项目


#### 运行

iOS运行这里不多赘述，需要注意的是把webview加载的ip换成本机ip

web运行，执行如下命令，前提是装了node环境的机器

``` 
cd WebViewInteractiveWeb
npm install 
npm run server
``` 




