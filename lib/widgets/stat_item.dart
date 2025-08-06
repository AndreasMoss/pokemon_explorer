import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatItem extends StatelessWidget {
  const StatItem({super.key, required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            fontFamily: 'NexaRegular',
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          '$value',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            fontFamily: 'NexaX',
          ),
        ),
      ],
    );
  }
}
