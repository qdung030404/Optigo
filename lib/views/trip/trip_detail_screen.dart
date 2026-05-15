import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:optigo/models/trip_model.dart';
import 'package:optigo/utils/route_matcher.dart';
import 'package:optigo/providers/map_provider.dart';
import 'package:optigo/views/trip/widget/departure_time_card.dart';
import 'package:optigo/views/trip/widget/pickup_points_bottom_sheet.dart';
import 'package:optigo/views/trip/widget/route_details_card.dart';
import 'package:provider/provider.dart';

class TripDetailScreen extends StatefulWidget {
  const TripDetailScreen({super.key});

  @override
  State<TripDetailScreen> createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends State<TripDetailScreen> {
  String? selectedName;
  @override
  Widget build(BuildContext context) {
    final trip = ModalRoute
        .of(context)!
        .settings
        .arguments as TripModel;
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Chi tiết chuyến đi',
          style: GoogleFonts.lexend(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            // Route Details Card
            RouteDetailsCard(
              trip: trip,
              selectedPickupPoint: selectedName,
              onPickupTap: () async {
                final mapProvider = context.read<MapProvider>();
                if (mapProvider.currentLatLng != null && trip.routePolyline.isNotEmpty) {
                  final driverRoute = RouteMatcher.decodePolyline(trip.routePolyline);
                  final candidates = RouteMatcher.getPickUpPoint(
                    userOrigin: mapProvider.currentLatLng!,
                    driverRoute: driverRoute,
                  );
                  final result = await showModalBottomSheet<Map<String, dynamic>>(
                    context: context,
                    builder: (context) => PickupPointsBottomSheet(
                      points: candidates,
                      initialSelectedAddress: selectedName,
                    ),
                  );

                  if (result != null) {
                    setState(() {
                      selectedName = result['name'];
                    });
                  }
                }
              },
            ),
            SizedBox(height: 16.h),
            // Departure Time Card
            DepartureTimeCard(trip: trip),
            SizedBox(height: 32.h),
            // Book Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xfffedd59),
                  foregroundColor: const Color(0xff176bac),
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Đặt chuyến',
                  style: GoogleFonts.lexend(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
