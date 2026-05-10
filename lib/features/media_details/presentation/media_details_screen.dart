import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/models/media_item.dart';
import '../../../shared/models/cast_member.dart';
import '../../../shared/widgets/film_grain.dart';
import '../../reviews/data/reviews_repository.dart';
import '../../reviews/presentation/widgets/review_card.dart';
import '../../reviews/presentation/widgets/review_sheet.dart';
import '../../favorites/data/favorites_repository.dart';
import '../../watchlist/data/watchlist_repository.dart';
import '../../auth/data/auth_repository.dart';
import '../../collections/data/collections_repository.dart';
import '../../discovery/presentation/discovery_controller.dart';
import '../../../shared/widgets/media_card.dart';
import '../../../shared/widgets/glass_container.dart';

class MediaDetailsScreen extends ConsumerWidget {
  final MediaItem item;

  const MediaDetailsScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final reviewsAsync = ref.watch(mediaReviewsProvider(item.id));
    final averageRatingAsync = ref.watch(averageRatingProvider(item.id));
    final isWatchlistedAsync = ref.watch(isInWatchlistProvider(item.id));

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 450,
            pinned: true,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(Icons.chevron_left, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  if (item.backdropPath != null || item.posterPath != null)
                    CachedNetworkImage(
                      imageUrl: item.backdropPath ?? item.posterPath!,
                      fit: BoxFit.cover,
                    ).animate().fadeIn(duration: 800.ms),
                  
                  // Futuristic Gradient Overlay
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black87,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.playlist_add, color: Colors.white),
                onPressed: () {}, // TODO: Implement Collections
              ),
              isWatchlistedAsync.when(
                data: (isWatch) => IconButton(
                  icon: Icon(
                    isWatch ? Icons.bookmark : Icons.bookmark_border,
                    color: isWatch ? AppColors.secondaryAccent : Colors.white,
                  ),
                  onPressed: () {
                    final user = ref.read(authRepositoryProvider).currentUser;
                    if (user != null) {
                      ref.read(watchlistRepositoryProvider).toggleWatchlist(user.uid, item);
                    }
                  },
                ),
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ],
          ),
          
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Rating
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          item.title.toUpperCase(),
                          style: theme.textTheme.displayMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                          ),
                        ).animate().fadeIn(delay: 200.ms).moveX(begin: -20),
                      ),
                      const SizedBox(width: 16),
                      GlassContainer(
                        opacity: 0.1,
                        borderRadius: 12,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              const Icon(Icons.radar, color: AppColors.secondaryAccent, size: 20),
                              const SizedBox(height: 4),
                              Text(
                                item.voteAverage.toStringAsFixed(1),
                                style: const TextStyle(
                                  color: AppColors.secondaryAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Description
                  const Text(
                    'TRANSMISSION_DATA',
                    style: TextStyle(
                      color: AppColors.secondaryAccent,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    item.overview,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.white70,
                      height: 1.6,
                      fontSize: 15,
                    ),
                  ).animate().fadeIn(delay: 400.ms),
                  
                  const SizedBox(height: 48),
                  
                  // Cast
                  const Text(
                    'MANIFEST_CREW',
                    style: TextStyle(
                      color: AppColors.secondaryAccent,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildCastSection(ref),
                  
                  const SizedBox(height: 48),
                  
                  // Reviews Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'COMMUNITY_LOGS',
                        style: TextStyle(
                          color: AppColors.secondaryAccent,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => ReviewSheet(mediaItem: item),
                          );
                        },
                        child: const Text('UPLOAD LOG', style: TextStyle(color: Colors.white54, fontSize: 10)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Reviews List
                  reviewsAsync.when(
                    data: (reviews) => ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: reviews.length,
                      itemBuilder: (context, index) => ReviewCard(review: reviews[index]),
                    ),
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, s) => const Text('Error loading reviews'),
                  ),
                  
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCastSection(WidgetRef ref) {
    return SizedBox(
      height: 100,
      child: ref.watch(mediaCreditsProvider(item.id, item.type.name)).when(
        data: (cast) => ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: cast.length,
          itemBuilder: (context, index) {
            final member = cast[index];
            return Container(
              margin: const EdgeInsets.only(right: 20),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.surface,
                    backgroundImage: member.profilePath != null 
                        ? CachedNetworkImageProvider(member.profilePath!)
                        : null,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    member.name.toUpperCase(),
                    style: const TextStyle(color: Colors.white54, fontSize: 8, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => const SizedBox.shrink(),
      ),
    );
  }
}
