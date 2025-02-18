//
//  MRECAdViewController.m
//  walkprint
//
//  Created by 小柚子 on 2025/2/18.
//

#import "MRECAdViewController.h"
#import <AppLovinSDK/AppLovinSDK.h>
@interface MRECAdViewController ()<MAAdViewAdDelegate>
@property (nonatomic, strong) MAAdView *adView;
@end

@implementation MRECAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"MRECs 广告";
    [self createMRECAd];
}

- (void)createMRECAd
{
    NSString *MERCs_AD_UNIT_ID = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"MRECs_AD_UNIT_ID"];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
