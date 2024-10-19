class PrayerTimeModel {
  final String location; // Lokasi
  final String date; // Tanggal
  final String imsak;
  final String subuh;
  final String terbit;
  final String dhuha;
  final String dzuhur;
  final String ashar;
  final String maghrib;
  final String isya;

  PrayerTimeModel({
    required this.location,
    required this.date,
    required this.imsak,
    required this.subuh,
    required this.terbit,
    required this.dhuha,
    required this.dzuhur,
    required this.ashar,
    required this.maghrib,
    required this.isya,
  });

  // Method untuk membuat model dari JSON
  factory PrayerTimeModel.fromJson(Map<String, dynamic> json) {
    return PrayerTimeModel(
      location: json['lokasi'],
      date: json['jadwal']['date'], // Mengambil tanggal dari sub-objek jadwal
      imsak: json['jadwal']['imsak'],
      subuh: json['jadwal']['subuh'],
      terbit: json['jadwal']['terbit'],
      dhuha: json['jadwal']['dhuha'],
      dzuhur: json['jadwal']['dzuhur'],
      ashar: json['jadwal']['ashar'],
      maghrib: json['jadwal']['maghrib'],
      isya: json['jadwal']['isya'],
    );
  }
}
