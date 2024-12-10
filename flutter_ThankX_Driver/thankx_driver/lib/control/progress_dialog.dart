import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../utils/app_color.dart';

typedef AlertWidgetButtonActionCallback = void Function(int index);

class ProgressDiloag extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: SpinKitWave(color:AppColor.primaryColor,), onWillPop: this._onBackSpace);
  }

  Future<bool> _onBackSpace() async {
    return false;
  }
}