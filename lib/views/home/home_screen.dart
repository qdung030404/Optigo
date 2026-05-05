import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:optigo/config/routes.dart';
import 'package:optigo/models/user_model.dart';
import 'package:optigo/providers/auth_provider.dart';
import 'package:optigo/providers/map_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _initialPosition = CameraPosition(
    target: LatLng(10.7769, 106.7009), // Mặc định: TP. Hồ Chí Minh
    zoom: 12,
  );

  /// Hàm build widget bản đồ Goong qua MapLibre
  Widget _buildGoongMap() {
    return Consumer<MapProvider>(
      builder: (context, mapProvider, _) {
        // Hiển thị lỗi vị trí qua SnackBar
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mapProvider.locationError != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(mapProvider.locationError!)),
            );
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
              attributionButtonPosition: null, // Ẩn nút attribution của MapLibre
              myLocationTrackingMode: MyLocationTrackingMode.none,
              myLocationRenderMode: MyLocationRenderMode.compass,
            ),
            // Loading khi style bản đồ chưa tải xong
            if (!mapProvider.styleLoaded)
              const Center(child: CircularProgressIndicator()),
            // Nút "Về vị trí của tôi"
            Positioned(
              bottom: 32,
              right: 16,
              child: FloatingActionButton(
                heroTag: 'my_location',
                backgroundColor: Colors.white,
                onPressed: mapProvider.locating
                    ? null
                    : () => mapProvider.goToCurrentLocation(),
                child: mapProvider.locating
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.my_location, color: Colors.blue),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
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
            child: Builder(
              builder: (context) => Container(
                decoration: BoxDecoration(
                  color: const Color(0xffFFF1B1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  icon: const Icon(Icons.search, color: Colors.blue),
                  onPressed: () => Navigator.pushNamed(context, Routes.search),
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              currentAccountPicture: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.blue, width: 2),
                ),
                child: const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40, color: Colors.blue),
                ),
              ),
              accountName: Text(
                user?.userName ?? 'Chưa đặt tên',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black),
              ),
              accountEmail: Text(
                user?.phoneNumber != null
                    ? user!.phoneNumber.replaceFirst(RegExp(r'^\+84'), '0')
                    : 'Chưa có số điện thoại',
                style: const TextStyle(color: Colors.black54),
              ),
            ),
            _drawerItem('Chỉnh sửa hồ sơ', Icons.edit, () {}),
            _drawerItem('Lịch sử', Icons.history, () {}),
            _drawerItem(
                'Địa chỉ đã lưu', Icons.location_on_outlined, () {}),
            _drawerItem('Cài đặt', Icons.settings_outlined, () {}),
            const Divider(),
            _drawerItem(
              'Đăng xuất',
              Icons.logout,
              () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Xác nhận'),
                    content:
                        const Text('Bạn có chắc chắn muốn đăng xuất?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Hủy'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Đăng xuất'),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  await authProvider.signOut();
                  if (context.mounted) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      Routes.login,
                      (route) => false,
                    );
                  }
                }
              },
              color: Colors.red,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      body: _buildGoongMap(), // ← hàm hiển thị bản đồ Goong
    );
  }

  Widget _drawerItem(String title, IconData icon, Function() onTap,
      {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: color)),
      onTap: onTap,
    );
  }
}
