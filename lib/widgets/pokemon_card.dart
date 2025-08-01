import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PokemonCard extends StatelessWidget {
  const PokemonCard({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.type,
    required this.typeColor,
  });

  final String name;
  final String imageUrl;
  final String type;
  final Color typeColor;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: 306.w,
        height: 292.h,
        color: typeColor,
        child: Center(
          child: Text(
            name,
            style: TextStyle(fontSize: 24.sp, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
