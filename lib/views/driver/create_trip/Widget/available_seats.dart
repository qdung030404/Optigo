import 'package:flutter/material.dart';

class AvailableSeats extends StatefulWidget {
  const AvailableSeats({super.key});

  @override
  State<AvailableSeats> createState() => _AvailableSeatsState();
}

class _AvailableSeatsState extends State<AvailableSeats> {
  int? _value = 4;

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
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Color(0xfffedd59),
                  child: Icon(Icons.airline_seat_recline_normal_sharp, color: Color(0xff176bac),),
                ),
                SizedBox(width: 10),
                Text(
                  'Số lượng ghế',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: FormField<int>(
              validator: (value) {
                if (value == null) {
                  return 'Vui lòng chọn số ghế';
                }
                return null;
              },
              onSaved: (value) => _value = value,
              builder: (FormFieldState<int> state) {
                return Column(
                  children: [
                    DropdownButtonFormField<int>(
                      value: _value,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      ),
                      items: [
                        DropdownMenuItem(value: 4, child: Text('4')),
                        DropdownMenuItem(value: 7, child: Text('7')),
                        DropdownMenuItem(value: 16, child: Text('16')),
                        DropdownMenuItem(value: 24, child: Text('24')),
                        DropdownMenuItem(value: 29, child: Text('29')),
                        DropdownMenuItem(value: 35, child: Text('35')),
                        DropdownMenuItem(value: 45, child: Text('45')),
                      ],
                      onChanged: (value) => state.didChange(value),
                    ),
                    if (state.hasError)
                      Text(
                        state.errorText!,
                        style: TextStyle(color: Colors.red),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
