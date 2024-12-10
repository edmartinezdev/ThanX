package com.app.thankxdriver;

import android.Manifest;
import android.annotation.SuppressLint;
import android.annotation.TargetApi;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.location.Location;
import android.os.Build;
import android.os.Bundle;
import android.os.IBinder;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.app.ActivityCompat;
import androidx.core.app.NotificationCompat;

import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.common.api.PendingResult;
import com.google.android.gms.common.api.Status;
import com.google.android.gms.location.LocationListener;
import com.google.android.gms.location.LocationRequest;
import com.google.android.gms.location.LocationServices;

import org.json.JSONException;
import org.json.JSONObject;

import java.net.URISyntaxException;

import io.socket.client.Ack;
import io.socket.client.IO;
import io.socket.client.Socket;
import io.socket.engineio.client.transports.WebSocket;


public class LiveTrackingService extends Service implements LocationListener, GoogleApiClient.ConnectionCallbacks, GoogleApiClient.OnConnectionFailedListener {


    private static final String CHANNEL_MIN = "channel_min_tracking";
    private static final String CHANNEL_LOW = "channel_low_tracking";

   static Context context;

    private NotificationManager mgr;
    private Socket mSocket;

//    private String trackingSocketUrl = "http://202.131.117.92:7046/v3/thankxTracking";
//    private String trackingSocketUrl = "http://35.225.98.185/v2/thankxTracking";
    private String trackingSocketUrl = "https://thankx.admindd.com/v3/thankxTracking";

    private double latitude;
    private double longitude;
    private int second = 3;

