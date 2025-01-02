# 0. 前置

以下是Coolplay广告SDK集成文档，请我们客户的开发人员参考此文档集成。同时开发人员在启动适配前，请通过商务先告知我方App的包名，我们将为该App提供集成广告所需的如下ID、sdkKey、apiKey、nativeId、mrecId和bannerId等，如果需要更多广告类型，也请通过商务联系我们。

# 1. 配置仓库地址

repositories {
  maven { url 'https://artifacts.applovin.com/android' }
  maven { url "https://artifact.bytedance.com/repository/pangle" }
}

# 2. App's build.gradle 增加依赖包

```
dependencies {
 // Applovin
    implementation("com.applovin:applovin-sdk:13.0.1")
    implementation 'com.google.android.gms:play-services-ads-identifier:18.1.0'
    implementation 'com.adjust.sdk:adjust-android:4.28.7'
    //google mediation adapter
    implementation 'com.applovin.mediation:google-adapter:23.6.0.1'
    //隐私协议 不需要ump 可以不添加
    implementation 'com.google.android.ump:user-messaging-platform:3.1.0'
    implementation 'com.applovin.mediation:bigoads-adapter:5.1.0.0'

    implementation 'com.applovin.mediation:bytedance-adapter:6.4.0.5.0'

    implementation 'com.applovin.mediation:mintegral-adapter:16.9.11.0'
}
```

# 3. AndroidManifest.xml

```
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    package="your.app.package.name">
    <uses-permission android:name="android.permission.AD_ID" />
    <application>
        // Applovin log 开关
        <meta-data  
                android:name="applovin.sdk.verbose_logging"
                android:value="true" />
                
         <meta-data
            android:name="com.google.android.gms.ads.APPLICATION_ID"
            android:value="ca-app-pub-2540674760491959~9832388524" />
        
    </application>
</manifest>
```

# 4. 初始化代码

```
在application中初始化代码

package cn.coolplay.mundonoticias

import android.app.Application
import android.content.Context
import android.util.Log
import com.tradplus.ads.open.TradPlusSdk


class App : Application() {

    override fun onCreate() {
        super.onCreate()
        //隐私合规声明后在初始化
        initSdk()
    }

      private fun initSdk() {
        val executor = Executors.newSingleThreadExecutor();
        executor.execute {
            val initConfigBuilder =
                AppLovinSdkInitializationConfiguration.builder(BuildConfig.sdkKey, this)
                    .setMediationProvider(AppLovinMediationProvider.MAX)
            //作为测试使用        
            val currentGaid = AdvertisingIdClient.getAdvertisingIdInfo(this).id
            if (currentGaid != null) {
                Log.i("Applovin", "currentGaid: $currentGaid")
                //这里为了测试,上线时不需要
                initConfigBuilder.testDeviceAdvertisingIds = Collections.singletonList(currentGaid)
            }

            val initConfig = initConfigBuilder.build()
            AppLovinSdk.getInstance(this).apply {
                //如果要从 GDPR 区域外部测试 Google CMP，请使用以下方法之一将调试用户地理位置设置为：GDPR
                //上线时不需要
                settings.setExtraParameter("google_test_device_hashed_id", "a5cabc60-3d80-4df0-9265-282aaacddab1")
                //隐私合规 如果自已已经存在一套 可以不使用
                settings.termsAndPrivacyPolicyFlowSettings.apply {
                    isEnabled = true
                    privacyPolicyUri = Uri.parse("https://imsoauthh5.efercro.com/privacyPrint.html")
                    //如果要从 GDPR 区域外部测试 Google CMP，请使用以下方法之一将调试用户地理位置设置为：GDPR 
                    //上线时不需要
                    debugUserGeography = AppLovinSdkConfiguration.ConsentFlowUserGeography.GDPR

                }
                initialize(initConfig) {
                    Log.i("Applovin", "onSdkInitialized")
                }
            }
            executor.shutdown()
        }
    }
}
```

# 5. 混淆配置

