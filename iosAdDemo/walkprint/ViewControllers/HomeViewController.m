//
//  HomeViewController.m
//  walkprint
//
//  Created by 小柚子 on 2024/12/5.
//

#import "HomeViewController.h"
#import "AIDrawViewController.h"
#import "WebPrintViewController.h"
#import "SearchImageViewController.h"
#import "AdsTestViewController.h"
#import <AppLovinSDK/AppLovinSDK.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <AdSupport/ASIdentifierManager.h>
#import "MRECAdViewController.h"
#import "BannerAdViewController.h"
#import "RewardViewController.h"
#import "APPOpenViewController.h"
#import "InterstitialAdViewController.h"
#import "NativeAdsViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
        
    // Title
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 50)];
    titleLabel.text = @"SZOS Demo";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:24];
    [self.view addSubview:titleLabel];
        
    // mrec Ad Button
    UIButton *mrecAdButton = [self createButtonWithTitle:@"MRECs 广告" action:@selector(goToMRECAd)];
    mrecAdButton.frame = CGRectMake(100, 150, self.view.frame.size.width - 200, 50);
    [self.view addSubview:mrecAdButton];
    
    // bammer Ad Button
    UIButton *bannerAdButton = [self createButtonWithTitle:@"Banner 广告" action:@selector(goToBannerAd)];
    bannerAdButton.frame = CGRectMake(100, 250, self.view.frame.size.width - 200, 50);
    [self.view addSubview:bannerAdButton];
    
    // Interstitial Ad Button
    UIButton *interAdButton = [self createButtonWithTitle:@"插屏 广告" action:@selector(goToInterstitialAd)];
    interAdButton.frame = CGRectMake(100, 350, self.view.frame.size.width - 200, 50);
    [self.view addSubview:interAdButton];
    
    // APPOpen Button
    UIButton *appOpenButton = [self createButtonWithTitle:@"开屏 广告" action:@selector(goToAppOpen)];
    appOpenButton.frame = CGRectMake(100, 450, self.view.frame.size.width - 200, 50);
    [self.view addSubview:appOpenButton];
    
    // reward ad Button
    UIButton *rewardAdsButton = [self createButtonWithTitle:@"激励 广告" action:@selector(goToRewardAd)];
    rewardAdsButton.frame = CGRectMake(100, 550, self.view.frame.size.width - 200, 50);
    [self.view addSubview:rewardAdsButton];
    
    // native ad Button
    UIButton *nativeAdsButton = [self createButtonWithTitle:@"Native 广告" action:@selector(goToNativeAd)];
    nativeAdsButton.frame = CGRectMake(100, 650, self.view.frame.size.width - 200, 50);
    [self.view addSubview:nativeAdsButton];
    
    // Integration Check Button
    UIButton *checkButton = [self createButtonWithTitle:@"集成检查" action:@selector(goToCheck)];
    checkButton.frame = CGRectMake(100, 750, self.view.frame.size.width - 200, 50);
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

- (void)goToBannerAd {
    BannerAdViewController *vc = [[BannerAdViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goToNativeAd {
    NativeAdsViewController *vc = [[NativeAdsViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goToMRECAd {
    MRECAdViewController *vc = [[MRECAdViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)goToRewardAd {
    RewardViewController *vc = [[RewardViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goToInterstitialAd {
    InterstitialAdViewController *vc = [[InterstitialAdViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goToAppOpen {
    APPOpenViewController *vc = [[APPOpenViewController alloc] init];
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
