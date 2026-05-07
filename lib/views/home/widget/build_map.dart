import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:optigo/providers/map_provider.dart';
import 'package:provider/provider.dart';

class BuildMap extends StatefulWidget {
  const BuildMap({super.key});

  @override
  State<BuildMap> createState() => _BuildMapState();
}

class _BuildMapState extends State<BuildMap> {
  static const _initialPosition = CameraPosition(
    target: LatLng(10.7769, 106.7009), // TP. Hồ Chí Minh
    zoom: 12,
  );

  @override
  Widget build(BuildContext context) {
    final mapProvider = context.watch<MapProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mapProvider.locationError != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(mapProvider.locationError!)));
        mapProvider.clearLocationError();
      }
    });
    return Stack(
      children: [
        MapLibreMap(
          styleString: MapProvider.goongStyleUrl,
          initialCameraPosition: _initialPosition,
          onMapCreated: mapProvider.onMapCreated,
          onStyleLoadedCallback: mapProvider.onStyleLoaded,
          myLocationEnabled: true,
          attributionButtonPosition: null,
          myLocationTrackingMode: MyLocationTrackingMode.none,
          myLocationRenderMode: MyLocationRenderMode.compass,
        ),
        if (!mapProvider.styleLoaded)
          const Center(child: CircularProgressIndicator()),
      ],
    );
  }
}
