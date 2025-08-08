import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pokemon_explorer/screens/search_not_used.dart';
import 'package:pokemon_explorer/screens/search_v2_screen.dart';
import 'package:pokemon_explorer/widgets/swipe_ball_indicator.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
  }

  void _handleStart() async {
    if (_navigated) return;
    _navigated = true;

    await _fadeController.forward(); // 👈 Θα αποκαλύψει την SearchScreen
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          //  Η SearchScreen υπάρχει ήδη κάτω
          const SearchScreenV2(),
          AnimatedBuilder(
            animation: _fadeAnimation,
            builder: (context, child) {
              return IgnorePointer(
                ignoring: _fadeAnimation.value == 0.0,
                child: FadeTransition(opacity: _fadeAnimation, child: child),
              );
            },
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.2,
                  colors: [Color.fromARGB(255, 64, 47, 19), Color(0xFF000000)],
                ),
              ),
              width: double.infinity,
              child: Column(
                children: [
                  Spacer(),
                  Text(
                    'Welcome to',
                    style: TextStyle(
                      fontFamily: 'NexaX',
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Image.asset(
                    'assets/images/title.png',
                    width: 267.14.w,
                    height: 177.94.h,
                  ),
                  SizedBox(height: 320.h),
                  SwipeBallIndicator(onTap: _handleStart),
                  SizedBox(height: 20.h),
                  Text(
                    'Tap the ball to Start Exploring!',
                    style: TextStyle(
                      fontFamily: 'NexaX',
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
