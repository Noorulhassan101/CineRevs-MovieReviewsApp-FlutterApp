import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/utils/adaptive_colors.dart';
import '../../../../shared/widgets/glass_container.dart';
import '../../domain/questionnaire_model.dart';
import '../../data/questionnaire_repository.dart';
import '../../../auth/data/auth_repository.dart';

class QuestionnaireSheet extends ConsumerStatefulWidget {
  final CommunityQuestionnaire questionnaire;
  final String communityId;
  final VoidCallback onCompleted;

  const QuestionnaireSheet({
    super.key,
    required this.questionnaire,
    required this.communityId,
    required this.onCompleted,
  });

  @override
  ConsumerState<QuestionnaireSheet> createState() => _QuestionnaireSheetState();
}

class _QuestionnaireSheetState extends ConsumerState<QuestionnaireSheet> {
  late Map<String, dynamic> _answers;
  bool _isSubmitting = false;
  String? _validationError;

  @override
  void initState() {
    super.initState();
    _answers = {};
    for (var question in widget.questionnaire.questions) {
      _answers[question.questionId] = 
          question.questionType == 'text' ? '' : null; // Empty string for text, null for multiChoice
    }
  }

  bool _validateAnswers() {
    for (var question in widget.questionnaire.questions) {
      final answer = _answers[question.questionId];
      if (question.questionType == 'text' && (answer == null || answer.toString().isEmpty)) {
        setState(() => _validationError = 'Please answer all questions');
        return false;
      } else if (question.questionType == 'multiChoice' && answer == null) {
        setState(() => _validationError = 'Please select an option for all questions');
        return false;
      }
    }
    setState(() => _validationError = null);
    return true;
  }

  Future<void> _submitQuestionnaire() async {
    if (!_validateAnswers()) return;

    setState(() => _isSubmitting = true);
    try {
      final userId = ref.read(authRepositoryProvider).currentUser?.uid;
      if (userId == null) return;

      await ref.read(questionnaireRepositoryProvider).submitQuestionnaireResponse(
        widget.communityId,
        userId,
        widget.questionnaire.id,
        _answers,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Questionnaire submitted! You can now join.')),
        );
        Navigator.pop(context);
        widget.onCompleted();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting questionnaire: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      borderRadius: 30,
      blur: 30,
      opacity: 0.1,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'MEMBERSHIP SCREENING',
              style: TextStyle(
                color: context.adaptiveWhite,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please answer the following questions to join this community',
              style: TextStyle(color: context.adaptiveWhite54, fontSize: 12),
            ),
            const SizedBox(height: 24),

            // Questions
            ...widget.questionnaire.questions.asMap().entries.map((entry) {
              final index = entry.key + 1;
              final question = entry.value;

              if (question.questionType == 'text') {
                return _TextQuestionField(
                  questionNumber: index,
                  question: question,
                  onChanged: (value) {
                    _answers[question.questionId] = value;
                  },
                );
              } else {
                // multiChoice
                return _MultiChoiceQuestionField(
                  questionNumber: index,
                  question: question,
                  selectedValue: _answers[question.questionId],
                  onChanged: (value) {
                    _answers[question.questionId] = value;
                  },
                );
              }
            }).toList(),

            const SizedBox(height: 24),

            // Validation error
            if (_validationError != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                ),
                child: Text(
                  _validationError!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitQuestionnaire,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryAccent,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  disabledBackgroundColor: AppColors.primaryAccent.withOpacity(0.5),
                ),
                child: _isSubmitting
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('SUBMIT', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TextQuestionField extends StatefulWidget {
  final int questionNumber;
  final QuestionItem question;
  final Function(String) onChanged;

  const _TextQuestionField({
    required this.questionNumber,
    required this.question,
    required this.onChanged,
  });

  @override
  State<_TextQuestionField> createState() => _TextQuestionFieldState();
}

class _TextQuestionFieldState extends State<_TextQuestionField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(() {
      widget.onChanged(_controller.text);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Q${widget.questionNumber}: ${widget.question.text}',
            style: TextStyle(color: context.adaptiveWhite, fontWeight: FontWeight.w500, fontSize: 12),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _controller,
            style: TextStyle(color: context.adaptiveWhite),
            minLines: 2,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Your answer...',
              hintStyle: TextStyle(color: context.adaptiveWhite24),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: context.adaptiveWhite12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: context.adaptiveWhite12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.primaryAccent),
              ),
              filled: true,
              fillColor: Colors.white.withOpacity(0.02),
              contentPadding: const EdgeInsets.all(12),
            ),
          ),
        ],
      ),
    );
  }
}

class _MultiChoiceQuestionField extends ConsumerWidget {
  final int questionNumber;
  final QuestionItem question;
  final String? selectedValue;
  final Function(String?) onChanged;

  const _MultiChoiceQuestionField({
    required this.questionNumber,
    required this.question,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Q${questionNumber}: ${question.text}',
            style: TextStyle(color: context.adaptiveWhite, fontWeight: FontWeight.w500, fontSize: 12),
          ),
          const SizedBox(height: 12),
          ...question.choices.map((choice) {
            final isSelected = selectedValue == choice;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: GestureDetector(
                onTap: () => onChanged(choice),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSelected ? AppColors.primaryAccent : context.adaptiveWhite12,
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    color: isSelected
                        ? AppColors.primaryAccent.withOpacity(0.1)
                        : Colors.white.withOpacity(0.02),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isSelected ? AppColors.primaryAccent : context.adaptiveWhite24,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: isSelected
                            ? Icon(Icons.check, size: 14, color: AppColors.primaryAccent)
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          choice,
                          style: TextStyle(
                            color: context.adaptiveWhite,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
