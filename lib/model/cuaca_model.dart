class CuacaModel {
  final String? jamCuaca;
  final String? kodeCuaca;
  final String? cuaca;
  final String? humidity;
  final String? tempC;
  final String? tempF;

  CuacaModel({
    this.jamCuaca,
    this.kodeCuaca,
    this.cuaca,
    this.humidity,
    this.tempC,
    this.tempF,
  });

  factory CuacaModel.fromJson(Map<String, dynamic> json) {
    return CuacaModel(
      jamCuaca: json['jamCuaca'],
      kodeCuaca: json['kodeCuaca'],
      cuaca: json['cuaca'],
      humidity: json['humidity'],
      tempC: json['tempC'],
      tempF: json['tempF'],
    );
  }
}
