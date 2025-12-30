import 'package:dio/dio.dart';
import 'package:news_app/data/data_source/network_constants.dart';
import 'package:news_app/data/models/news_item_model.dart';

class DioService {
  final dio = Dio();

  Future<dynamic> getNews({required String searchitem}) async {
    final response = await dio.get(
      '$baseUrl$newsEndpoint?q=$searchitem&from=${DateTime.now().subtract(Duration(days: 30)).toIso8601String().split('T')[0]}&sortBy=publishedAt&apiKey=$apiKey',
    );
    return (response.data['articles'] as List<dynamic>)
        .map((article) => NewsItemModel.fromJson(article))
        .toList();
  }
}
