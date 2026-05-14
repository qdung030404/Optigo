import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

class RouteMatcher {

  static List<LatLng> decodePolyline(String encoded) {
    List<PointLatLng> decoded = PolylinePoints.decodePolyline(encoded);
    return decoded.map((p) => LatLng(p.latitude, p.longitude)).toList();
  }

  static double calculateDistance({
    required LatLng userOrigin,
    required LatLng userDestination,
    required List<LatLng> driverRoute,
    double thresholdMeters = 20000.0,
  }) {
    if (driverRoute.isEmpty) {
      return 0.0;
    }
    int pickUpIndex = -1;
    int dropOffIndex = -1;
    double minPickUpDistance = thresholdMeters;
    for (int i = 0; i < driverRoute.length - 1; i++) {
      double distance = Geolocator.distanceBetween(
        userOrigin.latitude,
        userOrigin.longitude,
        driverRoute[i].latitude,
        driverRoute[i].longitude,
      );
      if (distance <= minPickUpDistance) {
        minPickUpDistance = distance;
        pickUpIndex = i;
      }
    }
    double minDropOffDistance = thresholdMeters;
    for (int i = 0; i < driverRoute.length; i++){
      double distance = Geolocator.distanceBetween(
        userDestination.latitude,
        userDestination.longitude,
        driverRoute[i].latitude,
        driverRoute[i].longitude,

      );
      if(distance <= minDropOffDistance){
        minDropOffDistance = distance;
        dropOffIndex = i;
      }
    }
    print("Khoảng cách đón gần nhất: $minPickUpDistance mét");
    print("Khoảng cách trả gần nhất: $minDropOffDistance mét");
    print("Index đón: $pickUpIndex, Index trả: $dropOffIndex");
    print("Điểm đầu tiên của tài xế: ${driverRoute.first}");
    print("Điểm cuối thực tế của tài xế: ${driverRoute.last}");
    print("Điểm đón bạn đang yêu cầu: $userOrigin");
    print("Điểm đến bạn đang yêu cầu: $userDestination");
    if(pickUpIndex != -1 && dropOffIndex != -1 && pickUpIndex < dropOffIndex){
      return 100.0;
    }
    return 0.0;
  }
}