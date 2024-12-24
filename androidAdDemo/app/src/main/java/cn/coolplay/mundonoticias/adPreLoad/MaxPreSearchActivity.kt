package cn.coolplay.mundonoticias.adPreLoad

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
import cn.coolplay.mundonoticias.BuildConfig
import cn.coolplay.mundonoticias.MaxSearchResultActivity
import cn.coolplay.mundonoticias.R
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


class MaxPreSearchActivity : AppCompatActivity(), MaxAdViewAdListener, MaxAdRevenueListener {

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
        adView = AdPreLoadView.getAdView("SearchBanner")
        adMrecView = AdPreLoadView.getAdView("SearchMrec")
        AdPreLoadView.addAdListener("SearchBanner", this)
        AdPreLoadView.addAdListener("SearchMrec", this)
        if (AdPreLoadView.isLoadedAd("SearchBanner")) {
            Log.e("'MaxPreSearchActivity'", "SearchBanner 已经加载成功")
            if (adView?.parent == null) {
                adContainer?.addView(adView)
            }
        }
        if (AdPreLoadView.isLoadedAd("SearchMrec")) {
            Log.e("MaxPreSearchActivity", "SearchMrec已经加载成功")
            if (adMrecView?.parent == null) {
                adMrecContainer?.addView(adMrecView)
            }
        }
    }

    private fun goSearch() {
        startActivity(Intent(this, MaxSearchResultActivity::class.java))
    }

    // 消亡banner广告，
    private fun destroyTpBanner() {
//        adView?.destroy()
//        adMrecView?.destroy()
        AdPreLoadView.onDestroyView()
    }

    override fun onDestroy() {
        destroyTpBanner()
        super.onDestroy()
    }

    override fun onAdLoaded(p0: MaxAd) {
        Log.e("TAG", "广告加载成功${p0.adUnitId}")
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
        Log.e("TAG", "广告显示成功${p0.adUnitId}")
    }

    override fun onAdHidden(p0: MaxAd) {
        Log.e("TAG", "广告隐藏成功")
    }

    override fun onAdClicked(p0: MaxAd) {

    }

    override fun onAdLoadFailed(p0: String, p1: MaxError) {

    }

    override fun onAdDisplayFailed(p0: MaxAd, p1: MaxError) {

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