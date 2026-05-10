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
import '../../notifications/presentation/notifications_screen.dart';
import '../../notifications/data/notifications_repository.dart';
import 'widgets/filter_bar.dart';
import 'widgets/recent_searches_view.dart';
import '../../../shared/widgets/glass_container.dart';

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
    const NotificationsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final unreadCountAsync = ref.watch(unreadNotificationsCountProvider);
    final theme = ref.watch(themeControllerProvider.notifier).currentTheme;

    return Theme(
      data: theme,
      child: Scaffold(
        body: _screens[_currentIndex],
        bottomNavigationBar: GlassContainer(
          borderRadius: 0,
          blur: 20,
          opacity: 0.1,
          border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05))),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            backgroundColor: Colors.transparent,
            elevation: 0,
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.explore_outlined),
                activeIcon: Icon(Icons.explore),
                label: 'DISCOVER',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.stream_outlined),
                activeIcon: Icon(Icons.stream),
                label: 'FEED',
              ),
              BottomNavigationBarItem(
                icon: unreadCountAsync.maybeWhen(
                  data: (count) => count > 0 
                    ? Badge(label: Text('$count'), child: const Icon(Icons.notifications_outlined))
                    : const Icon(Icons.notifications_outlined),
                  orElse: () => const Icon(Icons.notifications_outlined),
                ),
                activeIcon: const Icon(Icons.notifications),
                label: 'ALERTS',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.shield_outlined),
                activeIcon: Icon(Icons.shield),
                label: 'VAULT',
              ),
            ],
          ),
        ),
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
    final theme = ref.watch(themeControllerProvider.notifier).currentTheme;
    final themeMode = ref.watch(themeControllerProvider);
    
    final trendingMoviesAsync = ref.watch(trendingMoviesProvider);
    final popularAnimeAsync = ref.watch(popularAnimeProvider);
    final forYouAsync = ref.watch(forYouRecommendationsProvider);
    final searchQuery = ref.watch(searchQueryProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Dynamic Background Gradient
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.scaffoldBackgroundColor,
                  theme.colorScheme.surface.withOpacity(0.8),
                ],
              ),
            ),
          ),
          
          CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                expandedHeight: 140,
                backgroundColor: Colors.transparent,
                actions: [
                  IconButton(
                    icon: Icon(Icons.style, color: theme.colorScheme.primary),
                    onPressed: () => _showThemePicker(context),
                  ),
                  IconButton(
                    icon: const Icon(Icons.power_settings_new, color: Colors.white54),
                    onPressed: () => ref.read(authRepositoryProvider).signOut(),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text(
                    'ZENTHRA',
                    style: theme.textTheme.displayMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          shadows: [
                            Shadow(
                              color: theme.colorScheme.primary.withOpacity(0.5),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                  ),
                ),
              ),
              
              // Genre Filters with Futuristic Design
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 60,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      'ALL', 'ACTION', 'COMEDY', 'HORROR', 'ANIME', 'DRAMA', 'SCI-FI',
                    ].map((genre) {
                      final isSelected = (genre == 'ALL' && searchQuery.isEmpty) || 
                                         searchQuery.toUpperCase() == genre;
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: FilterChip(
                          label: Text(genre),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              ref.read(searchQueryProvider.notifier).update(genre == 'ALL' ? '' : genre.toLowerCase());
                            }
                          },
                          backgroundColor: Colors.transparent,
                          selectedColor: theme.colorScheme.primary.withOpacity(0.2),
                          side: BorderSide(
                            color: isSelected ? theme.colorScheme.primary : Colors.white12,
                          ),
                          labelStyle: TextStyle(
                            color: isSelected ? theme.colorScheme.primary : Colors.white60,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: FilterBar(),
                ),
              ),

              // Search Bar with Glow
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GlassContainer(
                    borderRadius: 30,
                    opacity: 0.05,
                    child: TextField(
                      onChanged: (value) {
                        _debouncer.run(() {
                          ref.read(searchQueryProvider.notifier).update(value);
                        });
                      },
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'SCANNING FOR MEDIA...',
                        hintStyle: const TextStyle(color: Colors.white24, fontSize: 12),
                        prefixIcon: Icon(Icons.radar, color: theme.colorScheme.primary),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      ),
                    ),
                  ),
                ),
              ),

              if (searchQuery.isEmpty)
                const SliverToBoxAdapter(
                  child: RecentSearchesView(),
                ),

              if (searchQuery.isEmpty && !ref.watch(discoveryFilterProvider).isApplied) ...[
                forYouAsync.when(
                  data: (items) => items.isNotEmpty 
                    ? SliverToBoxAdapter(
                        child: _MediaSection(
                          title: 'FOR YOU',
                          itemsAsync: AsyncValue.data(items),
                        ),
                      )
                    : const SliverToBoxAdapter(child: SizedBox.shrink()),
                  loading: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
                  error: (_, __) => const SliverToBoxAdapter(child: SizedBox.shrink()),
                ),
                SliverToBoxAdapter(
                  child: _MediaSection(
                    title: 'TRENDING MOVIES',
                    itemsAsync: trendingMoviesAsync,
                  ),
                ),
                SliverToBoxAdapter(
                  child: _MediaSection(
                    title: 'POPULAR ANIME',
                    itemsAsync: popularAnimeAsync,
                  ),
                ),
              ] else ...[
                _SearchResultsGrid(),
              ],
              
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ],
      ),
    );
  }

  void _showThemePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => GlassContainer(
        borderRadius: 30,
        blur: 30,
        opacity: 0.1,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('SELECT ATMOSPHERE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 2)),
              const SizedBox(height: 24),
              _ThemeOption(title: 'ZENITH', mode: AppThemeMode.light, color: Colors.white),
              _ThemeOption(title: 'MIDNIGHT', mode: AppThemeMode.midnight, color: AppColors.background),
              _ThemeOption(title: 'OBSIDIAN', mode: AppThemeMode.obsidian, color: Colors.black),
              _ThemeOption(title: 'NEBULA', mode: AppThemeMode.nebula, color: AppColors.nebulaBackground),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThemeOption extends ConsumerWidget {
  final String title;
  final AppThemeMode mode;
  final Color color;

  const _ThemeOption({required this.title, required this.mode, required this.color});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentMode = ref.watch(themeControllerProvider);
    final isSelected = currentMode == mode;
    final theme = ref.watch(themeControllerProvider.notifier).currentTheme;

    return ListTile(
      onTap: () {
        ref.read(themeControllerProvider.notifier).setTheme(mode);
        Navigator.pop(context);
      },
      leading: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: isSelected ? theme.colorScheme.primary : Colors.white24, width: 2),
        ),
      ),
      title: Text(title, style: TextStyle(color: isSelected ? theme.colorScheme.primary : Colors.white70, fontWeight: FontWeight.bold, fontSize: 12)),
      trailing: isSelected ? Icon(Icons.check_circle, color: theme.colorScheme.primary, size: 20) : null,
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
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
          child: Text(
            title,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 2),
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
                onTap: () => context.go('/details', extra: items[index]),
              ),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, s) => const SizedBox.shrink(),
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
              onTap: () => context.go('/details', extra: items[index]),
            ),
            childCount: items.length,
          ),
        ),
      ),
      loading: () => const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator())),
      error: (e, s) => const SliverToBoxAdapter(child: Center(child: Text('ERROR SCANNING'))),
    );
  }
}
