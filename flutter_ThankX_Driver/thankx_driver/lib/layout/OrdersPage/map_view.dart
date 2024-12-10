import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:thankxdriver/bloc/my_current_order_bloc.dart';
import 'package:thankxdriver/control/navigation_serviece.dart';
import 'package:thankxdriver/utils/app_image.dart';
import 'package:thankxdriver/utils/map_utils.dart';

import 'ClaimOrder/claim_order.dart';


class MapView extends StatefulWidget {

  MyCurrentOrderListBloc myCurrentOrderListBloc;
  MapView({this.myCurrentOrderListBloc});

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {

  GoogleMapController mapController;
  Completer _controller = Completer();

  LatLng marker;

  Set<Marker> markers = {};

  List<LatLng> locationList = List();

  @override
  void initState() {
    super.initState();
    setSourceAndDestinationIcons();
  }

  BitmapDescriptor sourceIcon;

  void setSourceAndDestinationIcons() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), AppImage.map);

  }

  void multiMarker(){
    for(int i = 0 ; i < this.widget.myCurrentOrderListBloc.orderList.length ; i++) {

      markers.add(
        Marker(
          markerId: MarkerId("PickUps"+i.toString()),
          position: LatLng(this.widget.myCurrentOrderListBloc.orderList[i].pickupLocation.latitude,this.widget.myCurrentOrderListBloc.orderList[i].pickupLocation.longitude),
          icon: sourceIcon,
          onTap: (){
            NavigationService().push( MaterialPageRoute(builder: (context) {
              return ClaimOrder(order:  this.widget.myCurrentOrderListBloc.orderList[i]);
            }));
          }
        ),
      );

      setState(() {});

    }
  }
//region Load  Marker from image name
  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }


  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      markers: markers,
        initialCameraPosition: CameraPosition(
          target: this.widget.myCurrentOrderListBloc.latLngList.length >0 ? this.widget.myCurrentOrderListBloc?.latLng : LatLng(0.0,0.0),
          zoom: 11,
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);

          multiMarker();

          mapController = controller;

          print("length" + this.widget.myCurrentOrderListBloc.latLngList.length.toString());

          if(this.widget.myCurrentOrderListBloc.latLngList.length>1)
          MapUtils().cameraLocationUpdateForList(this.widget.myCurrentOrderListBloc.latLngList, mapController, 50);

          if(this.widget.myCurrentOrderListBloc.latLngList.length==1){
            mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: this.widget.myCurrentOrderListBloc.latLngList[0],zoom: 14)));
          }

          },

//        }
        );
  }

}
