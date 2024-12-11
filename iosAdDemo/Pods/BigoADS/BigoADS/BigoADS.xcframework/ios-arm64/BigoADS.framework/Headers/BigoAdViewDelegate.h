//
//  BigoAdViewDelegate.h
//  BigoADS
//
//  Created by cai on 2024/11/13.
//

#import "BigoAdError.h"

NS_ASSUME_NONNULL_BEGIN

@class BigoAdView;

@protocol BigoAdViewDelegate <NSObject>

@optional

- (void)onAdView:(BigoAdView *)adView error:(BigoAdError *)error;

- (void)onAdViewImpression:(BigoAdView *)adView;

- (void)onAdViewClicked:(BigoAdView *)adView;

@end

NS_ASSUME_NONNULL_END
