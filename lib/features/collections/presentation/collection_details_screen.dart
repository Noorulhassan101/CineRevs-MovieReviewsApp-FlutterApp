import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/models/media_item.dart';
import '../../../shared/utils/adaptive_colors.dart';
import '../../../shared/widgets/glass_container.dart';
import '../../../shared/widgets/media_card.dart';
import '../../auth/data/auth_repository.dart';
import '../data/collections_repository.dart';
import '../domain/collection_model.dart';

class CollectionDetailsScreen extends ConsumerWidget {
  final Collection collection;
  const CollectionDetailsScreen({super.key, required this.collection});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authRepositoryProvider).currentUser;
    final isOwner = user?.uid == collection.userId;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                collection.title.toUpperCase(),
                style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2, fontSize: 16),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.primaryAccent.withOpacity(0.3),
                      AppColors.background,
                    ],
                  ),
                ),
                child: Center(
                  child: Opacity(
                    opacity: 0.1,
                    child: Icon(Icons.collections, size: 100, color: Colors.white),
                  ),
                ),
              ),
            ),
            actions: [
              if (isOwner)
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // TODO: Navigate to edit collection screen
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Edit functionality coming soon')),
                    );
                  },
                ),
            ],
          ),

          // Collection Info
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Creator Info
                  Row(
                    children: [
                      Icon(Icons.person, color: context.adaptiveWhite54, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'BY ${collection.userName.toUpperCase()}',
                          style: TextStyle(color: context.adaptiveWhite54, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Description
                  if (collection.description != null && collection.description!.isNotEmpty) ...[
                    const Text(
                      'DESCRIPTION',
                      style: TextStyle(color: AppColors.secondaryAccent, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      collection.description!,
                      style: TextStyle(color: context.adaptiveWhite70, height: 1.5),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Stats Row
                  Row(
                    children: [
                      _StatItem(label: 'ITEMS', value: collection.items.length.toString()),
                      const SizedBox(width: 48),
                      _StatItem(label: 'LIKES', value: collection.likesCount.toString()),
                      const SizedBox(width: 48),
                      _StatItem(label: 'ACCESS', value: collection.isPublic ? 'PUBLIC' : 'PRIVATE'),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Action Buttons
                  Row(
                    children: [
                      // Like Button
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // TODO: Implement like functionality
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Like functionality coming soon')),
                            );
                          },
                          icon: const Icon(Icons.favorite_outline),
                          label: const Text('LIKE'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white10,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Share Button
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // TODO: Implement share functionality
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Share functionality coming soon')),
                            );
                          },
                          icon: const Icon(Icons.share),
                          label: const Text('SHARE'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryAccent,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Items Header
                  const Text(
                    'COLLECTION_ITEMS',
                    style: TextStyle(color: AppColors.secondaryAccent, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2),
                  ),
                ],
              ),
            ),
          ),

          // Items Grid
          if (collection.items.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Text(
                  'NO ITEMS IN THIS COLLECTION YET.',
                  style: TextStyle(color: context.adaptiveWhite24, fontSize: 10),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final item = collection.items[index];
                    return Stack(
                      children: [
                        MediaCard(
                          item: item,
                          onTap: () => context.go('/details', extra: item),
                        ),
                        // Quick actions for items
                        if (isOwner)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GlassContainer(
                              borderRadius: 20,
                              opacity: 0.8,
                              child: PopupMenuButton(
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    child: const Text('Remove from Collection'),
                                    onTap: () {
                                      // TODO: Implement remove functionality
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Remove functionality coming soon')),
                                      );
                                    },
                                  ),
                                ],
                                child: const Icon(Icons.more_vert, size: 16),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                  childCount: collection.items.length,
                ),
              ),
            ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.secondaryAccent, fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 1.5),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(color: context.adaptiveWhite, fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
