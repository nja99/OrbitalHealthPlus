import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PopUpAlerts extends StatelessWidget {

  final String title;
  final String description;

  PopUpAlerts({
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
        style: TextStyle(fontSize: 17.5)
      ),
      content: Text(
        description, 
        textAlign: TextAlign.center
      ),
      actions: [
        Container(
          width: double.maxFinite,
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            child: Text(
              "Ok",
              style: TextStyle(
                color: Colors.grey,
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
