import 'package:flutter/material.dart';

class Desert extends StatelessWidget {
  const Desert(String s, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Desert"),
      ),
      body: const Center(
        child: Text("D"),
      ),
    );
  }
}
