import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../fraction_component/fraction_shape.dart';
import '../../models/interactive_piece.dart';
import 'division_selector.dart';

class QuestionViewPanel extends StatefulWidget {
  final ShapeType shapeType;
  final void Function(List<InteractivePiece>)? onPiecesGenerated;
  final String? image;

  const QuestionViewPanel({
    super.key,
    this.onPiecesGenerated,
    this.shapeType = ShapeType.circle,
    this.image,
  });

  @override
  State<QuestionViewPanel> createState() => _QuestionViewPanelState();
}

class _QuestionViewPanelState extends State<QuestionViewPanel> {
  int _totalPieces = 2;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.secondaryBackground,
        borderRadius: BorderRadius.circular(32),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            offset: Offset(0, 0),
            blurRadius: 4,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Column(
          children: [
            Expanded(
              child: FractionShape(
                key: ValueKey(widget.shapeType),
                type: widget.shapeType,
                totalPieces: _totalPieces,
                onPiecesGenerated: widget.onPiecesGenerated,
                image: widget.image,
              ),
            ),
            const SizedBox(height: 16),
            DivisionSelector(
              label: 'Stukjes',
              value: _totalPieces,
              onDecrement: _totalPieces > 2
                  ? () {
                      setState(() => _totalPieces--);
                    }
                  : null,
              onIncrement: () {
                setState(() => _totalPieces++);
              },
            ),
          ],
        ),
      ),
    );
  }
}