```
混淆配置已经自动处理,不需要自己填写广告相关的混淆
```

# 6. banner、MREC 广告

```
activity_search.xml

<FrameLayout
        android:id="@+id/adContainer"
        android:layout_width="match_parent"
        android:layout_height="match_parent" />


class MaxSearchActivity : AppCompatActivity(), MaxAdViewAdListener {

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
        //初始化 banner 广告
        adView = MaxAdView("填写bannerId", this)
        adContainer?.post {
            val heightDp = MaxAdFormat.BANNER.getAdaptiveSize(this).height
            val heightPx = AppLovinSdkUtils.dpToPx(this, heightDp)
            adView?.layoutParams = FrameLayout.LayoutParams(LayoutParams.MATCH_PARENT, heightPx)
            adView?.setListener(this)
            adView?.loadAd()
        }
        //初始化 MREC 广告 尺寸 300x250
        adMrecView = MaxAdView("填写 mrecId", MaxAdFormat.MREC, this)
        adMrecContainer?.post {
            val heightDp = MaxAdFormat.MREC.getAdaptiveSize(this).height
            val heightPx = AppLovinSdkUtils.dpToPx(this, heightDp)
            adView?.layoutParams = FrameLayout.LayoutParams(LayoutParams.MATCH_PARENT, heightPx)
            adMrecView?.setListener(this)
            adMrecView?.loadAd()
        }
        //如果不需要自动刷新,可以禁用自动刷新
        adView?.setExtraParameter("allow_pause_auto_refresh_immediately", "true")
        adView?.stopAutoRefresh()
    }

    private fun goSearch() {
        startActivity(Intent(this, MaxSearchResultActivity::class.java))
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
        //失败后加载下一个
        adView?.loadAd()
    }

    override fun onAdDisplayFailed(p0: MaxAd, p1: MaxError) {
       //显示失败后继续下一个
        adView?.loadAd()
    }

  override fun onAdDisplayed(p0: MaxAd) { /* DO NOT USE - THIS IS RESERVED FOR FULLSCREEN ADS ONLY AND WILL BE REMOVED IN A FUTURE SDK RELEASE */ }

  override fun onAdHidden(p0: MaxAd) { /* DO NOT USE - THIS IS RESERVED FOR FULLSCREEN ADS ONLY AND WILL BE REMOVED IN A FUTURE SDK RELEASE */ }

}
```

# 7. RecyclerView 广告

```
activity_search_result.xml
    <androidx.recyclerview.widget.RecyclerView
         android:id="@+id/recycler_view"
         android:layout_width="match_parent"
         android:layout_height="match_parent" />


        
class MaxSearchResultActivity : AppCompatActivity(), MaxAdViewAdListener {
       // Create recycler adapter
        val originalAdapter = CustomRecyclerAdapter(this, sampleData)

        // Configure ad adapter
        val settings = MaxAdPlacerSettings("填写 nativeId")
        settings.addFixedPosition(2)
        settings.addFixedPosition(8)
        settings.repeatingInterval = 6
        
        adAdapter = MaxRecyclerAdapter(settings, originalAdapter, this)
        //custom views, you must also set the nativeAdViewBinder on the adapter
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
        // Set ad size −1 (MATCH_PARENT) -2 (WRAP_CONTENT) 
        // set the ad size with a width of 300 and height of 200.
        adAdapter.adPlacer.setAdSize(-1, -2)

        adAdapter.setListener(object : MaxAdPlacer.Listener {
            override fun onAdLoaded(position: Int) {}

            override fun onAdRemoved(position: Int) {}

            override fun onAdClicked(ad: MaxAd?) {}

            override fun onAdRevenuePaid(ad: MaxAd?) {}
        })

        recyclerView.adapter = adAdapter
        recyclerView.layoutManager = GridLayoutManager(this, 3, RecyclerView.VERTICAL, false)
        adAdapter.loadAds()
}
```

# 8. 隐私合规

隐私合规具体规范请参照 https://developers.applovin.com/en/max/android/overview/privacy/

