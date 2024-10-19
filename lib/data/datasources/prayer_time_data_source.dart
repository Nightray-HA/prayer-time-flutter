import '../models/prayer_time_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PrayerTimeDataSource {
  Future<PrayerTimeModel> fetchPrayerTimes(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return PrayerTimeModel.fromJson(jsonResponse['data']); // Ambil data dari JSON yang benar
    } else {
      throw Exception('Failed to load prayer times');
    }
  }
}
