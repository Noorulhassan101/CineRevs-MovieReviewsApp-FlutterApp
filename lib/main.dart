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
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:isar/isar.dart' as isar_lib;
import 'features/favorites/domain/favorite_item.dart';
import 'features/favorites/data/favorites_repository.dart';
import 'features/discovery/domain/discovery_item.dart';
import 'features/discovery/domain/recent_search.dart';
import 'core/network/isar_provider.dart';
import 'features/profile/presentation/public_profile_screen.dart';
import 'features/reviews/presentation/communities_screen.dart';
import 'features/reviews/presentation/create_community_screen.dart';
import 'features/reviews/presentation/community_details_screen.dart';
import 'features/reviews/domain/community_model.dart';
import 'features/collections/presentation/collection_details_screen.dart';
import 'features/collections/domain/collection_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final dir = await getApplicationDocumentsDirectory();
  // New Isar directory so schema (per-user favorites) does not clash with old DB files.
  final isarDir = Directory('${dir.path}${Platform.pathSeparator}zenthra_isar');
  if (!await isarDir.exists()) {
    await isarDir.create(recursive: true);
  }
  final isar = await isar_lib.Isar.open(
    [FavoriteItemSchema, DiscoveryItemSchema, RecentSearchSchema],
    directory: isarDir.path,
  );
  
  runApp(
    ProviderScope(
      overrides: [
        isarProvider.overrideWithValue(isar),
        favoritesRepositoryProvider.overrideWithValue(FavoritesRepository(isar)),
      ],
      child: const ZenthraApp(),
    ),
  );
}

final routerProvider = Provider<GoRouter>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  
  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final user = authRepo.currentUser;
      final isLoggingIn = state.matchedLocation == '/login' || state.matchedLocation == '/signup';
      
      if (user == null && !isLoggingIn) return '/login';
      if (user != null && isLoggingIn) return '/';
      return null;
    },
    // This is the key to instant logout: refresh the router when auth state changes
    refreshListenable: _AuthListenable(ref),
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
          GoRoute(
            path: 'profile/:userId',
            builder: (context, state) {
              final userId = state.pathParameters['userId']!;
              return PublicProfileScreen(userId: userId);
            },
          ),
          GoRoute(
            path: 'communities',
            builder: (context, state) => const CommunitiesScreen(),
          ),
          GoRoute(
            path: 'create-community',
            builder: (context, state) => const CreateCommunityScreen(),
          ),
          GoRoute(
            path: 'community/:id',
            builder: (context, state) {
              final community = state.extra as Community;
              return CommunityDetailsScreen(community: community);
            },
          ),
          GoRoute(
            path: 'collection/:id',
            builder: (context, state) {
              final collection = state.extra as Collection;
              return CollectionDetailsScreen(collection: collection);
            },
          ),
        ],
      ),
    ],
  );
});

class _AuthListenable extends ChangeNotifier {
  _AuthListenable(Ref ref) {
    _subscription = ref.listen(authStateChangesProvider, (_, __) {
      notifyListeners();
    });
  }

  late final ProviderSubscription _subscription;

  @override
  void dispose() {
    _subscription.close();
    super.dispose();
  }
}

class ZenthraApp extends ConsumerWidget {
  const ZenthraApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeControllerProvider);
    final theme = ref.watch(themeControllerProvider.notifier).currentTheme;
    final router = ref.watch(routerProvider);
    
    return MaterialApp.router(
      title: 'Zenthra',
      debugShowCheckedModeBanner: false,
      theme: theme,
      routerConfig: router,
    );
  }
}
