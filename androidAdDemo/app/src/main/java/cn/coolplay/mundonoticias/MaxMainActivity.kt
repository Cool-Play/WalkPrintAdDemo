package cn.coolplay.mundonoticias

import android.content.Intent
import android.os.Bundle
import android.widget.Button
import androidx.appcompat.app.AppCompatActivity
import cn.coolplay.mundonoticias.adPreLoad.MaxAdPreDrawActivity
import cn.coolplay.mundonoticias.adPreLoad.MaxPreSearchActivity
import com.applovin.sdk.AppLovinSdk


class MaxMainActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_max_main)
        findViewById<Button>(R.id.tv_ai_draw).setOnClickListener {
            startActivity(Intent(this, MaxAdPreDrawActivity::class.java))

        }
        findViewById<Button>(R.id.tv_work_print).setOnClickListener {
            startActivity(Intent(this, MaxWorkPrintActivity::class.java))
        }
        findViewById<Button>(R.id.tv_ai_search_pic).setOnClickListener {
            startActivity(Intent(this, MaxPreSearchActivity::class.java))
        }
        findViewById<Button>(R.id.tv_show_debug).setOnClickListener {
            Runnable { AppLovinSdk.getInstance(applicationContext).showMediationDebugger() }.run()
        }
    }


}