package com.app.thankxdriver

import android.Manifest
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.provider.Settings
import android.util.DisplayMetrics
import android.util.Log
import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi
import androidx.core.app.ActivityCompat
import androidx.localbroadcastmanager.content.LocalBroadcastManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class  MainActivity: FlutterActivity() {

    val CHANNEL: String = "com.app.ThankXDriver"
    lateinit var customerId:String
    lateinit var driverId:String
    lateinit var i : Intent
    lateinit var serviceIntent : Intent

    //notification
    private var methodResult: MethodChannel.Result? = null
    private var methodcall: MethodCall? = null
    lateinit var orderId:String
    private var channel: MethodChannel? = null
    private var localBroadcastManager: LocalBroadcastManager? = null
    var permissionStatus:String?= null
    var isServiceChannel:Boolean = false

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {

        GeneratedPluginRegistrant.registerWith(flutterEngine)
        channel =  MethodChannel(flutterEngine.dartExecutor.binaryMessenger , CHANNEL)

         channel?.setMethodCallHandler {
              
            call, result -> 
              
              when {
            call.method == "startLocationService" -> {
                
                // setting data
                isServiceChannel = true
                i = Intent(applicationContext, LiveTrackingService::class.java)

                Log.i("service", "Service Me")
                orderId = call.argument<String>("orderId").toString()
                customerId = call.argument<String>("customerId").toString()
                driverId = call.argument<String>("driverId").toString()

                // putting Data in Intent to access it in service
                i.putExtra("order_id", orderId)
                i.putExtra("customer_id", customerId)
                i.putExtra("driver_id", driverId)

                //check if permission is granted
                if (isLocationPermissionGranted()) {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        this.startForegroundService(i)
                    } else {
                        this.startService(i)
                    }
                }else{
                    var list = arrayOf(Manifest.permission.ACCESS_FINE_LOCATION, Manifest.permission.ACCESS_COARSE_LOCATION)
                    ActivityCompat.requestPermissions(this,list,1)
                }
                result.success("String From Android")
            }
              
            call.method == "stopLocationService" -> {
//                    livetrack.stopLiveTracking(this)
                serviceIntent = Intent(applicationContext, LiveTrackingService::class.java)
                stopService(serviceIntent)
            }
              
            call.method == "openSetting" -> {
                i = Intent()
                i.action = Settings.ACTION_APPLICATION_DETAILS_SETTINGS
                i.data = Uri.fromParts("package" , getPackageName(),null)
                startActivity(i)
            }
              
            call.method == "clearAllNotification" -> {
                result.success("clearAllNotification")
            }
            else -> result.notImplemented()
        }

        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {

        super.onCreate(savedInstanceState)

        localBroadcastManager = LocalBroadcastManager.getInstance(this@MainActivity)
        
    }

    fun isLocationPermissionGranted(): Boolean {
//        val serviceIntent = Intent(this, ForegroundService::class.java)
//        serviceIntent.putExtra("inputExtra", "Foreground Service Example in Android")
        if (Build.VERSION.SDK_INT >= 23) {
            if (checkSelfPermission(Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED && checkSelfPermission(Manifest.permission.ACCESS_COARSE_LOCATION) == PackageManager.PERMISSION_GRANTED) {
                return true
            } else {
//                var list = arrayOf(Manifest.permission.ACCESS_FINE_LOCATION,Manifest.permission.ACCESS_COARSE_LOCATION)
//                ActivityCompat.requestPermissions(this,list,1)
                return false
            }
        } else { //permission is automatically granted on sdk<23 upon installation
            return true
        }
    }

    @RequiresApi(Build.VERSION_CODES.M)
    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)

        when (requestCode) {
            1 -> {
                var isPerpermissionForAllGranted = (grantResults[0]==0)
                Log.d("value", "grent length"+grantResults.size+"per"+permissions.size)

                if (grantResults.size > 0 && permissions.size == grantResults.size && isPerpermissionForAllGranted) {
//                        isPerpermissionForAllGranted = grantResults[0] == PackageManager.PERMISSION_GRANTED
                    Log.e("value", "Permission Granted, Now you can use local drive .")
                    permissionStatus = "Accepted"
                    Log.d("Permission Status", permissionStatus!!)
                }else if (!shouldShowRequestPermissionRationale( permissions[0])){
                    permissionStatus="NeverAskAgain"
                }
                else {
//                    isPerpermissionForAllGranted = true
                    permissionStatus="Denied"
                    Log.e("value", "Permission Denied, You cannot use local drive .")
                }
                if (isPerpermissionForAllGranted && isServiceChannel) {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        this.startForegroundService(i)
                    } else {
                        this.startService(i)
                    }
                }
                else{
                    stopService(serviceIntent)
                    if(methodcall!!.method=="grantLocationPermission")
                        methodResult!!.success(permissionStatus)
//                    var list = arrayOf(Manifest.permission.ACCESS_FINE_LOCATION,Manifest.permission.ACCESS_COARSE_LOCATION)
//                    ActivityCompat.requestPermissions(this,list,1)
                }
            }
        }
    }

}
