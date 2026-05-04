import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/app_theme.dart';
import 'features/discovery/presentation/home_screen.dart';
import 'features/media_details/presentation/media_details_screen.dart';
import 'shared/models/media_item.dart';

void main() {
  runApp(
    const ProviderScope(
      child: CineVaultApp(),
    ),
  );
}

final _router = GoRouter(
  initialLocation: '/',
  routes: [
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

class CineVaultApp extends StatelessWidget {
  const CineVaultApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'CineVault',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: _router,
    );
  }
}
