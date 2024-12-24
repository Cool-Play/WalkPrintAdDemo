package cn.coolplay.mundonoticias.adPreLoad

import android.app.Application
import android.content.Context
import android.util.Log
import android.view.ViewGroup.LayoutParams
import android.widget.FrameLayout
import cn.coolplay.mundonoticias.BuildConfig
import com.applovin.mediation.MaxAd
import com.applovin.mediation.MaxAdFormat
import com.applovin.mediation.MaxAdViewAdListener
import com.applovin.mediation.MaxError
import com.applovin.mediation.ads.MaxAdView
import com.applovin.sdk.AppLovinSdkUtils

class AdPreLoadViewData(
    val adUnitId: String,
    val tag: String,
    val isAutoLoad: Boolean = true,
    var isLoaded: Boolean = false,
    var maxView: MaxAdView? = null,
    val adType: MaxAdFormat = MaxAdFormat.BANNER,
    var adListener: MaxAdViewAdListener? = null
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
        )
    )
    var app: Application? = null

    fun addAdListener(tag: String, listener: MaxAdViewAdListener) {
        adViewMap[tag]?.adListener = listener
    }

    fun getAdView(tag: String): MaxAdView? {
        if (adViewMap.containsKey(tag)) {
            return adViewMap[tag]?.maxView
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
            }
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
                adPreLoadViewData.adListener?.onAdDisplayed(p0)
            }

            override fun onAdHidden(p0: MaxAd) {

            }

            override fun onAdClicked(p0: MaxAd) {

            }

            override fun onAdLoadFailed(p0: String, p1: MaxError) {
                adView.loadAd()
            }

            override fun onAdDisplayFailed(p0: MaxAd, p1: MaxError) {

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
                adPreLoadViewData.adListener?.onAdDisplayed(p0)
            }

            override fun onAdHidden(p0: MaxAd) {

            }

            override fun onAdClicked(p0: MaxAd) {

            }

            override fun onAdLoadFailed(p0: String, p1: MaxError) {
                adView.loadAd()
            }

            override fun onAdDisplayFailed(p0: MaxAd, p1: MaxError) {

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

    fun onDestroyView() {
        val adView = mutableListOf<String>()
        val iterator = adViewMap.iterator()

        while (iterator.hasNext()) {
            val entry = iterator.next()
            val adViewInstance = entry.value

            // 清理已经加载过的广告
            if (adViewInstance.maxView?.parent != null) {
                adViewInstance.maxView?.destroy()
                adViewInstance.maxView = null
                Log.d("AdPreLoadView", "销毁广告：${entry.key}")
                adView.add(entry.key)
            }
        }

        adView.forEach { tag ->
            // 销毁的广告提前与加载方便下一次使用
            loadSingAdByTag(tag)
        }

    }
}