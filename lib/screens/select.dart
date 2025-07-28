import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Select extends StatelessWidget {
  const Select({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Color(0xFF000000),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 90.h,
            left: -55.w,
            child: Opacity(
              opacity: 0.5, // κάνε το πιο διακριτικό
              child: Image.asset(
                'assets/images/ball_background.png',
                width: 405.w,
                height: 405.h,
              ),
            ),
          ),

          // 🔹 Όλο το περιεχόμενο της σελίδας
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select your ',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontFamily: 'NexaRegular',
                      color: Colors.white,
                      fontSize: 28,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        'Pokémon',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 42,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'NexaX',
                        ),
                      ),
                      SizedBox(width: 7.w),
                      Image.asset(
                        'assets/images/pokeball.png',
                        width: 27.w,
                        height: 27.h,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
