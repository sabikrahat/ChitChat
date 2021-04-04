import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final title;
  final content;
  final VoidCallback callback;
  final actionText;

  CustomDialog(this.title, this.content, this.callback,
      [this.actionText = "Reset"]);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          letterSpacing: 1.8,
          fontFamily: "Signatra",
          fontSize: 27.0,
        ),
      ),
      content: Text(content),
      actions: <Widget>[
        // ignore: deprecated_member_use
        FlatButton(
          onPressed: callback,
          color: Colors.indigo[400],
          child: Text(actionText),
        )
      ],
    );
  }
}
