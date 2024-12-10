import 'dart:async';
import 'dart:io' show Platform;

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:thankxdriver/channel/platform_channel.dart';
import 'package:thankxdriver/control/navigation_serviece.dart';
import 'package:thankxdriver/localization/localization.dart';
import 'package:thankxdriver/model/order_details_data.dart';
import 'package:thankxdriver/utils/app_color.dart';
import 'package:thankxdriver/utils/logger.dart';
import 'package:thankxdriver/utils/map_utils.dart';
import 'package:thankxdriver/utils/ui_utils.dart';
import 'package:thankxdriver/utils/utils.dart';

import '../../../../utils/app_image.dart';

class ClaimedOrderMap extends StatefulWidget {
  OrderDetailsData order;
  int orderStatus;

  ClaimedOrderMap({this.order,this.orderStatus});

  @override
  _ClaimedOrderMapState createState() => _ClaimedOrderMapState();
}

class _ClaimedOrderMapState extends State<ClaimedOrderMap> with AfterLayoutMixin {

  Timer timer;

  BitmapDescriptor pinLocationIcon;
  Marker sourceMarker,destinationMarker,driverMarker;

  Polyline _driverPolyLine;
  Set<Polyline> _polylines = {};

  // for my custom icons

  BitmapDescriptor sourceIcon;
  BitmapDescriptor destinationIcon;
  BitmapDescriptor driverIcon;

  GoogleMapController mapController ;
  Completer<GoogleMapController> _controller = Completer();
  LatLng SOURCE_LOCATION;
  LatLng DEST_LOCATION;
  LatLng driverLocation;

  CameraPosition _cameraPosition ;

  bool isMyLocationEnabled  = false;
  bool driverLocationUpdated = false;

  @override
  void initState() {

    SOURCE_LOCATION = LatLng(this.widget?.order?.pickupLocation?.latitude ?? 0.0,this.widget?.order?.pickupLocation?.longitude ?? 0.0);
    DEST_LOCATION= LatLng(this.widget?.order?.dropoffLocation?.latitude ?? 0.0 ,this.widget?.order?.dropoffLocation?.longitude ?? 0.0);

    _cameraPosition =  CameraPosition(
      target:LatLng(this.widget?.order?.pickupLocation?.latitude ?? 0.0,this.widget?.order?.pickupLocation?.longitude ?? 0.0),
      zoom: 11.4746,
    );

    timer = Timer.periodic(Duration(seconds: 5),(t){
      updateCameraLocation();
    });

    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) {

    //Setting Polyline
    setPolylines(driverLocation: null);
  }


  void dispose(){
    super.dispose();
    timer.cancel();
  }

  setUpSourceLocation(){

    if(SOURCE_LOCATION.latitude == 0.0 && SOURCE_LOCATION.longitude == 0.0 && mapController!=null ) {
      SOURCE_LOCATION = LatLng(this.widget.order?.pickupLocation?.latitude ?? 0.0, this.widget.order?.pickupLocation?.longitude ?? 0.0);
      DEST_LOCATION = LatLng(this.widget.order?.dropoffLocation?.latitude ?? 0.0, this.widget.order?.dropoffLocation?.longitude ?? 0.0);

      // source pin
      sourceMarker = Marker(markerId: MarkerId("PickUp"), position: SOURCE_LOCATION, icon: sourceIcon);
      // destination pin
      destinationMarker = Marker(markerId: MarkerId("DropOff"), position: DEST_LOCATION, icon: destinationIcon);

      setState(() {});

      MapUtils().cameraLocationUpdateForList((this.driverLocation != null) ? [this.driverLocation, SOURCE_LOCATION, DEST_LOCATION] : [SOURCE_LOCATION, DEST_LOCATION], this.mapController, 70);

       }
    }


  updateCameraLocation() async {
    PermissionGroup group = Platform.isIOS ? PermissionGroup.locationWhenInUse : PermissionGroup.location;
    bool isPermission = await PlatformChannel().checkForPermission(group);
    // Permission Denied by user
    if (!isPermission) { return; }

   final LatLng location = await PlatformChannel().getLocation();
   driverLocation = location;
   driverMarker = Marker(
       markerId: MarkerId("Driver"),
       position: driverLocation,
       anchor: Offset(0.5,0.5),
       icon: driverIcon
   );

   if(!driverLocationUpdated) {

    driverLocationUpdated=true;
    MapUtils().cameraLocationUpdateForList([driverLocation, SOURCE_LOCATION, DEST_LOCATION], this.mapController, 70);
   }
   // getting Polyline for driver to source and destination
   setPolylines(driverLocation: driverLocation);

   if(mounted)
   setState(() {});

  }


