import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserPage extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String email;
  final int? age;

  const UserPage({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.age,
    required User user,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              // Змініть колір фону кругового аватара тут
              radius: 50,
              child: Text(
                firstName.isNotEmpty ? firstName[0] : 'U',
                style: const TextStyle(
                  fontSize: 36,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '$firstName $lastName',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Age: $age',
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Email: $email',
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            // Додайте інші поля тут, якщо є додаткові дані про користувача
          ],
        ),
      ),
    );
  }
}
