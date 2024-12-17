//
//  AppDelegate.m
//  walkprint
//
//  Created by 小柚子 on 2024/12/5.
//

#import "AppDelegate.h"
#import <AppLovinSDK/AppLovinSDK.h>
#import "HomeViewController.h"
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <AdSupport/ASIdentifierManager.h>
#import <GoogleMobileAds/GoogleMobileAds.h>
@interface AppDelegate ()
@property (nonatomic, copy) NSString *idfaStr;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [ALPrivacySettings setHasUserConsent: YES];
    // 获取 Info.plist 中的配置项
    NSString * SDK_KEY = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SDK_KEY"];
    // Create the initialization configuration
    ALSdkInitializationConfiguration *initConfig = [ALSdkInitializationConfiguration configurationWithSdkKey: SDK_KEY builderBlock:^(ALSdkInitializationConfigurationBuilder *builder) {
      builder.mediationProvider = ALMediationProviderMAX;
        // Enable test mode by default for the current device.
        NSString *currentIDFV = UIDevice.currentDevice.identifierForVendor.UUIDString;
        if ( currentIDFV.length > 0 )
        {
            builder.testDeviceAdvertisingIdentifiers = @[currentIDFV];//上线前需要注释掉这段代码
        }
    }];


    // Configure the SDK settings if needed before or after SDK initialization.
    ALSdkSettings *settings = [ALSdk shared].settings;
//    settings.userIdentifier = @"«user-ID»";
//    [settings setExtraParameterForKey: @"uid2_token" value: @"«token-value»"];

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

    UIColor *barTintColor = [UIColor colorWithRed: 10/255.0 green: 131/255.0 blue: 170/255.0 alpha: 1.0];
    if ( @available(iOS 15.0, *) )
    {
        UINavigationBarAppearance *navigationBarAppearance = [[UINavigationBarAppearance alloc] init];
        [navigationBarAppearance configureWithOpaqueBackground];
        navigationBarAppearance.backgroundColor = barTintColor;
        navigationBarAppearance.titleTextAttributes = @{NSForegroundColorAttributeName : UIColor.whiteColor};
        [UINavigationBar appearance].standardAppearance = navigationBarAppearance;
        [UINavigationBar appearance].scrollEdgeAppearance = navigationBarAppearance;
        [UINavigationBar appearance].tintColor = UIColor.whiteColor;
    }
    else
    {
        // Fallback on earlier versions
        [UINavigationBar appearance].barTintColor = barTintColor;
        [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName : UIColor.whiteColor};
        [UINavigationBar appearance].tintColor = UIColor.whiteColor;
    }
    return YES;
}

- (void)checkoutIDFA{
    if (@available(iOS 14, *)) {
            // iOS14及以上版本需要先请求权限
            [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
                // 获取到权限后，依然使用老方法获取idfa
                if (status == ATTrackingManagerAuthorizationStatusAuthorized) {
                    NSString *idfa = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
                    NSLog(@"**********************************");
                    NSLog(@"%@",idfa);
                    self->_idfaStr = idfa;
                } else {
                         NSLog(@"请在设置-隐私-跟踪中允许App请求跟踪");
                }
            }];
        } else {
            // iOS14以下版本依然使用老方法
            // 判断在设置-隐私里用户是否打开了广告跟踪
            if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) {
                NSString *idfa = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
                NSLog(@"%@",idfa);
                self->_idfaStr = idfa;
            } else {
                NSLog(@"请在设置-隐私-广告中打开广告跟踪功能");
            }
        }
}
#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
