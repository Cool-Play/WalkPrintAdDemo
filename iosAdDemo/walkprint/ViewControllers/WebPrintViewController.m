//
//  WebPrintViewController.m
//  walkprint
//
//  Created by 小柚子 on 2024/11/20.
//

#import "WebPrintViewController.h"
#import <WebKit/WebKit.h>

@interface WebPrintViewController () <WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIActivityIndicatorView *loadingIndicator;
@property (nonatomic, strong) UIBarButtonItem *printButton;
@property (nonatomic, copy)NSString* printUrl;
@end

@implementation WebPrintViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"网页打印";
    // 获取 Info.plist 中的配置项
    _printUrl = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"PrintURL"];
    // 打印出读取到的值
    NSLog(@"printUrl: %@", _printUrl);
    if (_printUrl==NULL) {
        _printUrl = @"https://www.baidu.com/";
    }
    [self setupWebView];
    [self setupLoadingIndicator];
    [self loadWebPage];
    [self setupNavigationBar];
}

#pragma mark - UI Setup
- (void)setupWebView {
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    self.webView.navigationDelegate = self;
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.webView];
}

- (void)setupLoadingIndicator {
    self.loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
    self.loadingIndicator.center = self.view.center;
    self.loadingIndicator.hidesWhenStopped = YES;
    [self.view addSubview:self.loadingIndicator];
}

- (void)setupNavigationBar {
    self.printButton = [[UIBarButtonItem alloc] initWithTitle:@"打印"
                                                        style:UIBarButtonItemStylePlain
                                                       target:self
                                                       action:@selector(printWebPage)];
    self.navigationItem.rightBarButtonItem = self.printButton;
}

#pragma mark - Load Web Page
- (void)loadWebPage {
    NSURL *url = [NSURL URLWithString:_printUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

#pragma mark - WebView Navigation Delegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [self.loadingIndicator startAnimating];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self.loadingIndicator stopAnimating];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self.loadingIndicator stopAnimating];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"加载失败"
                                                                   message:error.localizedDescription
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *retryAction = [UIAlertAction actionWithTitle:@"重试"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action) {
        [self loadWebPage];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    [alert addAction:retryAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Print Functionality
- (void)printWebPage {
    // 获取当前网页的打印格式
    UIViewPrintFormatter *formatter = [self.webView viewPrintFormatter];

    // 设置打印信息
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputGeneral;
    printInfo.jobName = self.webView.URL.absoluteString;

    // 创建打印控制器
    UIPrintInteractionController *printController = [UIPrintInteractionController sharedPrintController];
    printController.printInfo = printInfo;
    printController.printFormatter = formatter;

    // 显示打印选项
    [printController presentAnimated:YES completionHandler:^(UIPrintInteractionController * _Nonnull printInteractionController, BOOL completed, NSError * _Nullable error) {
        if (completed) {
            NSLog(@"打印完成");
        } else if (error) {
            NSLog(@"打印失败: %@", error.localizedDescription);
        }
    }];
}

@end
