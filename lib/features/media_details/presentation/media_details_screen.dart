import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/models/media_item.dart';
import '../../../shared/widgets/film_grain.dart';
import '../../reviews/data/reviews_repository.dart';
import '../../reviews/presentation/widgets/review_card.dart';
import '../../reviews/presentation/widgets/review_sheet.dart';
import '../../favorites/data/favorites_repository.dart';
import '../../watchlist/data/watchlist_repository.dart';
import '../../auth/data/auth_repository.dart';

class MediaDetailsScreen extends ConsumerWidget {
  final MediaItem item;

  const MediaDetailsScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviewsAsync = ref.watch(mediaReviewsProvider(item.id));
    final isFavoriteAsync = ref.watch(isFavoriteProvider(item.id));
    final averageRatingAsync = ref.watch(averageRatingProvider(item.id));
    final isWatchlistedAsync = ref.watch(isInWatchlistProvider(item.id));

    return FilmGrain(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            // Cinematic Backdrop
            SliverAppBar(
              expandedHeight: 400,
              pinned: true,
              backgroundColor: AppColors.background,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                // Watchlist (Bookmark) Toggle
                isWatchlistedAsync.when(
                  data: (isWatchlisted) => Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      IconButton(
                        icon: Icon(
                          isWatchlisted ? Icons.bookmark : Icons.bookmark_border,
                          color: isWatchlisted ? AppColors.primaryAccent : Colors.white,
                        ),
                        tooltip: isWatchlisted ? 'Remove from Watchlist' : 'Add to Watchlist',
                        onPressed: () {
                          final user = ref.read(authRepositoryProvider).currentUser;
                          if (user != null) {
                            ref.read(watchlistRepositoryProvider).toggleWatchlist(user.uid, item);
                          }
                        },
                      ),
                      if (isWatchlisted)
                        const Positioned(
                          right: 6,
                          bottom: 6,
                          child: Icon(Icons.cloud_done, size: 12, color: AppColors.primaryAccent),
                        ),
                    ],
                  ),
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
                // Favorite (Heart) Toggle
                isFavoriteAsync.when(
                  data: (isFav) => IconButton(
                    icon: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? Colors.red : Colors.white,
                    ),
                    onPressed: () => ref.read(favoritesRepositoryProvider).toggleFavorite(item),
                  ),
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (item.backdropPath != null || item.posterPath != null)
                      CachedNetworkImage(
                        imageUrl: item.backdropPath ?? item.posterPath!,
                        fit: BoxFit.cover,
                      ).animate().fadeIn(duration: 800.ms).scale(begin: const Offset(1.1, 1.1), end: const Offset(1.0, 1.0)),
                    // Dark Gradient Overlay for readability
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            AppColors.background,
                          ],
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
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            item.title.toUpperCase(),
                            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                  color: AppColors.primaryAccent,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.amber.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.amber.withOpacity(0.5)),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.star, color: Colors.amber, size: 18),
                                  const SizedBox(width: 4),
                                  Text(
                                    item.voteAverage.toStringAsFixed(1),
                                    style: const TextStyle(
                                      color: Colors.amber,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            averageRatingAsync.when(
                              data: (avg) => avg > 0
                                  ? Text(
                                      'COMMUNITY: ${avg.toStringAsFixed(1)}',
                                      style: const TextStyle(
                                        color: AppColors.primaryAccent,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1,
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                              loading: () => const SizedBox.shrink(),
                              error: (_, __) => const SizedBox.shrink(),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      item.overview,
                      style: const TextStyle(
                        color: Colors.white70,
                        height: 1.6,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 48),
                    
                    // Community Reviews Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'COMMUNITY REVIEWS',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) => ReviewSheet(mediaItem: item),
                            );
                          },
                          icon: const Icon(Icons.add, color: AppColors.primaryAccent),
                          label: const Text(
                            'WRITE ONE',
                            style: TextStyle(color: AppColors.primaryAccent),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Reviews List
                    reviewsAsync.when(
                      data: (reviews) {
                        if (reviews.isEmpty) {
                          return const Center(
                            child: Text(
                              'BE THE FIRST TO REVIEW THIS.',
                              style: TextStyle(color: Colors.white24, letterSpacing: 1),
                            ),
                          );
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: reviews.length,
                          itemBuilder: (context, index) => ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                              child: ReviewCard(review: reviews[index]),
                            ),
                          ),
                        );
                      },
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (err, stack) => Center(child: Text('Error: $err')),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
