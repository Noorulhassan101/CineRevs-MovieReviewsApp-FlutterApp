import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'features/discovery/presentation/home_screen.dart';
import 'features/media_details/presentation/media_details_screen.dart';
import 'shared/models/media_item.dart';
import 'features/auth/presentation/login_screen.dart';
import 'features/auth/presentation/signup_screen.dart';
import 'features/auth/data/auth_repository.dart';
import 'package:path_provider/path_provider.dart';
import 'package:isar/isar.dart';
import 'features/favorites/domain/favorite_item.dart';
import 'features/favorites/data/favorites_repository.dart';
import 'features/discovery/domain/discovery_item.dart';
import 'features/discovery/domain/recent_search.dart';
import 'core/network/isar_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [FavoriteItemSchema, DiscoveryItemSchema, RecentSearchSchema],
    directory: dir.path,
  );
  
  runApp(
    ProviderScope(
      overrides: [
        isarProvider.overrideWithValue(isar),
        favoritesRepositoryProvider.overrideWithValue(FavoritesRepository(isar)),
      ],
      child: const CineVaultApp(),
    ),
  );
}

final _router = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final container = ProviderScope.containerOf(context);
    final user = container.read(authRepositoryProvider).currentUser;
    final isLoggingIn = state.matchedLocation == '/login' || state.matchedLocation == '/signup';
    
    if (user == null && !isLoggingIn) return '/login';
    if (user != null && isLoggingIn) return '/';
    return null;
  },
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
      routes: [
        GoRoute(
          path: 'details',
          builder: (context, state) {
            final item = state.extra as MediaItem;
            return MediaDetailsScreen(item: item);
          },
        ),
      ],
    ),
  ],
);

class CineVaultApp extends ConsumerWidget {
  const CineVaultApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeControllerProvider.notifier).currentTheme;
    return MaterialApp.router(
      title: 'CineVault',
      debugShowCheckedModeBanner: false,
      theme: theme,
      routerConfig: _router,
    );
  }
}
