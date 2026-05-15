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
    if(pickUpIndex != -1 && dropOffIndex != -1 && pickUpIndex < dropOffIndex){
      return 100.0;
    }
    return 0.0;
  }
  static List<Map<String, dynamic>> getPickUpPoint({
    required LatLng userOrigin,
    required List<LatLng> driverRoute,
    double radiusMeters = 20000.0,
  }){
    List<Map<String, dynamic>> pickUpPoints = [];
    for(int i = 0; i < driverRoute.length; i++){
      double distance = Geolocator.distanceBetween(
        userOrigin.latitude,
        userOrigin.longitude,
        driverRoute[i].latitude,
        driverRoute[i].longitude,
      );
      if(distance <= radiusMeters){
        pickUpPoints.add({
          'point': driverRoute[i],
          'distance': distance,
        });
      }
    }
    pickUpPoints.sort((a, b) => a['distance'].compareTo(b['distance']));

    return pickUpPoints.take(5).toList();
  }
}