package cn.coolplay.mundonoticias

import android.content.Intent
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import androidx.appcompat.app.AppCompatActivity

class MaxSplashActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.splash)
        Handler(Looper.getMainLooper()).postDelayed({
            goMain()
        }, 3000)
    }

    private fun goMain() {
        startActivity(Intent(this, MaxMainActivity::class.java))
        finish()
    }

}