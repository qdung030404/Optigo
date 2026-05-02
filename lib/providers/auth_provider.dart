import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:optigo/models/user_model.dart';

enum AuthStatus { initial, loading, codeSent, verifying, authenticated, unregistered , error}

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  AuthProvider({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;

  AuthStatus _status = AuthStatus.initial;

  String? errorText;
  AuthStatus get status => _status;
  String? get errorMessage => errorText;

  UserModel? _user;
  UserModel? get user => _user;

  bool get isLoading => status == AuthStatus.loading;
  bool get isSent => status == AuthStatus.codeSent;
  bool get isVerifying => status == AuthStatus.verifying;
  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isError => status == AuthStatus.error;

  String? _verificationId;

  Future<void> sendOtp(String phoneNumber) async {
    try {
      _status = AuthStatus.loading;
      errorText = null;
      notifyListeners();

      final completer = Completer<void>();

      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          print('[AUTH] verificationCompleted fired');
          try {
            UserCredential userCredential = await _auth.signInWithCredential(credential);
            _user = UserModel(
              uid: userCredential.user?.uid ?? '',
              userName: '',
              phoneNumber: userCredential.user?.phoneNumber ?? '',
            );
            _status = AuthStatus.authenticated;
            notifyListeners();
            if (!completer.isCompleted) completer.complete();
          } catch (e) {
            if (!completer.isCompleted) completer.completeError(e);
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          print('[AUTH] verificationFailed fired: ${e.code} - ${e.message}');
          errorText = e.message ?? e.toString();
          _status = AuthStatus.error;
          notifyListeners();
          if (!completer.isCompleted) completer.completeError(e);
        },
        codeSent: (String verificationId, int? resendToken) {
          print('[AUTH] codeSent fired! verificationId: $verificationId');
          _verificationId = verificationId;
          _status = AuthStatus.codeSent;
          notifyListeners();
          if (!completer.isCompleted) completer.complete();
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print('[AUTH] codeAutoRetrievalTimeout fired');
          _verificationId = verificationId;
        },
      );

      return completer.future;
    } catch (e) {
      errorText = e.toString();
      _status = AuthStatus.error;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> verifyOtp(String smsCode) async {
    if (_verificationId == null) {
      return;
    }
    try {
      _status = AuthStatus.verifying;
      errorText = null;
      notifyListeners();

      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: smsCode,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      bool isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;
      _user = UserModel(
        uid: userCredential.user?.uid ?? '',
        userName: '', 
        phoneNumber: userCredential.user?.phoneNumber ?? '',
      );
      if (isNewUser) {
        _status = AuthStatus.unregistered;
      } else {
        _status = AuthStatus.authenticated;
      }
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      errorText = e.message ?? e.toString();
      _status = AuthStatus.error;
      notifyListeners();
      rethrow;
    } catch (e) {
      errorText = e.toString();
      _status = AuthStatus.error;
      notifyListeners();
      rethrow;
    }
  }
  Future<void> updateProfile(String name) async {
    if (_user == null) return;
    try {
      _status = AuthStatus.loading;
      notifyListeners();

      await FirebaseFirestore.instance.collection('users').doc(_user!.uid).set({
        'user_name': name,
        'phone_number': _user!.phoneNumber,
      });
      _user = UserModel(
        uid: _user!.uid,
        userName: name,
        phoneNumber: _user!.phoneNumber,
      );
      _status = AuthStatus.authenticated;

      notifyListeners();
    } catch (e) {
      errorText = e.toString();
      _status = AuthStatus.error;
      notifyListeners();
    }
  }
  // Đăng xuất
  Future<void> signOut() async {
    await _auth.signOut();
    _user = null;
    _status = AuthStatus.initial;
    notifyListeners();
  }
}
