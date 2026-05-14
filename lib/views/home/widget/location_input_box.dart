import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:optigo/providers/map_provider.dart';
import 'package:optigo/providers/search_provider.dart';
import 'package:optigo/views/home/widget/search_location_widget.dart';
import 'package:optigo/models/place_model.dart';
import 'package:provider/provider.dart';

class LocationInputBox extends StatefulWidget {
  final String? initialDestinationText;
  final String? initialOriginText;
  final Function(PlaceModel)? onDestinationSelected;
  final SearchController? destinationController;
  final SearchController? originController;

  const LocationInputBox({
    super.key,
    this.initialDestinationText,
    this.initialOriginText,
    this.onDestinationSelected,
    this.destinationController,
    this.originController,
  });

  @override
  State<LocationInputBox> createState() => _LocationInputBoxState();
}

class _LocationInputBoxState extends State<LocationInputBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      width: MediaQuery.of(context).size.width - 32,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Icon(Icons.circle, color: Colors.yellowAccent, size: 30),
              Image.asset('assets/images/vertical_dotted_line.png'),
              Icon(Icons.location_pin, color: Colors.redAccent, size: 30),
            ],
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              children: [
                SearchLocationWidget(
                  hintText: 'Vị trí của bạn',
                  searchController: widget.originController,
                  initialText: widget.initialOriginText,
                  onSelected: (place) async {
                    final searchProvider = context.read<SearchProvider>();
                    final mapProvider = context.read<MapProvider>();
                    final detail = await searchProvider.getPlaceDetail(
                      place.placeId,
                    );
                    if (detail != null) {
                      mapProvider.setCurrentLocation(
                        LatLng(detail['lat']!, detail['lng']!),
                      );
                      mapProvider.getDirection();
                    }
                  },
                ),
                const Divider(height: 1, color: Colors.grey),
                SearchLocationWidget(
                  hintText: 'Nhập điểm đến',
                  searchController: widget.destinationController,
                  initialText: widget.initialDestinationText,
                  onSelected: (place) async {
                    if (widget.onDestinationSelected != null) {
                      widget.onDestinationSelected!(place);
                    }
                    final searchProvider = context.read<SearchProvider>();
                    final mapProvider = context.read<MapProvider>();
                    final detail = await searchProvider.getPlaceDetail(
                      place.placeId,
                    );
                    if (detail != null) {
                      await mapProvider.moveCameraAndAddMarker(
                        LatLng(detail['lat']!, detail['lng']!),
                      );
                      mapProvider.getDirection();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
