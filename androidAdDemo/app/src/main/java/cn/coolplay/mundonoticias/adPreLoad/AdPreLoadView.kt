package cn.coolplay.mundonoticias.adPreLoad

import android.app.Application
import android.content.Context
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.view.ViewGroup.LayoutParams
import android.widget.FrameLayout
import cn.coolplay.mundonoticias.BuildConfig
import com.applovin.mediation.MaxAd
import com.applovin.mediation.MaxAdFormat
import com.applovin.mediation.MaxAdListener
import com.applovin.mediation.MaxAdViewAdListener
import com.applovin.mediation.MaxError
import com.applovin.mediation.MaxReward
import com.applovin.mediation.MaxRewardedAdListener
import com.applovin.mediation.ads.MaxAdView
import com.applovin.mediation.ads.MaxRewardedAd
import com.applovin.sdk.AppLovinSdkUtils
import java.util.concurrent.TimeUnit
import kotlin.math.pow

class AdPreLoadViewData(
    val adUnitId: String,
    val tag: String,
    val isAutoLoad: Boolean = true,
    var isLoaded: Boolean = false,
    var isDisPlayed: Boolean = false,
    var maxView: MaxAdView? = null,
    var maxRewardedAd: MaxRewardedAd? = null,
    val adType: MaxAdFormat = MaxAdFormat.BANNER,
    var adListener: MaxAdListener? = null
)

object AdPreLoadView {
    private val adViewMap = mapOf(
        "AIDraw" to AdPreLoadViewData(
            BuildConfig.mrecId,
            adType = MaxAdFormat.MREC,
            tag = "AIDraw"
        ),
        "SearchBanner" to AdPreLoadViewData(BuildConfig.bannerId, tag = "SearchBanner"),
        "SearchMrec" to AdPreLoadViewData(
            BuildConfig.mrecId, tag = "SearchMrec",
            adType = MaxAdFormat.MREC,
        ),
        "RewardView" to AdPreLoadViewData(
            BuildConfig.rewardId,
            adType = MaxAdFormat.REWARDED,
            tag = "RewardView"
        ),
    )
    var app: Application? = null

    fun addAdListener(tag: String, listener: MaxAdListener) {
        adViewMap[tag]?.adListener = listener
    }

    fun removeAdListener(tag: String) {
        adViewMap[tag]?.adListener = null
    }

    fun getAdView(tag: String): AdPreLoadViewData? {
        if (adViewMap.containsKey(tag)) {
            return adViewMap[tag]
        }
        return null
    }

    fun isLoadedAd(tag: String): Boolean {
        if (adViewMap.containsKey(tag)) {
            return adViewMap[tag]?.isLoaded == true
        }
        return false
    }

    fun loadAdView(app: Application) {
        this.app = app
        adViewMap.forEach {
            loadSingAdByTag(it.key)
        }
    }

    private fun loadSingAdByTag(tag: String) {
        if (adViewMap.containsKey(tag)) {
            val adType = adViewMap[tag]?.adType
            when (adType) {
                MaxAdFormat.BANNER -> {
                    createBannerView(app!!.applicationContext, adViewMap[tag]!!)
                }

                MaxAdFormat.MREC -> {
                    createMrecView(app!!.applicationContext, adViewMap[tag]!!)
                }

                MaxAdFormat.REWARDED -> {
                    createRewardedView(app!!.applicationContext, adViewMap[tag]!!)
                }
            }
        }
    }

    private fun createRewardedView(
        applicationContext: Context?,
        adPreLoadViewData: AdPreLoadViewData
    ) {
        val adView = MaxRewardedAd.getInstance(adPreLoadViewData.adUnitId, applicationContext)
        var retryAttempt = 0.0
        adView.setListener(object : MaxRewardedAdListener {
            override fun onAdLoaded(p0: MaxAd) {
                retryAttempt = 0.0
                adPreLoadViewData.isLoaded = true
                adPreLoadViewData.adListener?.onAdLoaded(p0)
                Log.e("createRewardedView", "onAdLoaded")
            }

            override fun onAdDisplayed(p0: MaxAd) {
                Log.e("createRewardedView", "onAdDisplayed")
                adPreLoadViewData.isDisPlayed = true
                adPreLoadViewData.adListener?.onAdDisplayed(p0)
            }

            override fun onAdHidden(p0: MaxAd) {
                Log.e("createRewardedView", "onAdHidden")
                adPreLoadViewData.isDisPlayed = false
                adView.loadAd()
            }

            override fun onAdClicked(p0: MaxAd) {
                Log.e("createRewardedView", "onAdClicked")
                adPreLoadViewData.adListener?.onAdClicked(p0)
            }

            override fun onAdLoadFailed(p0: String, p1: MaxError) {
                Log.e("createRewardedView", "onAdLoadFailed")
                adPreLoadViewData.isDisPlayed = false
                adPreLoadViewData.isLoaded = false
                adPreLoadViewData.adListener?.onAdLoadFailed(p0, p1)
                // Rewarded ad failed to load
                // AppLovin recommends that you retry with exponentially higher delays up to a maximum delay (in this case 64 seconds)
                retryAttempt++
                val delayMillis = TimeUnit.SECONDS.toMillis(
                    2.0.pow(6.0.coerceAtMost(retryAttempt))
                        .toLong()
                )

                Handler(Looper.myLooper()!!).postDelayed({ adView.loadAd() }, delayMillis)
            }

            override fun onAdDisplayFailed(p0: MaxAd, p1: MaxError) {
                Log.e("createRewardedView", "onAdDisplayFailed")
                adPreLoadViewData.isDisPlayed = false
                adPreLoadViewData.isLoaded = false
                adPreLoadViewData.adListener?.onAdDisplayFailed(p0, p1)
                retryAttempt++
                val delayMillis = TimeUnit.SECONDS.toMillis(
                    2.0.pow(6.0.coerceAtMost(retryAttempt))
                        .toLong()
                )

                Handler(Looper.myLooper()!!).postDelayed({ adView.loadAd() }, delayMillis)
            }

            override fun onUserRewarded(p0: MaxAd, p1: MaxReward) {
                Log.e("createRewardedView", "onUserRewarded点击了广告")
                if (adPreLoadViewData.adListener != null && adPreLoadViewData.adListener is MaxRewardedAdListener) {
                    (adPreLoadViewData.adListener as MaxRewardedAdListener).onUserRewarded(p0, p1)
                }
            }
        })
        adPreLoadViewData.maxRewardedAd = adView
        //自动load 才会预加载
        if (adPreLoadViewData.isAutoLoad) {
            adView.loadAd()
        }
    }

