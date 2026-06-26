import '../models/principle.dart';

final List<Principle> principlesData = [
  Principle(
    title: 'Nutrition',
    heroImagePath: 'lib/Hero_pictures/Nutrition.jpg',
    lessons: [
      Lesson(
        title: 'Fuel your body right.',
        content: 'Proper nutrition is the foundation of good health. Focus on whole, plant-based foods, including fruits, vegetables, grains, and nuts. Avoid processed foods and excessive sugar.',
      ),
    ],
    quizQuestions: [
      QuizQuestion(
        question: 'Which of these is a whole food?',
        options: ['White bread', 'Apple', 'Potato chips', 'Soda'],
        correctAnswerIndex: 1,
      ),
    ],
  ),
  Principle(
    title: 'Exercise',
    heroImagePath: 'lib/Hero_pictures/wal_172619-runner-7876675_1920.jpg',
    lessons: [
      Lesson(
        title: 'Get moving daily.',
        content: 'Regular physical activity strengthens the heart, improves mood, and boosts energy levels. Aim for at least 30 minutes of moderate exercise most days of the week.',
      ),
    ],
    quizQuestions: [
      QuizQuestion(
        question: 'How many minutes of exercise is recommended daily?',
        options: ['5 minutes', '15 minutes', '30 minutes', '2 hours'],
        correctAnswerIndex: 2,
      ),
    ],
  ),
  Principle(
    title: 'Water',
    heroImagePath: 'lib/Hero_pictures/Water.jpg',
    lessons: [
      Lesson(
        title: 'Hydrate for health.',
        content: 'Water is essential for every cell in your body. It helps with digestion, circulation, and temperature regulation. Drink 8-10 glasses a day.',
      ),
    ],
    quizQuestions: [
      QuizQuestion(
        question: 'How many glasses of water should you drink daily?',
        options: ['1-2', '3-5', '8-10', '20+'],
        correctAnswerIndex: 2,
      ),
    ],
  ),
  Principle(
    title: 'Sunlight',
    heroImagePath: 'lib/Hero_pictures/Sunlight.jpg',
    lessons: [
      Lesson(
        title: 'Absorb natural light.',
        content: 'Sunlight is a natural source of Vitamin D, which is crucial for bone health and immune function. Spend some time outdoors every day.',
      ),
    ],
    quizQuestions: [
      QuizQuestion(
        question: 'Which vitamin does the body produce from sunlight?',
        options: ['Vitamin A', 'Vitamin B', 'Vitamin C', 'Vitamin D'],
        correctAnswerIndex: 3,
      ),
    ],
  ),
  Principle(
    title: 'Temperance',
    heroImagePath: 'lib/Hero_pictures/Temperance.jpg',
    lessons: [
      Lesson(
        title: 'Balance in all things.',
        content: 'Temperance means moderation in good things and abstinence from harmful ones. It applies to diet, work, and entertainment.',
      ),
    ],
    quizQuestions: [
      QuizQuestion(
        question: 'What does temperance mean?',
        options: ['Eating only sweets', 'Moderation and balance', 'Working all night', 'No sleep'],
        correctAnswerIndex: 1,
      ),
    ],
  ),
  Principle(
    title: 'Air',
    heroImagePath: 'lib/Hero_pictures/Air.jpg',
    lessons: [
      Lesson(
        title: 'Breathe fresh air.',
        content: 'Fresh, clean air is vital for life. Practice deep breathing and keep your living spaces well-ventilated to improve lung capacity and mental clarity.',
      ),
    ],
    quizQuestions: [
      QuizQuestion(
        question: 'What is important for good lung health?',
        options: ['Smoking', 'Staying indoors', 'Fresh air', 'Pollution'],
        correctAnswerIndex: 2,
      ),
    ],
  ),
  Principle(
    title: 'Rest',
    heroImagePath: 'lib/Hero_pictures/rest.jpg',
    lessons: [
      Lesson(
        title: 'Recover and recharge.',
        content: 'Sleep is the time when your body repairs itself. Aim for 7-9 hours of quality sleep each night to maintain physical and mental health.',
      ),
    ],
    quizQuestions: [
      QuizQuestion(
        question: 'How many hours of sleep are recommended for adults?',
        options: ['3-4', '5-6', '7-9', '12+'],
        correctAnswerIndex: 2,
      ),
    ],
  ),
  Principle(
    title: 'Trust',
    heroImagePath: 'lib/Hero_pictures/Trust.jpg',
    lessons: [
      Lesson(
        title: 'Trust in Divine Power.',
        content: 'A positive spiritual connection and trust in God can reduce stress, provide hope, and enhance overall well-being.',
      ),
    ],
    quizQuestions: [
      QuizQuestion(
        question: 'What can trust in a higher power help reduce?',
        options: ['Sleep', 'Stress', 'Appetite', 'Energy'],
        correctAnswerIndex: 1,
      ),
    ],
  ),
];
