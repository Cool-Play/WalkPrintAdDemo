# 0. 前置
20241209
以下是Coolplay广告SDK集成文档，请我们客户的开发人员参考此文档集成。同时开发人员在启动适配前，请通过商务先告知我方App的包名，我们将为该App提供集成广告所需的如下ID、sdkKey、apiKey、nativeId、mrecId和bannerId等，如果需要更多广告类型，也请通过商务联系我们。

# 1. 下载最新SDK

https://developers.applovin.com/en/max/ios/overview/manual-integration/

使用pod 安装sdk：
/*
# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'

target 'walkprint' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for walkprint
  pod 'AppLovinMediationGoogleAdapter'
  pod 'AppLovinSDK'
  pod 'Google-Mobile-Ads-SDK'
  pod 'GoogleUserMessagingPlatform'
end
*/
# 2. AppDelegate

```
初始化SDK
    NSString * SDK_KEY = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SDK_KEY"];
    // Create the initialization configuration
    ALSdkInitializationConfiguration *initConfig = [ALSdkInitializationConfiguration configurationWithSdkKey: SDK_KEY builderBlock:^(ALSdkInitializationConfigurationBuilder *builder) {
      builder.mediationProvider = ALMediationProviderMAX;
      builder.segmentCollection = [MASegmentCollection segmentCollectionWithBuilderBlock:^(MASegmentCollectionBuilder *builder) {
          [builder addSegment: [[MASegment alloc] initWithKey: @(849) values: @[@(1), @(3)]]];
      }];
    }];

    
    // Configure the SDK settings if needed before or after SDK initialization.
    ALSdkSettings *settings = [ALSdk shared].settings;
    settings.userIdentifier = @"«user-ID»";
    [settings setExtraParameterForKey: @"uid2_token" value: @"«token-value»"];

    // Note: you may also set these values in your Info.plist
    settings.termsAndPrivacyPolicyFlowSettings.enabled = YES;
    //注意以下的隐私协议和条款url需要在plist中换成自己的url
    // 获取 Info.plist 中的配置项
    NSString * termsOfServiceURL = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"TermsOfServiceURL"];
    NSLog(@"Current termsOfServiceURL is: %@", termsOfServiceURL);
    NSString * privacyPolicyURL = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"PrivacyPolicyURL"];
    NSLog(@"Current privacyPolicyURL is: %@", privacyPolicyURL);
    settings.termsAndPrivacyPolicyFlowSettings.termsOfServiceURL = [NSURL URLWithString: termsOfServiceURL];
    settings.termsAndPrivacyPolicyFlowSettings.privacyPolicyURL = [NSURL URLWithString: privacyPolicyURL];

    // Initialize the SDK with the configuration
    [[ALSdk shared] initializeWithConfiguration: initConfig completionHandler:^(ALSdkConfiguration *sdkConfig) {
      // Start loading ads
    }];
    
    //注：SD_KEY 、TermsOfServiceURL、PrivacyPolicyURL等都在plist文件中配置了，可根据实际情况进行替换尤其是PrivacyPolicyURL和TermsOfServiceURL
//如果初始化sdk时设置了测试模式 例如如下代码
//builder.testDeviceAdvertisingIdentifiers = @[yourIDFA];

 需要在上线前改为正式模式 即注释掉该行代码
```

# 3. banner、MREC 广告

