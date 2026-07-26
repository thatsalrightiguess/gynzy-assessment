import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class QuestionPromptBubble extends StatelessWidget {
  final String text;
  final bool showProfilePicture;

  const QuestionPromptBubble({
    super.key,
    required this.text,
    this.showProfilePicture = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile photo placeholder
          showProfilePicture
              ? Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: const Icon(
                    Icons.person,
                    color: AppColors.textSecondary,
                    size: 40,
                  ),
                )
              : const SizedBox(width: 80),
          const SizedBox(width: 24),
          // Chat bubble
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                  topRight: const Radius.circular(20),
                  bottomRight: const Radius.circular(20),
                  bottomLeft: const Radius.circular(20),
                  topLeft: Radius.circular(showProfilePicture ? 4 : 20), // Gives it a chat-bubble tail look if it's the first message
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 18,
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                  color: AppColors.text,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
