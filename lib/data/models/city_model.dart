class City {
  final int id;
  final String kode;
  final String name;

  City({required this.id, required this.kode, required this.name});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'],
      kode: json['id'].toString(),
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'kode': kode,
      'name': name,
    };
  }
}
