import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:news_app/data/network_constants.dart';

class DioService {
  final dio = Dio();

  Future<dynamic> getNews({required String searchedItem}) async {
    final response = await dio.get(
      '$baseUrl$newsEndpoint?q=$searchedItem&from=2025-11-22&sortBy=publishedAt&apiKey=7c07f0c86d484b30a5af1289c531cff1',
    );

    return response.data;
  }
}
