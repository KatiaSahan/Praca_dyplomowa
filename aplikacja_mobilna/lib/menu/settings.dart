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
          title: const Text('Settings'),
        ),
        body: Column(
          children: [
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              MaterialButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pop();
                },
                color: Colors.deepPurple[200],
                child: const Text('sign out'),
              ),
              const SizedBox(height: 20), // Проміжок для відокремлення кнопок
              MaterialButton(
                onPressed:
                    _navigateToEditProfilePage, // Виклик функції для переходу
                color: Colors.blue[200],
                child: const Text('Edit Profile'),
              ),
              const SizedBox(height: 20), // Проміжок для відокремлення кнопок
              MaterialButton(
                onPressed: _deleteAccount,
                color: Colors.red[200],
                child: const Text('Delete Account'),
              )
            ])
          ],
        ));
  }
}
