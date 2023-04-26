import 'package:flutter/material.dart';

class Sniadania extends StatelessWidget {
  const Sniadania(String s, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sniadania"),
      ),
      body: const Center(
        child: Text("S"),
      ),
    );
  }
}
