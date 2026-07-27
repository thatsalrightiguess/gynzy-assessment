import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../question_prompt_bubble.dart';
import '../../../../../widgets/primary_button.dart';

class AnswerViewPanel extends StatelessWidget {
  final List<String> questionTexts;
  final bool hasPieces;
  final bool isSuccess;
  final VoidCallback? onCheckAnswer;
  final VoidCallback? onResetPieces;
  final int currentQuestionNumber;
  final int totalQuestions;
  final String? pfImage;
  final GlobalKey? plateKey;

  const AnswerViewPanel({
    super.key,
    this.questionTexts = const [],
    this.hasPieces = false,
    this.isSuccess = false,
    this.onCheckAnswer,
    this.onResetPieces,
    this.currentQuestionNumber = 1,
    this.totalQuestions = 1,
    this.pfImage,
    this.plateKey,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppSizes.md),
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
                      pfImage: pfImage,
                    )
                  : SizedBox.shrink(key: ValueKey('empty_$i')),
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.md),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400, maxHeight: 400),
                  child: AspectRatio(
                    aspectRatio: 1.0,
                    child: Container(
                      key: plateKey,
                      decoration: const BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadow,
                            offset: Offset(0, 4),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'Sleep je stukjes hierheen!',
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(
                left: AppSizes.md,
                right: AppSizes.md,
                bottom: 0.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Visibility(
                    visible: hasPieces,
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            PrimaryButton(
                              text: 'Leg alles terug',
                              color: AppColors.reset,
                              onPressed: onResetPieces ?? () {},
                            ),
                            PrimaryButton(
                              text: isSuccess ? 'Volgende vraag' : 'Pizza geven',
                              color: isSuccess ? AppColors.correct : null,
                              onPressed: onCheckAnswer ?? () {},
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSizes.md),
                      ],
                    ),
                  ),
                  Text(
                    'Vraag $currentQuestionNumber / $totalQuestions',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
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
