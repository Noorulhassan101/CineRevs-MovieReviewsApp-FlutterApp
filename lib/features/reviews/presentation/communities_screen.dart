import 'package:zenthra/shared/utils/adaptive_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../data/community_repository.dart';
import '../domain/community_model.dart';
import 'create_community_screen.dart';
import 'community_details_screen.dart';

class CommunitiesScreen extends ConsumerWidget {
  const CommunitiesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Communities'),
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: AppColors.primaryAccent,
            labelColor: AppColors.primaryAccent,
            unselectedLabelColor: context.adaptiveWhite24,
            tabs: const [
              Tab(text: 'My Groups'),
              Tab(text: 'Discover'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _UserCommunitiesList(),
            _DiscoverCommunitiesList(),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => context.go('/create-community'),
          icon: const Icon(Icons.add),
          label: const Text('Create'),
          backgroundColor: AppColors.primaryAccent,
          foregroundColor: Colors.black,
        ),
      ),
    );
  }
}

class _UserCommunitiesList extends ConsumerWidget {
  const _UserCommunitiesList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final communitiesAsync = ref.watch(userCommunitiesProvider);

    return communitiesAsync.when(
      data: (communities) {
        if (communities.isEmpty) {
          return const _EmptyState(
            message: 'You haven\'t joined any communities yet.',
            icon: Icons.group_off_outlined,
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: communities.length,
          itemBuilder: (context, index) => _CommunityTile(community: communities[index]),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}

class _DiscoverCommunitiesList extends ConsumerWidget {
  const _DiscoverCommunitiesList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final communitiesAsync = ref.watch(allCommunitiesProvider);

    return communitiesAsync.when(
      data: (communities) {
        if (communities.isEmpty) {
          return const _EmptyState(
            message: 'No communities found.',
            icon: Icons.search_off_outlined,
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: communities.length,
          itemBuilder: (context, index) => _CommunityTile(community: communities[index], isDiscovery: true),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}

class _CommunityTile extends ConsumerWidget {
  final Community community;
  final bool isDiscovery;

  const _CommunityTile({required this.community, this.isDiscovery = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.adaptiveWhite.withOpacity(0.05)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: AppColors.primaryAccent.withOpacity(0.1),
          child: Text(
            community.name.substring(0, 1).toUpperCase(),
            style: const TextStyle(color: AppColors.primaryAccent, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          community.name,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              community.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: context.adaptiveWhite54, fontSize: 12),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.people_outline, size: 14, color: AppColors.secondaryAccent),
                const SizedBox(width: 4),
                Text(
                  '${community.membersCount} Members',
                  style: const TextStyle(color: AppColors.secondaryAccent, fontSize: 10, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    community.category.toUpperCase(),
                    style: const TextStyle(color: Colors.white60, fontSize: 8, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
        onTap: () {
          context.go('/community/${community.id}', extra: community);
        },
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String message;
  final IconData icon;

  const _EmptyState({required this.message, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: context.adaptiveWhite12),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: context.adaptiveWhite24, fontSize: 12, letterSpacing: 1),
          ),
        ],
      ),
    );
  }
}
