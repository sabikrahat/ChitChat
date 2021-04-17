import 'package:flutter/material.dart';

circularProgress() {
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(top: 12.0),
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(Colors.indigo[400]),
    ),
  );
}

linearProgress() {
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(top: 12.0, left: 5.0, right: 5.0),
    child: LinearProgressIndicator(
      valueColor: AlwaysStoppedAnimation(Colors.indigo[400]),
    ),
  );
}
