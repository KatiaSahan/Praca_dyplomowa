// ignore_for_file: use_build_context_synchronously, unused_import

import 'package:flutter/material.dart';
import '../../models/recipe_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../home.dart';

class AddRecipePage extends StatefulWidget {
  const AddRecipePage({super.key});

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

  Future<String> uploadImage(String recipeKey) async {
    if (_selectedImage == null) return '';

    String fileName = '${recipeKey}_photo';

    firebase_storage.Reference storageRef = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child('recipe_images')
        .child(fileName);

    await storageRef.putFile(_selectedImage!);

    return await storageRef.getDownloadURL();
  }

  void addRecipe(Recipe recipe, String recipeKey) async {
    recipe.imageUrl =
        uploadedImageUrl ?? ''; // Встановлюємо URL завантаженої фотографії

    // Збереження рецепту в базу даних Firebase
    DatabaseReference newRecipeRef = recipeRef.push();
    newRecipeRef.set(recipe.toJson());
    // Отримуємо ключ рецепту, щоб встановити фотографію відповідного об'єкту
    String recipeKey = newRecipeRef.key ?? '';
    String photoUrl = await uploadImage(recipeKey);
    // Оновлюємо об'єкт рецепту з фотографією
    newRecipeRef.update({'photoUrl': photoUrl});
  }

  void saveRecipe() async {
    List<String> ingredients = ingredientsController.text
        .split(',')
        .map((ingredient) => ingredient.trim())
        .toList();
    String recipeKey =
        FirebaseDatabase.instance.ref().child('recipes').push().key ?? '';
    await uploadImage(recipeKey);

    Recipe newRecipe = Recipe(
      title: titleController.text,
      ingredients: ingredients,
      instructions: instructionsController.text,
      imageUrl: uploadedImageUrl ?? '',
      recipeType: selectedRecipeType ?? '',
    );
    addRecipe(newRecipe, recipeKey);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeRecipePage()),
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
                title: const Text('Dodaj przepis',
                    style: TextStyle(color: Colors.white)),
                backgroundColor: const Color.fromARGB(248, 103, 16, 216),
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Nazwa przepisu',
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: ingredientsController,
                          decoration: const InputDecoration(
                            hintText: 'Wprowadź składniki przecinkami',
                          ),
                        ),
                      ],
                    ),
                    TextField(
                      controller: instructionsController,
                      decoration: const InputDecoration(
                        labelText: 'Instrukcje',
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
                        labelText: 'Rodzaj przepisu',
                      ),
                    ),
                    if (_selectedImage != null)
                      Image.file(
                        _selectedImage!,
                        height: 150,
                      ),
                    ElevatedButton(
                      onPressed: _selectImage,
                      child: const Text('Wybierz zdjęcie'),
                    ),
                    ElevatedButton(
                      onPressed: saveRecipe,
                      child: const Text('Zapisz przepis'),
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
