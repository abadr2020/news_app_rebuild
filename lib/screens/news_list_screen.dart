import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:news_app/data/dio_service.dart';
import '../widgets/news_card.dart';
import 'news_detail_screen.dart';

class NewsListScreen extends StatefulWidget {
  const NewsListScreen({super.key});

  @override
  State<NewsListScreen> createState() => _NewsListScreenState();
}

class _NewsListScreenState extends State<NewsListScreen> {
  final _searchController = TextEditingController();
  List newsArticles = [];
  String currentState = "Loading";

  @override
  void initState() {
    super.initState();
    getNewsFromAPI(searchItem: 'latest');
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
              getNewsFromAPI(searchItem: _searchController.text);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        color: scheme.primary,
        onRefresh: _refresh,
        child: currentState == "Loading"
            ? Center(child: CircularProgressIndicator(color: scheme.primary))
            : currentState == "Success"
            ? newsArticles.isEmpty
                  ? Center(
                      child: Text(
                        'No news available. Tap "Get News" to fetch articles.',
                      ),
                    )
                  : ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                      itemCount: newsArticles.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final a = newsArticles[index];
                        return NewsCard(
                          id: a['source']['id'] ?? "no id",
                          title: a['title'] ?? "No Title",
                          description: a['description'] ?? "No Description",
                          imageUrl:
                              a['urlToImage'] ??
                              "https://via.placeholder.com/150",
                          source: a['source']['name'] ?? "Unknown Source",
                          publishedAt: DateTime.parse(
                            a['publishedAt'] ?? "2024-01-01T00:00:00Z",
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                transitionDuration: const Duration(
                                  milliseconds: 400,
                                ),
                                pageBuilder: (_, __, ___) =>
                                    NewsDetailScreen(article: a),
                                transitionsBuilder: (_, anim, __, child) =>
                                    FadeTransition(opacity: anim, child: child),
                              ),
                            );
                          },
                        );
                      },
                    )
            : Center(
                child: Text(
                  'Error fetching news. Please try again later.',
                  style: TextStyle(color: scheme.error),
                ),
              ),
      ),
    );
  }

  Future<void> getNewsFromAPI({required String searchItem}) async {
    setState(() {
      currentState = "Loading";
    });

    try {
      DioService dioService = DioService();
      var newsData = await dioService.getNews(searchitem: searchItem);
      setState(() {
        newsArticles = newsData['articles'];
        currentState = "Success";
      });
    } on Exception catch (e) {
      log('Error fetching news: $e');
      setState(() {
        currentState = "Error";
      });
    }
  }
}
