import 'package:flutter_test/flutter_test.dart';
import 'package:zenthra/features/reviews/domain/review_model.dart';

void main() {
  group('Review Model Tests', () {
    test('Review model should include likes fields with default values', () {
      final review = Review(
        id: '1',
        userId: 'u1',
        userName: 'User 1',
        mediaId: 'm1',
        mediaType: 'movie',
        rating: 8.5,
        comment: 'Great!',
        createdAt: DateTime.now(),
      );

      expect(review.likesCount, 0);
      expect(review.likedBy, isEmpty);
    });

    test('Review model should correctly serialize/deserialize likes fields', () {
      final json = {
        'id': '1',
        'userId': 'u1',
        'userName': 'User 1',
        'mediaId': 'm1',
        'mediaType': 'movie',
        'rating': 8.5,
        'comment': 'Great!',
        'createdAt': '2023-01-01T00:00:00.000',
        'likesCount': 5,
        'likedBy': ['u2', 'u3'],
      };

      final review = Review.fromJson(json);

      expect(review.likesCount, 5);
      expect(review.likedBy, containsAll(['u2', 'u3']));
    });
  });
}
