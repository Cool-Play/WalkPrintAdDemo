//
//  InterstitialAdViewController.m
//  walkprint
//
//  Created by 小柚子 on 2025/2/18.
//

#import "InterstitialAdViewController.h"
#import <AppLovinSDK/AppLovinSDK.h>
@interface InterstitialAdViewController ()<MAAdDelegate>
@property (nonatomic, strong) MAInterstitialAd *interstitialAd;
@property (nonatomic, assign) NSInteger retryAttempt;
@property(nonatomic,strong)UILabel *tipsLbl;
@end

@implementation InterstitialAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"插屏广告";
            
    [self initViews];
    
    NSString *Interstitial_UNIT_ID = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"Interstitial_UNIT_ID"];
    self.interstitialAd = [[MAInterstitialAd alloc] initWithAdUnitIdentifier:Interstitial_UNIT_ID];
    self.interstitialAd.delegate = self;
    
    // Load the first ad
    [self.interstitialAd loadAd];
}

- (void)initViews{
    // 获取屏幕的宽度
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    self.tipsLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 120, screenWidth, 200)];
    self.tipsLbl.font = [UIFont systemFontOfSize:20];
    self.tipsLbl.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.tipsLbl];
    
    //底部展示广告按钮
    UIButton *showButton = [self createButtonWithTitle:@"show" action:@selector(showAd)];
    showButton.frame = CGRectMake((screenWidth - 100)/2, screenHeight - 50 - 20, 100, 50);
    [self.view addSubview:showButton];
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

- (void)showAd {
    NSLog(@"开始展示插屏广告");
    if ( [self.interstitialAd isReady] )
    {
        [self.interstitialAd showAd];
    }
}

#pragma mark - MAAdDelegate Protocol

- (void)didLoadAd:(MAAd *)ad
{
    // Interstitial ad is ready to be shown. '[self.interstitialAd isReady]' will now return 'YES'
    
    self.tipsLbl.text = @"load the ad!";
    NSLog(@"load the ad!");
    // Reset retry attempt
    self.retryAttempt = 0;
}

- (void)didFailToLoadAdForAdUnitIdentifier:(NSString *)adUnitIdentifier withError:(MAError *)error
{
    // Interstitial ad failed to load. We recommend retrying with exponentially higher delays up to a maximum delay (in this case 64 seconds).
    self.tipsLbl.text = [NSString stringWithFormat:@"failed to load ad unit id:%@ error:%@",adUnitIdentifier,error.message];
    NSLog(@"%@",[NSString stringWithFormat:@"failed to load ad unit id:%@ error:%@",adUnitIdentifier,error.message]);
    self.retryAttempt++;
    NSInteger delaySec = pow(2, MIN(6, self.retryAttempt));
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delaySec * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self.interstitialAd loadAd];
    });
}

- (void)didDisplayAd:(MAAd *)ad
{
    self.tipsLbl.text = @"it will display the ad!";
    NSLog(@"it will display the ad!");
}

- (void)didClickAd:(MAAd *)ad
{
    self.tipsLbl.text = @"you just clicked the ad!";
    NSLog(@"you just clicked the ad!");
}

- (void)didHideAd:(MAAd *)ad
{
    self.tipsLbl.text = @"you will hide ad!";
    NSLog(@"you will hide ad!");
    // Interstitial ad is hidden. Pre-load the next ad
    [self.interstitialAd loadAd];
}

- (void)didFailToDisplayAd:(MAAd *)ad withError:(MAError *)error
{
    // Interstitial ad failed to display. We recommend loading the next ad
    [self.interstitialAd loadAd];
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
