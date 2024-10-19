import '../datasources/prayer_time_data_source.dart';
import '../models/prayer_time_model.dart';

class PrayerTimeRepository {
  final PrayerTimeDataSource dataSource;

  PrayerTimeRepository(this.dataSource);

  Future<PrayerTimeModel> getPrayerTimes(String url) async {
    return await dataSource.fetchPrayerTimes(url);
  }
}
