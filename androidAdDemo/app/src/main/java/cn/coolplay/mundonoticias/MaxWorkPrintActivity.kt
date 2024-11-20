package cn.coolplay.mundonoticias

import android.annotation.SuppressLint
import android.os.Bundle
import android.webkit.WebView
import android.webkit.WebViewClient
import androidx.appcompat.app.AppCompatActivity


class MaxWorkPrintActivity : AppCompatActivity() {

    private var webView: WebView? = null

    @SuppressLint("SetJavaScriptEnabled")
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_max_work_print)
        webView = findViewById(R.id.webView)
        webView?.settings?.javaScriptEnabled = true//启用JavaScript的支持
        webView?.webViewClient = WebViewClient()//目标的网页仍然在当前WebView中显示
        webView?.loadUrl("https://freshinsightsnow.com/")
    }

    override fun onBackPressed() {
        if (webView?.canGoBack() == true) {
            webView?.goBack()
        } else {
            super.onBackPressed()
        }
    }
}