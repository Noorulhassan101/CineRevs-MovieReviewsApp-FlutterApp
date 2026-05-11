import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/questionnaire_model.dart';
import '../domain/questionnaire_response_model.dart';

part 'questionnaire_repository.g.dart';

class QuestionnaireRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get community's questionnaire (if exists)
  Future<CommunityQuestionnaire?> getCommunityQuestionnaire(String communityId) async {
    final doc = await _firestore
        .collection('communities')
        .doc(communityId)
        .collection('questionnaires')
        .doc('active') // Convention: use 'active' as doc ID
        .get();
    
    if (!doc.exists) return null;
    final data = doc.data()!;
    if (data['createdAt'] is Timestamp) {
      data['createdAt'] = (data['createdAt'] as Timestamp).toDate();
    }
    if (data['updatedAt'] is Timestamp) {
      data['updatedAt'] = (data['updatedAt'] as Timestamp).toDate();
    }
    return CommunityQuestionnaire.fromJson(data);
  }

  /// Create or update community questionnaire
  Future<void> updateCommunityQuestionnaire(
    String communityId,
    String ownerId,
    List<dynamic> questions, // List of question data from form
  ) async {
    final questionItems = (questions as List)
        .map((q) => {
          'questionId': q['questionId'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
          'text': q['text'],
          'questionType': q['questionType'], // 'text' or 'multiChoice'
          'choices': q['choices'] ?? [],
        })
        .toList();

    await _firestore
        .collection('communities')
        .doc(communityId)
        .collection('questionnaires')
        .doc('active')
        .set({
          'id': 'active',
          'communityId': communityId,
          'ownerId': ownerId,
          'questions': questionItems,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
  }

  /// Submit questionnaire response (auto-approve)
  Future<void> submitQuestionnaireResponse(
    String communityId,
    String userId,
    String questionnaireId,
    Map<String, dynamic> answers,
  ) async {
    final responseId = '${communityId}_${userId}_${DateTime.now().millisecondsSinceEpoch}';
    
    await _firestore
        .collection('questionnaire_responses')
        .doc(responseId)
        .set({
          'id': responseId,
          'communityId': communityId,
          'userId': userId,
          'questionnaireId': questionnaireId,
          'answers': answers,
          'status': 'approved', // Auto-approve per requirements
          'createdAt': FieldValue.serverTimestamp(),
          'responseAt': FieldValue.serverTimestamp(),
        });
  }

  /// Check if user has already completed questionnaire
  Future<QuestionnaireResponse?> getUserResponse(String communityId, String userId) async {
    final query = await _firestore
        .collection('questionnaire_responses')
        .where('communityId', isEqualTo: communityId)
        .where('userId', isEqualTo: userId)
        .orderBy('responseAt', descending: true)
        .limit(1)
        .get();

    if (query.docs.isEmpty) return null;
    final data = query.docs.first.data();
    if (data['createdAt'] is Timestamp) {
      data['createdAt'] = (data['createdAt'] as Timestamp).toDate();
    }
    if (data['responseAt'] is Timestamp) {
      data['responseAt'] = (data['responseAt'] as Timestamp).toDate();
    }
    return QuestionnaireResponse.fromJson(data);
  }

  /// Get all responses for a questionnaire (admin view)
  Stream<List<QuestionnaireResponse>> watchCommunityResponses(String communityId) {
    return _firestore
        .collection('questionnaire_responses')
        .where('communityId', isEqualTo: communityId)
        .orderBy('responseAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            if (data['createdAt'] is Timestamp) {
              data['createdAt'] = (data['createdAt'] as Timestamp).toDate();
            }
            if (data['responseAt'] is Timestamp) {
              data['responseAt'] = (data['responseAt'] as Timestamp).toDate();
            }
            return QuestionnaireResponse.fromJson(data);
          }).toList();
        });
  }
}

@riverpod
QuestionnaireRepository questionnaireRepository(QuestionnaireRepositoryRef ref) {
  return QuestionnaireRepository();
}
