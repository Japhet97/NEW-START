import 'package:flutter/material.dart';
import '../models/principle.dart';
import 'progress_screen.dart';

class QuizScreen extends StatefulWidget {
  final Principle principle;

  const QuizScreen({super.key, required this.principle});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  int? _selectedAnswerIndex;
  bool _isAnswered = false;

  void _answerQuestion(int selectedIndex) {
    if (_isAnswered) return;

    setState(() {
      _selectedAnswerIndex = selectedIndex;
      _isAnswered = true;
      if (selectedIndex == widget.principle.quizQuestions[_currentQuestionIndex].correctAnswerIndex) {
        _score++;
      }
    });

    // Wait for a short moment so the user can see the feedback (red/green colors)
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;

      if (_currentQuestionIndex < widget.principle.quizQuestions.length - 1) {
        setState(() {
          _currentQuestionIndex++;
          _selectedAnswerIndex = null;
          _isAnswered = false;
        });
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ProgressScreen(
              score: _score,
              total: widget.principle.quizQuestions.length,
              principleTitle: widget.principle.title,
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.principle.quizQuestions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('${widget.principle.title} Quiz'),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.quiz_outlined, size: 80, color: Colors.grey),
              const SizedBox(height: 16),
              const Text(
                'No quiz available for this principle yet.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    final question = widget.principle.quizQuestions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.principle.title} Quiz'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(
              value: (_currentQuestionIndex + 1) / widget.principle.quizQuestions.length,
              backgroundColor: Colors.green.withOpacity(0.1),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
            ),
            const SizedBox(height: 24),
            Text(
              'Question ${_currentQuestionIndex + 1}/${widget.principle.quizQuestions.length}',
              style: const TextStyle(fontSize: 18, color: Colors.grey, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              question.question,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            ...List.generate(question.options.length, (index) {
              Color cardColor = Colors.white;
              Color textColor = Colors.black87;
              BorderSide borderSide = const BorderSide(color: Colors.green, width: 1);

              if (_isAnswered) {
                final bool isCorrect = index == question.correctAnswerIndex;
                final bool isSelected = index == _selectedAnswerIndex;

                if (isCorrect) {
                  // Always highlight the correct answer in green
                  cardColor = Colors.green.shade100;
                  textColor = Colors.green.shade900;
                  borderSide = const BorderSide(color: Colors.green, width: 2);
                } else if (isSelected) {
                  // Highlight the selected WRONG answer in red
                  cardColor = Colors.red.shade100;
                  textColor = Colors.red.shade900;
                  borderSide = const BorderSide(color: Colors.red, width: 2);
                } else {
                  // Fade out other options
                  cardColor = Colors.grey.shade50;
                  textColor = Colors.grey;
                  borderSide = BorderSide(color: Colors.grey.shade300);
                }
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  child: ElevatedButton(
                    onPressed: () => _answerQuestion(index),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(18),
                      backgroundColor: cardColor,
                      foregroundColor: textColor,
                      elevation: _isAnswered && index == _selectedAnswerIndex ? 0 : 2,
                      side: borderSide,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          String.fromCharCode(65 + index), // A, B, C, D
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _isAnswered && index == question.correctAnswerIndex
                                ? Colors.green.shade900
                                : (_isAnswered && index == _selectedAnswerIndex ? Colors.red.shade900 : Colors.green),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Text(
                            question.options[index],
                            style: const TextStyle(fontSize: 17),
                          ),
                        ),
                        if (_isAnswered && index == question.correctAnswerIndex)
                          const Icon(Icons.check_circle, color: Colors.green),
                        if (_isAnswered && index == _selectedAnswerIndex && index != question.correctAnswerIndex)
                          const Icon(Icons.cancel, color: Colors.red),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
