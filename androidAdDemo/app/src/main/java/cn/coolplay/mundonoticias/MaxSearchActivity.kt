package cn.coolplay.mundonoticias

import android.annotation.SuppressLint
import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.view.ViewGroup.LayoutParams
import android.widget.EditText
import android.widget.FrameLayout
import android.widget.ImageView
import androidx.appcompat.app.AppCompatActivity
import androidx.appcompat.widget.AppCompatTextView
import com.adjust.sdk.Adjust
import com.adjust.sdk.AdjustAdRevenue
import com.adjust.sdk.AdjustConfig
import com.applovin.mediation.MaxAd
import com.applovin.mediation.MaxAdFormat
import com.applovin.mediation.MaxAdRevenueListener
import com.applovin.mediation.MaxAdViewAdListener
import com.applovin.mediation.MaxError
import com.applovin.mediation.ads.MaxAdView
import com.applovin.sdk.AppLovinSdkUtils


class MaxSearchActivity : AppCompatActivity(), MaxAdViewAdListener, MaxAdRevenueListener {

    private var adContainer: FrameLayout? = null
    private var adMrecContainer: FrameLayout? = null
    private var adView: MaxAdView? = null
    private var adMrecView: MaxAdView? = null
    private var searchEdit: AppCompatTextView? = null

    @SuppressLint("SetJavaScriptEnabled")
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_search)
        adContainer = findViewById(R.id.adContainer)
        adMrecContainer = findViewById(R.id.adMrecContainer)
        searchEdit = findViewById(R.id.et_search)

        searchEdit?.setOnClickListener {
            goSearch()
        }
        adView = MaxAdView(BuildConfig.bannerId, this)
        adContainer?.post {
            val heightDp = MaxAdFormat.BANNER.getAdaptiveSize(this).height
            val heightPx = AppLovinSdkUtils.dpToPx(this, heightDp)
            adView?.layoutParams = FrameLayout.LayoutParams(LayoutParams.MATCH_PARENT, heightPx)
            adView?.setListener(this)
            adView?.setRevenueListener(this)
            adView?.loadAd()
        }
        adMrecView = MaxAdView(BuildConfig.mrecId, MaxAdFormat.MREC, this)
        adMrecContainer?.post {
            val heightDp = MaxAdFormat.MREC.getAdaptiveSize(this).height
            val heightPx = AppLovinSdkUtils.dpToPx(this, heightDp)
            adView?.layoutParams = FrameLayout.LayoutParams(LayoutParams.MATCH_PARENT, heightPx)
            adMrecView?.setListener(this)
            adMrecView?.setRevenueListener(this)
            adMrecView?.loadAd()
        }
    }

    private fun goSearch() {
        startActivity(Intent(this, MaxSearchResultActivity::class.java))
    }

    // 消亡banner广告，
    private fun destroyTpBanner() {
        adView?.destroy()
        adMrecView?.destroy()
    }

    override fun onDestroy() {
        destroyTpBanner()
        super.onDestroy()
    }

    override fun onAdLoaded(p0: MaxAd) {
        Log.e("TAG", "广告加载成功")
        if (p0.adUnitId == BuildConfig.bannerId) {
            if (adView?.parent == null) {
                adContainer?.addView(adView)
            }
        } else if (p0.adUnitId == BuildConfig.mrecId) {
            if (adMrecView?.parent == null) {
                adMrecContainer?.addView(adMrecView)
            }
        }
    }

    override fun onAdDisplayed(p0: MaxAd) {
        Log.e("TAG", "广告显示成功")
    }

    override fun onAdHidden(p0: MaxAd) {
        Log.e("TAG", "广告隐藏成功")
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