import 'package:dio/dio.dart';

class DioService {
  final dio = Dio();

  Future<dynamic> getNews({required String searchitem}) async {
    final response = await dio.get(
      'https://newsapi.org/v2/everything?q=$searchitem&from=${DateTime.now().subtract(Duration(days: 30)).toIso8601String().split('T')[0]}&sortBy=publishedAt&apiKey=1f03e3fb988b484b9cc85ac560358dd7',
    );
    return response.data;
  }
}
