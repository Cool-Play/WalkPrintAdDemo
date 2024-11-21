//
//  HomeViewController.m
//  walkprint
//
//  Created by 小柚子 on 2024/11/20.
//

#import "HomeViewController.h"
#import "AIDrawViewController.h"
#import "WebPrintViewController.h"
#import "SearchImageViewController.h"
#import "AdsTestViewController.h"
#import <AppLovinSDK/AppLovinSDK.h>
@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
        
    // Title
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 50)];
    titleLabel.text = @"WorkprintDemo";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:24];
    [self.view addSubview:titleLabel];
    
    // AI Draw Button
    UIButton *aiDrawButton = [self createButtonWithTitle:@"AI绘图" action:@selector(goToAIDraw)];
    aiDrawButton.frame = CGRectMake(100, 200, self.view.frame.size.width - 200, 50);
    [self.view addSubview:aiDrawButton];
    
    // Web Print Button
    UIButton *webPrintButton = [self createButtonWithTitle:@"网页打印" action:@selector(goToWebPrint)];
    webPrintButton.frame = CGRectMake(100, 300, self.view.frame.size.width - 200, 50);
    [self.view addSubview:webPrintButton];
    
    // Search Image Button
    UIButton *searchImageButton = [self createButtonWithTitle:@"搜图" action:@selector(goToSearchImage)];
    searchImageButton.frame = CGRectMake(100, 400, self.view.frame.size.width - 200, 50);
    [self.view addSubview:searchImageButton];
    
//    // Ads test Button
//    UIButton *testAdsButton = [self createButtonWithTitle:@"广告测试" action:@selector(goToTestAds)];
//    testAdsButton.frame = CGRectMake(100, 500, self.view.frame.size.width - 200, 50);
//    [self.view addSubview:testAdsButton];
    
    // Integration Check Button
    UIButton *checkButton = [self createButtonWithTitle:@"集成检查" action:@selector(goToCheck)];
    checkButton.frame = CGRectMake(100, 500, self.view.frame.size.width - 200, 50);
    [self.view addSubview:checkButton];
}

- (UIButton *)createButtonWithTitle:(NSString *)title action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:title forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor systemGrayColor]];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.layer.cornerRadius = 10;
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)goToAIDraw {
    AIDrawViewController *vc = [[AIDrawViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goToWebPrint {
    WebPrintViewController *vc = [[WebPrintViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goToSearchImage {
    SearchImageViewController *vc = [[SearchImageViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goToTestAds {
    AdsTestViewController *vc = [[AdsTestViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goToCheck {
    [[ALSdk shared] showMediationDebugger];
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
