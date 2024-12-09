#import "SearchImageViewController.h"
#import <AppLovinSDK/AppLovinSDK.h>

@interface SearchImageViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate, MANativeAdDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *imageData;

@property (nonatomic, strong) MANativeAdLoader *nativeAdLoader;
@property (nonatomic, strong) NSMutableArray<UIView *> *nativeAdViews; // 存储广告视图

@property (nonatomic, strong) MAAdView *bannerAdView; // Banner 广告视图
@property (nonatomic, strong) MAAdView *mrecAdView; // MREC 广告视图

@end

@implementation SearchImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"搜索图片";
    self.imageData = [NSMutableArray array];
    self.nativeAdViews = [NSMutableArray array]; // 初始化广告视图数组
    
    [self setupBannerAd];    // 添加顶部 Banner 广告
    [self setupSearchBar];
    [self setupCollectionView];
    [self setupMRECAd];      // 添加底部 MREC 广告
    [self loadNativeAd];
}

// MARK: - Setup UI

- (void)setupBannerAd {
    NSString *Banner_AD_UNIT_ID = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"Banner_AD_UNIT_ID"];
    self.bannerAdView = [[MAAdView alloc] initWithAdUnitIdentifier:Banner_AD_UNIT_ID];
    self.bannerAdView.frame = CGRectMake(0, 144, self.view.frame.size.width, 120); // 在顶部显示
    self.bannerAdView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.bannerAdView];
    
    // 加载 Banner 广告
    [self.bannerAdView loadAd];
}

- (void)setupSearchBar {
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 94, self.view.frame.size.width, 50)];
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"输入搜索内容";
    [self.view addSubview:self.searchBar];
}

- (void)setupCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(10, 0, 10, 0);
    
    // 动态计算 itemSize，以便在不同屏幕尺寸下显示三列
    CGFloat screenWidth = self.view.frame.size.width;
    CGFloat itemSize = (screenWidth - 40) / 3; // 每行3个item
    layout.itemSize = CGSizeMake(itemSize, itemSize);
    NSLog(@"item size height: %lf width :%lf",itemSize,itemSize);
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 144, self.view.frame.size.width, self.view.frame.size.height - 194) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"ImageCell"];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"AdCell"];
    [self.view addSubview:self.collectionView];
    self.collectionView.hidden = YES; // 默认隐藏图片列表
}

- (void)setupMRECAd {
    NSString *MERCs_AD_UNIT_ID = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"MERCs_AD_UNIT_ID"];
    self.mrecAdView = [[MAAdView alloc] initWithAdUnitIdentifier:MERCs_AD_UNIT_ID];
    self.mrecAdView.frame = CGRectMake(0, self.view.frame.size.height - 250, self.view.frame.size.width, 250);
    self.mrecAdView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.mrecAdView];
    
    // 加载 MREC 广告
    [self.mrecAdView loadAd];
}

// MARK: - Load Native Ad

- (void)loadNativeAd {
    NSString *Native_AD_UNIT_ID = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"Native_AD_UNIT_ID"];
    self.nativeAdLoader = [[MANativeAdLoader alloc] initWithAdUnitIdentifier:Native_AD_UNIT_ID];
    self.nativeAdLoader.nativeAdDelegate = self;
    
    for (int i = 0; i < 5; i++) { // 加载多个广告视图
        [self.nativeAdLoader loadAd];
    }
}

- (void)didLoadNativeAd:(MANativeAdView *)nativeAdView forAd:(MAAd *)ad {
    // 保存加载成功的广告视图到数组中
    [self.nativeAdViews addObject:nativeAdView];
    [self.collectionView reloadData];
}

// MARK: - CollectionView Delegate & DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ((indexPath.item + 1) % 6 == 0 && self.nativeAdViews.count > 0) { // 每第6个cell展示广告
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AdCell" forIndexPath:indexPath];
        [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        // 获取当前广告视图，循环取出
        UIView *adView = self.nativeAdViews[(indexPath.item / 6) % self.nativeAdViews.count];
        adView.frame = cell.contentView.bounds;
        [cell.contentView addSubview:adView];
        
        return cell;
    }
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCell" forIndexPath:indexPath];
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (@available(iOS 13.0, *)) {
        cell.backgroundColor = [UIColor systemGray4Color];
    } else {
        // Fallback on earlier versions
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.bounds];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.image = [UIImage imageNamed:self.imageData[indexPath.item]]; // 替换为实际数据
    [cell.contentView addSubview:imageView];
    
    return cell;
}

// MARK: - SearchBar Delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [self performSearchWithQuery:searchBar.text];
}

- (void)performSearchWithQuery:(NSString *)query {
    if (query.length == 0) {
        [self.imageData removeAllObjects];
        self.collectionView.hidden = YES; // 隐藏图片列表
        self.mrecAdView.hidden = NO; // 显示底部广告
        self.bannerAdView.hidden = NO; // 显示顶部 Banner 广告
    } else {
        [self.imageData removeAllObjects];
        for (int i = 1; i <= 30; i++) {
            if (i % 2 == 0) {
                [self.imageData addObject:@"joker"]; // 替换为实际图片数据
            } else {
                [self.imageData addObject:@"joker2"]; // 替换为实际图片数据
            }
        }
        self.collectionView.hidden = NO; // 显示图片列表
        self.mrecAdView.hidden = YES; // 隐藏底部广告
        self.bannerAdView.hidden = NO; // 保持顶部 Banner 广告显示
        [self.collectionView reloadData];
    }
}

@end
