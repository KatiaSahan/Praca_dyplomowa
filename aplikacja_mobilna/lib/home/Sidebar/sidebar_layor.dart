import 'package:aplikacja_mobilna/home/Sidebar/sidebarr.dart';
import 'package:flutter/material.dart';
import '../home.dart';

class SideBarLayor extends StatelessWidget {
  const SideBarLayor({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: const <Widget>[RecipeListPage(), SideBar()],
    ));
  }
}
