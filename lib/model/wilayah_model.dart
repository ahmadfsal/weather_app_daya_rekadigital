class WilayahModel {
  final String? id;
  final String? propinsi;
  final String? kota;
  final String? kecamatan;
  final String? lat;
  final String? lon;

  WilayahModel({
    this.id,
    this.propinsi,
    this.kota,
    this.kecamatan,
    this.lat,
    this.lon,
  });

  factory WilayahModel.fromJson(Map<String, dynamic> json) {
    return WilayahModel(
      id: json['id'],
      propinsi: json['propinsi'],
      kota: json['kota'],
      kecamatan: json['kecamatan'],
      lat: json['lat'],
      lon: json['lon'],
    );
  }
}
