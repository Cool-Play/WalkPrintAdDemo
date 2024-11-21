//
//  AdsTestViewController.m
//  walkprint
//
//  Created by 小柚子 on 2024/11/20.
//

#import "AdsTestViewController.h"
#import <AppLovinSDK/AppLovinSDK.h>
@interface AdsTestViewController ()<MAAdViewAdDelegate, MAAdRevenueDelegate,MANativeAdDelegate>
@property (nonatomic, strong) MAAdView *adView;

@property (nonatomic, strong) MANativeAdLoader *nativeAdLoader;
@property (nonatomic, strong) MAAd *nativeAd;
@property (nonatomic, strong) UIView *nativeAdView;
@property (nonatomic, strong) MAAdView *bannerAdView; // Banner 广告视图
@end

@implementation AdsTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
//    [self createMRECAd];
//    [self createNativeAd];
    [self setupBannerAd];
}

- (void)setupBannerAd {
    NSString *Banner_AD_UNIT_ID = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"Banner_AD_UNIT_ID"];
    self.bannerAdView = [[MAAdView alloc] initWithAdUnitIdentifier:Banner_AD_UNIT_ID];
    self.bannerAdView.frame = CGRectMake(0, 100, self.view.frame.size.width, 50); // 在顶部显示
    self.bannerAdView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.bannerAdView];
    
    // 加载 Banner 广告
    [self.bannerAdView loadAd];
}

- (void)createNativeAd
{
  self.nativeAdLoader = [[MANativeAdLoader alloc] initWithAdUnitIdentifier: @"3db96cf9078275b0"];
  self.nativeAdLoader.nativeAdDelegate = self;
  [self.nativeAdLoader loadAd];
}

- (void)didLoadNativeAd:(MANativeAdView *)nativeAdView forAd:(MAAd *)ad
{
  // Clean up any pre-existing native ad to prevent memory leaks
  if ( self.nativeAd )
  {
    [self.nativeAdLoader destroyAd: self.nativeAd];
  }

  // Save ad for cleanup
  self.nativeAd = ad;

  if ( self.nativeAdView )
  {
    [self.nativeAdView removeFromSuperview];
  }

  // Add ad view to view
  self.nativeAdView = nativeAdView;
  [self.view addSubview: nativeAdView];
}

- (void)didFailToLoadNativeAdForAdUnitIdentifier:(NSString *)adUnitIdentifier withError:(MAError *)error
{
  // AppLovin recommends that you retry with exponentially higher delays up to a maximum delay
}

- (void)didClickNativeAd:(MAAd *)ad
{
  // Optional click callback
}


- (void)createMRECAd
{
  self.adView = [[MAAdView alloc] initWithAdUnitIdentifier: @"6875a8f6667278ea" adFormat: MAAdFormat.mrec];
  self.adView.delegate = self;

  // MREC width and height are 300 and 250 respectively, on iPhone and iPad
  CGFloat width = 300;
  CGFloat height = 250;

  // Center the MREC
  CGFloat x = self.view.center.x - 150;

    self.adView.frame = CGRectMake(x, x, width, height);

  // Set background or background color for MREC ads to be fully functional
    self.adView.backgroundColor = [UIColor grayColor];

  [self.view addSubview: self.adView];

  // Load the ad
  [self.adView loadAd];
}

#pragma mark - MAAdDelegate Protocol

- (void)didLoadAd:(MAAd *)ad {}

- (void)didFailToLoadAdForAdUnitIdentifier:(NSString *)adUnitIdentifier withError:(MAError *)error {}

- (void)didClickAd:(MAAd *)ad {}

- (void)didFailToDisplayAd:(MAAd *)ad withError:(MAError *)error {}

#pragma mark - MAAdViewAdDelegate Protocol

- (void)didExpandAd:(MAAd *)ad {}

- (void)didCollapseAd:(MAAd *)ad {}

#pragma mark - Deprecated Callbacks

- (void)didDisplayAd:(MAAd *)ad { /* DO NOT USE - THIS IS RESERVED FOR FULLSCREEN ADS ONLY AND WILL BE REMOVED IN A FUTURE SDK RELEASE */ }
- (void)didHideAd:(MAAd *)ad { /* DO NOT USE - THIS IS RESERVED FOR FULLSCREEN ADS ONLY AND WILL BE REMOVED IN A FUTURE SDK RELEASE */ }
@end
