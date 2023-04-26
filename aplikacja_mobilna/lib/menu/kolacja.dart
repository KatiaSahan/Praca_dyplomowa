import 'package:flutter/material.dart';

class Kolacja extends StatelessWidget {
  const Kolacja(String s, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kolacja"),
      ),
      body: const Center(
        child: Text("K"),
      ),
    );
  }
}