```
配置banner 广告
   #import "ExampleViewController.h"
#import <AppLovinSDK/AppLovinSDK.h>

@interface ExampleViewController()<MAAdViewAdDelegate>
@property (nonatomic, strong) MAAdView *adView;
@end

@implementation ExampleViewController

- (void)createBannerAd
{
  self.adView = [[MAAdView alloc] initWithAdUnitIdentifier: @"«ad-unit-ID»"];
  self.adView.delegate = self;

  // Banner height on iPhone and iPad is 50 and 90, respectively
  CGFloat height = (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad) ? 90 : 50;

  // Stretch to the width of the screen for banners to be fully functional
  CGFloat width = CGRectGetWidth(UIScreen.mainScreen.bounds);

  self.adView.frame = CGRectMake(x, y, width, height);

  // Set background or background color for banners to be fully functional
  self.adView.backgroundColor = «background-color»;

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

MRESc广告
#import "ExampleViewController.h"
#import <AppLovinSDK/AppLovinSDK.h>

@interface ExampleViewController()<MAAdViewAdDelegate>
@property (nonatomic, strong) MAAdView *adView;
@end

@implementation ExampleViewController

- (void)createMRECAd
{
  self.adView = [[MAAdView alloc] initWithAdUnitIdentifier: @"«ad-unit-ID»" adFormat: MAAdFormat.mrec];
  self.adView.delegate = self;

  // MREC width and height are 300 and 250 respectively, on iPhone and iPad
  CGFloat width = 300;
  CGFloat height = 250;

  // Center the MREC
  CGFloat x = self.view.center.x - 150;

  self.adView.frame = CGRectMake(x, y, width, height);

  // Set background or background color for MREC ads to be fully functional
  self.adView.backgroundColor = «background-color»;

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

native广告
@interface ExampleViewController()<MANativeAdDelegate>

@property (nonatomic, weak) IBOutlet UIView *nativeAdContainerView;

@property (nonatomic, strong) MANativeAdLoader *nativeAdLoader;
@property (nonatomic, strong) MAAd *nativeAd;
@property (nonatomic, strong) UIView *nativeAdView;

@end

@implementation ExampleViewController

- (void)createNativeAd
{
  self.nativeAdLoader = [[MANativeAdLoader alloc] initWithAdUnitIdentifier: @"«ad-unit-ID»"];
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
  [self.nativeAdContainerView addSubview: nativeAdView];

  // Set to false if modifying constraints after adding the ad view to your layout
  self.nativeAdContainerView.translatesAutoresizingMaskIntoConstraints = NO;

  // Set ad view to span width and height of container and center the ad
  [self.nativeAdContainerView addConstraint: [NSLayoutConstraint constraintWithItem: nativeAdView
                                                                          attribute: NSLayoutAttributeWidth
                                                                          relatedBy: NSLayoutRelationEqual
                                                                             toItem: self.nativeAdContainerView
                                                                          attribute: NSLayoutAttributeWidth
                                                                         multiplier: 1
                                                                           constant: 0]];
  [self.nativeAdContainerView addConstraint: [NSLayoutConstraint constraintWithItem: nativeAdView
                                                                          attribute: NSLayoutAttributeHeight
                                                                          relatedBy: NSLayoutRelationEqual
                                                                             toItem: self.nativeAdContainerView
                                                                          attribute: NSLayoutAttributeHeight
                                                                         multiplier: 1
                                                                           constant: 0]];
  [self.nativeAdContainerView addConstraint: [NSLayoutConstraint constraintWithItem: nativeAdView
                                                                          attribute: NSLayoutAttributeCenterX
                                                                          relatedBy: NSLayoutRelationEqual
                                                                             toItem: self.nativeAdContainerView
                                                                          attribute: NSLayoutAttributeCenterX
                                                                         multiplier: 1
                                                                           constant: 0]];
  [self.nativeAdContainerView addConstraint: [NSLayoutConstraint constraintWithItem: nativeAdView
                                                                          attribute: NSLayoutAttributeCenterY
                                                                          relatedBy: NSLayoutRelationEqual
                                                                             toItem: self.nativeAdContainerView
                                                                          attribute: NSLayoutAttributeCenterY
                                                                         multiplier: 1
                                                                           constant: 0]];
}

- (void)didFailToLoadNativeAdForAdUnitIdentifier:(NSString *)adUnitIdentifier withError:(MAError *)error
{
  // AppLovin recommends that you retry with exponentially higher delays up to a maximum delay
}

- (void)didClickNativeAd:(MAAd *)ad
{
  // Optional click callback
}

@end
```

# 4. 隐私合规

隐私合规具体规范请参照 https://developers.applovin.com/en/max/ios/overview/terms-and-privacy-policy-flow/

