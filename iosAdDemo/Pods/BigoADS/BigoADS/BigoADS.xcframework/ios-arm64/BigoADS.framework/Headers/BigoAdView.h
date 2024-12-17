//
//  BigoAdView.h
//  BigoADS
//
//  Created by cai on 2024/11/13.
//

#import "BigoAdComponentView.h"
#import "BigoBannerAdRequest.h"
#import "BigoAdViewRequestDelegate.h"
#import "BigoAdViewDelegate.h"
#import "BGAdBid.h"

NS_ASSUME_NONNULL_BEGIN

@interface BigoAdView : BigoAdComponentView

/**
 * A delegate that will be notified about ad request events.
 */
@property (nonatomic, weak, nullable) id<BigoAdViewRequestDelegate> requestDelegate;

/**
 * A delegate that will be notified about ad events.
 */
@property (nonatomic, weak, nullable) id<BigoAdViewDelegate> delegate;

/**
 * The size of the AdView format ad, or @c CGSizeZero otherwise.
 */
@property (nonatomic, assign, readonly) CGSize size;

- (void)loadAdWithAdRequest:(BigoBannerAdRequest *)adRequest;

- (void)loadAdWithAdRequest:(BigoBannerAdRequest *)adRequest ext:(nullable NSString *)ext;

- (nullable id<BGAdBid>)getBid;

- (nullable NSString *)getCreativeId;

- (BOOL)isExpired;

- (void)destroy;

@end

NS_ASSUME_NONNULL_END
