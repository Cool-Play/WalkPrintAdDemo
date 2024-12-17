//
//  BigoAdViewRequestDelegate.h
//  BigoADS
//
//  Created by cai on 2024/11/13.
//

#import "BigoAdError.h"

NS_ASSUME_NONNULL_BEGIN

@class BigoAdView;
@protocol BigoAdViewRequestDelegate <NSObject>

- (void)onBigoAdViewLoaded:(BigoAdView *)adView;

- (void)onBigoAdViewLoadError:(BigoAdError *)error;

@end

NS_ASSUME_NONNULL_END