    private fun createBannerView(app: Context, adPreLoadViewData: AdPreLoadViewData) {
        val adView = MaxAdView(adPreLoadViewData.adUnitId, adPreLoadViewData.adType, app)
        val heightDp = MaxAdFormat.BANNER.getAdaptiveSize(app).height
        val heightPx = AppLovinSdkUtils.dpToPx(app, heightDp)
        adView.layoutParams = FrameLayout.LayoutParams(LayoutParams.MATCH_PARENT, heightPx)
        adView.placement = adPreLoadViewData.tag
        adView.setListener(object : MaxAdViewAdListener {
            override fun onAdLoaded(ad: MaxAd) {
                adPreLoadViewData.isLoaded = true
                adPreLoadViewData.adListener?.onAdLoaded(ad)
            }

            override fun onAdDisplayed(p0: MaxAd) {
                adPreLoadViewData.isDisPlayed = true
                adPreLoadViewData.adListener?.onAdDisplayed(p0)
            }

            override fun onAdHidden(p0: MaxAd) {
                adPreLoadViewData.isDisPlayed = false
                adView.loadAd()
            }

            override fun onAdClicked(p0: MaxAd) {

            }

            override fun onAdLoadFailed(p0: String, p1: MaxError) {
                adPreLoadViewData.isLoaded = false
                adView.loadAd()
            }

            override fun onAdDisplayFailed(p0: MaxAd, p1: MaxError) {
                adPreLoadViewData.isDisPlayed = false
            }

            override fun onAdExpanded(p0: MaxAd) {

            }

            override fun onAdCollapsed(p0: MaxAd) {

            }
        })
        adPreLoadViewData.maxView = adView
        //自动load 才会预加载
        if (adPreLoadViewData.isAutoLoad) {
            adView.loadAd()
        }
    }

    private fun createMrecView(app: Context, adPreLoadViewData: AdPreLoadViewData) {
        val adView = MaxAdView(adPreLoadViewData.adUnitId, adPreLoadViewData.adType, app)
        if (!adPreLoadViewData.isAutoLoad) {
            adView.setExtraParameter("allow_pause_auto_refresh_immediately", "true")
            adView.stopAutoRefresh()
        }
        adView.placement = adPreLoadViewData.tag
        val heightDp = MaxAdFormat.MREC.getAdaptiveSize(app).height
        val heightPx = AppLovinSdkUtils.dpToPx(app, heightDp)
        adView.layoutParams = FrameLayout.LayoutParams(LayoutParams.MATCH_PARENT, heightPx)
        adView.setListener(object : MaxAdViewAdListener {
            override fun onAdLoaded(ad: MaxAd) {
                adPreLoadViewData.isLoaded = true
                adPreLoadViewData.adListener?.onAdLoaded(ad)
            }

            override fun onAdDisplayed(p0: MaxAd) {
                adPreLoadViewData.isDisPlayed = true
                adPreLoadViewData.adListener?.onAdDisplayed(p0)
            }

            override fun onAdHidden(p0: MaxAd) {
                adPreLoadViewData.isDisPlayed = false
                adView.loadAd()
            }

            override fun onAdClicked(p0: MaxAd) {

            }

            override fun onAdLoadFailed(p0: String, p1: MaxError) {
                adPreLoadViewData.isDisPlayed = false
                adView.loadAd()
            }

            override fun onAdDisplayFailed(p0: MaxAd, p1: MaxError) {
                adPreLoadViewData.isDisPlayed = false
            }

            override fun onAdExpanded(p0: MaxAd) {

            }

            override fun onAdCollapsed(p0: MaxAd) {

            }
        })
        adPreLoadViewData.maxView = adView
        //自动load 才会预加载
        if (adPreLoadViewData.isAutoLoad) {
            adView.loadAd()
        }
    }

    fun onDestroyView(isExit: Boolean = false) {
        val adView = mutableListOf<String>()
        val iterator = adViewMap.iterator()

        while (iterator.hasNext()) {
            val entry = iterator.next()
            val adViewInstance = entry.value

            // 清理已经加载过的广告
            if (adViewInstance.maxView?.parent != null || isExit) {
                adViewInstance.maxView?.destroy()
                adViewInstance.maxView = null
                Log.d("AdPreLoadView", "销毁广告：${entry.key}")
                adView.add(entry.key)
            }
            //不为空 并且显示过了 销毁 重新与加载下一个
            if (adViewInstance.maxRewardedAd != null && (adViewInstance.isDisPlayed || isExit)) {
                adViewInstance.maxRewardedAd?.destroy()
                adViewInstance.maxRewardedAd = null
                Log.d("AdPreLoadView", "销毁广告：${entry.key}")
                adView.add(entry.key)
            }
        }
        if (isExit) return
        adView.forEach { tag ->
            // 销毁的广告提前与加载方便下一次使用
            loadSingAdByTag(tag)
        }

    }

}