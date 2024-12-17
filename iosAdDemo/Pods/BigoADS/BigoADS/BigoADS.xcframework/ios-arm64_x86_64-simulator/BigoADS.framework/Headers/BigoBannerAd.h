//
//  BigoBannerAd.h
//  AFNetworking
//
//  Created by 蔡庆敏 on 2021/5/17.
//

#import <Foundation/Foundation.h>
#import "BigoAd.h"

NS_ASSUME_NONNULL_BEGIN

@interface BigoBannerAd : BigoAd

- (nullable UIView *)adView;

- (int32_t)getHeight;

- (int32_t)getWidth;

@end

NS_ASSUME_NONNULL_END