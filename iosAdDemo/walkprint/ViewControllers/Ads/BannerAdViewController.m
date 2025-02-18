//
//  BannerAdViewController.m
//  walkprint
//
//  Created by 小柚子 on 2025/2/18.
//

#import "BannerAdViewController.h"
#import <AppLovinSDK/AppLovinSDK.h>
@interface BannerAdViewController ()<MAAdViewAdDelegate>
@property (nonatomic, strong) MAAdView *bannerAdView; // Banner 广告视图
@end

@implementation BannerAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Banner 广告";
    [self setupBannerAd];
}

- (void)setupBannerAd {
    NSString *Banner_AD_UNIT_ID = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"Banner_AD_UNIT_ID"];
    self.bannerAdView = [[MAAdView alloc] initWithAdUnitIdentifier:Banner_AD_UNIT_ID];
    self.bannerAdView.frame = CGRectMake(0, 320, self.view.frame.size.width, 300); // 在顶部显示
    self.bannerAdView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.bannerAdView];
    
    // 加载 Banner 广告
    [self.bannerAdView loadAd];
}

#pragma mark - MAAdDelegate Protocol

- (void)didLoadAd:(MAAd *)ad {}

- (void)didFailToLoadAdForAdUnitIdentifier:(NSString *)adUnitIdentifier withError:(MAError *)error {}

- (void)didClickAd:(MAAd *)ad {}

- (void)didFailToDisplayAd:(MAAd *)ad withError:(MAError *)error {}

#pragma mark - MAAdViewAdDelegate Protocol

- (void)didExpandAd:(MAAd *)ad {}

- (void)didCollapseAd:(MAAd *)ad {}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
