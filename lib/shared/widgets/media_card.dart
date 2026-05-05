import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../models/media_item.dart';

class MediaCard extends StatelessWidget {
  final MediaItem item;
  final VoidCallback onTap;

  const MediaCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.surface,
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Poster Image
            if (item.posterPath != null)
              CachedNetworkImage(
                imageUrl: item.posterPath!,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(color: AppColors.surface),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              )
            else
              const Center(child: Icon(Icons.movie, color: AppColors.textSecondary)),

            // Gradient Overlay (Cinematic Aesthetic)
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: AppColors.posterGradient,
                ),
              ),
            ),

            // Text Info (Title and Rating)
            Positioned(
              bottom: 8,
              left: 8,
              right: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: AppColors.primaryAccent, size: 12),
                      const SizedBox(width: 4),
                      Text(
                        item.voteAverage.toStringAsFixed(1),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 10,
                              color: AppColors.primaryAccent,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0);
  }
}
