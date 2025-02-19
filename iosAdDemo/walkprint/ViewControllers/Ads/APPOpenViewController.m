//
//  APPOpenViewController.m
//  walkprint
//
//  Created by 小柚子 on 2025/2/14.
//

#import "APPOpenViewController.h"
#import <AppLovinSDK/AppLovinSDK.h>

@interface APPOpenViewController ()<MAAdDelegate>
@property(nonatomic,strong)UILabel *tipsLbl;
@property (nonatomic, strong) MAAppOpenAd *appOpenAd;
@end

@implementation APPOpenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"APP开屏广告";
    
    [self initViews];
    
    NSString *APPOPEN_UNIT_ID = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"APPOPEN_UNIT_ID"];
    self.appOpenAd = [[MAAppOpenAd alloc] initWithAdUnitIdentifier:APPOPEN_UNIT_ID];
    
    self.appOpenAd.delegate = self;
    
    // Load the first ad
    [self.appOpenAd loadAd];
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
    NSLog(@"开始展示开屏广告");
    if ( [self.appOpenAd isReady] )
    {
        [self.appOpenAd showAd];
    }
}

#pragma mark - MAAdDelegate Protocol

- (void)didLoadAd:(MAAd *)ad
{
    // App Open ad is ready to be shown. '[self.appOpenAd isReady]' will now return 'YES'
    self.tipsLbl.text = @"load Ad success";
    NSLog(@"load Ad success");
}

- (void)didFailToLoadAdForAdUnitIdentifier:(NSString *)adUnitIdentifier withError:(MAError *)error
{
    self.tipsLbl.text = [NSString stringWithFormat:@"fail to load ad unit id:%@ error:%@",adUnitIdentifier,error.message];
    NSLog(@"%@",[NSString stringWithFormat:@"fail to load ad unit id:%@ error:%@",adUnitIdentifier,error.message]);
}

- (void)didDisplayAd:(MAAd *)ad
{
    self.tipsLbl.text = @"display ad";
    NSLog(@"display ad");
}

- (void)didClickAd:(MAAd *)ad
{
    self.tipsLbl.text = @"you click ad!!!";
    NSLog(@"you click ad!!!");
}

- (void)didHideAd:(MAAd *)ad
{
    // App Open ad is hidden. Pre-load the next ad
    [self.appOpenAd loadAd];
}

- (void)didFailToDisplayAd:(MAAd *)ad withError:(MAError *)error
{
    // App Open ad failed to display. We recommend loading the next ad
    [self.appOpenAd loadAd];
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
