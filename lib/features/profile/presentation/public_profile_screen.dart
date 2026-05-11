import 'package:zenthra/shared/utils/adaptive_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/data/auth_repository.dart';
import '../../reviews/data/reviews_repository.dart';
import '../../watchlist/data/watchlist_repository.dart';
import '../../reviews/presentation/widgets/review_card.dart';
import '../../../shared/widgets/media_card.dart';
import '../data/social_repository.dart';
import '../../notifications/data/notifications_repository.dart';

class PublicProfileScreen extends ConsumerWidget {
  final String userId;

  const PublicProfileScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserId = ref.watch(authRepositoryProvider).currentUser?.uid;
    final userReviewsAsync = ref.watch(reviewsRepositoryProvider).getReviewsByUser(userId);
    final watchlistAsync = ref.watch(watchlistRepositoryProvider).watchWatchlist(userId);
    final isFollowingAsync = ref.watch(isFollowingProvider(userId));
    final followersCountAsync = ref.watch(followersCountProvider(userId));
    final followingCountAsync = ref.watch(followingCountProvider(userId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('VAULT EXPLORER'),
      ),
      body: StreamBuilder(
        stream: userReviewsAsync,
        builder: (context, reviewsSnapshot) {
          final reviews = reviewsSnapshot.data ?? [];
          final userName = reviews.isNotEmpty ? reviews.first.userName : 'Unknown User';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── User Header ──────────────────────────────────────────
                ref.watch(userProfileProvider(userId)).when(
                  data: (profile) => Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                        backgroundImage: profile?.photoUrl != null ? NetworkImage(profile!.photoUrl!) : null,
                        child: profile?.photoUrl == null
                            ? Text(
                                (profile?.displayName ?? userName).substring(0, 1).toUpperCase(),
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profile?.displayName ?? userName,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            Text(
                              profile?.bio ?? 'Zenthra Member',
                              style: TextStyle(color: context.adaptiveWhite54, fontSize: 12),
                            ),
                          if (currentUserId != null && currentUserId != userId)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: isFollowingAsync.when(
                                data: (isFollowing) => OutlinedButton(
                                  onPressed: () async {
                                    if (isFollowing) {
                                      ref.read(socialRepositoryProvider).unfollowUser(currentUserId, userId);
                                    } else {
                                      final profile = await ref.read(socialRepositoryProvider).watchProfile(currentUserId).first;
                                      final userName = profile?.displayName ?? 'Unknown';
                                      
                                      ref.read(socialRepositoryProvider).followUser(
                                        currentUserId: currentUserId,
                                        currentUserName: userName,
                                        targetUserId: userId,
                                        notificationsRepo: ref.read(notificationsRepositoryProvider),
                                      );
                                    }
                                  },
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: isFollowing ? context.adaptiveWhite54 : Theme.of(context).colorScheme.primary,
                                    side: BorderSide(color: isFollowing ? context.adaptiveWhite24 : Theme.of(context).colorScheme.primary),
                                    visualDensity: VisualDensity.compact,
                                  ),
                                  child: Text(isFollowing ? 'UNFOLLOW' : 'FOLLOW'),
                                ),
                                loading: () => const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                                error: (_, __) => const SizedBox.shrink(),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, __) => const SizedBox.shrink(),
              ),
                const SizedBox(height: 16),

                // ── Stats Row ────────────────────────────────────────────
                StreamBuilder(
                  stream: watchlistAsync,
                  builder: (context, watchlistSnapshot) {
                    final watchlistCount = watchlistSnapshot.data?.length ?? 0;
                    return Row(
                      children: [
                        _StatChip(
                          icon: Icons.bookmark,
                          label: 'Watchlist',
                          count: watchlistCount,
                        ),
                        const SizedBox(width: 12),
                        _StatChip(
                          icon: Icons.rate_review,
                          label: 'Reviews',
                          count: reviews.length,
                        ),
                        const SizedBox(width: 12),
                        followersCountAsync.when(
                          data: (count) => _StatChip(
                            icon: Icons.people,
                            label: 'Followers',
                            count: count,
                          ),
                          loading: () => const _StatChip(icon: Icons.people, label: 'Followers', count: 0),
                          error: (_, __) => const _StatChip(icon: Icons.people, label: 'Followers', count: 0),
                        ),
                      ],
                    );
                  }
                ),
                const SizedBox(height: 48),

                // ── Watchlist Section ────────────────────────────────────
                const _SectionHeader(title: 'THEIR WATCHLIST', icon: Icons.bookmark),
                const SizedBox(height: 16),
                StreamBuilder(
                  stream: watchlistAsync,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final items = snapshot.data ?? [];
                    if (items.isEmpty) {
                      return const _EmptyMessage(text: 'THIS VAULT IS CURRENTLY EMPTY.');
                    }
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                      ),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return MediaCard(
                          item: item.toMediaItem(),
                          onTap: () {}, // For now, simple view
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 48),

                // ── Reviews Section ───────────────────────────────────
                const _SectionHeader(title: 'THEIR REVIEWS', icon: Icons.rate_review),
                const SizedBox(height: 16),
                if (reviews.isEmpty)
                  const _EmptyMessage(text: 'NO REVIEWS POSTED YET.')
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: reviews.length,
                    itemBuilder: (context, index) => ReviewCard(review: reviews[index]),
                  ),
                const SizedBox(height: 100),
              ],
            ),
          );
        }
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }
}

class _EmptyMessage extends StatelessWidget {
  final String text;
  const _EmptyMessage({required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Text(text, style: TextStyle(color: context.adaptiveWhite24, letterSpacing: 1)),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 4),
            Text(
              '$count',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Text(
              label,
              style: TextStyle(fontSize: 10, color: context.adaptiveWhite54),
            ),
          ],
        ),
      ),
    );
  }
}
