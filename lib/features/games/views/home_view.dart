import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/game_card_row.dart';
import '../../../core/widgets/my_app_bar.dart';
import '../../../theme/app_theme.dart';
import '../models/game_model.dart';
import '../providers/game_provider.dart';
import '../widgets/carousel_widget.dart';
import '../widgets/featured_game_card.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
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
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 300) {
      final provider = context.read<GameProvider>();
      if (!provider.isFetchingMore && !provider.isLoading) {
        provider.loadMoreGames();
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    final gameProvider = context.watch<GameProvider>();
    final allGames = gameProvider.games;

    final featuredGames = allGames.take(5).toList();

    final remainingGames = allGames.length > 5 ? allGames.sublist(5) : [];

    return Scaffold(
      appBar: MyAppBar(
        isReadOnly: true,
        onSearchTap: () => Navigator.pushNamed(context, '/search'),
        onSearchChanged: (_) {},
        onLoginTap: () => Navigator.pushNamed(context, '/profile'),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        final isWide = constraints.maxWidth > 700;
        return RefreshIndicator(
          onRefresh: () => gameProvider.fetchGames(),
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(child: _buildSectionTitle('Popular Games')),
              if (featuredGames.isNotEmpty)
                SliverToBoxAdapter(
                  child: GameCarousel(
                    items: featuredGames,
                    itemBuilder: (context, index, item) => FeaturedGameCard(game: item as Game),
                  ),
                ),
              SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: isWide
                    ? SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 0,
                    childAspectRatio: 3.2,
                  ),
                  delegate: SliverChildBuilderDelegate(
                        (context, index) => GameCardRow(game: remainingGames[index]),
                    childCount: remainingGames.length,
                  ),
                )
                    : SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) => GameCardRow(game: remainingGames[index]),
                    childCount: remainingGames.length,
                  ),
                ),
              ),

              if (gameProvider.isFetchingMore)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }


  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(title, style: const TextStyle(fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary)),
    );
  }
}