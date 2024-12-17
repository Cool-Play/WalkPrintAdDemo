//
//  BigoAdErrorCode.h
//  Pods
//
//  Created by 蔡庆敏 on 2021/5/17.
//

#ifndef BigoAdErrorCode_h
#define BigoAdErrorCode_h


//region 广告请求链路错误码
static NSInteger const BIGO_AD_ERROR_CODE_UNINITIALIZED = 1000; // 未初始化
static NSInteger const BIGO_AD_ERROR_CODE_INVALID_REQUEST = 1001; // 无效请求，如请求参数未正确设置等
static NSInteger const BIGO_AD_ERROR_CODE_AD_DISABLE = 1002; // 当前广告不可用，如下发的配置为该 slot 已关闭
static NSInteger const BIGO_AD_ERROR_CODE_NETWORK_ERROR = 1003; // 网络请求异常，如网络环境不可用
static NSInteger const BIGO_AD_ERROR_CODE_NO_FILL = 1004; // 广告未填充
static NSInteger const BIGO_AD_ERROR_CODE_INTERNAL_ERROR = 1005; // 广告请求内部异常，如返回的广告数据异常等
static NSInteger const BIGO_AD_ERROR_CODE_ASSETS_ERROR = 1006; // 广告素材相关异常，比如 vast 解析异常、html 素材加载失败等
static NSInteger const BIGO_AD_ERROR_CODE_APP_ID_UNMATCHED = 1007; // 初始化APP ID不匹配
static NSInteger const BIGO_AD_ERROR_CODE_NO_CONFIG = 1008; // 无配置
static NSInteger const BIGO_AD_ERROR_CODE_CREATE_AD_INSTANCE_FAIL = 1009;//创建ad实例错误
static NSInteger const BIGO_AD_ERROR_CODE_UNKNOWN_AD_INSTANCE_FAIL = 1010;//未知ad实例
static NSInteger const BIGO_AD_ERROR_CODE_EMPTY_APP_ID = 1013; //app id为空
static NSInteger const BIGO_AD_ERROR_CODE_INVALID_SLOT = 1014; // slot不在config中导致校验失败
static NSInteger const BIGO_AD_ERROR_CODE_SLOT_STATE_DISABLE = 1015; // slot开关为关闭状态
static NSInteger const BIGO_AD_ERROR_CODE_SLOT_TYPE_UNMATCHED = 1016; // slot广告类型不匹配
static NSInteger const BIGO_AD_ERROR_CODE_IMPRESSION_REACH_LIMIT = 1017; // 广告展示已达上限
static NSInteger const BIGO_AD_ERROR_CODE_EMPTY_PAYLOAD = 1018; // Server bidding类型的广告payload为空
static NSInteger const BIGO_AD_ERROR_CODE_SLOT_EMPTY = 1019; // 校验 slot id 为空
static NSInteger const BIGO_AD_ERROR_CODE_ICON_ADS_FAILED = 1020; // iconAds都下载失败
static NSInteger const BIGO_AD_ERROR_CODE_AD_DATA_CLS_TYPE_UNMATCHED = 1021; // adData类型不匹配
static NSInteger const BIGO_AD_ERROR_CODE_AD_DATA_EMPTY_CONTENT = 1022; // 插屏banner中display字段为空
static NSInteger const BIGO_AD_ERROR_CODE_DOUBLE_VIDEO_EMPTY_VIDEO = 1023; // 双video视频素材数为0
static NSInteger const BIGO_AD_ERROR_CODE_UNKNOWN_AD = 1024; // 未知ad实例
static NSInteger const BIGO_AD_ERROR_CODE_REQUEST_TIMEOUT = 1025; // 请求超时
static NSInteger const BIGO_AD_ERROR_CODE_REQUEST_FAILED = 1026; // 请求失败
static NSInteger const BIGO_AD_ERROR_CODE_EMPTY_IMAGE_URL = 1027; // 图片链接为空
static NSInteger const BIGO_AD_ERROR_CODE_INVALID_HTTP_URL = 1028; // 图片链接为http协议，不合法
static NSInteger const BIGO_AD_ERROR_CODE_IMAGE_DOWNLOAD_FAILED = 1029; // 图片下载失败
static NSInteger const BIGO_AD_ERROR_CODE_VIDEO_AD_DATA_CLS_TYPE = 1030; // video adData类型不匹配
static NSInteger const BIGO_AD_ERROR_CODE_EMPTY_VIDEO = 1031; // video字段为空
static NSInteger const BIGO_AD_ERROR_CODE_INVALID_DURATION = 1032; // 视频时长无效（激励视频要求最少3秒）
static NSInteger const BIGO_AD_ERROR_CODE_VIDEO_FAILED_NO_BACKUP = 1033; // 视频下载失败，而且没有兜底填充的图片素材
static NSInteger const BIGO_AD_ERROR_CODE_VIDEO_FAILED = 1034; // 视频下载失败
//endregion

//region 广告交互过程（展示、点击等）错误码
static NSInteger const BIGO_AD_ERROR_CODE_AD_EXPIRED = 2000; // 广告已过期
static NSInteger const BIGO_AD_ERROR_CODE_NATIVE_VIEW_MISSING = 2001; // Native 广告主视图 NativeAdView 缺失
static NSInteger const BIGO_AD_ERROR_CODE_VIDEO_ERROR = 2002; // 视频播放过程相关异常
static NSInteger const BIGO_AD_ERROR_CODE_FULLSCREEN_AD_FAILED_TO_SHOW = 2003; // 全屏广告（插屏 & 激励视频）展示异常
//endregion

#endif /* BigoAdErrorCode_h */
