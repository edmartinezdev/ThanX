import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Custom1AlertDialog extends StatelessWidget {

  Widget child;
  Custom1AlertDialog({this.child});

  @override
   Widget build(BuildContext context) {
  return BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
    child: Dialog(
      child: child,
      backgroundColor: Colors.transparent,
    ),
  );
}
}
