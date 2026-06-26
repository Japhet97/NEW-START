import 'package:flutter/material.dart';

class AirScreen extends StatelessWidget {
  const AirScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Air'),
      ),
      body: const Center(
        child: Text('Air Screen'),
      ),
    );
  }
}
