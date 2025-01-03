package cn.coolplay.mundonoticias

import android.content.Intent
import android.os.Bundle
import android.widget.Button
import android.widget.FrameLayout
import androidx.appcompat.app.AppCompatActivity
import cn.coolplay.mundonoticias.adPreLoad.AdPreLoadView
import cn.coolplay.mundonoticias.adPreLoad.MaxAdPreDrawActivity
import cn.coolplay.mundonoticias.adPreLoad.MaxPreSearchActivity
import com.applovin.mediation.MaxAd
import com.applovin.mediation.MaxAdListener
import com.applovin.mediation.MaxError
import com.applovin.mediation.ads.MaxRewardedAd
import com.applovin.sdk.AppLovinSdk


class MaxMainActivity : AppCompatActivity(), MaxAdListener {
    var isShowReward = false
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_max_main)
        findViewById<Button>(R.id.tv_ai_draw).setOnClickListener {
            startActivity(Intent(this, MaxAdDrawActivity::class.java))

        }
        // 预加载广告  这里只是做了预加载 实现方式 不是必须的。开发中可参考自我实现
        findViewById<Button>(R.id.tv_ai_pre_draw).setOnClickListener {
            startActivity(Intent(this, MaxAdPreDrawActivity::class.java))

        }
        // 预加载广告  这里只是做了预加载 实现方式 不是必须的。开发中可参考自我实现
        findViewById<Button>(R.id.tv_ai_search_pic_pre).setOnClickListener {
            startActivity(Intent(this, MaxPreSearchActivity::class.java))

        }
        findViewById<Button>(R.id.tv_work_print).setOnClickListener {
            startActivity(Intent(this, MaxWorkPrintActivity::class.java))
        }
        findViewById<Button>(R.id.tv_ai_search_pic).setOnClickListener {
            startActivity(Intent(this, MaxSearchActivity::class.java))
        }
        findViewById<Button>(R.id.reward).setOnClickListener {
            val adview = AdPreLoadView.getAdView("RewardView")?.maxRewardedAd
            //如果已经loaded 直接显示
            if (AdPreLoadView.isLoadedAd("RewardView") && adview?.isReady == true) {
                adview.showAd(this)
            } else {
                isShowReward = true
            }
        }
        findViewById<Button>(R.id.tv_show_debug).setOnClickListener {
            Runnable { AppLovinSdk.getInstance(applicationContext).showMediationDebugger() }.run()
        }
    }

    override fun onResume() {
        super.onResume()
        AdPreLoadView.addAdListener("RewardView", this)

    }

    override fun onStop() {
        super.onStop()
        AdPreLoadView.removeAdListener("RewardView")

    }

    override fun onDestroy() {
        AdPreLoadView.onDestroyView(true)
        super.onDestroy()
    }

    override fun onAdLoaded(p0: MaxAd) {
        if (!isShowReward) return
        isShowReward = false
        val adview = AdPreLoadView.getAdView("RewardView")?.maxRewardedAd
        //如果已经loaded 直接显示
        if (adview?.isReady == true) {
            adview.showAd(this)
        }
    }

    override fun onAdDisplayed(p0: MaxAd) {

    }

    override fun onAdHidden(p0: MaxAd) {

    }

    override fun onAdClicked(p0: MaxAd) {

    }

    override fun onAdLoadFailed(p0: String, p1: MaxError) {

    }

    override fun onAdDisplayFailed(p0: MaxAd, p1: MaxError) {

    }

}