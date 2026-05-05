import 'package:flutter/material.dart';
import 'package:optigo/providers/map_provider.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final SearchController _searchController = SearchController();

  @override
  void initState() {
    super.initState();
    // 2. Lắng nghe thay đổi văn bản ngay từ Controller
    _searchController.addListener(() {
      final text = _searchController.text;
      // Gọi API tìm kiếm mỗi khi text thay đổi
      context.read<MapProvider>().searchPlace(text);
    });
  }
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Lắng nghe thay đổi từ MapProvider ngay trong build
    final mapProvider = context.watch<MapProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tìm kiếm địa điểm'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SearchAnchor(
                searchController: _searchController,
                builder: (context, controller) {
                  return SearchBar(
                    controller: controller,
                    hintText: 'Tìm kiếm địa điểm, con đường...',
                    leading: const Icon(Icons.search, color: Colors.blue),
                    onTap: () {
                      controller.openView();
                    },
                    elevation: const WidgetStatePropertyAll<double>(2.0),
                  );
                },
                suggestionsBuilder: (context, controller) {
                  final results = mapProvider.searchResults;
                  if (results.isEmpty) {
                    return [const ListTile(title: Text('Không tìm thấy kết quả'))];
                  }

                  return results
                      .map((place) => ListTile(
                            leading: const Icon(Icons.location_on_outlined,
                                color: Colors.redAccent),
                            title: Text(place.mainText),
                            subtitle: Text(place.secondaryText),
                            onTap: () {
                              // 1. Đóng view tìm kiếm
                              controller.closeView(place.description);
                              // 2. Gọi hàm xử lý chọn địa điểm (lấy tọa độ chi tiết và cắm marker)
                              mapProvider.selectPlace(place.placeId);
                              // 3. Quay lại HomeScreen để xem kết quả trên bản đồ
                              Navigator.pop(context);
                            },
                          ))
                      .toList(); // Quan trọng: Phải có .toList()
                },
              ),
            ),
            // Nếu đang trong trạng thái tìm kiếm, có thể hiện linear progress ở dưới search bar
            if (mapProvider.searching)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: LinearProgressIndicator(),
              ),
            // Hiển thị lỗi nếu có
            if (mapProvider.searchError != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  mapProvider.searchError!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
