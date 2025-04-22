package cn.coolplay.mundonoticias

import android.R.layout
import android.os.Bundle
import android.util.Log
import android.widget.FrameLayout
import androidx.appcompat.app.AppCompatActivity
import com.mofeng.ff.component.open.Sdk
import com.tcl.ff.component.vastad.Controller
import com.tcl.ff.component.vastad.core.callbacks.LazyLoaderAdListener


class  MaxSplashActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.splash)
        val adContainer = findViewById<FrameLayout>(R.id.adContainer)
        Sdk.getAd().setEnableLog(true)
        Sdk.getAd().begin(this).lazyLoad().listen(object : LazyLoaderAdListener {
            override fun onAdLoaded(controller: Controller) {
                Log.e("aaa", "onAdLoaded")
                controller.start(adContainer)
            }

            override fun onAdFinished() {
                Log.e("aaa", "onAdFinished")
            }

            override fun onAdError() {
                Log.e("aaa", "onAdError")
            }

            override fun onContainerSizeError() {
                Log.e("aaa", "onContainerSizeError")
            }
        }).start()

//        Handler(Looper.getMainLooper()).postDelayed({
//            goMain()
//        }, 3000)
    }

//    private fun goMain() {
//        startActivity(Intent(this, MaxMainActivity::class.java))
//        finish()
//    }

}