import 'package:dio/dio.dart';

final dadataSource = DadataDatasource();

class DadataDatasource {
  late final Dio dio;

  DadataDatasource() {
    dio = Dio(
      BaseOptions(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Token 263bdeb5e91ca9e6c00178ea41911ec94912d7ec',
          'X-Secret': 'c1a65c7a1cae38316b5ff99f3a9027071e7f831e'
        },
      ),
    );
  }

  Future<List<String>> getSuggestions(String query) async {
    try {
      Response response = await dio.post(
          'http://suggestions.dadata.ru/suggestions/api/4_1/rs/suggest/address',
          data: {
            "query": query,
          });

      List<dynamic> suggestions = response.data["suggestions"];

      List<String> res =
          suggestions.map((e) => (e as Map)['value'].toString()).toList();

      return res;
    } on DioException catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<bool> getCleanAddress(String ask) async {
    try {
      Response response = await dio.post(
        'https://cleaner.dadata.ru/api/v1/clean/address',
        data: ask,
      );
      print(response.data);
      return response.statusCode == 200;
    } on DioException catch (e) {
      print(e.toString());
      return false;
    }
  }
}
