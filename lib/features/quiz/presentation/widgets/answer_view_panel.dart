import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'question_prompt_bubble.dart';
import '../../../../widgets/primary_button.dart';

class AnswerViewPanel extends StatelessWidget {
  final List<String> questionTexts;
  final bool hasPieces;
  final bool isSuccess;
  final VoidCallback? onCheckAnswer;

  const AnswerViewPanel({
    super.key,
    this.questionTexts = const [],
    this.hasPieces = false,
    this.isSuccess = false,
    this.onCheckAnswer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.answerBackground,
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
                style: TextStyle(color: Colors.grey, fontSize: 18),
              ),
            ),
          ),
          if (hasPieces)
            Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: PrimaryButton(
                text: isSuccess ? 'Volgende vraag' : 'Check Answer',
                color: isSuccess ? Colors.green : null,
                onPressed: onCheckAnswer ?? () {},
              ),
            ),
        ],
      ),
    );
  }
}
