import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:thankx_user/localization/localization.dart';
import 'package:thankx_user/utils/app_font.dart';
import '../utils/ui_utils.dart';

typedef AlertWidgetButtonActionCallback = void Function(int index);

class AlertWidget extends StatefulWidget {
  final String title;
  final String message;
  final List<String> buttonOption;
  final AlertWidgetButtonActionCallback onCompletion;

  AlertWidget(
      {this.title, this.message, this.buttonOption, this.onCompletion});

  @override
  _AlertWidgetState createState() => _AlertWidgetState();
}

class _AlertWidgetState extends State<AlertWidget> {
  BuildContext _alertContext;

  Widget get titleWidget {
    var mainTitle = this.widget.title ?? '';
    if (mainTitle.length == 0) {
      mainTitle = AppTranslations.globalTranslations.appName;
    }

    if (Platform.isIOS) {
      if (mainTitle != null && mainTitle.length > 0) {
        final style = UIUtills().getTextStyle(
            fontName: AppFont.robotoBold, fontsize: 16, characterSpacing: 0.68);
        var titleW = Align(
          child: Text(
            mainTitle,
            style: style,
          ),
          alignment: Alignment.topCenter,
        );
        return Padding(padding: EdgeInsets.only(bottom: 10), child: titleW,);
      }
    } else if (Platform.isAndroid) {
      if (mainTitle != null && mainTitle.length > 0) {
        final style = UIUtills().getTextStyle(
            fontName: AppFont.robotoBold, fontsize: 16, characterSpacing: 0.68);
        var titleW = Align(
          child: Text(
            mainTitle,
            style: style,
          ),
          alignment: Alignment.topLeft,
        ); 
        return titleW;
      }
    }
    return null;
  }

  Widget get messageWidget {
    if (this.widget.message != null && this.widget.message.length > 0) {
      final style = UIUtills().getTextStyle(
          fontName: AppFont.robotoRegular,
          fontsize: 14,
          characterSpacing: 0.68);
      var messageW = Text(
        this.widget.message,
        style: style,
      );
      return (Platform.isIOS)
          ? messageW
          : Padding(
              child: messageW,
              padding: EdgeInsets.only(top: 10.0),
            );
    }
    return null;
  }

  List<Widget> get actionWidgert {
    List<Widget> arrButtons = [];

    for (String str in this.widget.buttonOption) {
      Widget button;
      if (Platform.isIOS) {
        final style = UIUtills().getTextStyle(
            fontName: AppFont.robotoMedium,
            fontsize: 18,
            characterSpacing: 0.68);
        button = CupertinoDialogAction(
            isDestructiveAction: str.toLowerCase() ==
                AppTranslations.globalTranslations.buttonCancel.toLowerCase(),
            child: Text(
              str,
              style: style,
            ),
            onPressed: () => this.onButtonPressed(str));
      } else {
        final style = UIUtills().getTextStyle(
            fontName: AppFont.robotoRegular,
            fontsize: 14,
            characterSpacing: 0.68);
        button = FlatButton(
          child: Text(
            str,
            style: style,
          ),
          onPressed: () => this.onButtonPressed(str),
        );
      }
      arrButtons.add(button);
    }
    return arrButtons;
  }

  @override
  Widget build(BuildContext context) {
    _alertContext = context;

    var alertDialog;
    if (Platform.isIOS) {
      alertDialog = CupertinoAlertDialog(
        title: this.titleWidget,
        content: this.messageWidget,
        actions: actionWidgert,
      );
    } else {
      alertDialog = AlertDialog(
        title: this.titleWidget,
        content: this.messageWidget,
        actions: actionWidgert,
        contentPadding: const EdgeInsets.fromLTRB(24.0, 7.0, 20.0, 12.0),
      );
    }
    return alertDialog;
    //return WillPopScope(child: alertDialog, onWillPop: this._onBackSpace);
  }

  void onButtonPressed(String btnTitle) {
    int index = this.widget.buttonOption.indexOf(btnTitle);

    //dismiss Diloag
    Navigator.of(_alertContext).pop();

    // Provide callback
    if (this.widget.onCompletion != null) {
      this.widget.onCompletion(index);
    }
  }
}
