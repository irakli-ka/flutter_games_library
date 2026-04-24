import 'package:flutter/material.dart';
import '/theme/app_theme.dart';

class GameCardRow extends StatelessWidget {
  const GameCardRow({
    super.key,
    required this.title,
    required this.genre,
    required this.rating,
    required this.image,
    this.onTap,
    this.onDelete,
    this.onAdd,
    this.showAddButton = true,
  });

  final String title;
  final String genre;
  final double rating;
  final ImageProvider image;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onAdd;
  final bool showAddButton;

  @override
  Widget build(BuildContext context) {
    final ratingColor = rating >= 4.0
        ? AppColors.ratingHigh
        : rating >= 2.5
            ? AppColors.ratingMedium
            : AppColors.ratingLow;

    return Card(
      elevation: 2,
      color: AppColors.myDarkerBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: AppColors.iconColor),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image(
                  image: image,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Wrap(
                      direction: Axis.vertical,
                      spacing: 4,
                      children: [
                        SizedBox(
                          width: constraints.maxWidth,
                          child: Text(
                            title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: constraints.maxWidth,
                          child: Text(
                            genre,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: ratingColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      rating.toStringAsFixed(2),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (showAddButton)
                        IconButton(
                          onPressed: onAdd,
                          icon: const Icon(Icons.add_circle_outline),
                          tooltip: 'Add',
                        ),
                      IconButton(
                        onPressed: onDelete,
                        icon: const Icon(Icons.delete_outline),
                        tooltip: 'Delete',
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}