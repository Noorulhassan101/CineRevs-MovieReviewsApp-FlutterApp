import 'dart:io';

void main() {
  final filesToFix = [
    'lib/shared/widgets/media_card.dart',
    'lib/shared/widgets/glass_container.dart',
    'lib/features/reviews/presentation/widgets/review_sheet.dart',
    'lib/features/reviews/presentation/widgets/review_card.dart',
    'lib/features/reviews/presentation/widgets/rating_selector.dart',
    'lib/features/reviews/presentation/widgets/comment_section.dart',
    'lib/features/reviews/presentation/global_feed_screen.dart',
    'lib/features/profile/presentation/public_profile_screen.dart',
    'lib/features/profile/presentation/profile_screen.dart',
    'lib/features/notifications/presentation/notifications_screen.dart',
    'lib/features/media_details/presentation/media_details_screen.dart',
    'lib/features/discovery/presentation/home_screen.dart',
    'lib/features/discovery/presentation/widgets/filter_bar.dart',
    'lib/features/discovery/presentation/widgets/recent_searches_view.dart',
    'lib/features/auth/presentation/signup_screen.dart',
    'lib/features/auth/presentation/login_screen.dart',
  ];

  int totalReplaced = 0;

  for (final path in filesToFix) {
    final file = File(path);
    if (!file.existsSync()) continue;
    
    String content = file.readAsStringSync();
    
    if (content.contains('Colors.white')) {
      if (!content.contains("import 'package:zenthra/shared/utils/adaptive_colors.dart';") && 
          !content.contains("import '../../../shared/utils/adaptive_colors.dart';") &&
          !content.contains("import '../../shared/utils/adaptive_colors.dart';")) {
        
        // Add import at the top
        content = "import 'package:zenthra/shared/utils/adaptive_colors.dart';\n" + content;
      }

      content = content.replaceAll('Colors.white70', 'context.adaptiveWhite70');
      content = content.replaceAll('Colors.white54', 'context.adaptiveWhite54');
      content = content.replaceAll('Colors.white24', 'context.adaptiveWhite24');
      content = content.replaceAll('Colors.white12', 'context.adaptiveWhite12');
      content = content.replaceAll('Colors.white10', 'context.adaptiveWhite10');
      content = content.replaceAll('Colors.white', 'context.adaptiveWhite');

      file.writeAsStringSync(content);
      totalReplaced++;
      print('Fixed \$path');
    }
  }
  
  print('Total files updated: \$totalReplaced');
}
