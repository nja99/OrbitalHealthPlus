import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {

  final String title;
  final String description;

  const CustomAlertDialog({
    super.key,
    required this.title,
    required this.description,
    });

  @override
  Widget build(BuildContext context) {
    
    return AlertDialog(
      title: Text(
        title, 
        textAlign: TextAlign.center, 
        style: const TextStyle(fontSize: 17.5)
      ),
      content: Text(
        description, 
        textAlign: TextAlign.center
      ),
      actions: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              elevation: 0,
            ),
            child: Text(
              "Ok",
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 15.0,
              ),
            ),
          ),
        ),
      ],
      actionsAlignment: MainAxisAlignment.center,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
    );
  }
}

void showCustomDialog(BuildContext context, String title, String description) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return CustomAlertDialog(title: title, description: description);
    },
  );
}
