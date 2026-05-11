import 'package:zenthra/shared/utils/adaptive_colors.dart';
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
    final favoritesAsync = ref.watch(favoritesListProvider);
    final isFavorite = favoritesAsync.valueOrNull?.any((f) => f.mediaId == item.id) ?? false;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 450,
            pinned: true,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: Icon(Icons.chevron_left, color: context.adaptiveWhite),
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
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? AppColors.secondaryAccent : context.adaptiveWhite,
                ),
                onPressed: () {
                  final uid = ref.read(authRepositoryProvider).currentUser?.uid;
                  if (uid != null) {
                    ref.read(favoritesRepositoryProvider).toggleFavorite(uid, item);
                  }
                },
              ),
              IconButton(
                icon: Icon(Icons.playlist_add, color: context.adaptiveWhite),
                onPressed: () => _showCollectionPicker(context, ref),
              ),
              isWatchlistedAsync.when(
                data: (isWatch) => IconButton(
                  icon: Icon(
                    isWatch ? Icons.bookmark : Icons.bookmark_border,
                    color: isWatch ? AppColors.secondaryAccent : context.adaptiveWhite,
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
                            color: context.adaptiveWhite,
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
                    'Overview',
                    style: TextStyle(
                      color: AppColors.secondaryAccent,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    item.overview,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: context.adaptiveWhite70,
                      height: 1.6,
                      fontSize: 15,
                    ),
                  ).animate().fadeIn(delay: 400.ms),
                  
                  const SizedBox(height: 48),
                  
                  // Cast
                  const Text(
                    'Cast & Crew',
                    style: TextStyle(
                      color: AppColors.secondaryAccent,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
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
                        'Reviews',
                        style: TextStyle(
                          color: AppColors.secondaryAccent,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
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
                        child: Text('Write a Review', style: TextStyle(color: context.adaptiveWhite54, fontSize: 12)),
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

  void _showCollectionPicker(BuildContext context, WidgetRef ref) {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Consumer(
        builder: (context, ref, child) {
          final collectionsAsync = ref.watch(userCollectionsProvider);
          return Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select Collection',
                  style: TextStyle(color: AppColors.primaryAccent, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1),
                ),
                const SizedBox(height: 16),
                collectionsAsync.when(
                  data: (collections) {
                    if (collections.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text('No collections created yet. Go to your Profile to create one.', style: TextStyle(color: Colors.white24, fontSize: 12)),
                      );
                    }
                    return Flexible(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: collections.length,
                        itemBuilder: (context, index) {
                          final collection = collections[index];
                          return ListTile(
                            leading: const Icon(Icons.folder_outlined, color: AppColors.secondaryAccent),
                            title: Text(collection.title.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 14)),
                            onTap: () async {
                              await ref.read(collectionsRepositoryProvider).addItemToCollection(collection.id, item);
                              if (context.mounted) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('ADDED TO ${collection.title.toUpperCase()}')),
                                );
                              }
                            },
                          );
                        },
                      ),
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Text('Error: $e'),
                ),
              ],
            ),
          );
        },
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
                    style: TextStyle(color: context.adaptiveWhite54, fontSize: 8, fontWeight: FontWeight.bold),
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