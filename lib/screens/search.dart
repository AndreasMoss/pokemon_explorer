import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pokemon_explorer/models/pokemon_type.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late PokemonType _selectedType;
  @override
  void initState() {
    super.initState();
    _selectedType = pokemonTypes.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Text(
          'Search',
          style: TextStyle(
            fontFamily: 'NexaX',
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Type',
              style: TextStyle(
                fontFamily: 'NexaRegular',
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(7.r),
              ),
              child: DropdownButton<PokemonType>(
                value: _selectedType,
                isExpanded: true,
                dropdownColor: Colors.black,
                iconEnabledColor: Colors.white,
                underline: const SizedBox(),
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'NexaRegular',
                  fontSize: 16.sp,
                ),
                items: pokemonTypes.map((type) {
                  return DropdownMenuItem(value: type, child: Text(type.title));
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    print(value.icon);
                    setState(() {
                      _selectedType = value;
                    });
                  }
                },
              ),
            ),

            SizedBox(height: 15.h),
            Text(
              'Enter Name',
              style: TextStyle(
                fontFamily: 'NexaRegular',
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              height: 58.h,
              child: ElevatedButton(
                onPressed: () {
                  print("MPIIII");
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7.r),
                  ),
                  backgroundColor: Color(0xFFFFAF2C),
                  padding: EdgeInsets.only(top: 20.h, bottom: 20.h),
                ),
                child: Text(
                  'Search Pokémons',
                  style: TextStyle(
                    fontFamily: 'NexaX',
                    color: Colors.black,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
