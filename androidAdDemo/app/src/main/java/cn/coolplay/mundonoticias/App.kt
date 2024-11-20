package cn.coolplay.mundonoticias

import android.app.Application
import android.content.Context
import android.util.Log
import com.applovin.sdk.AppLovinMediationProvider
import com.applovin.sdk.AppLovinSdk
import com.applovin.sdk.AppLovinSdkInitializationConfiguration
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
            val initConfig =
                AppLovinSdkInitializationConfiguration.builder(BuildConfig.sdkKey, this)
                    .setMediationProvider(AppLovinMediationProvider.MAX)
                    .build()

            AppLovinSdk.getInstance(this).initialize(initConfig) {
                Log.i("Applovin", "onSdkInitialized")
            }
            executor.shutdown()
        }
    }
}