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
  List newsList = [];
  String currentState = 'init';
  // loading
  // success
  // error

  var _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getNewFromApi(searchedItem: 'Egypt');
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
        title: Row(
          children: [
            const Text('Top News'),
            SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hint: Text(
                    'Type to search..',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  suffix: IconButton(
                    icon: Icon(Icons.search),
                    iconSize: 32,
                    onPressed: () {
                      getNewFromApi(searchedItem: _searchController.text);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        color: scheme.primary,
        onRefresh: _refresh,
        child: currentState == 'init'
            ? Center(
                child: Text(
                  'Welcome to news app, please click "Get news" to see todays news',
                ),
              )
            : currentState == 'loading'
            ? Center(child: CircularProgressIndicator())
            : currentState == 'success'
            ? newsList.isEmpty
                  ? Center(
                      child: Text(
                        'No news available. Tap "Get News" to fetch articles.',
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          for (int i = 0; i < newsList.length; i++)
                            NewsCard(
                              id: newsList[i]['source']['id'] ?? "no id",
                              title: newsList[i]['title'] ?? 'No Title',
                              description:
                                  newsList[i]['description'] ??
                                  "No Description",
                              imageUrl:
                                  newsList[i]['urlToImage'] ??
                                  "https://via.placeholder.com/150",
                              source:
                                  newsList[i]['source']['name'] ??
                                  "Unknown Source",
                              publishedAt: DateTime.parse(
                                newsList[i]['publishedAt'] ??
                                    "2024-01-01T00:00:00Z",
                              ),
                              onTap: () {
                                Navigator.of(context).push(
                                  PageRouteBuilder(
                                    transitionDuration: const Duration(
                                      milliseconds: 400,
                                    ),
                                    pageBuilder: (_, __, ___) =>
                                        NewsDetailScreen(article: newsList[i]),
                                    transitionsBuilder: (_, anim, __, child) =>
                                        FadeTransition(
                                          opacity: anim,
                                          child: child,
                                        ),
                                  ),
                                );
                              },
                            ),
                        ],
                      ),
                    )
            : Center(child: Text('Error fetching news. Please try again.')),

        // ListView.separated(
        //   physics: const AlwaysScrollableScrollPhysics(),
        //   padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        //   itemCount: articles.length,
        //   separatorBuilder: (_, __) => const SizedBox(height: 16),
        //   itemBuilder: (context, index) {
        //     final a = articles[index];
        //     return NewsCard(
        //       id: a['id'],
        //       title: a['title'],
        //       description: a['description'],
        //       imageUrl: a['imageUrl'],
        //       source: a['source'],
        //       publishedAt: a['publishedAt'],
        //       onTap: () {
        //         Navigator.of(context).push(
        //           PageRouteBuilder(
        //             transitionDuration: const Duration(milliseconds: 400),
        //             pageBuilder: (_, __, ___) => NewsDetailScreen(article: a),
        //             transitionsBuilder: (_, anim, __, child) =>
        //                 FadeTransition(opacity: anim, child: child),
        //           ),
        //         );
        //       },
        //     );
        //   },
        // ),
      ),
    );
  }

  Future<void> getNewFromApi({required String searchedItem}) async {
    setState(() {
      currentState = 'loading';
    });

    try {
      final newsResponse = await DioService().getNews(
        searchedItem: searchedItem,
      );

      setState(() {
        newsList = newsResponse['articles'];
        currentState = 'success';
      });
    } catch (error) {
      setState(() {
        currentState = 'error';
      });
    }
  }
}
