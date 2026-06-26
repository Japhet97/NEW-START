class Principle {
  final int? id;
  final String title;
  final String heroImagePath;
  final List<Lesson> lessons;
  final List<QuizQuestion> quizQuestions;

  Principle({
    this.id,
    required this.title,
    required this.heroImagePath,
    required this.lessons,
    required this.quizQuestions,
  });

  // This is used for the static description on the card
  String get staticDescription {
    switch (title.toLowerCase()) {
      case 'nutrition': return 'Fuel your body right.';
      case 'exercise': return 'Get moving daily.';
      case 'water': return 'Hydrate for health.';
      case 'sunlight': return 'Absorb natural light.';
      case 'temperance': return 'Balance in all things.';
      case 'air': return 'Breathe fresh air.';
      case 'rest': return 'Recover and recharge.';
      case 'trust': return 'Trust in Divine Power.';
      default: return 'Healthy Living';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': title,
      'lessons': lessons.map((l) => l.toJson()).toList(),
      'quizzes': quizQuestions.map((q) => q.toJson()).toList(),
    };
  }

  factory Principle.fromJson(Map<String, dynamic> json) {
    int? parsedId;
    if (json['id'] != null) {
      parsedId = int.tryParse(json['id'].toString());
    }

    final String apiName = json['name']?.toString() ?? 'Unknown';

    List<Lesson> lessonList = [];
    if (json['lessons'] != null && json['lessons'] is List) {
      for (var l in (json['lessons'] as List)) {
        if (l is Map<String, dynamic>) {
          lessonList.add(Lesson.fromJson(l));
        }
      }
    }

    List<QuizQuestion> questions = [];
    if (json['quizzes'] != null && json['quizzes'] is List) {
      for (var q in (json['quizzes'] as List)) {
        if (q is Map<String, dynamic>) {
          questions.add(QuizQuestion.fromJson(q));
        }
      }
    }

    return Principle(
      id: parsedId,
      title: apiName,
      heroImagePath: _getHeroImagePath(apiName),
      lessons: lessonList,
      quizQuestions: questions,
    );
  }

  static String _getHeroImagePath(String name) {
    switch (name.toLowerCase()) {
      case 'nutrition': return 'lib/Hero_pictures/Nutrition.jpg';
      case 'exercise': return 'lib/Hero_pictures/wal_172619-runner-7876675_1920.jpg';
      case 'water': return 'lib/Hero_pictures/Water.jpg';
      case 'sunlight': return 'lib/Hero_pictures/Sunlight.jpg';
      case 'temperance': return 'lib/Hero_pictures/Temperance.jpg';
      case 'air': return 'lib/Hero_pictures/Air.jpg';
      case 'rest': return 'lib/Hero_pictures/rest.jpg';
      case 'trust': return 'lib/Hero_pictures/Trust.jpg';
      default: return 'lib/Hero_pictures/default.jpg';
    }
  }
}

class Lesson {
  final String title;
  final String content;
  final String? benefits;
  final String? tips;
  final String? bibleVerse;

  Lesson({
    required this.title,
    required this.content,
    this.benefits,
    this.tips,
    this.bibleVerse,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'benefits': benefits,
      'tips': tips,
      'bible_verse': bibleVerse,
    };
  }

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      title: json['title']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      benefits: json['benefits']?.toString(),
      tips: json['tips']?.toString(),
      bibleVerse: json['bible_verse']?.toString(),
    );
  }
}

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctAnswerIndex;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
  });

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'options': options.asMap().entries.map((e) => {
        'option_label': String.fromCharCode(65 + e.key),
        'option_text': e.value
      }).toList(),
      'correct_answer': String.fromCharCode(65 + correctAnswerIndex),
    };
  }

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    List<String> optionTexts = [];
    int correctIdx = 0;

    if (json['options'] != null && json['options'] is List) {
      final optionsList = json['options'] as List;
      for (var o in optionsList) {
        if (o is Map<String, dynamic>) {
          optionTexts.add(o['option_text']?.toString() ?? '');
        }
      }

      String correctLabel = json['correct_answer']?.toString() ?? 'A';
      for (int i = 0; i < optionsList.length; i++) {
        if (optionsList[i] is Map<String, dynamic> &&
            optionsList[i]['option_label']?.toString() == correctLabel) {
          correctIdx = i;
          break;
        }
      }
    }

    return QuizQuestion(
      question: json['question']?.toString() ?? '',
      options: optionTexts,
      correctAnswerIndex: correctIdx,
    );
  }
}
