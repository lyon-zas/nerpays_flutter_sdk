package com.nearpays.nearpays_flutter_sdk

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.nfc.NfcAdapter
import androidx.annotation.NonNull
import com.nearpays.nearpaysnfcsdk.NfcScannerActivity
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry


/** NearpaysFlutterSdkPlugin */
class NearpaysFlutterSdkPlugin(
) : FlutterPlugin, MethodCallHandler, ActivityAware, PluginRegistry.ActivityResultListener {

    val METHOD_CHANNEL_NAME = "nearpays_flutter_sdk"
    private lateinit var channel: MethodChannel
    var activity: Activity? = null
    private var context: Context? = null
    var pendingResult: Result? = null
    private var activityBinding: ActivityPluginBinding? = null


    private fun startScanning() {

        val intent = Intent(context!!, NfcScannerActivity::class.java)
        val nfcAvailable = NfcAdapter.getDefaultAdapter(activity!!) != null
        if (!nfcAvailable) {
            intent.putExtra("camera", true)
        }
        activity?.startActivityForResult(intent, SCAN_REQUEST_CODE)
    }

    private fun isNfcAvailable(): String {
        NfcAdapter.getDefaultAdapter(activityBinding!!.activity) ?: return "false"
        return "true"
    }


    private val SCAN_REQUEST_CODE = 2023

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        //super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == SCAN_REQUEST_CODE) {
            if (resultCode == Activity.RESULT_OK) {
                if (data != null && data.hasExtra("scan")) {
                    val cardDetails = data.getStringExtra("scan")
                    try {
                        //channel?.invokeMethod("cardDetailsReceived", cardDetails)

                        pendingResult?.success(cardDetails)
                    } catch (e: Exception) {
                        pendingResult?.success(null)
                        e.printStackTrace()
                    }
                    pendingResult = null

                    return true
                } else {
                    pendingResult?.success(null)
                }
            } else if (resultCode == Activity.RESULT_CANCELED) {
                pendingResult?.success(null)
            }
            return true
        }
        return false
    }

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, METHOD_CHANNEL_NAME)
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext;
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        binding.addActivityResultListener(this);
    }

    override fun onDetachedFromActivityForConfigChanges() {
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activityBinding = binding
    }

    override fun onDetachedFromActivity() {
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "getPlatformVersion" -> {
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
            }

            "nfc_available" -> {
                val available = isNfcAvailable()
                result.success(available)
            }

            "swipe_card" -> {
                startScanning()
                pendingResult = result
            }

            "scan_card" -> {
                startScanning()
                pendingResult = result
            }

            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        context = null;
    }
}
