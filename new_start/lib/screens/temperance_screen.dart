import 'package:flutter/material.dart';

class TemperanceScreen extends StatelessWidget {
  const TemperanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Temperance'),
      ),
      body: const Center(
        child: Text('Temperance Screen'),
      ),
    );
  }
}
