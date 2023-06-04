import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  const Settings(String s, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: const Center(
        child: Text("S"),
      ),
    );
  }
}
