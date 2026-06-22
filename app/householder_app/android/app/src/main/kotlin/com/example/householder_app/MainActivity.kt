package com.example.householder_app

import android.content.Context
import android.net.ConnectivityManager
import android.net.Network
import android.net.NetworkCapabilities
import android.net.NetworkRequest
import android.os.Handler
import android.os.Looper
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val methodChannelName = "app.householder/connectivity"
    private val eventChannelName = "app.householder/connectivity/events"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val messenger = flutterEngine.dartExecutor.binaryMessenger
        val cm = getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager

        MethodChannel(messenger, methodChannelName).setMethodCallHandler { call, result ->
            when (call.method) {
                "status" -> result.success(if (isOnline(cm)) "online" else "offline")
                else -> result.notImplemented()
            }
        }

        EventChannel(messenger, eventChannelName).setStreamHandler(
            ConnectivityStreamHandler(cm)
        )
    }

    private fun isOnline(cm: ConnectivityManager): Boolean {
        val network = cm.activeNetwork ?: return false
        val caps = cm.getNetworkCapabilities(network) ?: return false
        return caps.hasCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET)
    }

    /** Pushes "online"/"offline" to Dart via an [EventChannel] as the network changes. */
    private class ConnectivityStreamHandler(
        private val cm: ConnectivityManager,
    ) : EventChannel.StreamHandler {
        private val mainHandler = Handler(Looper.getMainLooper())
        private var callback: ConnectivityManager.NetworkCallback? = null

        override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
            val sink = events ?: return
            val cb = object : ConnectivityManager.NetworkCallback() {
                override fun onAvailable(network: Network) {
                    mainHandler.post { sink.success("online") }
                }

                override fun onLost(network: Network) {
                    mainHandler.post { sink.success("offline") }
                }
            }
            callback = cb
            cm.registerNetworkCallback(
                NetworkRequest.Builder()
                    .addCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET)
                    .build(),
                cb,
            )
        }

        override fun onCancel(arguments: Any?) {
            callback?.let { cm.unregisterNetworkCallback(it) }
            callback = null
        }
    }
}
