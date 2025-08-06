import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pokemon_explorer/api/poke_api_service.dart';
import 'package:pokemon_explorer/functions/general.dart';
import 'package:pokemon_explorer/widgets/stat_item.dart';
import 'package:pokemon_explorer/widgets/char_tag.dart';

/// NA FTIAXW TO THEMA ME TO OTI DE FORTWNEI TA POKEMON ME MEGALITERA ONOMATA LOGW FORMAT (check)
/// NA FTIAXW TO OTI EMFANIZEI KAI SECONDARY TYPE SE AUTA POY KANW SEARCH
/// NA KANW TO API NA EMFANIZEI TA 10 PRWTA
/// NA ILOPOIISW TO SEARCH BY NAME
///
/// othoni gia failed to fetch details

class PokemonDetail extends StatelessWidget {
  const PokemonDetail({
    super.key,
    required this.pokemonName,
    required this.tColor,
  });

  final String pokemonName;
  final Color tColor;

  @override
  Widget build(BuildContext context) {
    final pokeApi = PokeApiService();
    print('Fetching details for: $pokemonName');

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, tColor, Colors.black],
          ),
        ),
        padding: const EdgeInsets.all(25.0),
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 25.h),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),

                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF373737),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      width: 42.w,
                      height: 42.h,
                      child: Center(
                        child: Icon(Icons.arrow_back, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),

              FutureBuilder(
                future: pokeApi.getPokemonDetail(pokemonName),
                builder: (context, asyncSnapshot) {
                  print('fetching details for: $pokemonName');
                  if (asyncSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Expanded(
                      child: Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    );
                  }
                  if (asyncSnapshot.hasError) {
                    return Text(
                      'Error: ${asyncSnapshot.error}',
                      style: TextStyle(
                        fontFamily: 'NexaX',
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    );
                  }

                  final pDetails = asyncSnapshot.data!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 18.h),

                      // Name + Type
                      Text(
                        pokemonNameFormatter(pDetails.name),
                        style: TextStyle(
                          fontFamily: 'NexaX',
                          fontSize: 32.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CharTag(label: pDetails.type, color: tColor),
                          // Container(
                          //   padding: EdgeInsets.symmetric(
                          //     vertical: 6.h,
                          //     horizontal: 12.w,
                          //   ),
                          //   decoration: BoxDecoration(
                          //     color: tColor,
                          //     borderRadius: BorderRadius.circular(20.r),
                          //   ),
                          //   child: Text(
                          //     pDetails.type.toUpperCase(),
                          //     style: TextStyle(
                          //       color: Colors.white,
                          //       fontSize: 14.sp,
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),

                      SizedBox(height: 50.h),

                      // Image
                      Image.network(
                        pDetails.imageUrl,
                        width: 276.w,
                        height: 279.h,
                        fit: BoxFit.contain,
                      ),

                      SizedBox(height: 18.h),

                      // Stats Card
                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(100),
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            StatItem(label: 'HP', value: pDetails.hp),
                            StatItem(label: 'ATK', value: pDetails.attack),
                            StatItem(label: 'DEF', value: pDetails.defense),
                          ],
                        ),
                      ),

                      SizedBox(height: 24.h),

                      // Description
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: Text(
                          pDetails.description,

                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'NexaRegular',
                            fontSize: 14.sp,
                            color: Colors.white70,
                          ),
                        ),
                      ),

                      SizedBox(height: 40.h),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
