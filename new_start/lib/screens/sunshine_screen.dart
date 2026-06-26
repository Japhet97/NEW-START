import 'package:flutter/material.dart';

class SunshineScreen extends StatelessWidget {
  const SunshineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sunshine'),
      ),
      body: const Center(
        child: Text('Sunshine Screen'),
      ),
    );
  }
}
