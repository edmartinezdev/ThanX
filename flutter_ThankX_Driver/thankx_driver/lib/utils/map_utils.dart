import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:thankxdriver/api_provider/api_constant.dart';
import 'package:thankxdriver/utils/polyline_utils.dart';

import 'app_color.dart';
import 'app_image.dart';

class MapUtils{



  factory MapUtils(){
    return _instance;
  }

  static MapUtils _instance = MapUtils._internal();

  MapUtils._internal();

  // convert icon to bitmap for map
  getBitmapIcon(String image){
    return BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        image);
  }

  getPolyline(LatLng source, LatLng destination) async {
    final response = await PolyLineUtil().getRouteBetweenCoordinates(source: source, destination: destination,);
    if (response.status) {
      return Polyline(
        polylineId: PolylineId("PickUp"),
        visible: true,
        width: 2,
        color: AppColor.textColor,
        points: response.arrLatLng,
      );
    } else {
      return null;
    }
  }

  getPolylineFormEncodedString(String encoded) async {
    final arrList = PolyLineUtil().decodeEncodedPolyline(encoded);
    return Polyline(
      polylineId: PolylineId("PickUp"),
      visible: true,
      width: 2,
      color: AppColor.textColor,
      points: arrList,
    );
  }

  getPolylineBetweenThreePoints(LatLng driver ,LatLng source,LatLng destination) async {
    final response = await PolyLineUtil().getRouteBetweenCoordinates(source: driver, destination: destination, wayPoint: [source]);
    if (response.status) {
      return Polyline(
        polylineId: PolylineId("PickUp"),
        visible: true,
        width: 2,
        color: AppColor.textColor,
        points: response.arrLatLng,
      );
    } else {
      return null;
    }
  }

  // TO Focus Camera between two points
  cameraLocationUpdate(LatLng source ,LatLng destination,GoogleMapController mapController,double padding){

    LatLngBounds bound;
    if (source.latitude > destination.latitude &&
        source.longitude > destination.longitude) {
      bound = LatLngBounds(southwest: destination, northeast: source);
    } else if (source.longitude > destination.longitude) {
      bound = LatLngBounds(
          southwest: LatLng(source.latitude, destination.longitude),
          northeast: LatLng(destination.latitude, source.longitude));
    } else if (source.latitude > destination.latitude) {
      bound = LatLngBounds(
          southwest: LatLng(destination.latitude, source.longitude),
          northeast: LatLng(source.latitude, destination.longitude));
    } else {
      bound = LatLngBounds(southwest: source, northeast: destination);
    }

    CameraUpdate u2 = CameraUpdate.newLatLngBounds(bound, padding,);
    mapController.animateCamera(u2).then((void v){
      check(u2,mapController);
    });
  }

  getLatLngBounds(LatLng source ,LatLng destination){
    LatLngBounds bound;

    if (source.latitude > destination.latitude &&
        source.longitude > destination.longitude) {
      bound = LatLngBounds(southwest: destination, northeast: source);
    } else if (source.longitude > destination.longitude) {
      bound = LatLngBounds(
          southwest: LatLng(source.latitude, destination.longitude),
          northeast: LatLng(destination.latitude, source.longitude));
    } else if (source.latitude > destination.latitude) {
      bound = LatLngBounds(
          southwest: LatLng(destination.latitude, source.longitude),
          northeast: LatLng(source.latitude, destination.longitude));
    } else {
      bound = LatLngBounds(southwest: source, northeast: destination);
    }

    return bound;
  }

  cameraLocationUpdateForList(List<LatLng> latlngs , GoogleMapController mapController,double padding ){

    LatLngBounds bound = getLatLngBounds(latlngs[0], latlngs[1]);

    double highestlat = latlngs[0].latitude;
    double highestlon = latlngs[0].longitude;
    double lowestlat = latlngs[0].latitude;
    double lowestlng = latlngs[0].longitude;

    for(int i=0;i < latlngs.length ; i++){
      if(latlngs[i].latitude > highestlat)
        highestlat = latlngs[i].latitude;

      if(latlngs[i].longitude > highestlon)
        highestlon = latlngs[i].longitude;

      if(latlngs[i].latitude < lowestlat)
        lowestlat = latlngs[i].latitude;

      if(latlngs[i].longitude < lowestlng)
        lowestlng = latlngs[i].longitude;
    }

    bound = LatLngBounds(northeast: LatLng(highestlat,highestlon), southwest: LatLng(lowestlat, lowestlng),);

    CameraUpdate u2 = CameraUpdate.newLatLngBounds(bound, padding,);
    mapController.animateCamera(u2).then((void v){
      check(u2,mapController);
      check(u2,mapController);
    });

  }

  void check(CameraUpdate u, GoogleMapController c) async {
    c.animateCamera(u);
    c.animateCamera(u);
    LatLngBounds l1=await c.getVisibleRegion();
    LatLngBounds l2=await c.getVisibleRegion();

    if(l1.southwest.latitude == -90 ||l2.southwest.latitude == -90)
      check(u, c);
  }

}