  void setSourceAndDestinationIcons() async {
    sourceIcon = await MapUtils().getBitmapIcon((this.widget.orderStatus > 3)?AppImage.mapActive : AppImage.map);

    destinationIcon = await MapUtils().getBitmapIcon((this.widget.orderStatus > 4)?AppImage.flagActive : AppImage.flag);

    driverIcon = await MapUtils().getBitmapIcon(AppImage.locationPoint);
  }

  void setMapPins() {

    // source pin
      sourceMarker = Marker(
          markerId: MarkerId("PickUp"),
          position: SOURCE_LOCATION,
          icon: sourceIcon
      );

    // destination pin
     destinationMarker = Marker(
          markerId: MarkerId("DropOff"),
          position: DEST_LOCATION,
          icon: destinationIcon
      );

      setState(() {});

  }

  setPolylines({LatLng driverLocation}) async {

    // PolyLine from driver to source to destination
    if (!(this.widget.order.overviewPolyline.isNotEmpty && _polylines.toList().isEmpty)) { return; }

    Polyline polyline = await MapUtils().getPolylineFormEncodedString(this.widget.order.overviewPolyline);

    _polylines.clear();
    _polylines.add(polyline);

    setState(() {});

  }



  @override
  Widget build(BuildContext context) {

    setSourceAndDestinationIcons();
    setUpSourceLocation();
    setMapPins();
    setPolylines();


    return  Stack(
      children: <Widget>[
        Container(
          child: ClipRRect(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
            child: GoogleMap(
              myLocationButtonEnabled:false,
              myLocationEnabled: false,
              mapType: MapType.normal,
              initialCameraPosition: _cameraPosition,
              zoomControlsEnabled: false,
              compassEnabled: false,
              markers: Set.of((driverMarker != null?[sourceMarker,destinationMarker,driverMarker]:[sourceMarker,destinationMarker])),
              polylines: _polylines,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                mapController = controller;

                //setting pins
                setMapPins();

                //Sets Camera between Two Locations
                MapUtils().cameraLocationUpdate(SOURCE_LOCATION,DEST_LOCATION,this.mapController,70);

              },
            ),
          ),
        ),
        Positioned(
          top: UIUtills().getProportionalWidth(20),right: UIUtills().getProportionalWidth(10),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColor.whiteColor,
            ),
            height: UIUtills().getProportionalWidth(50),
            width: UIUtills().getProportionalWidth(50),
            child: IconButton(icon: Icon(Icons.my_location),onPressed: _getToCurrentLocation,),
          ),
        ),
      ],
    );
  }

  Future<void> _getToCurrentLocation() async {


    Logger().v("Check for location permission");
    PermissionGroup group = Platform.isIOS ? PermissionGroup.locationWhenInUse : PermissionGroup.location;
    final bool result = await PlatformChannel().checkForPermission(group);
    if (result == false) {

      Utils.showAlert(NavigationService().navigatorKey.currentState.overlay.context, message: AppTranslations.globalTranslations.locationPermissionAlert, arrButton: [AppTranslations.globalTranslations.buttonCancel, AppTranslations.globalTranslations.buttonOk],
        callback: (int index) async {
          if (index == 1) {
            PlatformChannel().openAppSetting().then((r){
              _getToCurrentLocation();
            });
            isMyLocationEnabled = true;
            setState(() {});
          }else{
//            getCurrentLocation();

            isMyLocationEnabled = true;
            setState(() {});
          }
        },
      );
      return;
    }
    isMyLocationEnabled = true;
    setState(() {});

    final LatLng location = await PlatformChannel().getLocation();


    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: location,zoom: 12)));
//    MapUtils().cameraLocationUpdateForList((this.driverLocation != null) ? [this.driverLocation, SOURCE_LOCATION, DEST_LOCATION,LatLng(_currentPosition.latitude,_currentPosition.longitude)] : [SOURCE_LOCATION, DEST_LOCATION,LatLng(_currentPosition.latitude,_currentPosition.longitude)], this.mapController, 70);

  }


}
