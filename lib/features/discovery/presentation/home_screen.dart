import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/network/debouncer.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/models/media_item.dart';
import '../../../shared/widgets/film_grain.dart';
import '../../../shared/widgets/media_card.dart';
import 'discovery_controller.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _debouncer = Debouncer(milliseconds: 500);

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final trendingMoviesAsync = ref.watch(trendingMoviesProvider);
    final popularAnimeAsync = ref.watch(popularAnimeProvider);
    final searchQuery = ref.watch(searchQueryProvider);

    return Scaffold(
      body: Stack(
        children: [
          // Background Film Grain (SVG or subtle overlay could go here)
          Positioned.fill(
            child: Container(
              color: AppColors.background,
            ),
          ),
          
          CustomScrollView(
            slivers: [
              // Atmospheric App Bar
              SliverAppBar(
                floating: true,
                expandedHeight: 120,
                backgroundColor: Colors.transparent,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text(
                    'CINEVAULT',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          letterSpacing: 4,
                          color: AppColors.primaryAccent,
                        ),
                  ),
                ),
              ),

              // Search Bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: TextField(
                    onChanged: (value) {
                      _debouncer.run(() {
                        ref.read(searchQueryProvider.notifier).update(value);
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search movies or anime...',
                      prefixIcon: const Icon(Icons.search, color: AppColors.primaryAccent),
                      filled: true,
                      fillColor: AppColors.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),

              if (searchQuery.isEmpty) ...[
                // Trending Movies Section
                SliverToBoxAdapter(
                  child: _MediaSection(
                    title: 'TRENDING MOVIES',
                    itemsAsync: trendingMoviesAsync,
                  ),
                ),

                // Popular Anime Section
                SliverToBoxAdapter(
                  child: _MediaSection(
                    title: 'POPULAR ANIME',
                    itemsAsync: popularAnimeAsync,
                  ),
                ),
              ] else ...[
                // Search Results Grid
                _SearchResultsGrid(),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _MediaSection extends StatelessWidget {
  final String title;
  final AsyncValue<List<MediaItem>> itemsAsync;

  const _MediaSection({required this.title, required this.itemsAsync});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        SizedBox(
          height: 220,
          child: itemsAsync.when(
            data: (items) => ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              itemBuilder: (context, index) => MediaCard(
                item: items[index],
                onTap: () {
                  context.go('/details', extra: items[index]);
                },
              ),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, s) => const Center(child: Text('Error loading data')),
          ),
        ),
      ],
    );
  }
}

class _SearchResultsGrid extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resultsAsync = ref.watch(searchResultsProvider);

    return resultsAsync.when(
      data: (items) => SliverPadding(
        padding: const EdgeInsets.all(16),
        sliver: SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) => MediaCard(
              item: items[index],
              onTap: () {
                context.go('/details', extra: items[index]);
              },
            ),
            childCount: items.length,
          ),
        ),
      ),
      loading: () => const SliverToBoxAdapter(
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, s) => const SliverToBoxAdapter(
        child: Center(child: Text('Error searching')),
      ),
    );
  }
}
