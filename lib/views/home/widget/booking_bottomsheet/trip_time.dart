import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:optigo/providers/trip_provider.dart';
import 'package:optigo/views/home/widget/booking_bottomsheet/travel_selector_widget/travel_time_selector.dart';
import 'package:provider/provider.dart';

class TripTime extends StatefulWidget {
  const TripTime({super.key});

  @override
  State<TripTime> createState() => _TripTimeState();
}

class _TripTimeState extends State<TripTime> {
  Map<String, dynamic>? _selectedTravelTime;
  String _displayTime(TripProvider tripProvider) {
    if (!tripProvider.isTimeSelected) return 'Vui lòng chọn thời gian di chuyển';
    if (tripProvider.isNow) return "Ngay bây giờ";

    final date = tripProvider.selectedDate;
    final time = tripProvider.selectedTime;

    final year = date.year.toString();
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');

    return "$hour:$minute, $day/$month/$year";
  }
  @override
  Widget build(BuildContext context) {
    final tripProvider = context.watch<TripProvider>();
    return GestureDetector(
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TravelTimeSelector()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Thời gian di chuyển',
                    style: GoogleFonts.lexend(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _displayTime(tripProvider),
                    style: GoogleFonts.lexend(
                      fontSize: 14,
                      color: tripProvider.isTimeSelected ? const Color(0xff176bac) : Colors.grey,
                      fontWeight: tripProvider.isTimeSelected ? FontWeight.w500 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
