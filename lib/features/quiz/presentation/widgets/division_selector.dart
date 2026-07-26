import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class DivisionSelector extends StatelessWidget {
  final int value;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;
  final String label;

  const DivisionSelector({
    super.key,
    required this.value,
    this.onIncrement,
    this.onDecrement,
    this.label = '',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppColors.border, width: 2),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            offset: Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          if (label.isNotEmpty) ...[
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
            const Spacer(),
          ],
          IconButton(
            onPressed: onDecrement,
            icon: const Icon(Icons.remove_circle_outline),
            iconSize: 36,
          ),
          const Spacer(),
          Text(
            value.toString(),
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          IconButton(
            onPressed: onIncrement,
            icon: const Icon(Icons.add_circle_outline),
            iconSize: 36,
          ),
        ],
      ),
    );
  }
}
