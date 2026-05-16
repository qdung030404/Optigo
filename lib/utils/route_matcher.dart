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
    if(driverRoute.length < 2) return [];
    final allPickUpPoints = Iterable<int>.generate(driverRoute.length - 1).map((i) {
      final result = _pointToSegment(driverRoute[i], driverRoute[i + 1], userOrigin);
      return {
        'point': result.point,
        'distance': result.distance,
      };
    }).where((item) => item['distance'] as double <= radiusMeters).toList();
    allPickUpPoints.sort((a, b) => (a['distance'] as double).compareTo(b['distance'] as double));
    List<Map<String, dynamic>> filteredPoints = [];

    for (var currentItem in allPickUpPoints) {
      LatLng currentLatLng = currentItem['point'] as LatLng;

      bool isClosed = filteredPoints.any((selectedItem) {
        LatLng selectedLatLng = selectedItem['point'] as LatLng;
        double distanceBetweenPoints = Geolocator.distanceBetween(
          currentLatLng.latitude,
          currentLatLng.longitude,
          selectedLatLng.latitude,
          selectedLatLng.longitude,
        );
        return distanceBetweenPoints < 200.0;
      });

      if (!isClosed) {
        filteredPoints.add(currentItem);
      }
    }
    return filteredPoints.take(5).toList();
  }
  static({LatLng point, double distance}) _pointToSegment(LatLng a, LatLng b, LatLng p) {
    double ax = a.longitude, ay = a.latitude;
    double bx = b.longitude, by = b.latitude;
    double px = p.longitude, py = p.latitude;

    double abx = bx - ax, aby = by - ay;
    double apx = px - ax, apy = py - ay;
    double ab2 = abx * abx + aby * aby;
    double t = ab2 == 0 ? 0 : (apx * abx + apy * aby) / ab2;
    t = t.clamp(0, 1);
    final  lngPoint = ax + t * aby;
    final  latPoint = ay + t * abx;
    final point = LatLng(latPoint, lngPoint);
    final distance = Geolocator.distanceBetween(
      p.latitude,
      p.longitude,
      latPoint,
      lngPoint,
    );
    return (point: point, distance: distance);
  }
}