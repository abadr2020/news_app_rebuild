import 'package:flutter/material.dart';
import '../widgets/news_card.dart';
import 'news_detail_screen.dart';

class NewsListScreen extends StatefulWidget {
  const NewsListScreen({super.key});

  @override
  State<NewsListScreen> createState() => _NewsListScreenState();
}

class _NewsListScreenState extends State<NewsListScreen> {
  late List<Map<String, dynamic>> articles;

  @override
  void initState() {
    super.initState();
    // UI-only inline demo data (no data layer)
    articles = [
      {
        'id': '1',
        'title': 'Breakthrough in AI Research Promises Faster Models',
        'description':
            'Researchers unveil a training technique that reduces compute costs while increasing accuracy across benchmarks.',
        'content':
            'In a landmark study released today, a cross-institutional team introduced a novel optimization strategy that accelerates model training by up to 40% without sacrificing performance...\n\nIndustry leaders say this could reshape model deployment timelines across sectors from healthcare to finance.',
        'imageUrl':
            'https://images.unsplash.com/photo-1518779578993-ec3579fee39f?q=80&w=1600&auto=format&fit=crop',
        'source': 'Tech Daily',
        'author': 'Samir Khan',
        'publishedAt': DateTime.now().subtract(const Duration(hours: 2)),
      },
      {
        'id': '2',
        'title': 'Global Markets Rally as Inflation Eases',
        'description':
            'Stocks see broad gains following reports indicating inflation cooled more than expected in key regions.',
        'content':
            'Markets across Europe and Asia posted strong gains as investors reacted to fresh data showing inflation easing for the third consecutive month...',
        'imageUrl':
            'https://images.unsplash.com/photo-1526304640581-d334cdbbf45e?q=80&w=1600&auto=format&fit=crop',
        'source': 'Market Watch',
        'author': 'Ava Reynolds',
        'publishedAt': DateTime.now().subtract(const Duration(hours: 5)),
      },
      {
        'id': '3',
        'title': 'Sustainable Energy Milestone Reached Offshore',
        'description':
            'A new offshore wind farm comes online, setting a production record and powering hundreds of thousands of homes.',
        'content':
            'The project integrates next-gen turbines with AI-driven maintenance forecasts to maximize uptime. Officials said the site will avoid over a million tons of CO2 annually...',
        'imageUrl':
            'https://images.unsplash.com/photo-1509395176047-4a66953fd231?q=80&w=1600&auto=format&fit=crop',
        'source': 'Eco News',
        'author': 'Lina Chen',
        'publishedAt': DateTime.now().subtract(
          const Duration(days: 1, hours: 1),
        ),
      },
    ];
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
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () {},
            tooltip: 'Search (coming soon)',
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: RefreshIndicator(
        color: scheme.primary,
        onRefresh: _refresh,
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          itemCount: articles.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final a = articles[index];
            return NewsCard(
              id: a['id'],
              title: a['title'],
              description: a['description'],
              imageUrl: a['imageUrl'],
              source: a['source'],
              publishedAt: a['publishedAt'],
              onTap: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 400),
                    pageBuilder: (_, __, ___) => NewsDetailScreen(article: a),
                    transitionsBuilder: (_, anim, __, child) =>
                        FadeTransition(opacity: anim, child: child),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
