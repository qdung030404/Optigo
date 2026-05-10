import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:optigo/models/trip_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TripProvider extends ChangeNotifier{
  final _supabase = Supabase.instance.client;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> createTrip(TripModel trip) async {
    _isLoading = true;
    notifyListeners();
    try{
      final idToken = await FirebaseAuth.instance.currentUser?.getIdToken();

      await SupabaseClient(
        dotenv.env['SUPABASE_URL']!,
        dotenv.env['SUPABASE_ANON_KEY']!,
        headers: {'Authorization': 'Bearer $idToken'},
      ).from('trips').insert(
        trip.toMap(),
      );

    }catch(e){
      debugPrint("Lỗi tạo chuyến đi: $e");
    }finally{
      _isLoading = false;
      notifyListeners();
    }
  }
}