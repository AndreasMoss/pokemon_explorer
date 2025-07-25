import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search'), backgroundColor: Colors.black),
      body: Center(
        child: Text(
          'Search functionality will be implemented here.',
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
      ),
    );
  }
}
