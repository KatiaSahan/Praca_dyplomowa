import 'package:flutter/material.dart';

import 'home/home.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const RecipeListPage(),
      // routes: <String, WidgetBuilder>{
      //    "/a": (BuildContext context) => const Sniadania(),
      // }
    ); // odwołanie do klasy LoginPage
  }
}
