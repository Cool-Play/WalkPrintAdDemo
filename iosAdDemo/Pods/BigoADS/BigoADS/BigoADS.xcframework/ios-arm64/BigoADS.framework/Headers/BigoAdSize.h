//
//  BigoAdSize.h
//  BigoADS
//
//  Created by 蔡庆敏 on 2021/5/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

static NSString * const BIGO_BANNER_ADAPTIVE = @"bigo_banner_adaptive";

@interface BigoAdSize : NSObject

@property (nonatomic, readonly) CGFloat width;
@property (nonatomic, readonly) CGFloat height;
@property (nonatomic, readonly) NSString *desc;

+ (BigoAdSize *)BANNER; //320x50
+ (BigoAdSize *)MEDIUM_RECTANGLE; //300x250
+ (BigoAdSize *)LARGE_BANNER; //320x90
+ (BigoAdSize *)MOBILE_LARGE_LEADERBOARD; //320x100
+ (BigoAdSize *)LEADERBOARD; //728x90

+ (BigoAdSize *)getAdaptiveAdSizeWithWidth:(CGFloat)width;


@end

NS_ASSUME_NONNULL_END
