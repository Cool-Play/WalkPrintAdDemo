package cn.coolplay.mundonoticias

import android.app.Activity
import android.app.Application
import android.content.Context
import android.net.Uri
import android.os.Bundle
import android.util.Log
import cn.coolplay.mundonoticias.adPreLoad.AdPreLoadView
import com.adjust.sdk.Adjust
import com.adjust.sdk.AdjustConfig
import com.applovin.sdk.AppLovinMediationProvider
import com.applovin.sdk.AppLovinSdk
import com.applovin.sdk.AppLovinSdkInitializationConfiguration
import com.google.android.gms.ads.identifier.AdvertisingIdClient
import java.util.Collections
import java.util.concurrent.Executors


class App : Application() {



    override fun attachBaseContext(base: Context?) {
        super.attachBaseContext(base)
    }


    override fun onCreate() {
        super.onCreate()
        initSdk()
    }

    private fun initSdk() {
        val executor = Executors.newSingleThreadExecutor();
        executor.execute {
            val initConfigBuilder =
                AppLovinSdkInitializationConfiguration.builder(BuildConfig.sdkKey, this)
                    .setMediationProvider(AppLovinMediationProvider.MAX)
            val currentGaid = AdvertisingIdClient.getAdvertisingIdInfo(this).id
            if (currentGaid != null) {
                Log.i("Applovin", "currentGaid: $currentGaid")
                initConfigBuilder.testDeviceAdvertisingIds = Collections.singletonList(currentGaid)
            }

            val initConfig = initConfigBuilder.build()
            AppLovinSdk.getInstance(this).apply {
                //如果要从 GDPR 区域外部测试 Google CMP，请使用以下方法之一将调试用户地理位置设置为：GDPR
//                settings.setExtraParameter("google_test_device_hashed_id", "a5cabc60-3d80-4df0-9265-282aaacddab1")
                settings.termsAndPrivacyPolicyFlowSettings.apply {
                    isEnabled = true
                    privacyPolicyUri = Uri.parse("https://imsoauthh5.efercro.com/privacyPrint.html")
                    //如果要从 GDPR 区域外部测试 Google CMP，请使用以下方法之一将调试用户地理位置设置为：GDPR
//                    debugUserGeography = AppLovinSdkConfiguration.ConsentFlowUserGeography.GDPR

                }
                initialize(initConfig) {
                    Log.i("Applovin", "onSdkInitialized")
                    // Initialize Adjust SDK 统计目前不需要
//                    val config =
//                        AdjustConfig(this@App, "{YourAppToken}", AdjustConfig.ENVIRONMENT_SANDBOX)
//                    Adjust.onCreate(config)
//                    registerActivityLifecycleCallbacks(AdjustLifecycleCallbacks())
                    //与加载广告
                    AdPreLoadView.loadAdView(this@App)
                }
            }
            executor.shutdown()
        }
    }

    private class AdjustLifecycleCallbacks : ActivityLifecycleCallbacks {
        override fun onActivityCreated(activity: Activity, bundle: Bundle?) {}

        override fun onActivityStarted(activity: Activity) {}

        override fun onActivityResumed(activity: Activity) {
            Adjust.onResume()
        }

        override fun onActivityPaused(activity: Activity) {
            Adjust.onPause()
        }

        override fun onActivityStopped(activity: Activity) {}

        override fun onActivitySaveInstanceState(activity: Activity, bundle: Bundle) {}

        override fun onActivityDestroyed(activity: Activity) {}
    }

}