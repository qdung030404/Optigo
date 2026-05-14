import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:optigo/config/routes.dart';
import 'package:optigo/providers/map_provider.dart';
import 'package:optigo/providers/trip_provider.dart';
import 'package:optigo/views/home/widget/booking_bottomsheet/travel_selector_widget/travel_time_selector.dart';
import 'package:optigo/views/home/widget/booking_bottomsheet/trip_time.dart';
import 'package:provider/provider.dart';

import 'number_of_passenger.dart';
import 'payment_method.dart';

class BookingBottomsheet extends StatefulWidget {
  const BookingBottomsheet({super.key});

  @override
  State<BookingBottomsheet> createState() => _BookingBottomsheetState();
}

class _BookingBottomsheetState extends State<BookingBottomsheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      height: MediaQuery.of(context).size.height * 0.5,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: Container(
              width: 80,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 10,),
          TripTime(),
          const SizedBox(height: 16),
          NumberOfPassenger(),
          const SizedBox(height: 16),
          const PaymentMethod(),
          Spacer(),
          ElevatedButton(
            onPressed: () {
              final mapProvider = context.read<MapProvider>();
              context.read<TripProvider>().findTrips(origin: mapProvider.currentLatLng!, destination: mapProvider.destinationLatLng!);
              Navigator.pushNamed(context, Routes.tripList);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xfffedd59),
              minimumSize: Size(double.infinity, 60.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: Text(
              'Tìm chuyến',
              style: TextStyle(
                color: const Color(0xff176bac),
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ]
      )
    );
  }
}
