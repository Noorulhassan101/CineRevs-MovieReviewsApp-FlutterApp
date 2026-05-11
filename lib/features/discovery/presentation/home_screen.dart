import 'package:zenthra/shared/utils/adaptive_colors.dart';
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
import '../../reviews/presentation/communities_screen.dart';
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
    const CommunitiesScreen(),
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
          border: Border(top: BorderSide(color: context.adaptiveWhite.withOpacity(0.05))),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            backgroundColor: Colors.transparent,
            elevation: 0,
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.explore_outlined),
                activeIcon: Icon(Icons.explore),
                label: 'Discover',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.groups_outlined),
                activeIcon: Icon(Icons.groups),
                label: 'Communities',
              ),
              BottomNavigationBarItem(
                icon: unreadCountAsync.maybeWhen(
                  data: (count) => count > 0 
                    ? Badge(label: Text('$count'), child: const Icon(Icons.notifications_outlined))
                    : const Icon(Icons.notifications_outlined),
                  orElse: () => const Icon(Icons.notifications_outlined),
                ),
                activeIcon: const Icon(Icons.notifications),
                label: 'Notifications',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Profile',
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
                expandedHeight: 80,
                backgroundColor: Colors.transparent,
                actions: [
                  IconButton(
                    icon: Icon(Icons.palette_outlined, color: theme.colorScheme.primary),
                    onPressed: () => _showThemePicker(context),
                  ),
                  IconButton(
                    icon: Icon(Icons.logout_outlined, color: context.adaptiveWhite54),
                    onPressed: () => ref.read(authRepositoryProvider).signOut(),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: false,
                  titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
                  title: Text(
                    'Zenthra',
                    style: theme.textTheme.headlineSmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                          shadows: [
                            Shadow(
                              color: theme.colorScheme.primary.withOpacity(0.3),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                  ),
                ),
              ),
              
              // Genre Filters with Dropdown
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: _CategoryDropdown(selectedGenre: searchQuery),
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
                      style: TextStyle(color: context.adaptiveWhite),
                      decoration: InputDecoration(
                        hintText: 'Search movies, shows, or anime...',
                        hintStyle: TextStyle(color: context.adaptiveWhite24, fontSize: 14),
                        prefixIcon: Icon(Icons.search, color: theme.colorScheme.primary),
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
                          title: 'Recommended for You',
                          itemsAsync: AsyncValue.data(items),
                        ),
                      )
                    : const SliverToBoxAdapter(child: SizedBox.shrink()),
                  loading: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
                  error: (_, __) => const SliverToBoxAdapter(child: SizedBox.shrink()),
                ),
                SliverToBoxAdapter(
                  child: _MediaSection(
                    title: 'Trending Movies',
                    itemsAsync: trendingMoviesAsync,
                  ),
                ),
                SliverToBoxAdapter(
                  child: _MediaSection(
                    title: 'Popular Anime',
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
              Text('Select Theme', style: TextStyle(color: context.adaptiveWhite, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              _ThemeOption(title: 'Light Mode', mode: AppThemeMode.light, color: context.adaptiveWhite),
              _ThemeOption(title: 'Dark Mode', mode: AppThemeMode.midnight, color: AppColors.background),
              _ThemeOption(title: 'AMOLED Dark', mode: AppThemeMode.obsidian, color: Colors.black),
              _ThemeOption(title: 'Nebula', mode: AppThemeMode.nebula, color: AppColors.nebulaBackground),
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
          border: Border.all(color: isSelected ? theme.colorScheme.primary : context.adaptiveWhite24, width: 2),
        ),
      ),
      title: Text(title, style: TextStyle(color: isSelected ? theme.colorScheme.primary : context.adaptiveWhite70, fontWeight: FontWeight.bold, fontSize: 12)),
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
            style: TextStyle(color: context.adaptiveWhite),
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
      error: (e, s) => const SliverToBoxAdapter(child: Center(child: Text('Error finding results.'))),
    );
  }
}

class _CategoryDropdown extends ConsumerWidget {
  final String selectedGenre;

  const _CategoryDropdown({required this.selectedGenre});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeControllerProvider.notifier).currentTheme;
    final genres = ['All', 'Action', 'Comedy', 'Horror', 'Anime', 'Drama', 'Sci-Fi'];
    final displayValue = selectedGenre.isEmpty ? 'All' : selectedGenre[0].toUpperCase() + selectedGenre.substring(1);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8),
        color: theme.colorScheme.primary.withOpacity(0.05),
      ),
      child: DropdownButton<String>(
        value: displayValue,
        isExpanded: true,
        underline: const SizedBox(),
        items: genres.map((genre) {
          return DropdownMenuItem<String>(
            value: genre,
            child: Text(
              genre,
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            ref.read(searchQueryProvider.notifier).update(value == 'All' ? '' : value.toLowerCase());
          }
        },
        style: TextStyle(
          color: theme.colorScheme.primary,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
        dropdownColor: theme.scaffoldBackgroundColor,
        iconEnabledColor: theme.colorScheme.primary,
      ),
    );
  }
}