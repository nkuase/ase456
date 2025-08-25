import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  const MyButton(
      {Key? key,
      required this.child,
      required this.buttonColor,
      required this.textColor,
      required this.function})
      : super(key: key);

  final String child;
  final buttonColor, textColor, function;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
              height: 100,
              width: 100,
              color: buttonColor,
              child: Center(
                child: Text(child,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                        fontSize: 20)),
              )),
        ),
      ),
    );
  }
}
