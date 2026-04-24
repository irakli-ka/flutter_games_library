import 'package:flutter/material.dart';
import '/pages/main_page.dart';
import '/widgets/game_card_row.dart';

class UserPage extends StatelessWidget {
  const UserPage({
    super.key,
    required this.userGames,
  });

  final ValueNotifier<List<GameItem>> userGames;

  void _removeFromUserList(GameItem game) {
    final current = List<GameItem>.from(userGames.value);
    current.remove(game);
    userGames.value = current;
  }

  Widget _buildGameCard(GameItem game) {
    return GameCardRow(
      title: game.title,
      genre: game.genre,
      rating: game.rating,
      image: NetworkImage(game.imageUrl),
      showAddButton: false,
      onDelete: () => _removeFromUserList(game),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Games'),
      ),
      body: ValueListenableBuilder<List<GameItem>>(
        valueListenable: userGames,
        builder: (context, games, _) {
          if (games.isEmpty) {
            return const Center(
              child: Text('No games added yet'),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(12),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 700;

                if (isWide) {
                  return GridView.builder(
                    itemCount: games.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
          );
        },
      ),
    );
  }
}