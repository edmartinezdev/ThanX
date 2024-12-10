package thankxuser.app.com.thankx_user

import android.util.DisplayMetrics
import android.util.Log
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity(), MethodChannel.MethodCallHandler {

    private var mResult: MethodChannel.Result? = null
    private var channel: MethodChannel? = null

    val CHANNEL: String  = "com.app.thankX_user"

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {

        mResult = result
        Log.v("Call Method", call.method)
        when {
            call.method == "getScreenWidth" -> {
                val displayMetrics = DisplayMetrics()
                windowManager.defaultDisplay.getMetrics(displayMetrics)
                val res = displayMetrics.widthPixels.toDouble() / displayMetrics.scaledDensity
                result.success(res)
            }
            call.method == "getScreenHeight" -> {
                val displayMetrics = DisplayMetrics()
                windowManager.defaultDisplay.getMetrics(displayMetrics)
                val res = displayMetrics.heightPixels.toDouble() / displayMetrics.scaledDensity
                result.success(res)
            }
//            call.method == "clearAllNotification" -> {
//                result.success("clearAllNotification")
//            }
            else -> result.notImplemented()
        }
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            this.onMethodCall(call, result)
        }
    }
}
