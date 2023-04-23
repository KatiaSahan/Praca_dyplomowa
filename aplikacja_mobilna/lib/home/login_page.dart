import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            width: w,
            height: h * 0.3,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("img/loginfoto.jpg"), fit: BoxFit.cover)),
          ),
          Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              width: w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Hello",
                      style:
                          TextStyle(fontSize: 70, fontWeight: FontWeight.bold)),
                  Text("Sign into your account",
                      style: TextStyle(fontSize: 20, color: Colors.grey[500])),
                  const SizedBox(
                    height: 50,
                  ),
                  Container(
                    decoration: BoxDecoration(color: Colors.white, boxShadow: [
                      BoxShadow(
                          blurRadius: 10,
                          offset: const Offset(1, 1),
                          color: Colors.grey.withOpacity(0.4))
                    ]),
                    child: TextField(
                      decoration: InputDecoration(
                          focusedBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 1.0)),
                          enabledBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 1.0)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30))),
                    ),
                  )
                ],
              ))
        ],
      ),
    );
  }
}
