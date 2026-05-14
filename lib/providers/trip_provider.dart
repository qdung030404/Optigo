import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:optigo/models/trip_model.dart';
import 'package:optigo/utils/mock_data.dart';

import '../utils/route_matcher.dart';

class TripProvider extends ChangeNotifier {
  bool _isNow = false;
  bool _isTimeSelected = false;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String _note = "";
  int _passengerCount = 1;
  String _paymentMethod = "Tiền mặt";
  List<TripModel> _trips = [];
  bool _isLoading = false;

  final SearchController searchController = SearchController();

  SearchController get searchCtrl => searchController;

  TripProvider() {
    searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    notifyListeners();
  }

  bool get isNow => _isNow;
  DateTime get selectedDate => _selectedDate;
  TimeOfDay get selectedTime => _selectedTime;
  bool get isTimeSelected => _isTimeSelected;
  int get passengerCount => _passengerCount;
  String get paymentMethod => _paymentMethod;
  String get note => _note;
  List<TripModel> get trips => _trips;
  bool get isLoading => _isLoading;

  void setDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void setTime(TimeOfDay time) {
    _selectedTime = time;
    notifyListeners();
  }

  void setNote(String note) {
    _note = note;
    notifyListeners();
  }

  void setIsNow(bool isNow) {
    _isNow = isNow;
    notifyListeners();
  }

  void confirmTime() {
    _isTimeSelected = true;
    notifyListeners();
  }

  void incrementPassenger() {
    _updatePassengerCount(_passengerCount + 1);
  }

  void decrementPassenger() {
    _updatePassengerCount(_passengerCount - 1);
  }

  void setPaymentMethod(String method) {
    _paymentMethod = method;
    notifyListeners();
  }

  void _updatePassengerCount(int newCount) {
    if (newCount >= 1) {
      _passengerCount = newCount;
      notifyListeners();
    }
  }

  Future<void> findTrips({required LatLng origin, required LatLng destination}) async {
    _isLoading = true;
    _trips = [];
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    List<TripModel> allMockTrips = MockData.getMockTrips();
    List<TripModel> recommendedTrips = [];
    for (var trip in allMockTrips) {
      if (trip.availableSeats < _passengerCount) {
        continue;
      }

      // if (!_isNow) {
      //   DateTime userDateTime = DateTime(
      //     _selectedDate.year, _selectedDate.month, _selectedDate.day,
      //     _selectedTime.hour, _selectedTime.minute,
      //   );
      //   // Tính độ lệch thời gian giữa User và Tài xế (đơn vị: phút)
      //   int timeDiff = trip.departureTime.difference(userDateTime).inMinutes.abs();
      //   if (timeDiff > 360) {
      //     continue;
      //   }
      // }

      if (trip.routePolyline.isNotEmpty) {
        List<LatLng> driverRoute = RouteMatcher.decodePolyline(trip.routePolyline);
        double score = RouteMatcher.calculateDistance(
          userOrigin: origin,
          userDestination: destination,
          driverRoute: driverRoute,
        );

        if (score >= 50.0) {
          recommendedTrips.add(trip);
        }
      }
    }
    _trips = recommendedTrips;
    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }
}