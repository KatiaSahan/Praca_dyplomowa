// ignore_for_file: use_build_context_synchronously
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  const Settings(String s, {Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

// Функція для отримання поточної мови додатку
Future<String> getLanguage() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('language') ??
      'en'; // Повернути значення мови або за замовчуванням 'en'
}

// Функція для отримання поточної теми додатку
Future<String> getTheme() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('theme') ??
      'light'; // Повернути значення теми або за замовчуванням 'light'
}

class _SettingsState extends State<Settings> {
  final user = FirebaseAuth.instance.currentUser!;
  String _currentLanguage = 'en'; // Поточне значення мови
  String _currentTheme = 'light'; // Поточне значення теми

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  // Завантаження налаштувань
  _loadSettings() async {
    String language = await getLanguage();
    String theme = await getTheme();
    setState(() {
      _currentLanguage = language;
      _currentTheme = theme;
    });
  }

  // Збереження мови
  _saveLanguage(String language) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('language', language);
  }

  // Збереження теми
  _saveTheme(String theme) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('theme', theme);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text('Language'),
            trailing: DropdownButton<String>(
              value: _currentLanguage,
              items: ['en', 'es', 'fr'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _currentLanguage = newValue!;
                  _saveLanguage(newValue); // Зберегти вибрану мову
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Theme'),
            subtitle: const Text('Choose app theme'),
            trailing: Column(
              children: [
                RadioListTile<String>(
                  title: const Text('Light'),
                  value: 'light',
                  groupValue: _currentTheme,
                  onChanged: (String? value) {
                    setState(() {
                      _currentTheme = value!;
                      _saveTheme(value); // Зберегти вибрану тему
                    });
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Dark'),
                  value: 'dark',
                  groupValue: _currentTheme,
                  onChanged: (String? value) {
                    setState(() {
                      _currentTheme = value!;
                      _saveTheme(value); // Зберегти вибрану тему
                    });
                  },
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MaterialButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pop();
                },
                color: Colors.deepPurple[200],
                child: const Text('sign out'),
              )
            ],
          ),
        ],
      ),
    );
  }
}
