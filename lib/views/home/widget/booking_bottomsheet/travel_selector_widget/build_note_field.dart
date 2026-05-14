import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:optigo/providers/trip_provider.dart';
import 'package:provider/provider.dart';

class BuildNoteField extends StatefulWidget {
  const BuildNoteField({super.key});

  @override
  State<BuildNoteField> createState() => _BuildNoteFieldState();
}

class _BuildNoteFieldState extends State<BuildNoteField> {
  final TextEditingController _noteController = TextEditingController();


  @override
  void initState() {
    _noteController.text = context.read<TripProvider>().note;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Ghi chú cho tài xế",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp),
          ),
          TextField(
            controller: _noteController,
            maxLines: 4,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: "",
            ),
          ),
        ],
      ),
    );
  }
}
