package com.example.android_webview

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.webkit.*
import android.widget.Button
import androidx.appcompat.app.AppCompatActivity
import androidx.fragment.app.Fragment
import androidx.navigation.NavController
import androidx.navigation.Navigation
import androidx.navigation.fragment.findNavController
import androidx.navigation.ui.NavigationUI

class MainActivity : AppCompatActivity() {

    private lateinit var navController: NavController

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        setSupportActionBar(findViewById(R.id.toolbar))

        navController = Navigation.findNavController(this, R.id.nav_host_fragment)
        NavigationUI.setupActionBarWithNavController(this, navController)
    }

    override fun onSupportNavigateUp(): Boolean {
        return navController.navigateUp()
    }
}

class MainFragment : Fragment() {

    override fun onCreateView(
            inflater: LayoutInflater, container: ViewGroup?,
            savedInstanceState: Bundle?
    ): View? {
        // Inflate the layout for this fragment
        return inflater.inflate(R.layout.fragment_main, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        view.findViewById<Button>(R.id.webView).setOnClickListener {
            findNavController().navigate(R.id.webView)
        }
    }
}

class WebViewFragment : Fragment() {

    override fun onCreateView(
            inflater: LayoutInflater, container: ViewGroup?,
            savedInstanceState: Bundle?
    ): View? {
        // Inflate the layout for this fragment
        return inflater.inflate(R.layout.fragment_webview, container, false)
    }

    private lateinit var webView: WebView

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        webView = view.findViewById(R.id.webView)
        webView.settings.javaScriptEnabled = true
        webView.webViewClient = webViewClient
        webView.webChromeClient = chromeClient

        webView.loadUrl("https://sunbreak.github.io/webview.trial/index.html")
    }

    private val webViewClient = object : WebViewClient() {
        override fun shouldInterceptRequest(view: WebView, url: String): WebResourceResponse? {
            println("shouldInterceptRequest(WebView, url) $url")
            return intercept(url) ?: super.shouldInterceptRequest(view, url)
        }

        override fun shouldInterceptRequest(view: WebView, request: WebResourceRequest): WebResourceResponse? {
            println("shouldInterceptRequest(WebView, WebResourceRequest) ${request.url}")
            return intercept(request.url.toString()) ?: super.shouldInterceptRequest(view, request)
        }
    }

    private fun intercept(url: String): WebResourceResponse? {
        if (url == "https://sunbreak.github.io/webview.trial/index.js") {
            val data = "alert('Local alert');".byteInputStream()
            return WebResourceResponse("application/javascript", "utf-8", data).apply {
                setStatusCodeAndReasonPhrase(200, "OK")
            }
        }
        return null
    }

    private val chromeClient = object : WebChromeClient() {
        override fun onJsAlert(view: WebView?, url: String?, message: String?, result: JsResult?): Boolean {
            println("onJsAlert $url, $message")
            return super.onJsAlert(view, url, message, result)
        }
    }
}