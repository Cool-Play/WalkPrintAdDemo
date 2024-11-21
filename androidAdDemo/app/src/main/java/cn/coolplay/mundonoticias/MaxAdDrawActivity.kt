package cn.coolplay.mundonoticias

import android.graphics.Color
import android.os.Bundle
import android.util.Log
import android.view.Gravity
import android.widget.Button
import android.widget.FrameLayout
import android.widget.ImageView
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.isVisible
import coil.load
import com.adjust.sdk.Adjust
import com.adjust.sdk.AdjustAdRevenue
import com.adjust.sdk.AdjustConfig
import com.applovin.mediation.MaxAd
import com.applovin.mediation.MaxAdFormat
import com.applovin.mediation.MaxAdRevenueListener
import com.applovin.mediation.MaxAdViewAdListener
import com.applovin.mediation.MaxError
import com.applovin.mediation.ads.MaxAdView


class MaxAdDrawActivity : AppCompatActivity(), MaxAdViewAdListener, MaxAdRevenueListener {

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
        adView = MaxAdView(BuildConfig.mrecId, MaxAdFormat.MREC, this)
        adView?.setExtraParameter("allow_pause_auto_refresh_immediately", "true")
        adView?.stopAutoRefresh()        // Stretch to the width of the screen for banners to be fully functional
        // Get the adaptive banner height.
        //设置广告位名称 用于不同版面类别的统计
        adView?.placement = "AIDraw"

        adContainer?.post {
            val heightDp = adContainer?.measuredHeight ?: 0
            Log.i("Max", "Banner height: $heightDp")

            adView?.layoutParams = FrameLayout.LayoutParams(heightDp, heightDp, Gravity.CENTER)
            adView?.setListener(this)
            adView?.setRevenueListener(this)
            tvShow?.setOnClickListener {
                aiResult?.isVisible = false
                adView?.loadAd()
            }
        }
    }

    // 消亡banner广告，
    private fun destroyTpBanner() {
        adView?.destroy()
    }

    override fun onDestroy() {
        destroyTpBanner()
        super.onDestroy()
    }

    override fun onAdLoaded(p0: MaxAd) {
        if (adView?.parent == null) {
            adContainer?.addView(adView)
        }
    }

    override fun onAdDisplayed(p0: MaxAd) {
        tvShow?.postDelayed({
            adContainer?.removeView(adView)
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
        val adjustAdRevenue = AdjustAdRevenue(AdjustConfig.AD_REVENUE_APPLOVIN_MAX)
        adjustAdRevenue.setRevenue(ad.revenue, "USD")
        adjustAdRevenue.setAdRevenueNetwork(ad.networkName)
        adjustAdRevenue.setAdRevenueUnit(ad.adUnitId)
        adjustAdRevenue.setAdRevenuePlacement(ad.placement)

        Adjust.trackAdRevenue(adjustAdRevenue)
    }

}