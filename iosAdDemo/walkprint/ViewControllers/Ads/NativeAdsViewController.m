//
//  NativeAdsViewController.m
//  walkprint
//
//  Created by 小柚子 on 2025/2/18.
//

#import "NativeAdsViewController.h"
#import <AppLovinSDK/AppLovinSDK.h>
@interface NativeAdsViewController ()<MAAdViewAdDelegate,MANativeAdDelegate>
@property (nonatomic, strong) MAAdView *adView;

@property (nonatomic, strong) MANativeAdLoader *nativeAdLoader;
@property (nonatomic, strong) MAAd *nativeAd;
@property (nonatomic, strong) UIView *nativeAdView;
@end

@implementation NativeAdsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Native 广告";
    [self createNativeAd];
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
