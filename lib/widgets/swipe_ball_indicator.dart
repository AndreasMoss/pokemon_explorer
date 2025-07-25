import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SwipeBallIndicator extends StatefulWidget {
  final VoidCallback onTap;

  const SwipeBallIndicator({super.key, required this.onTap});

  @override
  State<SwipeBallIndicator> createState() => _SwipeBallIndicatorState();
}

class _SwipeBallIndicatorState extends State<SwipeBallIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounceAnimation;
  double _scale = 1.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);

    _bounceAnimation = Tween<double>(
      begin: 0,
      end: -10.h,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() async {
    setState(() => _scale = 1.3);
    await Future.delayed(const Duration(milliseconds: 120));
    setState(() => _scale = 1.0);
    await Future.delayed(const Duration(milliseconds: 150));
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _bounceAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _bounceAnimation.value),
            child: Transform.scale(scale: _scale, child: child),
          );
        },
        child: Image.asset(
          'assets/images/pokeball.png',
          width: 41.w,
          height: 41.h,
        ),
      ),
    );
  }
}
