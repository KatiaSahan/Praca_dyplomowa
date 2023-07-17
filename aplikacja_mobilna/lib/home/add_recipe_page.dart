import 'package:flutter/material.dart';
import '../models/recipe_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AddRecipePage extends StatefulWidget {
  const AddRecipePage({Key? key}) : super(key: key);

  @override
  State<AddRecipePage> createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {
  final TextEditingController titleController = TextEditingController();

  final TextEditingController descriptionController = TextEditingController();

  final TextEditingController ingredientsController = TextEditingController();

  final TextEditingController instructionsController = TextEditingController();

  final TextEditingController photoUrlController = TextEditingController();

  final DatabaseReference recipeRef =
      FirebaseDatabase.instance.ref().child('recipes');

  File? _selectedImage;
  String? uploadedImageUrl;

  void _selectImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? selected = await picker.pickImage(source: ImageSource.gallery);
    if (selected != null) {
      setState(() {
        _selectedImage = File(selected.path);
      });
    }
  }

  Future<void> uploadImage() async {
    if (_selectedImage == null) return;

    // Згенерувати унікальне ім'я файлу для завантаженої фотографії
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();

    // Отримати посилання на Firebase Storage
    firebase_storage.Reference storageRef = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child('recipe_images')
        .child(fileName);

    // Завантажити файл зображення в Firebase Storage
    await storageRef.putFile(_selectedImage!);

    // Отримати посилання на завантажену фотографію
    String downloadURL = await storageRef.getDownloadURL();

    setState(() {
      uploadedImageUrl = downloadURL;
    });
  }

  void addRecipe(Recipe recipe) {
    recipe.photoUrl =
        uploadedImageUrl ?? ''; // Встановлюємо URL завантаженої фотографії
    recipeRef.push().set(recipe.toJson());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Додати рецепт'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Назва рецепту',
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: ingredientsController,
                  decoration: const InputDecoration(
                    hintText: 'Введіть інгредієнти через кому',
                  ),
                ),
              ],
            ),
            TextField(
              controller: instructionsController,
              decoration: const InputDecoration(
                labelText: 'Інструкції',
              ),
            ),
            if (_selectedImage != null)
              Image.file(
                _selectedImage!,
                height: 150,
              ),
            ElevatedButton(
              onPressed: _selectImage,
              child: const Text('Вибрати фото'),
            ),
            ElevatedButton(
              onPressed: () {
                List<String> ingredients = ingredientsController.text
                    .split(',')
                    .map((ingredient) => ingredient.trim())
                    .toList();
                Recipe newRecipe = Recipe(
                  title: titleController.text,
                  ingredients: ingredients,
                  instructions: instructionsController.text,
                  photoUrl: '',
                );
                addRecipe(newRecipe);
                // Додайте логіку для збереження рецепту у базу даних або іншу необхідну дію
                Navigator.pop(
                    context); // Закриття сторінки додавання рецепту після збереження
              },
              child: const Text('Зберегти рецепт'),
            ),
          ],
        ),
      ),
    );
  }
}
