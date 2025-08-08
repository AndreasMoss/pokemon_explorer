import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pokemon_explorer/functions/general.dart';
import 'package:pokemon_explorer/screens/pokemon_detail_screen.dart';

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
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              PokemonDetailScreen(pokemonName: name, tColor: typeColor),
        ),
      ),
      child: Card(
        //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(60.r)),
        child: Container(
          width: 306.w,
          height: 214.h,
          decoration: BoxDecoration(
            //color: Colors.red,
            //borderRadius: BorderRadius.circular(12.r),
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 0.25,
              colors: [typeColor.withAlpha(200), Color.fromARGB(255, 0, 0, 0)],
            ),
          ),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(imageUrl, width: 100.w, height: 100.h),
              SizedBox(height: 14.h),
              Text(
                pokemonNameFormatter(name),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'NexaX',
                  fontSize: 20.sp,
                  color: Colors.white,
                ),
              ),
              // SizedBox(height: 5.h),
              // Container(
              //   padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(12.r),
              //     border: Border.all(width: 3.w),
              //     color: typeColor,
              //   ),
              //   child: Text(
              //     type,
              //     style: TextStyle(fontSize: 18.sp, color: Colors.white70),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
