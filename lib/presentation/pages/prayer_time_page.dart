import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/datasources/prayer_time_data_source.dart';
import '../../data/repositories/prayer_time_repository.dart';
import '../controllers/prayer_time_controller.dart';

class PrayerTimePage extends StatelessWidget {
  final PrayerTimeController controller;
  final String prayerTimeUrl; // Menambahkan parameter

  // Konstruktor yang menerima URL
  PrayerTimePage({Key? key, required this.prayerTimeUrl})
      : controller = PrayerTimeController(PrayerTimeRepository(PrayerTimeDataSource())),
        super(key: key) {
    // Memanggil fetchPrayerTimes pada inisialisasi
    controller.fetchPrayerTimes(prayerTimeUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Waktu Sholat')),
      body: Obx(() {
        if (controller.prayerTime.value.location.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }

        // Ambil jadwal dari objek
        final jadwal = controller.prayerTime.value;

        return ListView(
          children: [
            ListTile(title: Text('Lokasi: ${jadwal.location}')),
            ListTile(title: Text('Tanggal: ${jadwal.date}')),
            ListTile(title: Text('Imsak: ${jadwal.imsak}')),
            ListTile(title: Text('Subuh: ${jadwal.subuh}')),
            ListTile(title: Text('Terbit: ${jadwal.terbit}')),
            ListTile(title: Text('Dhuha: ${jadwal.dhuha}')),
            ListTile(title: Text('Dzuhur: ${jadwal.dzuhur}')),
            ListTile(title: Text('Ashar: ${jadwal.ashar}')),
            ListTile(title: Text('Maghrib: ${jadwal.maghrib}')),
            ListTile(title: Text('Isya: ${jadwal.isya}')),
          ],
        );
      }),
    );
  }
}
