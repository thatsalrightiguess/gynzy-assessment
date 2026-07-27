import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_sizes.dart';

class QuestionPromptBubble extends StatelessWidget {
  final String text;
  final bool showProfilePicture;
  final String? pfImage;

  const QuestionPromptBubble({
    super.key,
    required this.text,
    this.showProfilePicture = true,
    this.pfImage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        right: AppSizes.sm,
        top: AppSizes.sm,
        bottom: AppSizes.sm,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile photo placeholder
          showProfilePicture
              ? Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.border, width: 2.0),
                    image: DecorationImage(
                      image: AssetImage('lib/assets/images/pfs/${pfImage ?? 'pf_1'}.png'),
                      fit: BoxFit.cover,
                    ),
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
                  topLeft: Radius.circular(
                    showProfilePicture ? 4 : 20,
                  ), // Gives it a chat-bubble tail look if it's the first message
                ),
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
