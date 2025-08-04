import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pokemon_explorer/functions/general.dart';

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
      //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(60.r)),
      child: Container(
        width: 306.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 0.35,
            colors: [typeColor.withAlpha(200), Color.fromARGB(255, 0, 0, 0)],
          ),
        ),
        height: 292.h,

        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(imageUrl, width: 100.w, height: 100.h),
              SizedBox(height: 10.h),
              Text(
                capitalize(name),
                style: TextStyle(fontSize: 24.sp, color: Colors.white),
              ),
              SizedBox(height: 5.h),
              Text(
                type,
                style: TextStyle(fontSize: 18.sp, color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
