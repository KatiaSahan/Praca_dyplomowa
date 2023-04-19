import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SmallText extends StatefulWidget {
  final Color? color;
  final String text;
  final double size;
  final double height;
  const SmallText(
      {Key? key,
      this.color,
      required this.text,
      this.size = 15,
      this.height = 1.2})
      : super(key: key);

  @override
  State<SmallText> createState() => _SmallTextState();
}

class _SmallTextState extends State<SmallText> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text,
      style: TextStyle(
          fontFamily: 'Roboto',
          color: widget.color,
          fontSize: widget.size,
          height: widget.height),
    );
  }
}
