// lib/main.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'data/datasources/city_data_source.dart';
import 'presentation/pages/city_filter_page.dart';

void main() {
  // Dependency Injection
  Get.put(CityDataSource());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Jadwal Sholat',
      home: CityFilterPage(),
    );
  }
}
