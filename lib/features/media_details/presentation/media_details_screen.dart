import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/models/media_item.dart';
import '../../../shared/widgets/film_grain.dart';

class MediaDetailsScreen extends StatelessWidget {
  final MediaItem item;

  const MediaDetailsScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Cinematic Backdrop
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            backgroundColor: AppColors.background,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  if (item.backdropPath != null || item.posterPath != null)
                    CachedNetworkImage(
                      imageUrl: item.backdropPath ?? item.posterPath!,
                      fit: BoxFit.cover,
                    ),
                  // Dark Gradient Overlay for readability
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          AppColors.background,
                        ],
                        stops: [0.3, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Details Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    item.title.toUpperCase(),
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          color: AppColors.primaryAccent,
                        ),
                  ),
                  const SizedBox(height: 8),

                  // Metadata Row
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.textSecondary),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          item.type.name.toUpperCase(),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.star, color: AppColors.primaryAccent, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        item.voteAverage.toStringAsFixed(1),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppColors.primaryAccent,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Synopsis Header
                  Text(
                    'SYNOPSIS',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          letterSpacing: 2,
                        ),
                  ),
                  const SizedBox(height: 8),

                  // Synopsis Text
                  Text(
                    item.overview,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          height: 1.6,
                        ),
                  ),
                  
                  const SizedBox(height: 100), // Space for FAB in Phase 2
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
