import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IsLoadingScreen extends StatelessWidget {
  const IsLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Image.asset(
          'assets/images/searching.png',
          width: 399.w,
          height: 410.h,
        ),
      ),
    );
  }
}
