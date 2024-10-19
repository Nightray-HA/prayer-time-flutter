import 'package:get/get.dart';
import '../../data/models/prayer_time_model.dart';
import '../../data/repositories/prayer_time_repository.dart';

class PrayerTimeController extends GetxController {
  final PrayerTimeRepository repository;
  var prayerTime = PrayerTimeModel(
    location: '',
    date: '',
    imsak: '',
    subuh: '',
    terbit: '',
    dhuha: '',
    dzuhur: '',
    ashar: '',
    maghrib: '',
    isya: '',
  ).obs; // Model kosong untuk diisi nanti

  PrayerTimeController(this.repository);

  @override
  void onInit() {
    super.onInit();
  }

  void fetchPrayerTimes(String url) async {
    try {
      final time = await repository.getPrayerTimes(url);
      prayerTime.value = time; // Mengupdate dengan objek PrayerTimeModel
    } catch (e) {
      print('Error fetching prayer times: $e');
    }
  }
}
