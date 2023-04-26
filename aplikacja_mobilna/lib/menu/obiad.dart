import 'package:flutter/material.dart';

class Obiad extends StatelessWidget {
  const Obiad(String s, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Obiad"),
      ),
      body: const Center(
        child: Text("O"),
      ),
    );
  }
}
