import 'game_model.dart';

class GameDetails {
  final Game basicInfo;
  final String fullDescription;
  final List<String> developerNames;
  final List<String> storeNames;
  final String? websiteUrl;
  final String releaseDate;
  final List<String> tags;
  final List<String> screenshots;

  GameDetails({
    required this.basicInfo,
    required this.fullDescription,
    required this.developerNames,
    required this.storeNames,
    required this.releaseDate,
    required this.tags,
    this.websiteUrl,
    required this.screenshots,
  });

  factory GameDetails.fromJson(Map<String, dynamic> json,
      {List<String> screenshots = const []}) {
    return GameDetails(
      basicInfo: Game.fromJson(json),
      fullDescription: json['description_raw'] ?? json['description'] ?? '',
      websiteUrl: json['website'],
      developerNames: (json['developers'] as List?)
          ?.map((d) => d['name'] as String)
          .toList() ?? [],
      storeNames: (json['stores'] as List?)
          ?.map((p) => p['store']['name'] as String)
          .toList() ?? [],
      releaseDate: json['released'] ?? 'N/A',
      tags: (json['tags'] as List?)
          ?.map((t) => t['name'] as String)
          .toList() ?? [],
      screenshots: screenshots,
    );
  }
}