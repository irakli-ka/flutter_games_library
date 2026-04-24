import 'dart:math';

import 'package:flutter/material.dart';
import '/theme/app_theme.dart';
import '/widgets/game_card_row.dart';
import '/widgets/my_app_bar.dart';
import 'user_page.dart';

class GameItem {
  final String title;
  final String genre;
  final double rating;
  final String imageUrl;

  GameItem({
    required this.title,
    required this.genre,
    required this.rating,
    required this.imageUrl,
  });
}

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.userGames});

  final ValueNotifier<List<GameItem>> userGames;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final TextEditingController _addController = TextEditingController();
  final TextEditingController _genreController = TextEditingController();
  String _searchQuery = '';
  final Random _random = Random();
  final List<GameItem> _games = [
    GameItem(
      title: 'Portal',
      genre: 'Action, Puzzle',
      rating: 4.49,
      imageUrl: 'https://picsum.photos/400',
    ),
    GameItem(
      title: 'Elden Ring',
      genre: 'Action, RPG',
      rating: 4.9,
      imageUrl: 'https://picsum.photos/200',
    ),
    GameItem(
      title: 'Devil May Cry',
      genre: 'Action, Hack And Slash',
      rating: 4.5,
      imageUrl: 'https://picsum.photos/600',
    ),
    GameItem(
      title: 'Dark Souls',
      genre: 'RPG, Action',
      rating: 4.9,
      imageUrl: 'https://picsum.photos/230',
    ),
    GameItem(
      title: 'The Witcher 3',
      genre: 'RPG',
      rating: 4.8,
      imageUrl: 'https://picsum.photos/700',
    ),
    GameItem(
      title: 'Hollow Knight',
      genre: 'Metroidvania',
      rating: 4.7,
      imageUrl: 'https://picsum.photos/50',
    ),
    GameItem(
      title: 'Nier Automata',
      genre: 'Hack And Slash, RPG',
      rating: 4.6,
      imageUrl: 'https://picsum.photos/320',
    ),
    GameItem(
      title: 'The Elder Scrolls V: Skyrim',
      genre: 'Open World, RPG',
      rating: 4.0,
      imageUrl: 'https://picsum.photos/450',
    ),
    GameItem(
      title: 'Dark Souls 2',
      genre: 'RPG, Action',
      rating: 4.9,
      imageUrl: 'https://picsum.photos/435',
    ),
    GameItem(
      title: 'Dark Souls ',
      genre: 'RPG, Action',
      rating: 4.9,
      imageUrl: 'https://picsum.photos/335',
    ),

  ];

  void _addToUserList(GameItem game) {
    final current = List<GameItem>.from(widget.userGames.value);
    if (!current.any((item) => item.title == game.title)) {
      current.add(game);
      widget.userGames.value = current;
    }
  }

  Widget _buildGameCard(GameItem game) {
    return GameCardRow(
      title: game.title,
      genre: game.genre,
      rating: game.rating,
      image: NetworkImage(game.imageUrl),
      showAddButton: true,
      onAdd: () => _addToUserList(game),
      onDelete: () => _deleteGame(game),
    );
  }

  @override
  void dispose() {
    _addController.dispose();
    _genreController.dispose();
    super.dispose();
  }

  void _addGame() {
    final titleText = _addController.text.trim();
    final genreText = _genreController.text.trim();

    if (titleText.isEmpty) return;

    final randomRating = double.parse(
      (_random.nextDouble() * 5).toStringAsFixed(2),
    );

    setState(() {
      _games.add(
        GameItem(
          title: titleText,
          genre: genreText.isEmpty ? 'Unknown Genre' : genreText,
          rating: randomRating,
          imageUrl:
              'https://picsum.photos/300?random=${DateTime.now().millisecondsSinceEpoch}',
        ),
      );
      _addController.clear();
      _genreController.clear();
    });
  }

  void _deleteGame(GameItem item) {
    setState(() {
      _games.remove(item);
    });
  }

  List<GameItem> get _filteredGames {
    if (_searchQuery.isEmpty) return _games;
    return _games
        .where(
          (game) =>
              game.title.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final games = _filteredGames;

    return Scaffold(
      appBar: MyAppBar(
        onSearchChanged: (value) {
          setState(() => _searchQuery = value);
        },
        onLoginTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => UserPage(userGames: widget.userGames),
            ),
          );
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextField(
                      controller: _addController,
                      decoration: InputDecoration(
                        hintText: 'Game title',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: AppColors.myDarkerBackground,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      onSubmitted: (_) => _addGame(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: _genreController,
                      decoration: InputDecoration(
                        hintText: 'Genre',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: AppColors.myDarkerBackground,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      onSubmitted: (_) => _addGame(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(onPressed: _addGame, child: const Text('Add')),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth >= 700;

                    if (games.isEmpty) {
                      return const Center(child: Text('No games found'));
                    }
                    if (isWide) {
                      return GridView.builder(
                        itemCount: games.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                              childAspectRatio: 3.4,
                            ),
                        itemBuilder: (context, index) {
                          final game = games[index];
                          return _buildGameCard(game);
                        },
                      );
                    }
                    return ListView.separated(
                      itemCount: games.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final game = games[index];
                        return _buildGameCard(game);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
