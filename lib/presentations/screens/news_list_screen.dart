import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/cubits/news_list/news_list_cubit.dart';
import 'package:news_app/data/data_source/dio_service.dart';
import 'package:news_app/data/models/news_item_model.dart';
import '../widgets/news_card.dart';
import 'news_detail_screen.dart';

class NewsListScreen extends StatefulWidget {
  const NewsListScreen({super.key});

  @override
  State<NewsListScreen> createState() => _NewsListScreenState();
}

class _NewsListScreenState extends State<NewsListScreen> {
  final _searchController = TextEditingController();
  List<NewsItemModel> newsArticles = [];

  @override
  void initState() {
    super.initState();
    context.read<NewsListCubit>().getNewsFromAPI(searchItem: 'latest');
  }

  Future<void> _refresh() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top News'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SizedBox(
              width: 200,
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search news...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () {
              context.read<NewsListCubit>().getNewsFromAPI(
                searchItem: _searchController.text.isEmpty
                    ? 'latest'
                    : _searchController.text,
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<NewsListCubit, NewsListState>(
        builder: (context, state) {
          if (state is NewsListLoading) {
            return Center(
              child: CircularProgressIndicator(color: scheme.primary),
            );
          } else if (state is NewsListSuccess) {
            newsArticles = state.newsData;
            if (newsArticles.isEmpty) {
              return Center(
                child: Text(
                  'No news available. Tap "Get News" to fetch articles.',
                ),
              );
            } else {
              // return ListView.builder(
              //   physics: const AlwaysScrollableScrollPhysics(),
              //   padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              //   itemCount: newsArticles.length,
              //   itemBuilder: (context, index) {
              //     final a = newsArticles[index];
              //     return NewsCard(
              //       id: a.id,
              //       title: a.title,
              //       description: a.description,
              //       imageUrl: a.imageUrl ?? "https://via.placeholder.com/150",
              //       source: a.source,
              //       publishedAt: DateTime.parse(
              //         a.publishedAt.toIso8601String(),
              //       ),
              //       onTap: () {
              //         Navigator.of(context).push(
              //           PageRouteBuilder(
              //             transitionDuration: const Duration(milliseconds: 400),
              //             pageBuilder: (_, __, ___) =>
              //                 NewsDetailScreen(article: newsArticles[index]),
              //             transitionsBuilder: (_, anim, __, child) =>
              //                 FadeTransition(opacity: anim, child: child),
              //           ),
              //         );
              //       },
              //     );
              //   },
              // );
              return ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                itemCount: newsArticles.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final a = newsArticles[index];
                  return NewsCard(
                    id: a.id,
                    title: a.title,
                    description: a.description,
                    imageUrl: a.imageUrl ?? "https://via.placeholder.com/150",
                    source: a.source,
                    publishedAt: DateTime.parse(
                      a.publishedAt.toIso8601String(),
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 400),
                          pageBuilder: (_, __, ___) =>
                              NewsDetailScreen(article: newsArticles[index]),
                          transitionsBuilder: (_, anim, __, child) =>
                              FadeTransition(opacity: anim, child: child),
                        ),
                      );
                    },
                  );
                },
              );
            }
          } else {
            return Center(
              child: Text(
                'Error fetching news. Please try again later.',
                style: TextStyle(color: scheme.error),
              ),
            );
          }
        },
      ),
    );
  }
}
