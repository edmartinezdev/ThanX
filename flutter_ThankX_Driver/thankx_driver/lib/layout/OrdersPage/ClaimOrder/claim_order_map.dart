import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:thankxdriver/channel/platform_channel.dart';
import 'package:thankxdriver/control/navigation_serviece.dart';
import 'package:thankxdriver/localization/localization.dart';
import 'package:thankxdriver/model/my_current_order_model.dart';
import 'package:thankxdriver/utils/app_color.dart';
import 'package:thankxdriver/utils/app_image.dart';
import 'package:thankxdriver/utils/logger.dart';
import 'package:thankxdriver/utils/map_utils.dart';
import 'package:thankxdriver/utils/ui_utils.dart';
import 'package:thankxdriver/utils/utils.dart';



class ClaimOrderMap extends StatefulWidget {
  PickupLocation pickUp,dropOff;
  String overlayPolyLine;
  ClaimOrderMap({this.pickUp,this.dropOff, this.overlayPolyLine});

  @override
  _ClaimOrderMapState createState() => _ClaimOrderMapState();
}

class _ClaimOrderMapState extends State<ClaimOrderMap> {

  BitmapDescriptor pinLocationIcon;
  Set<Marker> _markers = {};

  Set<Polyline> _polylines = {};
  bool isMyLocationEnabled  = false;

  // for my custom icons

  BitmapDescriptor sourceIcon;
  BitmapDescriptor destinationIcon;

  GoogleMapController mapController ;
  Completer<GoogleMapController> _controller = Completer();

  static CameraPosition _cameraPosition;

  @override
  void initState() {
    _cameraPosition =  CameraPosition(
      target: LatLng(widget.pickUp.latitude, widget.pickUp.longitude),
      zoom: 11.4746,
    );

    setSourceAndDestinationIcons();
    super.initState();
  }

  //Setting Polylines Between two points
  void setSourceAndDestinationIcons() async {
    sourceIcon = await MapUtils().getBitmapIcon(AppImage.map);
    destinationIcon = await MapUtils().getBitmapIcon(AppImage.flag);
  }

  void setMapPins() {
    setState(() {
      // source pin
      _markers.add(Marker(
          markerId: MarkerId("PickUp"),
          position: LatLng(widget.pickUp.latitude,widget.pickUp.longitude),
          icon: sourceIcon
      ));
      // destination pin
      _markers.add(Marker(
          markerId: MarkerId("DropOff"),
          position: LatLng(widget.dropOff.latitude,widget.dropOff.longitude),
          icon: destinationIcon
      ));
    });
  }

  setPolylines() async {

    Polyline polyline = await MapUtils().getPolylineFormEncodedString(this.widget.overlayPolyLine);
    _polylines.add(polyline);

    setState(() {});
  }




  @override
  Widget build(BuildContext context) {

    if (this.widget.overlayPolyLine.isNotEmpty && this._polylines.toSet().isEmpty) {
      this.setPolylines();
    }

    return  Stack(
      children: <Widget>[
        Container(
          child: ClipRRect(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
            child:GoogleMap(
              myLocationButtonEnabled:false,
              mapType: MapType.normal,
              myLocationEnabled: isMyLocationEnabled,
              initialCameraPosition: _cameraPosition,
              zoomControlsEnabled: false,
              compassEnabled: false,
              markers: _markers,
              polylines: _polylines,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                mapController = controller;

                //setting pins
                setMapPins();

                //Sets Camera between Two Locations
                MapUtils().cameraLocationUpdate(LatLng(widget.pickUp.latitude,widget.pickUp.longitude),LatLng(widget.dropOff.latitude,widget.dropOff.longitude),this.mapController,70);

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
