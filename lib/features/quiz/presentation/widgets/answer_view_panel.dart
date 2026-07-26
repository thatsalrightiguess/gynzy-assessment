import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'question_prompt_bubble.dart';
import '../../../../widgets/primary_button.dart';

class AnswerViewPanel extends StatelessWidget {
  final List<String> questionTexts;
  final bool hasPieces;
  final bool isSuccess;
  final VoidCallback? onCheckAnswer;
  final VoidCallback? onResetPieces;
  final int currentQuestionNumber;
  final int totalQuestions;

  const AnswerViewPanel({
    super.key,
    this.questionTexts = const [],
    this.hasPieces = false,
    this.isSuccess = false,
    this.onCheckAnswer,
    this.onResetPieces,
    this.currentQuestionNumber = 1,
    this.totalQuestions = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          if (questionTexts.isEmpty)
            const QuestionPromptBubble(text: 'Loading...'),
          for (int i = 0; i < 2; i++)
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                final offsetAnimation = Tween<Offset>(
                  begin: const Offset(0.0, 0.2), // start slightly below
                  end: Offset.zero,
                ).animate(animation);
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  ),
                );
              },
              child: i < questionTexts.length
                  ? QuestionPromptBubble(
                      key: ValueKey(questionTexts[i]),
                      text: questionTexts[i],
                      showProfilePicture: i == 0,
                    )
                  : SizedBox.shrink(key: ValueKey('empty_$i')),
            ),
          const Expanded(
            child: Center(
              child: Text(
                'Sleep je stukjes hierheen!',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 18),
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(left: 32.0, right: 32.0, bottom: 32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (hasPieces)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      PrimaryButton(
                        text: 'Leg alles terug',
                        color: AppColors.reset,
                        onPressed: onResetPieces ?? () {},
                      ),
                      PrimaryButton(
                        text: isSuccess ? 'Volgende vraag' : 'Check Answer',
                        color: isSuccess ? AppColors.correct : null,
                        onPressed: onCheckAnswer ?? () {},
                      ),
                    ],
                  ),
                if (hasPieces) const SizedBox(height: 16),
                Text(
                  'Vraag $currentQuestionNumber / $totalQuestions',
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          ),
        ],
      ),
    );
  }
}
