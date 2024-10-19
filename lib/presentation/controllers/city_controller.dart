// lib/presentation/controllers/city_controller.dart

import 'package:get/get.dart';
import '../../data/datasources/city_data_source.dart';
import '../../data/local/db_helper.dart';
import '../../data/models/city_model.dart'; // Pastikan untuk mengimpor model City

class CityController extends GetxController {
  final CityDataSource dataSource;
  final DBHelper dbHelper = DBHelper();

  var cities = <City>[].obs; // Mengubah menjadi list City
  var isLoading = true.obs;

  CityController(this.dataSource);

  @override
  void onInit() {
    super.onInit();
    loadCities();
  }

  Future<void> loadCities() async {
    isLoading(true);
    try {
      // Fetch cities from local database first
      final localCities = await dbHelper.getAllCities();
      if (localCities.isNotEmpty) {
        // No need to map again; they're already City objects.
        cities.assignAll(localCities);
      } else {
        // If no cities in local database, fetch from API
        await dataSource.fetchAndSaveAllCities();
        final allCities = await dbHelper.getAllCities();
        cities.assignAll(allCities); // Assuming allCities are already City objects
      }

    } catch (e) {
      print('Error loading cities: $e');
    } finally {
      isLoading(false);
    }
  }


  // Search city by keyword using API
  Future<void> searchCity(String keyword) async {
    if (keyword.isEmpty) return;
    try {
      isLoading(true);
      final result = await dataSource.searchCity(keyword);
      // Menyimpan hasil pencarian ke dalam observables cities
      cities.assignAll(result);
    } catch (e) {
      print('Error searching city: $e');
    } finally {
      isLoading(false);
    }
  }
}
