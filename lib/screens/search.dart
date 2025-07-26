import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
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
              child: ElevatedButton(
                onPressed: () {
                  // Handle search action
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
