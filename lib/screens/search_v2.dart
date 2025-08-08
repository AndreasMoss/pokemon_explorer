import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pokemon_explorer/models/pokemon_type.dart';
import 'package:pokemon_explorer/widgets/type_card.dart';

class SearchScreenV2 extends StatefulWidget {
  const SearchScreenV2({super.key});

  @override
  State<SearchScreenV2> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreenV2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.2,
            colors: [Color.fromARGB(255, 64, 47, 19), Color(0xFF000000)],
          ),
        ),
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 35.h),
            Text(
              'Select Pokémon Type',
              style: TextStyle(
                fontFamily: 'NexaX',
                color: Colors.white,
                fontSize: 22.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            // SizedBox(height: 5.h),
            Expanded(
              child: ListView.builder(
                itemCount: (pokemonTypes.length / 2).ceil(), // πόσες σειρές
                itemBuilder: (context, rowIndex) {
                  final firstIndex = rowIndex * 2;
                  final secondIndex = firstIndex + 1;

                  final PokemonType first = pokemonTypes[firstIndex];
                  final PokemonType? second = secondIndex < pokemonTypes.length
                      ? pokemonTypes[secondIndex]
                      : null;

                  return Padding(
                    padding: EdgeInsets.only(bottom: 34.h),
                    child: Row(
                      children: [
                        Expanded(child: TypeCard(type: first)),
                        SizedBox(width: 25.w),
                        Expanded(
                          child: second != null
                              ? TypeCard(type: second)
                              : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
