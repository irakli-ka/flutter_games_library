import 'package:flutter/material.dart';
import 'package:flutter_games_library/theme/app_theme.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../features/games/models/platform_model.dart';

Widget buildPlatformIcons(List<Platform> platforms) {
  final Set<String> iconPaths = {};

  for (var p in platforms) {
    final slug = p.slug.toLowerCase();
    if (slug.contains('pc')) {
      iconPaths.add('lib/assets/icons/ic_platform_pc.svg');
    } else if (slug.contains('playstation') || slug.contains('ps')) {
      iconPaths.add('lib/assets/icons/ic_platform_playstation.svg');
    } else if (slug.contains('xbox')) {
      iconPaths.add('lib/assets/icons/ic_platform_xbox.svg');
    } else if (slug.contains('nintendo') || slug.contains('switch')) {
      iconPaths.add('lib/assets/icons/ic_platform_nintendo.svg');
    }
  }

  return Row(
    children: iconPaths.map((path) =>
        Padding(
          padding: const EdgeInsets.only(right: 6),
          child: SvgPicture.asset(
            path,
            width: 16,
            height: 16,
            colorFilter: const ColorFilter.mode(AppColors.iconColor, BlendMode.srcIn),
          ),
        )).toList(),
  );
}