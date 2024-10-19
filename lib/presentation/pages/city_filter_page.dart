import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:get/get.dart';
import '../../data/local/db_helper.dart';
import '../../data/models/city_model.dart';
import '../../data/datasources/city_data_source.dart';
import '../controllers/city_controller.dart';
import '../pages/prayer_time_page.dart';

class CityFilterPage extends StatefulWidget {
  @override
  _CityFilterPageState createState() => _CityFilterPageState();
}

class _CityFilterPageState extends State<CityFilterPage> {
  final CityController cityController = Get.put(CityController(CityDataSource()));
  String? selectedCityId;
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("City Filter", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          if (cityController.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownSearch<String>(
                items: (String filter, dynamic _) async {
                  List<City> localCities = cityController.cities;
                  List<String> cityNames = localCities.map((city) => city.name).toList();

                  List<String> filteredCities = cityNames.where((name) => name.toLowerCase().contains(filter.toLowerCase())).toList();

                  if (filteredCities.isEmpty) {
                    List<City> apiCities = await cityController.dataSource.searchCity(filter);
                    filteredCities = apiCities.map((city) => city.name).toList();
                  }

                  return filteredCities;
                },
                decoratorProps: DropDownDecoratorProps(
                  decoration: InputDecoration(
                    labelText: 'Pilih Kota',
                    border: OutlineInputBorder(),
                  ),
                ),
                popupProps: PopupProps.menu(
                  fit: FlexFit.loose,
                  showSearchBox: true,
                ),
                onChanged: (value) {
                  if (value != null) {
                    final selectedCity = cityController.cities.firstWhere((city) => city.name == value);
                    selectedCityId = selectedCity.kode.toString();
                    print("Selected city: $value, ID: $selectedCityId");
                  }
                },
                selectedItem: null,
              ),
              SizedBox(height: 16.0),

              Text("Pilih Tanggal", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 8.0),
              GestureDetector(
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDate ?? DateTime.now(), // Use selectedDate as initialDate
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      selectedDate = pickedDate; // Update selectedDate
                    });
                    print("Selected date: ${selectedDate!.toLocal()}".split(' ')[0]);
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(selectedDate != null ? selectedDate!.toLocal().toString().split(' ')[0] : "Tanggal yang dipilih", style: TextStyle(color: Colors.black)),
                      Icon(Icons.calendar_today, color: Colors.teal),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24.0),

              ElevatedButton(
                onPressed: () async {
                  if (selectedCityId != null) {
                    final cityId = selectedCityId;
                    final selectedDateString = selectedDate != null
                        ? "${selectedDate!.year}-${selectedDate!.month}-${selectedDate!.day}"
                        : DateTime.now().toLocal().toString().split(' ')[0];

                    final prayerTimeUrl = 'https://api.myquran.com/v2/sholat/jadwal/$cityId/$selectedDateString';
                    print("Fetching prayer time from: $prayerTimeUrl");

                    Get.to(() => PrayerTimePage(prayerTimeUrl: prayerTimeUrl)); // Kirim URL ke halaman Prayer Time
                  } else {
                    print("Pilih kota terlebih dahulu!");
                    Get.snackbar(
                      'Peringatan',
                      'Silakan pilih kota terlebih dahulu!',
                      snackPosition: SnackPosition.BOTTOM,
                      duration: Duration(seconds: 3),
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  }
                },
                child: Text("Cari"),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
