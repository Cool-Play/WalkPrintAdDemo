//
//  AIDrawViewController.m
//  walkprint
//
//  Created by 小柚子 on 2024/11/20.
//

#import "AIDrawViewController.h"
#import <AppLovinSDK/AppLovinSDK.h>

@interface AIDrawViewController ()<MAAdViewAdDelegate, MAAdRevenueDelegate>
@property (nonatomic, strong) UIButton *drawButton;      // 开始绘制按钮
@property (nonatomic, strong) UIImageView *imageView;    // 用于显示本地图片
@property (nonatomic, strong) MAAdView *adView;          // 广告视图
@property (nonatomic, strong) NSTimer *resetAdTimer;     // 定时器用于恢复广告
@property (nonatomic, assign) BOOL isShowingAd;          // 用于判断当前是否显示广告
@end

@implementation AIDrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"AI 绘图";

    // 初始化广告视图
    NSString *MERCs_AD_UNIT_ID = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"MERCs_AD_UNIT_ID"];
    self.adView = [[MAAdView alloc] initWithAdUnitIdentifier:MERCs_AD_UNIT_ID];
    self.adView.delegate = self;
    self.adView.revenueDelegate = self;
    self.adView.backgroundColor = UIColor.blackColor;

    CGFloat width = 300;
    CGFloat height = 250;
    CGFloat x = (self.view.frame.size.width - width) / 2;
    CGFloat y = self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;

    self.adView.frame = CGRectMake(x, y, width, height);
    [self.view addSubview:self.adView];
    [self.adView loadAd];
    self.isShowingAd = YES;

    // 初始化按钮
    self.drawButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.drawButton.frame = CGRectMake((self.view.frame.size.width - 200) / 2, CGRectGetMaxY(self.adView.frame) + 20, 200, 50);
    [self.drawButton setTitle:@"开始绘制" forState:UIControlStateNormal];
    [self.drawButton setBackgroundColor:[UIColor systemBlueColor]];
    [self.drawButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.drawButton addTarget:self action:@selector(startDrawing) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.drawButton];

    // 初始化本地图片视图（覆盖广告视图）
    self.imageView = [[UIImageView alloc] initWithFrame:self.adView.frame];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.hidden = YES;  // 默认隐藏
    self.imageView.image = [UIImage imageNamed:@"joker2"]; // 替换为本地图片名称
    [self.view addSubview:self.imageView];
}

#pragma mark - 按钮点击事件

- (void)startDrawing {
    if (!self.isShowingAd) return;

    // 停止当前的广告显示，展示本地图片
    self.isShowingAd = NO;
    self.adView.hidden = YES;
    self.imageView.hidden = NO;

    // 开启定时器，6秒后恢复广告
    [self.resetAdTimer invalidate]; // 确保只有一个定时器在运行
    self.resetAdTimer = [NSTimer scheduledTimerWithTimeInterval:6.0
                                                         target:self
                                                       selector:@selector(resetToAd)
                                                       userInfo:nil
                                                        repeats:NO];
}

#pragma mark - 恢复广告

- (void)resetToAd {
    self.isShowingAd = YES;
    self.adView.hidden = NO;
    self.imageView.hidden = YES;
}

#pragma mark - MAAdDelegate Protocol

- (void)didLoadAd:(MAAd *)ad {
    NSLog(@"Ad loaded successfully.");
}

- (void)didFailToLoadAdForAdUnitIdentifier:(NSString *)adUnitIdentifier withError:(MAError *)error {
    NSLog(@"Failed to load ad: %@", error.message);
}

- (void)didClickAd:(MAAd *)ad {
    NSLog(@"Ad clicked.");
}

- (void)didFailToDisplayAd:(MAAd *)ad withError:(MAError *)error {
    NSLog(@"Failed to display ad: %@", error.message);
}

#pragma mark - MAAdViewAdDelegate Protocol

- (void)didExpandAd:(MAAd *)ad {}

- (void)didCollapseAd:(MAAd *)ad {}

#pragma mark - MAAdRevenueDelegate Protocol

- (void)didPayRevenueForAd:(MAAd *)ad {
    NSLog(@"Ad revenue paid.");
}

@end
