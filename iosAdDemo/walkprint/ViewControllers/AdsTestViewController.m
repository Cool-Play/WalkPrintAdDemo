//
//  AdsTestViewController.m
//  walkprint
//
//  Created by 小柚子 on 2024/12/5.
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
    [self createMRECAd];
    [self createNativeAd];
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

- (void)createNativeAd
{
    NSString *Native_AD_UNIT_ID = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"Native_AD_UNIT_ID"];
    self.nativeAdLoader = [[MANativeAdLoader alloc] initWithAdUnitIdentifier: Native_AD_UNIT_ID];//3db96cf9078275b0
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
    NSLog(@"load native ads error:%@",error.message);
}

- (void)didClickNativeAd:(MAAd *)ad
{
    // Optional click callback
}


- (void)createMRECAd
{
    NSString *MERCs_AD_UNIT_ID = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"MERCs_AD_UNIT_ID"];
    self.adView = [[MAAdView alloc] initWithAdUnitIdentifier: MERCs_AD_UNIT_ID adFormat: MAAdFormat.mrec];
    self.adView.delegate = self;
    
    // MREC width and height are 300 and 250 respectively, on iPhone and iPad
    CGFloat width = 300;
    CGFloat height = 250;
    
    // Center the MREC
    CGFloat x = self.view.center.x - 150;
    CGFloat y = self.view.frame.size.height - 150 - height;
    self.adView.frame = CGRectMake(x, y, width, height);
    
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
