import 'package:dio/dio.dart';
import 'package:weather_app_daya_rekadigital/model/cuaca_model.dart';
import 'package:weather_app_daya_rekadigital/model/wilayah_model.dart';

class WeatherRepository {
  static Future<List<WilayahModel>?> getListWilayah() async {
    try {
      Response response = await Dio()
          .get('https://ibnux.github.io/BMKG-importer/cuaca/wilayah.json');

      if (response.data == null || response.data == []) {
        return null;
      }

      return (response.data as List)
          .map((e) => WilayahModel.fromJson(e))
          .toList();
    } on DioError catch (_) {
      return null;
    }
  }

  static Future<List<CuacaModel>?> getListCuacaByIdWilayah(
      String idWilayah) async {
    try {
      Response response = await Dio()
          .get('https://ibnux.github.io/BMKG-importer/cuaca/$idWilayah.json');

      if (response.data == null || response.data == []) {
        return null;
      }

      return (response.data as List)
          .map((e) => CuacaModel.fromJson(e))
          .toList();
    } on DioError catch (_) {
      return null;
    }
  }
}
