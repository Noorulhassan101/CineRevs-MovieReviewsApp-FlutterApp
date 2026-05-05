import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/network/debouncer.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/models/media_item.dart';
import '../../../shared/widgets/film_grain.dart';
import '../../../shared/widgets/media_card.dart';
import '../../auth/data/auth_repository.dart';
import '../domain/recent_search.dart';
import 'discovery_controller.dart';
import '../../../core/theme/theme_controller.dart';
import '../../reviews/presentation/global_feed_screen.dart';
import '../../profile/presentation/profile_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const _DiscoveryView(),
    const GlobalFeedScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.movie_filter_outlined),
            activeIcon: Icon(Icons.movie_filter),
            label: 'DISCOVER',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.public_outlined),
            activeIcon: Icon(Icons.public),
            label: 'COMMUNITY',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'VAULT',
          ),
        ],
      ),
    );
  }
}

class _DiscoveryView extends ConsumerStatefulWidget {
  const _DiscoveryView();

  @override
  ConsumerState<_DiscoveryView> createState() => _DiscoveryViewState();
}

class _DiscoveryViewState extends ConsumerState<_DiscoveryView> {
  final _debouncer = Debouncer(milliseconds: 300);

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
                actions: [
                  IconButton(
                    icon: const Icon(Icons.palette, color: AppColors.primaryAccent),
                    onPressed: () => _showThemePicker(context),
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout, color: Colors.white54),
                    onPressed: () => ref.read(authRepositoryProvider).signOut(),
                  ),
                ],
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
              
              // Genre Chips
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 50,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      'ALL',
                      'ACTION',
                      'COMEDY',
                      'HORROR',
                      'ANIME',
                      'DRAMA',
                      'SCI-FI',
                    ].map((genre) {
                      final isSelected = (genre == 'ALL' && searchQuery.isEmpty) || 
                                         searchQuery.toUpperCase() == genre;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(genre),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              ref.read(searchQueryProvider.notifier).update(genre == 'ALL' ? '' : genre.toLowerCase());
                            }
                          },
                          backgroundColor: AppColors.surface,
                          selectedColor: AppColors.primaryAccent,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.black : Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }).toList(),
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

  void _showThemePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('CHOOSE YOUR ATMOSPHERE', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 24),
            _ThemeOption(
              title: 'MIDNIGHT',
              subtitle: 'Deep Teal & Amber (Classic)',
              mode: AppThemeMode.midnight,
              color: AppColors.background,
            ),
            _ThemeOption(
              title: 'OBSIDIAN',
              subtitle: 'Pure Black & Cyan (High Contrast)',
              mode: AppThemeMode.obsidian,
              color: Colors.black,
            ),
            _ThemeOption(
              title: 'NEBULA',
              subtitle: 'Space Purple & Pink (Vibrant)',
              mode: AppThemeMode.nebula,
              color: const Color(0xFF1A0B2E),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeOption extends ConsumerWidget {
  final String title;
  final String subtitle;
  final AppThemeMode mode;
  final Color color;

  const _ThemeOption({
    required this.title,
    required this.subtitle,
    required this.mode,
    required this.color,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentMode = ref.watch(themeControllerProvider);
    final isSelected = currentMode == mode;

    return ListTile(
      onTap: () {
        ref.read(themeControllerProvider.notifier).setTheme(mode);
        Navigator.pop(context);
      },
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: isSelected ? AppColors.primaryAccent : Colors.white24, width: 2),
        ),
      ),
      title: Text(title, style: TextStyle(color: isSelected ? AppColors.primaryAccent : Colors.white, fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      trailing: isSelected ? const Icon(Icons.check_circle, color: AppColors.primaryAccent) : null,
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

    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 900 ? 4 : (screenWidth > 600 ? 3 : 2);

    return resultsAsync.when(
      data: (items) => SliverPadding(
        padding: const EdgeInsets.all(16),
        sliver: SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
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
