import 'dart:async';
import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:optigo/models/user_model.dart';
import 'package:optigo/providers/auth_provider.dart';
import 'package:optigo/providers/map_provider.dart';
import 'package:optigo/providers/search_provider.dart';
import 'package:optigo/views/home/widget/build_drawer.dart';
import 'package:optigo/views/home/widget/build_map.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _initialPosition = CameraPosition(
    target: LatLng(10.7769, 106.7009), // TP. Hồ Chí Minh
    zoom: 12,
  );
  Timer? timeDebounce;
  final SearchController _searchController = SearchController();

  @override
  void initState() {
    super.initState();
    // Lắng nghe sự thay đổi của text để gọi API tìm kiếm
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    timeDebounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if(timeDebounce?.isActive ?? false) timeDebounce!.cancel();
    timeDebounce = Timer(const Duration(milliseconds: 500), () {
      if (_searchController.text.isNotEmpty) {
        if (!mounted) return;
        context.read<SearchProvider>().searchPlace(_searchController.text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.select<AuthProvider, UserModel?>((p) => p.user);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Builder(
            builder: (context) => Container(
              decoration: BoxDecoration(
                color: const Color(0xffFFF1B1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: IconButton(
                icon: const Icon(Icons.menu, color: Colors.black),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xffFFF1B1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: SearchAnchor(
                searchController: _searchController,
                builder: (context, controller) {
                  return IconButton(
                    icon: const Icon(Icons.search, color: Colors.black),
                    onPressed: () => controller.openView(),
                  );
                },
                suggestionsBuilder: (context, controller) {
                  // Lắng nghe SearchProvider để cập nhật gợi ý
                  final searchProvider = context.read<SearchProvider>();
                  final results = searchProvider.searchResults;

                  if (controller.text.isEmpty) {
                    final history = searchProvider.searchHistory;
                    if (history.isEmpty) {
                      return [const ListTile(title: Text('Nhập để tìm kiếm'))];
                    }
                    return [
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('Gần đây',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      ...history.map((query) => ListTile(
                            leading: const Icon(Icons.history),
                            title: Text(query),
                            onTap: () => controller.text = query,
                          )),
                      TextButton(
                        onPressed: () => searchProvider.clearHistory(),
                        child: const Text('Xóa lịch sử'),
                      ),
                    ];
                  }

                  if (results.isEmpty && !searchProvider.isSearching) {
                    return [const ListTile(title: Text('Không tìm thấy kết quả'))];
                  }

                  return results.map((place) => ListTile(
                        leading: const Icon(Icons.location_on_outlined,
                            color: Colors.blue),
                        title: Text(place.mainText),
                        subtitle: Text(place.secondaryText),
                        onTap: () async {
                          // Capture MapProvider trước khi await và trước khi đóng view
                          final mapProvider = context.read<MapProvider>();
                          
                          //Đóng view và lưu lịch sử
                          controller.closeView(place.description);
                          searchProvider.addToHistory(place.description);

                          //Lấy tọa độ chi tiết
                          final detail = await searchProvider.getPlaceDetail(place.placeId);
                          if (detail != null && mounted) {
                            final latLng = LatLng(detail['lat']!, detail['lng']!);
                            //Sử dụng provider đã capture
                            mapProvider.moveCameraAndAddMarker(latLng);
                          }
                        },
                      )).toList();
                },
              ),
            ),
          ),
        ],
      ),
      drawer: BuildDrawer(user: user),
      body: BuildMap(),
    );
  }
}
