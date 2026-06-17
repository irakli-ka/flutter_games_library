import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../../../theme/app_theme.dart';
import '../widgets/carousel_widget.dart';

class GameDetailsView extends StatefulWidget {
  final int gameId;

  const GameDetailsView({super.key, required this.gameId});

  @override
  State<GameDetailsView> createState() => _GameDetailsViewState();
}

class _GameDetailsViewState extends State<GameDetailsView> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<GameProvider>().fetchGameDetails(widget.gameId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final gameProvider = context.watch<GameProvider>();
    final details = gameProvider.selectedGameDetails;

    if (gameProvider.isDetailsLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (details == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Failed to load game details')),
      );
    }

    final basic = details.basicInfo;

    return Scaffold(
      backgroundColor: AppColors.myBackground,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 214,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: GameCarousel(
                items: details.screenshots,
                height: 200,
                overlayIndicators: true,
                itemBuilder: (context, index, url) => Image.network(url as String, fit: BoxFit.cover),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(basic.title, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    const SizedBox(height: 12),
                    if (details.developerNames.isNotEmpty)
                      Text('Creator: ${details.developerNames.join(", ")}',
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 16)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text('Rating: ${basic.rating} ', style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 16)),
                        const Icon(Icons.star, color: Colors.amber, size: 18),
                      ],
                    ),
                  ],
                ),
              ),

              _buildChipsSection('Genres', basic.genre.split(', ')),
              _buildChipsSection('Platforms', basic.platforms.map((p) => p.name).toList()),
              _buildChipsSection('Stores', details.storeNames),
              _buildChipsSection('Tags', details.tags),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Released: ${details.releaseDate.toString().split(' ')[0]}',
                        style: const TextStyle(color: AppColors.textSecondary)),
                    if (details.websiteUrl != null) ...[
                      const SizedBox(height: 8),
                      Text('Website: ${details.websiteUrl}',
                          style: const TextStyle(color: AppColors.linkColor)),
                    ],
                    const SizedBox(height: 24),
                    const Text('Description', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    const SizedBox(height: 12),
                    Text(details.fullDescription, style: const TextStyle(color: AppColors.textSecondary, fontSize: 16, height: 1.6)),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildChipsSection(String title, List<String> items) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: items.map((item) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Chip(
                label: Text(item, style: const TextStyle(color: AppColors.textPrimary, fontSize: 12)),
                backgroundColor: Colors.transparent,
                shape: StadiumBorder(side: BorderSide(color: AppColors.textSecondary.withValues(alpha: 0.5))),
              ),
            )).toList(),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}