    private LocationRequest mLocationRequest;
    GoogleApiClient mGoogleApiClient;
    private String orderId ;
    private String customerId;
    private String driverId;
//    SharedPreferences sp = getApplicationContext();

/*

    public void startLiveTracking(Context ctxt,String orderId,String customerId,String driverId) {
        this.orderId = orderId ;
        this.customerId =customerId;
        this.driverId =driverId;

//        socketdetails = new SharedPreferences().getStringSet("socketdetails");`
        Intent i = new Intent(ctxt, LiveTrackingService.class);
        i.putExtra("order_id",orderId);
        i.putExtra("customer_id",customerId);
        i.putExtra("driver_id",driverId);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            ctxt.startForegroundService(i);
        } else {
            ctxt.startService(i);
        }
    }

    public void stopLiveTracking(Context ctxt) {
        Intent i = new Intent(ctxt, LiveTrackingService.class);
        ctxt.stopService(i);
    }
*/


    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        Log.d("DemoService", "onBind()");
        throw new IllegalStateException("Exception");
    }

    @Override
    public void onCreate() {
        super.onCreate();

        mgr = (NotificationManager) getSystemService(NOTIFICATION_SERVICE);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            initChannels();
        }
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {

        Log.i("socket ","on Start Command");

        connectWithSocket();

        // getting Data for socket Initialization
        this.orderId=intent.getStringExtra("order_id");
        this.driverId=intent.getStringExtra("driver_id");
        this.customerId=intent.getStringExtra("customer_id");


        // Notification coade
        String channel = CHANNEL_LOW;
        startForeground(13371, buildForegroundNotification(channel, ""));

        // Update location method
        createLocationRequest();

        mGoogleApiClient = new GoogleApiClient.Builder(this)
                .addApi(LocationServices.API)
                .addConnectionCallbacks(this)
                .addOnConnectionFailedListener(this)
                .build();

        mGoogleApiClient.connect();
        return (super.onStartCommand(intent, flags, startId));

    }

    private void connectWithSocket() {

        Log.i("socket ","connect with Socket");

        try {

            IO.Options socketOptions = new IO.Options();
            socketOptions.forceNew = true;
            socketOptions.secure = true;
            socketOptions.reconnection = true;
            socketOptions.upgrade = false ;

            socketOptions.transports = new String[]{WebSocket.NAME};

            mSocket = IO.socket(trackingSocketUrl,socketOptions);
            mSocket.connect();

        } catch (URISyntaxException e) {

            Log.i("socket",e.toString());
            e.printStackTrace();

        }

        mSocket.on(Socket.EVENT_CONNECT, args -> {

            Log.i("socket ","Socket cNNECTED=======================");

            try {

                JSONObject obj2 = new JSONObject();
                obj2.accumulate("socketId",mSocket.id());
                obj2.accumulate("driverId", driverId);

                mSocket.emit("driver-join", obj2, (Ack) args1 -> {
                    try{
                        JSONObject obj = (JSONObject) args1[0];
                        Log.i("emit","Driver Joined ***********************"+ obj.toString());
                    }catch (Exception e){

                    }

                });
            }catch (Exception e){
                Log.i("emit","Socket Disconnect"+e);
            }

        });
        mSocket.on(Socket.EVENT_DISCONNECT, args -> {
//                DebugLog.e("Socket tracking ==== connected ==");
            Log.i("socket ","Socket Disconnect");
        });

        mSocket.on(Socket.EVENT_CONNECT_ERROR,args -> {

            Log.i("socket ","Socket "+args[0].toString());

        });


    }


    @SuppressLint("RestrictedApi")
    protected void createLocationRequest() {
        mLocationRequest = new LocationRequest();
        mLocationRequest.setInterval(second * 1000);
        mLocationRequest.setFastestInterval(second * 1000);
        mLocationRequest.setPriority(LocationRequest.PRIORITY_HIGH_ACCURACY);
    }

    @Override
    public void onLocationChanged(Location location) {
        latitude = location.getLatitude();
        longitude = location.getLongitude();

        JSONObject obj1 = new JSONObject();
        try {
            Log.i("emit","*********************** orderId"+ orderId);
            obj1.put("orderId", this.orderId);
            obj1.put("customerId",this.customerId);
            obj1.put("driverId", this.driverId);
            obj1.put("latitude",latitude);
            obj1.put("longitude",longitude);
            mSocket.emit("update-driver-location",obj1,(Ack)args1->{
                try{
                    JSONObject obj = (JSONObject) args1[0];
                    Log.i("emit","***********************"+ obj.toString());
                }catch (Exception e){

                }
            });
        } catch (JSONException e) {
            e.printStackTrace();
        }
//        mSocket.emit("update-driver-location",args->{
//
//        });
    }

    @Override
    public void onConnected(@Nullable Bundle bundle) {
        startLocationUpdates();
    }


    @Override
    public void onConnectionSuspended(int i) {
    }


    @Override
    public void onConnectionFailed(@NonNull ConnectionResult connectionResult) {
    }


    /***************** Show Notification after reached *******************/

    @TargetApi(Build.VERSION_CODES.O)
    private void initChannels() {
        NotificationChannel channel = new NotificationChannel(CHANNEL_MIN, "Very Unimportant Notifications", NotificationManager.IMPORTANCE_DEFAULT);
        mgr.createNotificationChannel(channel);
        channel = new NotificationChannel(CHANNEL_LOW, "Fairly Unimportant Notifications", NotificationManager.IMPORTANCE_DEFAULT);
        mgr.createNotificationChannel(channel);
    }


    private Notification buildForegroundNotification(String channel, String address) {
        NotificationCompat.Builder b = new NotificationCompat.Builder(this, channel);
        b.setOngoing(true)
                .setContentTitle("")
                .setStyle(new NotificationCompat.BigTextStyle().bigText("Location Service"))
                .setSmallIcon(R.drawable.common_google_signin_btn_icon_light_focused)
                .setContentText("Location Service").build();

        b.setOngoing(false).setOnlyAlertOnce(false);

        return (b.build());
    }

    @Override
    public void onDestroy() {
        if (mGoogleApiClient != null) {
            stopLocationUpdates();
            mGoogleApiClient.disconnect();
            // mgr.cancelAll();
            if (mSocket != null)
                mSocket.disconnect();
        }
        super.onDestroy();
    }


    protected void startLocationUpdates() {
        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
            return;
        }
        PendingResult<Status> pendingResult = LocationServices.FusedLocationApi.requestLocationUpdates(mGoogleApiClient, mLocationRequest, this);
    }


    protected void stopLocationUpdates() {
        LocationServices.FusedLocationApi.removeLocationUpdates(mGoogleApiClient, this);
    }



}
