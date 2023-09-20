// ignore_for_file: use_build_context_synchronously, unused_import

import 'package:flutter/material.dart';
import '../../models/recipe_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../home.dart';

class AddRecipePage extends StatefulWidget {
  const AddRecipePage({Key? key}) : super(key: key);

  @override
  State<AddRecipePage> createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController ingredientsController = TextEditingController();
  final TextEditingController instructionsController = TextEditingController();
  String? selectedRecipeType; // Обраний тип рецепту
  final List<String> recipeTypes = ['Sniadania', 'Obiad', 'Kolacja', 'Desert'];
  final DatabaseReference recipeRef =
      FirebaseDatabase.instance.ref().child('recipes');

  File? _selectedImage;
  String? uploadedImageUrl;

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

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

    String fileName = DateTime.now().millisecondsSinceEpoch.toString();

    firebase_storage.Reference storageRef = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child('recipe_images')
        .child(fileName);

    await storageRef.putFile(_selectedImage!);

    String downloadURL = await storageRef.getDownloadURL();

    setState(() {
      uploadedImageUrl = downloadURL;
    });
  }

  void addRecipe(Recipe recipe) {
    recipe.imageUrl =
        uploadedImageUrl ?? ''; // Встановлюємо URL завантаженої фотографії

    // Збереження рецепту в базу даних Firebase
    DatabaseReference newRecipeRef = recipeRef.push();
    newRecipeRef.set(recipe.toJson());
    // Отримуємо ключ рецепту, щоб встановити фотографію відповідного об'єкту
    String recipeKey = newRecipeRef.key ?? '';

    // Оновлюємо об'єкт рецепту з фотографією
    newRecipeRef.update({'photoUrl': uploadedImageUrl});

    // Завантаження фотографії до Firebase Storage з використанням ключа рецепту
    String fileName = '${recipeKey}_photo';
    firebase_storage.Reference storageRef = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child('recipe_images')
        .child(fileName);
    storageRef.putFile(_selectedImage!);
  }

  void saveRecipe() async {
    List<String> ingredients = ingredientsController.text
        .split(',')
        .map((ingredient) => ingredient.trim())
        .toList();

    await uploadImage();

    Recipe newRecipe = Recipe(
      title: titleController.text,
      ingredients: ingredients,
      instructions: instructionsController.text,
      imageUrl: uploadedImageUrl ?? '',
      recipeType: selectedRecipeType ?? '',
    );
    addRecipe(newRecipe);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeRecipePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
          builder: (context) {
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
                    DropdownButtonFormField<String>(
                      value: selectedRecipeType,
                      onChanged: (newValue) {
                        setState(() {
                          selectedRecipeType = newValue;
                        });
                      },
                      items: recipeTypes.map((type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                      decoration: const InputDecoration(
                        labelText: 'Тип рецепту',
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
                      onPressed: saveRecipe,
                      child: const Text('Зберегти рецепт'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
