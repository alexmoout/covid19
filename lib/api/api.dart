import 'package:dio/dio.dart';
import 'package:flutteriu_covid19/model/data_detail_model.dart';

class Api {
  Dio dio = Dio();

  final String _api = 'https://corona.lmao.ninja/v2/all';

  Future<DataDetailModel> getTotal() async {
    try {
      Response response = await dio.get(_api);
      return DataDetailModel.fromJson(response.data);
    } catch (error) {
      print(error);
      return null;
    }
  }

  final String daily =
      "https://corona.lmao.ninja/v3/covid-19/historical/all?lastdays=7";
  Future<dynamic> getDaily() async {
    try {
      Response response = await dio.get((daily));

      return response.data;
    } catch (error) {
      return null;
    }
  }
}
