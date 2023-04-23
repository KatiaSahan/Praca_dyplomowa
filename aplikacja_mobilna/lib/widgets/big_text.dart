import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class BigText extends StatefulWidget {
  final Color? color;
  final String text;
  final double size;
  final TextOverflow overFlow;
  const BigText({
    Key? key,
    this.color,
    required this.text,
    this.size = 30,
    this.overFlow = TextOverflow.ellipsis, required style,
  }) : super(key: key);

  @override
  State<BigText> createState() => _BigTextState();
}

class _BigTextState extends State<BigText> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text,
      maxLines: 1,
      style: TextStyle(
          fontFamily: 'Roboto',
          color: widget.color,
          fontSize: widget.size,
          fontWeight: FontWeight.w400),
      overflow: widget.overFlow,
    );
  }
}
