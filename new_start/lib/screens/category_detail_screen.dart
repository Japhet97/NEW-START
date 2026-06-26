import 'package:flutter/material.dart';
import '../models/principle.dart';
import 'quiz_screen.dart';

class CategoryDetailScreen extends StatefulWidget {
  final Principle principle;

  const CategoryDetailScreen({super.key, required this.principle});

  @override
  State<CategoryDetailScreen> createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          // Content
          Column(
            children: [
              // Hero Image Header
              Stack(
                children: [
                  Hero(
                    tag: widget.principle.title,
                    child: SizedBox(
                      height: 300,
                      width: double.infinity,
                      child: Image.asset(
                        widget.principle.heroImagePath,
                        fit: BoxFit.cover,
                        color: Colors.black.withOpacity(0.1),
                        colorBlendMode: BlendMode.darken,
                      ),
                    ),
                  ),
                  Container(
                    height: 300,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.5),
                          Colors.black.withOpacity(0.1),
                          Colors.black.withOpacity(0.5),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 40,
                    left: 10,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    child: Text(
                      widget.principle.title,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [Shadow(color: Colors.black, blurRadius: 10)],
                      ),
                    ),
                  ),
                ],
              ),

              // Page Indicator (if multiple lessons)
              if (widget.principle.lessons.length > 1)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      widget.principle.lessons.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentPage == index ? Colors.green : Colors.grey[300],
                        ),
                      ),
                    ),
                  ),
                ),

              // Lessons PageView
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: widget.principle.lessons.length,
                  itemBuilder: (context, index) {
                    final lesson = widget.principle.lessons[index];
                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lesson.title,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            lesson.content,
                            style: TextStyle(
                              fontSize: 18,
                              height: 1.6,
                              color: isDark ? Colors.white70 : Colors.black87,
                            ),
                          ),
                          if (lesson.benefits != null && lesson.benefits!.isNotEmpty) ...[
                            const SizedBox(height: 24),
                            Text(
                              'Benefits',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              lesson.benefits!,
                              style: TextStyle(
                                fontSize: 16,
                                height: 1.4,
                                color: isDark ? Colors.white70 : Colors.black54,
                              ),
                            ),
                          ],
                          if (lesson.tips != null && lesson.tips!.isNotEmpty) ...[
                            const SizedBox(height: 24),
                            Text(
                              'Healthy Tips',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              lesson.tips!,
                              style: TextStyle(
                                fontSize: 16,
                                height: 1.4,
                                color: isDark ? Colors.white70 : Colors.black54,
                              ),
                            ),
                          ],
                          if (lesson.bibleVerse != null && lesson.bibleVerse!.isNotEmpty) ...[
                            const SizedBox(height: 24),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isDark ? Colors.green.withOpacity(0.1) : Colors.green.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.green.withOpacity(0.2)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Row(
                                    children: [
                                      Icon(Icons.menu_book, color: Colors.green, size: 20),
                                      SizedBox(width: 8),
                                      Text(
                                        'Spiritual Insight',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    lesson.bibleVerse!,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontStyle: FontStyle.italic,
                                      color: isDark ? Colors.white70 : Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          const SizedBox(height: 100), // Space for button
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          // Quiz Button (Floating at bottom)
          Positioned(
            bottom: 24,
            left: 24,
            right: 24,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizScreen(principle: widget.principle),
                  ),
                );
              },
              icon: const Icon(Icons.quiz),
              label: const Text('Take Short Quiz'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
