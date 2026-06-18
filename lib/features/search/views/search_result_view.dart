import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/game_card_row.dart';
import '../../../theme/app_theme.dart';
import '../providers/search_provider.dart';

class SearchResultView extends StatefulWidget {
  const SearchResultView({super.key});

  @override
  State<SearchResultView> createState() => _SearchResultViewState();
}

class _SearchResultViewState extends State<SearchResultView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      context.read<SearchProvider>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchProvider = context.watch<SearchProvider>();
    final results = searchProvider.searchResults;

    return PopScope(
      canPop: true,
      child: Scaffold(
        body: LayoutBuilder(builder: (context, constraints) {
          final isWide = constraints.maxWidth > 700;

          if (searchProvider.isLoading && results.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: () => searchProvider.search(),
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                const SliverToBoxAdapter(child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 32, 16, 16),
                  child: Text('Search Results',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight
                          .bold, color: AppColors.textPrimary)),
                )),
                if (results.isEmpty && !searchProvider.isLoading)
                  const SliverFillRemaining(child: Center(
                      child: Text('No results found', style: TextStyle(
                          color: AppColors.textSecondary))))
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    sliver: isWide
                        ? SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 0,
                          childAspectRatio: 3.2),
                      delegate: SliverChildBuilderDelegate((context, index) =>
                          GameCardRow(game: results[index]), childCount: results
                          .length),
                    )
                        : SliverList(delegate: SliverChildBuilderDelegate((
                        context, index) => GameCardRow(game: results[index]),
                        childCount: results.length)),
                  ),
                if (searchProvider.isFetchingMore)
                  const SliverToBoxAdapter(child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()))),
              ],
            ),
          );
        }),
      ),
    );
  }
}