package com.example.android_webview

import android.os.Bundle
import android.webkit.WebView
import androidx.appcompat.app.AppCompatActivity

class MainActivity : AppCompatActivity() {

    private lateinit var webview: WebView

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        setSupportActionBar(findViewById(R.id.toolbar))

        webview = findViewById(R.id.webview)
        webview.settings.javaScriptEnabled = true

        webview.loadUrl("https://github.com")
    }
}