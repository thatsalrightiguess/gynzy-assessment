import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/answer_view_panel.dart';
import '../widgets/question_view_panel.dart';
import '../widgets/fraction_shape.dart';
import '../models/interactive_piece.dart';
import 'dart:convert';
import 'dart:math';
import 'dart:async';
import 'package:flutter/services.dart';
import '../widgets/fraction_pieces/fraction_piece_circle.dart';
import '../widgets/fraction_pieces/fraction_piece_rectangle.dart';
import 'success_screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final List<InteractivePiece> pieces = [];
  final GlobalKey answerPanelKey = GlobalKey();
  List<String> currentQuestionTexts = [];
  String? currentAnswer;
  bool hasPiecesInAnswerView = false;
  bool isCurrentAnswerCorrect = false;
  bool isSuccess = false;

  List<dynamic> _allQuestions = [];
  int _currentQuestionIndex = 0;
  ShapeType _currentShapeType = ShapeType.circle;
  bool _showNextQuestionProgress = false;
  Timer? _successTimer;

  @override
  void initState() {
    super.initState();
    _loadQuestion();
  }

  Future<void> _loadQuestion() async {
    final String response = await rootBundle.loadString('lib/features/quiz/data/datasources/mock_questions.json');
    final data = json.decode(response) as List<dynamic>;
    if (data.isNotEmpty) {
      setState(() {
        _allQuestions = data;
        _loadCurrentQuestionData();
      });
    }
  }

  void _loadCurrentQuestionData() {
    if (_allQuestions.isEmpty) return;
    final currentQ = _allQuestions[_currentQuestionIndex % _allQuestions.length];
    
    setState(() {
      final desc = currentQ['description'];
      if (desc is List) {
        currentQuestionTexts = desc.map((e) => e.toString()).toList();
      } else {
        currentQuestionTexts = [desc.toString()];
      }
      currentAnswer = currentQ['answer'];
      
      if (currentQ['type'] == 'rectangle') {
        _currentShapeType = ShapeType.rectangle;
      } else {
        _currentShapeType = ShapeType.circle;
      }

      isSuccess = false;
      hasPiecesInAnswerView = false;
      isCurrentAnswerCorrect = false;
      _showNextQuestionProgress = false;
      _successTimer?.cancel();
      _successTimer = null;
      pieces.clear();
    });
  }

  void _handlePiecesGenerated(List<InteractivePiece> newPieces) {
    if (newPieces.isEmpty) return;
    final shapeType = newPieces.first.type;

    setState(() {
      final bool divisionChanged = pieces.any((p) {
        if (p.type != shapeType) return false;
        final sample = newPieces.first;
        if (shapeType == ShapeType.circle) {
          return p.totalPieces != sample.totalPieces;
        } else {
          return p.fractionSize != sample.fractionSize ||
              p.width != sample.width ||
              p.height != sample.height;
        }
      });

      if (divisionChanged) {
        // Reset all pieces of this shape type (including those in answer view) when division changes
        pieces.removeWhere((p) => p.type == shapeType);
      } else {
        pieces.removeWhere((p) => 
          p.type == shapeType && 
          p.position == p.initialPosition && 
          !newPieces.any((np) => np.id == p.id)
        );
      }
      
      for (final newPiece in newPieces) {
        final existingIndex = pieces.indexWhere((p) => p.id == newPiece.id);
        if (existingIndex >= 0) {
          final existingPiece = pieces[existingIndex];
          // If the piece hasn't been moved, update its position to the new initial position
          if (existingPiece.position == existingPiece.initialPosition) {
            existingPiece.position = newPiece.initialPosition;
          }
          existingPiece.initialPosition = newPiece.initialPosition;
        } else {
          pieces.add(newPiece);
        }
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final RenderBox? answerBox = answerPanelKey.currentContext?.findRenderObject() as RenderBox?;
      if (answerBox != null) {
        final Offset answerPosition = answerBox.localToGlobal(Offset.zero);
        final Size answerSize = answerBox.size;
        _calculateAndLogAnswer(answerPosition & answerSize);
      }
    });
  }

  void _handlePanEnd(InteractivePiece piece) {
    final RenderBox? answerBox = answerPanelKey.currentContext?.findRenderObject() as RenderBox?;
    if (answerBox != null) {
      final Offset answerPosition = answerBox.localToGlobal(Offset.zero);
      final Size answerSize = answerBox.size;
      final Rect answerRect = answerPosition & answerSize;

      // Approximate the center of the piece
      final double centerX = piece.position.dx + (piece.width ?? piece.radius! * 2) / 2;
      final double centerY = piece.position.dy + (piece.height ?? piece.radius! * 2) / 2;

      if (!answerRect.contains(Offset(centerX, centerY))) {
        setState(() {
          piece.position = piece.initialPosition;
        });
      }

      _calculateAndLogAnswer(answerRect);
    }
  }

  void _calculateAndLogAnswer(Rect answerRect) {
    final Map<String, int> counts = {};

    for (final p in pieces) {
      final double pCenterX = p.position.dx + (p.width ?? p.radius! * 2) / 2;
      final double pCenterY = p.position.dy + (p.height ?? p.radius! * 2) / 2;
      
      if (answerRect.contains(Offset(pCenterX, pCenterY))) {
        final key = '${p.type.name}_${p.fractionSize}';
        counts[key] = (counts[key] ?? 0) + 1;
      }
    }

    if (counts.isEmpty) {
      setState(() {
        hasPiecesInAnswerView = false;
        isCurrentAnswerCorrect = false;
      });
      return;
    }

    bool correct = false;
    if (currentAnswer != null) {
      final parts = currentAnswer!.split('/');
      if (parts.length == 2) {
        final numerator = int.tryParse(parts[0]) ?? 0;
        final denominator = int.tryParse(parts[1]) ?? 0;

        if (counts.length == 1) {
           final entry = counts.entries.first;
           final entryParts = entry.key.split('_');
           final pieceDenom = int.tryParse(entryParts[1]) ?? 0;
           if (pieceDenom == denominator && entry.value == numerator) {
              correct = true;
           }
        }
      }
    }

    setState(() {
      hasPiecesInAnswerView = true;
      isCurrentAnswerCorrect = correct;
    });
  }

  void _onCheckAnswer() {
    if (isSuccess) {
      _successTimer?.cancel();
      _successTimer = null;
      _goToNextQuestion();
      return;
    }

    if (isCurrentAnswerCorrect && !isSuccess) {
      setState(() {
        isSuccess = true;
        _showNextQuestionProgress = true;
        currentQuestionTexts = List.from(currentQuestionTexts);
        if (currentQuestionTexts.length >= 2) {
          currentQuestionTexts.removeLast();
        }
        currentQuestionTexts.add('Ja perfect! Dankjewel!');
      });

      _successTimer = Timer(const Duration(seconds: 5), () {
        if (!mounted) return;
        _goToNextQuestion();
      });
    } else if (!isSuccess) {
      final random = Random();
      final wrongMessages = ['Bijna! Probeer het nog eens!', 'Net niet! Kijk nog eens goed.'];
      final message = wrongMessages[random.nextInt(wrongMessages.length)];
      setState(() {
        currentQuestionTexts = List.from(currentQuestionTexts);
        if (currentQuestionTexts.length >= 2) {
          currentQuestionTexts.removeLast();
        }
        currentQuestionTexts.add(message);
      });
    }
  }

  void _goToNextQuestion() {
    if (_currentQuestionIndex + 1 >= _allQuestions.length) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const SuccessScreen()),
      );
    } else {
      setState(() {
        _currentQuestionIndex++;
        _loadCurrentQuestionData();
      });
    }
  }

  void _onResetPieces() {
    setState(() {
      for (final piece in pieces) {
        piece.position = piece.initialPosition;
      }
      hasPiecesInAnswerView = false;
      isCurrentAnswerCorrect = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.answerBackground,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Row(
            textDirection: TextDirection.rtl,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: AnswerViewPanel(
                  key: answerPanelKey,
                  questionTexts: currentQuestionTexts,
                  hasPieces: hasPiecesInAnswerView,
                  isSuccess: isSuccess,
                  onCheckAnswer: _onCheckAnswer,
                  onResetPieces: _onResetPieces,
                  currentQuestionNumber: _currentQuestionIndex + 1,
                  totalQuestions: _allQuestions.length,
                ),
              ),
              Expanded(
                child: QuestionViewPanel(
                  shapeType: _currentShapeType,
                  onPiecesGenerated: _handlePiecesGenerated,
                ),
              ),
            ],
          ),
          ...pieces.map((piece) {
            Widget childWidget;
            if (piece.type == ShapeType.circle) {
              childWidget = FractionPieceCircle(
                radius: piece.radius!,
                index: piece.index!,
                totalPieces: piece.totalPieces!,
                color: piece.color,
                onPanUpdate: (delta) {
                  setState(() {
                    piece.position += delta;
                  });
                },
                onPanEnd: () => _handlePanEnd(piece),
              );
            } else {
              childWidget = FractionPieceRectangle(
                width: piece.width!,
                height: piece.height!,
                color: piece.color,
                fractionSize: piece.fractionSize,
                onPanUpdate: (delta) {
                  setState(() {
                    piece.position += delta;
                  });
                },
                onPanEnd: () => _handlePanEnd(piece),
              );
            }

            return Positioned(
              left: piece.position.dx,
              top: piece.position.dy,
              child: childWidget,
            );
          }),
          if (_showNextQuestionProgress)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.0, end: 1.0),
                duration: const Duration(seconds: 5),
                builder: (context, value, child) {
                  return LinearProgressIndicator(
                    value: value,
                    minHeight: 8,
                    backgroundColor: AppColors.border,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.correct),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
