import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:news_app/data/data_source/dio_service.dart';
import 'package:news_app/data/models/news_item_model.dart';

part 'news_list_state.dart';

class NewsListCubit extends Cubit<NewsListState> {
  NewsListCubit() : super(NewsListInitial());

  Future<void> getNewsFromAPI({required String searchItem}) async {
    emit(NewsListLoading());

    try {
      DioService dioService = DioService();
      final List<NewsItemModel> newsData = await dioService.getNews(
        searchitem: searchItem,
      );
      emit(NewsListSuccess(newsData: newsData));
    } on Exception catch (e) {
      log('Error fetching news: $e');
      emit(NewsListError());
    }
  }
}
