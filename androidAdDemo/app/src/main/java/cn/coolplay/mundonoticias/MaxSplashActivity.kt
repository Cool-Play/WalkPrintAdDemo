package cn.coolplay.mundonoticias

import android.content.Intent
import android.os.Bundle
import android.widget.FrameLayout
import androidx.appcompat.app.AppCompatActivity
import cn.coolplay.mundonoticias.utils.AppOpenManager

class MaxSplashActivity : AppCompatActivity() {
    private val timeRunner = Runnable {
        goMain()
    }
    var adContainer: FrameLayout? = null
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.splash)
        val openManager = AppOpenManager(this)
        adContainer = findViewById(R.id.adContainer)
        lifecycle.addObserver(openManager)
        adContainer?.postDelayed(timeRunner, 5000)
    }

    fun cancelTimer() {
        adContainer?.removeCallbacks(timeRunner)
    }

    fun goMain() {
        startActivity(Intent(this, MaxMainActivity::class.java))
        finish()
    }
}