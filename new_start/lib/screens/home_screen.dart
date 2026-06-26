import 'package:flutter/material.dart';
import 'dart:math';
import '../models/principle.dart';
import '../services/api_service.dart';
import '../services/notification_service.dart';
import '../widgets/principle_card.dart';
import '../widgets/principle_skeleton.dart';
import 'category_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Principle>> _principlesFuture;
  final ApiService _apiService = ApiService();
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _loadAllData();
    _scheduleRandomAdvice();
  }

  void _scheduleRandomAdvice() {
    // Show a notification after a random delay (10 to 60 seconds)
    // to simulate a "pop notification" feel while using the app
    final random = Random();
    final delay = 10 + random.nextInt(50);

    Future.delayed(Duration(seconds: delay), () {
      if (mounted) {
        _notificationService.showRandomAdvice();
      }
    });
  }

  void _loadAllData() {
    setState(() {
      _principlesFuture = _apiService.fetchPrinciples();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Uses theme's scaffoldBackgroundColor
      appBar: AppBar(
        title: const Text(
          'NEW START',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
        ),
        centerTitle: true,
        // Uses theme's appBarTheme
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: FutureBuilder<List<Principle>>(
          future: _principlesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.85,
                ),
                itemCount: 8,
                itemBuilder: (context, index) => const PrincipleSkeleton(),
              );
            } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Connecting to health principles...'));
            }

            final principles = snapshot.data!;

            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.85,
              ),
              itemCount: principles.length,
              itemBuilder: (context, index) {
                final principle = principles[index];
                return PrincipleCard(
                  principle: principle,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryDetailScreen(principle: principle),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
