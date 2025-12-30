part of 'news_list_cubit.dart';

@immutable
sealed class NewsListState {}

final class NewsListInitial extends NewsListState {}

final class NewsListLoading extends NewsListState {}

final class NewsListSuccess extends NewsListState {
  NewsListSuccess({required List<NewsItemModel> this.newsData});
  final List<NewsItemModel> newsData;
}

final class NewsListError extends NewsListState {}
