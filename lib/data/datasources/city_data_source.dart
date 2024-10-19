import 'dart:convert';
import 'package:http/http.dart' as http;
import '../local/db_helper.dart';
import '../models/city_model.dart'; // Pastikan untuk mengimpor model City

class CityDataSource {
  final DBHelper dbHelper = DBHelper();

  final String allCitiesUrl = 'https://api.myquran.com/v2/sholat/kota/semua'; // API untuk semua kota
  final String searchCityUrl = 'https://api.myquran.com/v2/sholat/kota/cari'; // API untuk pencarian kota

  // Fetch all cities from API
  Future<void> fetchAndSaveAllCities() async {
    final response = await http.get(Uri.parse(allCitiesUrl));

    if (response.statusCode == 200) {
      final List<dynamic> cities = json.decode(response.body)['data'];
      for (var city in cities) {
        final cityModel = City(id: int.parse(city['id']), kode: city['id'], name: city['lokasi']); // Membuat model City
        await dbHelper.insertCity(cityModel.id, cityModel.kode, cityModel.name); // Simpan kota ke database
      }
    } else {
      throw Exception('Failed to load cities');
    }
  }

  // Search city from API by keyword
  Future<List<City>> searchCity(String keyword) async {
    final response = await http.get(Uri.parse('$searchCityUrl/$keyword'));
    if (response.statusCode == 200) {
      final List<dynamic> cities = json.decode(response.body)['data'];
      List<City> result = [];
      // Save any cities not in local database
      for (var city in cities) {
        final cityModel = City(id: int.parse(city['id']), kode: city['id'], name: city['lokasi']);
        final localCities = await dbHelper.searchCity(cityModel.name);
        if (localCities.isEmpty) {
          await dbHelper.insertCity(cityModel.id, cityModel.kode, cityModel.name);
        }
        result.add(cityModel); // Tambahkan ke hasil
      }
      return result; // Kembalikan daftar kota yang ditemukan
    } else {
      throw Exception('Failed to search city');
    }
  }
}
