import 'package:flutter/material.dart';
import 'package:optigo/providers/trip_provider.dart';
import 'package:optigo/views/home/widget/booking_bottomsheet/travel_time_selector.dart';
import 'package:provider/provider.dart';

class BookingBottomsheet extends StatefulWidget {
  const BookingBottomsheet({super.key});

  @override
  State<BookingBottomsheet> createState() => _BookingBottomsheetState();
}

class _BookingBottomsheetState extends State<BookingBottomsheet> {
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
    return Container(
      padding: EdgeInsets.all(16),
      height: MediaQuery.of(context).size.height * 0.4,
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
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Thời gian di chuyển',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TravelTimeSelector()),
              );
            },
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          _displayTime(tripProvider),
                          style: TextStyle(
                            color: _selectedTravelTime == null ? Colors.grey : Colors.black,
                            fontWeight: _selectedTravelTime == null ? FontWeight.normal : FontWeight.bold,
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios_outlined),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ]
      )
    );
  }
}
