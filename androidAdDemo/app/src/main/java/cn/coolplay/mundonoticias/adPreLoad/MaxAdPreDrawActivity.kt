package cn.coolplay.mundonoticias.adPreLoad

import android.os.Bundle
import android.util.Log
import android.widget.Button
import android.widget.FrameLayout
import android.widget.ImageView
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.isInvisible
import androidx.core.view.isVisible
import cn.coolplay.mundonoticias.R
import coil.load
import com.applovin.mediation.MaxAd
import com.applovin.mediation.MaxAdRevenueListener
import com.applovin.mediation.MaxAdViewAdListener
import com.applovin.mediation.MaxError
import com.applovin.mediation.ads.MaxAdView


class MaxAdPreDrawActivity : AppCompatActivity(), MaxAdViewAdListener, MaxAdRevenueListener {

    private var adContainer: FrameLayout? = null
    private var adView: MaxAdView? = null
    private var aiResult: ImageView? = null
    private var tvShow: Button? = null
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_max_ai_draw)
        adContainer = findViewById(R.id.adContainer)

        tvShow = findViewById(R.id.tv_show)
        aiResult = findViewById(R.id.ai_result)
        adContainer?.post {
            adView = AdPreLoadView.getAdView("AIDraw")?.maxView
            AdPreLoadView.addAdListener("AIDraw", this)
            tvShow?.setOnClickListener {
                aiResult?.isVisible = false
                //如果已经加载后 直接显示 否则等待 加载完成显示
                if (AdPreLoadView.isLoadedAd("AIDraw")) {
                    Log.e("MaxAdPreDrawActivity", "AIDraw 已经加载成功")
                    if (adView?.parent == null) {
                        adContainer?.addView(adView)
                    }

                    if (adView?.isVisible == false) {
                        adView?.isVisible = true
                        tvShow?.postDelayed({
                            adView?.isInvisible = true
                            aiResult?.isVisible = true
                            aiResult?.load(R.mipmap.xiaogou)
                        }, 10000)
                    }
                }
            }

        }

    }

    // 消亡banner广告，
    private fun destroyTpBanner() {
//        adView?.destroy()
        AdPreLoadView.onDestroyView()
    }

    override fun onDestroy() {
        destroyTpBanner()
        super.onDestroy()
    }

    override fun onAdLoaded(p0: MaxAd) {
        Log.e("MaxAdPreDrawActivity", "加载成功")
        //这里控制不允许提前显示
        if (adView?.parent == null) {
            adContainer?.addView(adView)
        }
    }

    override fun onAdDisplayed(p0: MaxAd) {
        Log.e("MaxAdPreDrawActivity", "显现成功")
        tvShow?.postDelayed({
            adView?.isInvisible = true
            aiResult?.isVisible = true
            aiResult?.load(R.mipmap.xiaogou)
        }, 10000)

    }

    override fun onAdHidden(p0: MaxAd) {
    }

    override fun onAdClicked(p0: MaxAd) {

    }

    override fun onAdLoadFailed(p0: String, p1: MaxError) {
        adView?.loadAd()
    }

    override fun onAdDisplayFailed(p0: MaxAd, p1: MaxError) {
        adView?.loadAd()
    }

    override fun onAdExpanded(p0: MaxAd) {

    }

    override fun onAdCollapsed(p0: MaxAd) {
    }

    override fun onAdRevenuePaid(ad: MaxAd) {
//        val adjustAdRevenue = AdjustAdRevenue(AdjustConfig.AD_REVENUE_APPLOVIN_MAX)
//        adjustAdRevenue.setRevenue(ad.revenue, "USD")
//        adjustAdRevenue.setAdRevenueNetwork(ad.networkName)
//        adjustAdRevenue.setAdRevenueUnit(ad.adUnitId)
//        adjustAdRevenue.setAdRevenuePlacement(ad.placement)
//
//        Adjust.trackAdRevenue(adjustAdRevenue)
    }

}