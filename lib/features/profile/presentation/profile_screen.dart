import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Repositories
import '../../auth/data/auth_repository.dart';
import '../../favorites/data/favorites_repository.dart';
import '../../reviews/data/reviews_repository.dart';
import '../../watchlist/data/watchlist_repository.dart';

// Widgets
import '../../reviews/presentation/widgets/review_card.dart';
import '../../../shared/widgets/media_card.dart';

// THIS IS THE LINE YOU NEED TO ADD:
import 'package:cinevault/features/favorites/domain/favorite_mapper.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authRepositoryProvider).currentUser;
    final favoritesAsync = ref.watch(favoritesListProvider);
    final userReviewsAsync = ref.watch(userReviewsProvider);
    final watchlistAsync = ref.watch(userWatchlistProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('MY VAULT'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authRepositoryProvider).signOut(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── User Header ──────────────────────────────────────────
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                  child: Text(
                    user?.email?.substring(0, 1).toUpperCase() ?? 'U',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.email ?? 'Unknown User',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const Text(
                        'Premium Member',
                        style: TextStyle(color: Colors.white54, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ── Stats Row ────────────────────────────────────────────
            Row(
              children: [
                _StatChip(
                  icon: Icons.favorite,
                  label: 'Favorites',
                  countAsync: favoritesAsync.whenData((f) => f.length),
                ),
                const SizedBox(width: 12),
                _StatChip(
                  icon: Icons.bookmark,
                  label: 'Watchlist',
                  countAsync: watchlistAsync.whenData((w) => w.length),
                ),
                const SizedBox(width: 12),
                _StatChip(
                  icon: Icons.rate_review,
                  label: 'Reviews',
                  countAsync: userReviewsAsync.whenData((r) => r.length),
                ),
              ],
            ),
            const SizedBox(height: 48),

            // ── Favorites Section ────────────────────────────────────
            const _SectionHeader(title: 'MY FAVORITES', icon: Icons.favorite),
            const SizedBox(height: 16),
            favoritesAsync.when(
              data: (favorites) {
                if (favorites.isEmpty) {
                  return const _EmptyMessage(text: 'NO FAVORITES YET.');
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
                  itemCount: favorites.length,
                  itemBuilder: (context, index) {
                    final fav = favorites[index];
                    return MediaCard(
                      item: fav.toMediaItem(),
                      onTap: () => context.go('/details', extra: fav.toMediaItem()),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => Center(child: Text('Error: $e')),
            ),
            const SizedBox(height: 48),

            // ── Watchlist Section ────────────────────────────────────
            const _SectionHeader(title: 'MY WATCHLIST', icon: Icons.bookmark),
            const SizedBox(height: 16),
            watchlistAsync.when(
              data: (items) {
                if (items.isEmpty) {
                  return const _EmptyMessage(text: 'YOUR WATCHLIST IS EMPTY.');
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
                      onTap: () => context.go('/details', extra: item.toMediaItem()),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => Center(child: Text('Error: $e')),
            ),
            const SizedBox(height: 48),

            // ── My Reviews Section ───────────────────────────────────
            const _SectionHeader(title: 'MY REVIEWS', icon: Icons.rate_review),
            const SizedBox(height: 16),
            userReviewsAsync.when(
              data: (reviews) {
                if (reviews.isEmpty) {
                  return const _EmptyMessage(text: 'YOU HAVEN\'T REVIEWED ANYTHING YET.');
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: reviews.length,
                  itemBuilder: (context, index) => ReviewCard(review: reviews[index]),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => Center(child: Text('Error: $e')),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}

// ── Reusable Sub-widgets ─────────────────────────────────────────────────

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
        child: Text(text, style: const TextStyle(color: Colors.white24, letterSpacing: 1)),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final AsyncValue<int> countAsync;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.countAsync,
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
            countAsync.when(
              data: (count) => Text(
                '$count',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              loading: () => const SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              error: (_, __) => const Text('–'),
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 10, color: Colors.white54),
            ),
          ],
        ),
      ),
    );
  }
}
