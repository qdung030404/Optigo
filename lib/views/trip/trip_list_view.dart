import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:optigo/config/routes.dart';
import 'package:optigo/providers/trip_provider.dart';
import 'package:provider/provider.dart';

class TripListView extends StatelessWidget {
  const TripListView({super.key});

  @override
  Widget build(BuildContext context) {
    final tripProvider = context.watch<TripProvider>();
    final trips = tripProvider.trips;

    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
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
          'Chuyến đi sẵn có',
          style: GoogleFonts.lexend(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body:trips.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: EdgeInsets.all(16.w),
                  itemCount: trips.length,
                  itemBuilder: (context, index) {
                    final trip = trips[index];
                    return GestureDetector(
                      onTap: (){
                        Navigator.pushNamed(context, Routes.tripDetail, arguments: trip);
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 16.h),
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    Icon(Icons.my_location, color: const Color(0xff176bac), size: 20.sp),
                                    Container(
                                      width: 1.w,
                                      height: 30.h,
                                      color: Colors.grey[300],
                                    ),
                                    Icon(Icons.location_on, color: Colors.red, size: 20.sp),
                                  ],
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        trip.originName,
                                        style: GoogleFonts.lexend(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(height: 25.h),
                                      Text(
                                        trip.destinationName,
                                        style: GoogleFonts.lexend(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  currencyFormat.format(trip.price),
                                  style: GoogleFonts.lexend(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xff176bac),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.access_time_filled, size: 16.sp, color: Colors.grey[600]),
                                    SizedBox(width: 4.w),
                                    Text(
                                      DateFormat('HH:mm - dd/MM/yyyy').format(trip.departureTime),
                                      style: GoogleFonts.lexend(
                                        fontSize: 13.sp,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.event_seat, size: 16.sp, color: Colors.grey[600]),
                                    SizedBox(width: 4.w),
                                    Text(
                                      'Còn ${trip.availableSeats} chỗ',
                                      style: GoogleFonts.lexend(
                                        fontSize: 13.sp,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    );
                  },
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.directions_car_filled_outlined, size: 80.sp, color: Colors.grey[300]),
          SizedBox(height: 16.h),
          Text(
            'Không tìm thấy chuyến đi nào',
            style: GoogleFonts.lexend(
              fontSize: 16.sp,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
