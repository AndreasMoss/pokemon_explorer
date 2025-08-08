import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokemon_explorer/api/poke_api_service.dart';
import 'package:pokemon_explorer/models/pokemon_type.dart';
import 'package:pokemon_explorer/screens/select.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late PokemonType _selectedType;
  final TextEditingController _nameController = TextEditingController();
  String _searchName = '';

  @override
  void initState() {
    super.initState();
    _selectedType = pokemonTypes.first;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final PokeApiService apiService = PokeApiService();
    //print("The entered name is: $_searchName");

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
                  return DropdownMenuItem(
                    value: type,
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          type.icon,
                          width: 24.w,
                          height: 24.h,

                          // colorFilter: const ColorFilter.mode(
                          //   Colors.red,
                          //   BlendMode.srcIn,
                          // ),
                        ),
                        SizedBox(width: 10.w),
                        Text(type.title),
                      ],
                    ),
                  );
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
            SizedBox(height: 10.h),
            TextField(
              controller: _nameController,
              onChanged: (value) {
                setState(() {
                  _searchName = value;
                });
              },
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'NexaRegular',
                fontSize: 16.sp,
              ),
              cursorColor: Colors.white,
              decoration: InputDecoration(
                hintText: 'eg. Charizard',
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontFamily: 'NexaRegular',
                  fontSize: 15.sp,
                ),
                filled: true,
                fillColor: const Color(0xFF1E1E1E),
                suffixIcon: Icon(Icons.search, color: Colors.white),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 20.h,
                  horizontal: 12.w,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(7.r),
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(7.r),
                  borderSide: BorderSide(color: Colors.transparent),
                ),
              ),
            ),

            Spacer(),
            SizedBox(
              width: double.infinity,
              height: 58.h,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Select(selectedType: _selectedType),
                    ),
                  );
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
