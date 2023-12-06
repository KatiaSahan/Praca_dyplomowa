// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'additional_page/edit_profile_page.dart';

class Settings extends StatefulWidget {
  const Settings(String s, {super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final user = FirebaseAuth.instance.currentUser!;
  final firestore = FirebaseFirestore.instance;

  void _navigateToEditProfilePage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const EditProfilePage(
          age: '',
          lastName: '',
          email: '',
          firstName: '',
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  // Завантаження налаштувань
  _loadSettings() async {
    // Завантаження коду налаштувань, якщо потрібно
    setState(() {
      // Присвоєння значень налаштувань змінним
    });
  }

// Функція для видалення облікового запису користувача
  _deleteAccount() async {
    try {
      // Видалення даних користувача з Firestore
      await firestore.collection('users').doc(user.uid).delete();

      // Видалення облікового запису з Firebase
      await user.delete();

      // Вихід зі звіту з видаленням облікового запису
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pop();
    } catch (error) {
      // Обробка помилок видалення облікового запису
      if (kDebugMode) {
        print("Error deleting account: $error");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(248, 103, 16, 216),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple[200],
                  padding: const EdgeInsets.symmetric(vertical: 18.0),
                ),
                child:
                    const Text('Wyloguj się', style: TextStyle(fontSize: 20)),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _navigateToEditProfilePage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[200],
                  padding: const EdgeInsets.symmetric(vertical: 18.0),
                ),
                child:
                    const Text('Edytuj profil', style: TextStyle(fontSize: 20)),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _deleteAccount,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[200],
                  padding: const EdgeInsets.symmetric(vertical: 18.0),
                ),
                child: const Text('Usuń konto', style: TextStyle(fontSize: 20)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
