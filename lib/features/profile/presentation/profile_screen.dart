import 'package:zenthra/shared/utils/adaptive_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Repositories
import '../../auth/data/auth_repository.dart';
import '../../favorites/data/favorites_repository.dart';
import '../../reviews/data/reviews_repository.dart';
import '../../watchlist/data/watchlist_repository.dart';
import '../../collections/data/collections_repository.dart';
import '../../collections/domain/collection_model.dart';
import '../data/social_repository.dart';
import 'edit_profile_screen.dart';

// Widgets
import '../../reviews/presentation/widgets/review_card.dart';
import '../../../shared/widgets/media_card.dart';
import '../../../core/theme/app_colors.dart';

// THIS IS THE LINE YOU NEED TO ADD:
import 'package:zenthra/features/favorites/domain/favorite_mapper.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authRepositoryProvider).currentUser;
    final profileAsync = ref.watch(currentUserProfileProvider);
    final favoritesAsync = ref.watch(favoritesListProvider);
    final userReviewsAsync = ref.watch(userReviewsProvider);
    final watchlistAsync = ref.watch(userWatchlistProvider);
    final collectionsAsync = ref.watch(userCollectionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
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
            profileAsync.when(
              data: (profile) => Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                    backgroundImage: profile?.photoUrl != null ? NetworkImage(profile!.photoUrl!) : null,
                    child: profile?.photoUrl == null
                        ? Text(
                            (profile?.displayName ?? user?.email ?? 'U').substring(0, 1).toUpperCase(),
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
                          profile?.displayName ?? user?.email ?? 'Unknown User',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        if (profile?.bio != null && profile!.bio!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              profile.bio!,
                              style: TextStyle(color: context.adaptiveWhite70, fontSize: 13),
                            ),
                          ),
                        TextButton.icon(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => EditProfileScreen(initialProfile: profile)),
                          ),
                          icon: const Icon(Icons.edit, size: 14),
                          label: const Text('Edit Profile', style: TextStyle(fontSize: 12)),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(0, 30),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
                const SizedBox(width: 12),
                profileAsync.when(
                  data: (p) => _StatChip(
                    icon: Icons.people,
                    label: 'Followers',
                    countAsync: AsyncValue.data(p?.followersCount ?? 0),
                  ),
                  loading: () => const _StatChip(icon: Icons.people, label: 'Followers', countAsync: AsyncValue.loading()),
                  error: (_, __) => const _StatChip(icon: Icons.people, label: 'Followers', countAsync: AsyncValue.data(0)),
                ),
              ],
            ),
            const SizedBox(height: 48),

            // ── Collections Section ──────────────────────────────────
            _SectionHeader(
              title: 'Collections',
              icon: Icons.collections_bookmark,
              onAction: () => _showCreateCollectionDialog(context, ref),
              actionLabel: 'New',
            ),
            const SizedBox(height: 16),
            collectionsAsync.when(
              data: (collections) {
                if (collections.isEmpty) {
                  return const _EmptyMessage(text: 'No collections yet.');
                }
                return SizedBox(
                  height: 140,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: collections.length,
                    itemBuilder: (context, index) {
                      final col = collections[index];
                      return _CollectionCard(collection: col);
                    },
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => Center(child: Text('Error: $e')),
            ),
            const SizedBox(height: 48),

            // ── Favorites Section ────────────────────────────────────
            const _SectionHeader(title: 'Favorites', icon: Icons.favorite),
            const SizedBox(height: 16),
            favoritesAsync.when(
              data: (favorites) {
                if (favorites.isEmpty) {
                  return const _EmptyMessage(text: 'No favorites yet.');
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
            const _SectionHeader(title: 'Watchlist', icon: Icons.bookmark),
            const SizedBox(height: 16),
            watchlistAsync.when(
              data: (items) {
                if (items.isEmpty) {
                  return const _EmptyMessage(text: 'Your watchlist is empty.');
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
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  void _showCreateCollectionDialog(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('New Collection', style: TextStyle(letterSpacing: 1)),
        content: TextField(
          controller: titleController,
          decoration: const InputDecoration(hintText: 'Collection Title (e.g. Top Action)'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              final title = titleController.text.trim();
              if (title.isNotEmpty) {
                final user = ref.read(authRepositoryProvider).currentUser;
                if (user != null) {
                  final profile = await ref.read(socialRepositoryProvider).watchProfile(user.uid).first;
                  final collection = Collection(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    userId: user.uid,
                    userName: profile?.displayName ?? user.email ?? 'Unknown',
                    title: title,
                    createdAt: DateTime.now(),
                  );
                  await ref.read(collectionsRepositoryProvider).createCollection(collection);
                  if (context.mounted) Navigator.pop(context);
                }
              }
            },
            child: const Text('Create', style: TextStyle(color: AppColors.primaryAccent)),
          ),
        ],
      ),
    );
  }
}

class _CollectionCard extends StatelessWidget {
  final Collection collection;
  const _CollectionCard({required this.collection});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.go('/collection/${collection.id}', extra: collection);
      },
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.adaptiveWhite10),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: collection.items.isEmpty
                  ? Center(child: Icon(Icons.collections, color: context.adaptiveWhite12))
                  : Stack(
                      children: [
                        Positioned.fill(
                          child: collection.items.first.posterPath != null 
                            ? Image.network(collection.items.first.posterPath!, fit: BoxFit.cover)
                            : Center(child: Icon(Icons.movie, color: context.adaptiveWhite24)),
                        ),
                        Container(color: Colors.black45),
                        Center(
                          child: Text(
                            '${collection.items.length}\nItems',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                collection.title.toUpperCase(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onAction;
  final String? actionLabel;

  const _SectionHeader({
    required this.title,
    required this.icon,
    this.onAction,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
        if (onAction != null)
          TextButton(
            onPressed: onAction,
            child: Text(
              actionLabel ?? 'See All',
              style: const TextStyle(fontSize: 14, color: AppColors.primaryAccent),
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
              style: TextStyle(color: context.adaptiveWhite70, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}