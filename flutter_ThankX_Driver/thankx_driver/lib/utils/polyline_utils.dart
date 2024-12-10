import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:thankxdriver/api_provider/api_constant.dart';
import 'package:thankxdriver/utils/logger.dart';
import 'package:tuple/tuple.dart';

class PolylineResponse {
  bool status;
  List<LatLng> arrLatLng;
  String overviewPolyline;

  PolylineResponse({
    this.status,
    this.arrLatLng,
    this.overviewPolyline,
  });
}

class PolyLineUtil {
  factory PolyLineUtil() {
    return _instance;
  }

  static PolyLineUtil _instance = PolyLineUtil._internal();

  PolyLineUtil._internal();

  List<Tuple3<LatLng, LatLng, String>> _arrDetail = List<Tuple3<LatLng, LatLng, String>>();

  Future<PolylineResponse> getRouteBetweenCoordinates({LatLng source, LatLng destination, List<LatLng> wayPoint = const []}) async {
    if (_arrDetail.isNotEmpty) {
      final arr = _arrDetail
          .where(
              (o) => ((o.item1.latitude == source.latitude) && (o.item1.longitude == source.longitude) && (o.item2.latitude == destination.latitude) && (o.item2.longitude == destination.longitude)))
          .toList();
      if (arr.isNotEmpty) {
        final obj = arr.first;
        List<LatLng> polylinePoints = decodeEncodedPolyline(obj.item3);
        return PolylineResponse(
          status: true,
          arrLatLng: polylinePoints,
          overviewPolyline: obj.item3,
        );
      }
    }

    final Map<String, dynamic> parms = Map<String, dynamic>();
    parms["origin"] = source.latitude.toString() + "," + source.longitude.toString();
    parms["destination"] = destination.latitude.toString() + "," + destination.longitude.toString();
    parms["mode"] = "driving";
    parms["key"] = ApiConstant.googlePlacesKey;
    parms["waypoints"] = wayPoint.map((o) => o.latitude.toString() + "," + o.longitude.toString()).join("|");
    parms["sensor"] = false;

    Logger().e("Params :: ${parms}");

    List<LatLng> polylinePoints = [];
    String overviewPolyline;

    try {
      final response = await Dio().get("https://maps.googleapis.com/maps/api/directions/json", queryParameters: parms);

      Logger().v("Response Status code:: ${response.statusCode}");
      if (response.statusCode == 200) {
        if ((response.data["routes"] is List<dynamic>) && (response.data["routes"] as List<dynamic>).isNotEmpty) {
          overviewPolyline = response.data["routes"][0]["overview_polyline"]["points"];
          polylinePoints = decodeEncodedPolyline(overviewPolyline);
          _arrDetail.add(Tuple3(source, destination, overviewPolyline));
        } else {
          overviewPolyline = '';
        }
        polylinePoints.insert(0, source);
        polylinePoints.add(destination);
      }
    } on DioError catch (error) {
      Logger().v('Error Details :: ${error.message}');
    }

    return PolylineResponse(
      status: polylinePoints.isNotEmpty,
      arrLatLng: polylinePoints,
      overviewPolyline: overviewPolyline,
    );
  }

  /// for more info about the algorithm check https://developers.google.com/maps/documentation/utilities/polylinealgorithm
  ///return [List]
  List<LatLng> decodeEncodedPolyline(String encoded) {
    List<LatLng> poly = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;
      LatLng p = LatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble());
      poly.add(p);
    }
    return poly;
  }
}
