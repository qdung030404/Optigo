
import 'package:flutter/material.dart';

class TripProvider extends ChangeNotifier{
  bool _isNow = false;
  bool _isTimeSelected = false;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String _note = "";

  bool get isNow => _isNow;
  DateTime get selectedDate => _selectedDate;
  TimeOfDay get selectedTime => _selectedTime;
  bool get isTimeSelected => _isTimeSelected;
  String get note => _note;

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

  void resetTime() {
    _isTimeSelected = false;
    notifyListeners();
  }
}