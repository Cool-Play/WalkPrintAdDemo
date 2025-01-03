package cn.coolplay.mundonoticias.utils

import android.content.Context
import android.util.Log
import androidx.lifecycle.DefaultLifecycleObserver
import androidx.lifecycle.LifecycleOwner
import cn.coolplay.mundonoticias.BuildConfig
import cn.coolplay.mundonoticias.MaxSplashActivity
import com.applovin.mediation.MaxAd
import com.applovin.mediation.MaxAdListener
import com.applovin.mediation.MaxError
import com.applovin.mediation.ads.MaxAppOpenAd
import com.applovin.sdk.AppLovinSdk

class AppOpenManager(private var applicationContext: Context) : DefaultLifecycleObserver,
    MaxAdListener {
    private var appOpenAd: MaxAppOpenAd = MaxAppOpenAd(BuildConfig.splashId, applicationContext)
    private var cActivity: MaxSplashActivity? = null

    init {
        appOpenAd.setListener(this)
        appOpenAd.loadAd()
    }

    private fun showAdIfReady() {
        if (!AppLovinSdk.getInstance(applicationContext).isInitialized) return
        if (appOpenAd.isReady) {
            appOpenAd.showAd("splash")
        } else {
            appOpenAd.loadAd()
        }
    }

    override fun onStart(owner: LifecycleOwner) {
        super.onStart(owner)
        Log.e("AppOpenManager", "splash onStart ${owner is MaxSplashActivity}")
        if (owner is MaxSplashActivity) {
            cActivity = owner
            showAdIfReady()
        }
    }

    override fun onDestroy(owner: LifecycleOwner) {
        super.onDestroy(owner)
        appOpenAd.destroy()
        cActivity?.lifecycle?.removeObserver(this)
        cActivity = null
    }

    override fun onAdLoaded(ad: MaxAd) {
        Log.e("AppOpenManager", "splash 加载成功 $cActivity")
        cActivity?.also {
            showAdIfReady()
        }
    }

    override fun onAdLoadFailed(adUnitId: String, error: MaxError) {
        appOpenAd.loadAd()
        cActivity?.goMain()
    }

    override fun onAdDisplayed(ad: MaxAd) {
        Log.e("AppOpenManager", "splash 展示成功")
        cActivity?.cancelTimer()
    }

    override fun onAdClicked(ad: MaxAd) {}

    override fun onAdHidden(ad: MaxAd) {
        appOpenAd.loadAd()
        cActivity?.goMain()
    }

    override fun onAdDisplayFailed(ad: MaxAd, error: MaxError) {
        appOpenAd.loadAd()
        cActivity?.goMain()
    }
}