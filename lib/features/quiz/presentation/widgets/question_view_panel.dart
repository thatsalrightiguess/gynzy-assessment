import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'fraction_shape.dart';
import '../models/interactive_piece.dart';

class QuestionViewPanel extends StatelessWidget {
  final void Function(List<InteractivePiece>)? onPiecesGenerated;
  final ShapeType shapeType;

  const QuestionViewPanel({
    super.key, 
    this.onPiecesGenerated,
    this.shapeType = ShapeType.circle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.questionBackground,
        borderRadius: BorderRadius.circular(32),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            offset: Offset(4, 0),
            blurRadius: 8,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FractionShape(
          key: ValueKey(shapeType),
          type: shapeType, 
          totalPieces: shapeType == ShapeType.circle ? 8 : 1,
          rows: shapeType == ShapeType.rectangle ? 2 : 1,
          columns: shapeType == ShapeType.rectangle ? 3 : 1,
          onPiecesGenerated: onPiecesGenerated,
        ),
      ),
    );
  }
}
