import 'package:flutter/material.dart';

class UserButton extends StatelessWidget {

  final String buttonText;
  final Function()? onPressed;

  const UserButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
    });

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(25),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.orange,
          elevation: 5,

        ),
        child: Center(
          child: Text(
            buttonText,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
       ),
      ),
    );
  }
}