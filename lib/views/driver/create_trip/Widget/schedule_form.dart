import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ScheduleForm extends StatefulWidget {
  const ScheduleForm({super.key});

  @override
  State<ScheduleForm> createState() => _ScheduleFormState();
}

class _ScheduleFormState extends State<ScheduleForm> {
  final formatter = DateFormat.yMd();
  DateTime? _selectedDate;

  TimeOfDay? _selectedTime;

  void _timePicker() async {
    final timeOfDay = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (timeOfDay == null) return;
    setState(() {
      _selectedTime = timeOfDay;
    });
  }

  void _datePicker() async {
    final now = DateTime.now();
    // Chuyến đi chỉ nên bắt đầu từ hiện tại hoặc tương lai
    final firstDate = DateTime(now.year, now.month, now.day);

    final pickDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: DateTime(now.year + 2),
    );

    if (pickDate == null) return; // Tránh crash nếu người dùng nhấn Cancel

    setState(() {
      _selectedDate = pickDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 32,
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[500]!,
            offset: Offset(4, 4),
            blurRadius: 15,
            spreadRadius: 1,
          ),
          // Bóng sáng ở góc trên bên trái
          BoxShadow(
            color: Colors.white,
            offset: Offset(-4, -4),
            blurRadius: 15,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Color(0xfffedd59),
                    child: Icon(Icons.calendar_today, color: Color(0xff176bac)),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Lịch trình',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left:16),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        _selectedTime == null
                            ? '--:--'
                            : _selectedTime!.format(context),
                      ),
                      IconButton(
                        onPressed: _timePicker,
                        icon: Icon(Icons.access_time),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left:16),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        _selectedDate == null
                            ? '--/--/----'
                            : formatter.format(_selectedDate!),
                      ),
                      IconButton(
                        onPressed: _datePicker,
                        icon: Icon(Icons.calendar_month),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
