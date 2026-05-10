import 'package:flutter/material.dart';
import 'package:optigo/views/driver/create_trip/Widget/route_form.dart';

import 'Widget/available_seats.dart';
import 'Widget/price.dart';
import 'Widget/schedule_form.dart';

class CreateTrip extends StatefulWidget {
  const CreateTrip({super.key});

  @override
  State<CreateTrip> createState() => _CreateTripState();
}

class _CreateTripState extends State<CreateTrip> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text("Tạo chuyến đi"),
              SizedBox(height: 10),
              RouteForm(),
              ScheduleForm(),
              AvailableSeats(),
              Price(),
            ],
          ),
        ),
      ),
    );
  }
}
