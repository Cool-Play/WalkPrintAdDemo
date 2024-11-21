package cn.coolplay.mundonoticias

import android.app.Activity
import android.content.Context
import android.graphics.Color
import android.os.Bundle
import android.util.Log
import android.view.View
import android.view.ViewGroup
import android.view.inputmethod.InputMethodManager
import android.widget.EditText
import android.widget.FrameLayout
import android.widget.ImageView
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import androidx.recyclerview.widget.GridLayoutManager
import androidx.recyclerview.widget.RecyclerView
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
import com.applovin.mediation.nativeAds.MaxNativeAdViewBinder
import com.applovin.mediation.nativeAds.adPlacer.MaxAdPlacer
import com.applovin.mediation.nativeAds.adPlacer.MaxAdPlacerSettings
import com.applovin.mediation.nativeAds.adPlacer.MaxRecyclerAdapter
import com.applovin.sdk.AppLovinSdkUtils
import kotlin.random.Random

class MaxSearchResultActivity : AppCompatActivity(), MaxAdViewAdListener, MaxAdRevenueListener {

    private val sampleData = arrayListOf<Int>()
    private lateinit var adAdapter: MaxRecyclerAdapter
    private var searchEdit: EditText? = null
    private var btnSearch: TextView? = null
    private var adContainer: FrameLayout? = null
    private var adView: MaxAdView? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_search_result)
        val recyclerView = findViewById<RecyclerView>(R.id.recycler_view)
        searchEdit = findViewById(R.id.search_edit)
        btnSearch = findViewById(R.id.btnSearch)
        adContainer = findViewById(R.id.adContainer)
        findViewById<ImageView>(R.id.iv_back).setOnClickListener {
            this.finish()
        }
        adView = MaxAdView(BuildConfig.bannerId, this)
        adContainer?.post {
            val heightDp = MaxAdFormat.BANNER.getAdaptiveSize(this).height
            val heightPx = AppLovinSdkUtils.dpToPx(this, heightDp)
            adView?.layoutParams =
                FrameLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, heightPx)
            adView?.setListener(this)
            adView?.loadAd()
        }
        // Create recycler adapter
        val originalAdapter = CustomRecyclerAdapter(this, sampleData)

        // Configure ad adapter
        val settings = MaxAdPlacerSettings(BuildConfig.nativeId)
        settings.addFixedPosition(2)
        settings.addFixedPosition(8)
        settings.repeatingInterval = 6
        // If using custom views, you must also set the nativeAdViewBinder on the adapter

        adAdapter = MaxRecyclerAdapter(settings, originalAdapter, this)
        val binder: MaxNativeAdViewBinder =
            MaxNativeAdViewBinder.Builder(R.layout.native_custom_ad_view)
                .setTitleTextViewId(R.id.title_text_view)
                .setBodyTextViewId(R.id.body_text_view)
                .setAdvertiserTextViewId(R.id.advertiser_text_view)
                .setIconImageViewId(R.id.icon_image_view)
                .setMediaContentViewGroupId(R.id.media_view_container)
                .setOptionsContentViewGroupId(R.id.options_view)
                .setStarRatingContentViewGroupId(R.id.star_rating_view)
                .setCallToActionButtonId(R.id.cta_button)
                .build()
        adAdapter.adPlacer.setNativeAdViewBinder(binder)
        adAdapter.adPlacer.setAdSize(-1, -2)

        adAdapter.setListener(object : MaxAdPlacer.Listener {
            override fun onAdLoaded(position: Int) {}

            override fun onAdRemoved(position: Int) {}

            override fun onAdClicked(ad: MaxAd?) {}

            override fun onAdRevenuePaid(ad: MaxAd) {
                val adjustAdRevenue = AdjustAdRevenue(AdjustConfig.AD_REVENUE_APPLOVIN_MAX)
                adjustAdRevenue.setRevenue(ad.revenue, "USD")
                adjustAdRevenue.setAdRevenueNetwork(ad.networkName)
                adjustAdRevenue.setAdRevenueUnit(ad.adUnitId)
                adjustAdRevenue.setAdRevenuePlacement(ad.placement)
                Adjust.trackAdRevenue(adjustAdRevenue)

            }
        })

        recyclerView.adapter = adAdapter
        recyclerView.layoutManager = GridLayoutManager(this, 3, RecyclerView.VERTICAL, false)
        adAdapter.loadAds()
        btnSearch?.setOnClickListener {
            it.hideKeyboard()
            fillData()
        }
    }

    private fun fillData() {
        sampleData.clear()
        for (i in 0..15) {
            sampleData.add(R.mipmap.xiaochou)
            sampleData.add(R.mipmap.xiaochou1)
        }
        adAdapter.notifyDataSetChanged()
    }

    fun View.hideKeyboard() {
        val imm = context.getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
        imm.hideSoftInputFromWindow(windowToken, 0)
    }

    override fun onBackPressed() {
        super.onBackPressed()
        finish()
    }

    private fun destroyBanner() {
        adAdapter.destroy()
        adView?.destroy()
    }

    override fun onDestroy() {
        destroyBanner()
        super.onDestroy()
    }

    override fun onAdLoaded(p0: MaxAd) {
        Log.e("TAG", "广告加载成功")
        if (p0.adUnitId == BuildConfig.bannerId) {
            if (adView?.parent == null) {
                adContainer?.addView(adView)
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

    class CustomRecyclerAdapter(private val activity: Activity, val data: List<Int>) :
        RecyclerView.Adapter<CustomRecyclerAdapter.ViewHolder>() {
        // 生成随机颜色的方法
        private fun getRandomColor(): Int {
            return Color.argb(255, Random.nextInt(256), Random.nextInt(256), Random.nextInt(256))
        }

        override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
            val view = activity.layoutInflater.inflate(
                R.layout.activity_text_recycler_view_holder,
                parent,
                false
            )
            return ViewHolder(view)
        }

        override fun onBindViewHolder(holder: ViewHolder, position: Int) {
            holder.ivView.load(data[position])
        }

        override fun getItemCount(): Int {
            return data.size
        }

        class ViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {
            val ivView: ImageView = itemView.findViewById(R.id.iv_view)
        }

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
