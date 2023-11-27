// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  final String email;
  final String firstName;
  final String lastName;
  final String age;

  const EditProfilePage({
    super.key,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.age,
  });

  @override
  EditProfilePageState createState() => EditProfilePageState();
}

class EditProfilePageState extends State<EditProfilePage> {
  final user = FirebaseAuth.instance.currentUser!;
  final firestore = FirebaseFirestore.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set the text controllers with existing user data
    _emailController.text = user.email ?? '';

    // Load additional user data from Firestore
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      // Fetch the user document from Firestore
      final userDoc = await firestore.collection('users').doc(user.uid).get();

      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        setState(() {
          _firstNameController.text = userData['firstName'] ?? '';
          _lastNameController.text = userData['lastName'] ?? '';
          _ageController.text = (userData['age'] ?? 0).toString();
        });
      }
    } catch (error) {
      // Handle error if data cannot be loaded
      debugPrint("Error loading user data: $error");
    }
  }

  Future<void> _updateProfile() async {
    final newEmail = _emailController.text;
    final newPassword = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    try {
      // Update the user's display name and email in Firebase
      await user.updateEmail(newEmail);

      // Check if the user entered a new password and confirm password
      if (newPassword.isNotEmpty && newPassword == confirmPassword) {
        await user.updatePassword(newPassword);
      }

      // Update user data in Firestore using user.uid as the document ID
      await firestore.collection('users').doc(user.uid).update({
        'email': newEmail,
        'age': int.tryParse(_ageController.text),
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated')),
      );

      // Return to the previous page after updating
      Navigator.of(context).pop();
    } catch (error) {
      // Handle profile update errors
      debugPrint("Error updating profile: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error updating profile')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration:
                    const InputDecoration(labelText: 'Confirm Password'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: 'First Name'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: 'Last Name'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Age'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _updateProfile,
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
