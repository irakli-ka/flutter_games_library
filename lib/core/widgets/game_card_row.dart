import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../features/profile/providers/profile_provider.dart';
import '../utils/icon_map.dart';
import '../../features/games/models/game_model.dart';
import '../../theme/app_theme.dart';

class GameCardRow extends StatelessWidget {
  final Game game;

  const GameCardRow({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final profileProvider = context.watch<ProfileProvider>();
    final isInLibrary = profileProvider.isInLibrary(game.id);

    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/game-details',
          arguments: game.id,
        );
      },
      child: Container(
        constraints: const BoxConstraints(minHeight: 110),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.myDarkerBackground,
          borderRadius: BorderRadius.circular(16),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  game.imageUrl,
                  width: 86,
                  height: 86,
                  fit: BoxFit.cover,
                  cacheWidth: 250,
                  errorBuilder: (context, error, stackTrace) =>
                      Container(
                        width: 86,
                        height: 86,
                        color: Colors.grey[800],
                        child: const Icon(Icons.gamepad, color: Colors.white54),
                      ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      game.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      game.genre,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    buildPlatformIcons(game.platforms),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getRatingColor(game.rating),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      game.rating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  if (authProvider.isAuthenticated)
                    GestureDetector(
                      onTap: () => profileProvider.toggleLibrary(game),
                      child: Icon(
                        isInLibrary ? Icons.bookmark : Icons
                            .bookmark_add_outlined,
                        color: AppColors.iconColor,
                        size: 28,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getRatingColor(double rating) {
    if (rating >= 4.0) return AppColors.ratingHigh;
    if (rating >= 3.0) return AppColors.ratingMedium;
    if (rating == 0.0) return Colors.grey;
    return AppColors.ratingLow;
  }
}