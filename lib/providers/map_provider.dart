import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:optigo/models/place_model.dart';

enum MapType { initial, locating, locationError, searching, searchError }

class MapProvider extends ChangeNotifier {
  static String get goongStyleUrl {
    final key = dotenv.env['GOONG_MAPTILES_KEY'] ?? '';
    return 'https://tiles.goong.io/assets/goong_map_highlight.json?api_key=$key';
  }

  final apiKey = dotenv.env['GOONG_API_KEY'];

  MapType _mapType = MapType.initial;
  MapType get mapType => _mapType;

  // Tách riêng trạng thái Style đã load xong
  bool _isStyleLoaded = false;
  bool get styleLoaded => _isStyleLoaded;

  MapLibreMapController? _controller;
  String? _locationError;
  String? _searchError;
  Symbol? _currentLocationMarker;

  List<PlaceModel> _searchResults = [];

  bool get locating => mapType == MapType.locating;
  bool get searching => mapType == MapType.searching;
  String? get locationError => _locationError;
  String? get searchError => _searchError;
  List<PlaceModel> get searchResults => _searchResults;
  MapLibreMapController? get controller => _controller;

  // ─── Map lifecycle ────────────────────────────────────────────────────────

  void onMapCreated(MapLibreMapController controller) {
    _controller = controller;
    notifyListeners();
  }

  Future<void> onStyleLoaded() async {
    _isStyleLoaded = true; // Đánh dấu đã tải xong style vĩnh viễn
    notifyListeners();
    await goToCurrentLocation();
  }

  // ─── Location & Markers ───────────────────────────────────────────────────

  Future<void> goToCurrentLocation() async {
    _mapType = MapType.locating;
    _locationError = null;
    notifyListeners();

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _locationError = 'GPS đang tắt. Vui lòng bật GPS và thử lại.';
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _locationError = 'Quyền truy cập vị trí bị từ chối.';
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        _locationError =
            'Quyền vị trí bị chặn vĩnh viễn. Vui lòng vào Cài đặt để cấp quyền.';
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      final latLng = LatLng(position.latitude, position.longitude);

      if (_controller != null) {
        if (_currentLocationMarker != null) {
          await _controller!.removeSymbol(_currentLocationMarker!);
        }

        _currentLocationMarker = await _controller!.addSymbol(
          SymbolOptions(
            geometry: latLng,
            iconImage: 'marker-15',
            iconSize: 1.5,
          ),
        );
      }

      await _controller?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: latLng,
            zoom: 15,
          ),
        ),
      );
    } catch (e) {
      _mapType = MapType.locationError;
      _locationError = 'Không thể lấy vị trí: $e';
    } finally {
      _mapType = MapType.initial;
      notifyListeners();
    }
  }

  // ─── Search Place ─────────────────────────────────────────────────────────

  Future<void> searchPlace(String input) async {
    if (input.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    _mapType = MapType.searching;
    _searchError = null;
    notifyListeners();

    final url =
        'https://rsapi.goong.io/Place/Autocomplete?api_key=$apiKey&input=${Uri.encodeComponent(input)}';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          final List predictions = data['predictions'];
          _searchResults =
              predictions.map((p) => PlaceModel.fromJson(p)).toList();
        } else {
          _searchError = 'Lỗi từ API Goong: ${data['status']}';
        }
      } else {
        _searchError = 'Lỗi kết nối server: ${response.statusCode}';
      }
    } catch (e) {
      _mapType = MapType.searchError;
      _searchError = 'Không thể tìm kiếm: $e';
    } finally {
      if (_mapType == MapType.searching) {
        _mapType = MapType.initial;
      }
      notifyListeners();
    }
  }

  Future<void> selectPlace(String placeId) async {
    final url =
        'https://rsapi.goong.io/Place/Detail?api_key=$apiKey&place_id=$placeId';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          final location = data['result']['geometry']['location'];
          final latLng = LatLng(location['lat'], location['lng']);
          if (_currentLocationMarker != null) {
            await _controller!.removeSymbol(_currentLocationMarker!);
          }
          _currentLocationMarker = await _controller!.addSymbol(
            SymbolOptions(
              geometry: latLng,
              iconImage: 'marker-15',
              iconSize: 1.5,
            ),
          );
          _searchResults = [];
          notifyListeners();
          _controller!.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: latLng,
                zoom: 15,
              ),
            ),
          );
        }
      }
    } catch (e) {
      _mapType = MapType.searchError;
      _searchError = ' Lỗi: $e';
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}