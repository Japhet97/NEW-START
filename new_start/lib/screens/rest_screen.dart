import 'package:flutter/material.dart';

class RestScreen extends StatelessWidget {
  const RestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rest'),
      ),
      body: const Center(
        child: Text('Rest Screen'),
      ),
    );
  }
}
