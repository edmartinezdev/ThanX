import 'dart:io' show Platform, File;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thankx_user/channel/platform_channel.dart';
import 'package:thankx_user/localization/localization.dart';
import 'enum.dart';
import 'logger.dart';
import 'utils.dart';

typedef ImageSelectionCallBack = void Function(File file);

class MediaSelector {

  factory MediaSelector() {
    return _singleton;
  }
  static final MediaSelector _singleton = MediaSelector._internal();
  MediaSelector._internal() {
    Logger().v("Instance created MediaSelector");
  }

  String _getMessageForTitle(MediaFor purpose) {
    if (purpose == MediaFor.profile) {
      return AppTranslations.globalTranslations.msgProfilePhotoSelection;
    }
    return "";
  }

  String _getMessageForPermission(MediaFor purpose, ImageSource source) {
    if (source == ImageSource.camera) {
      if (purpose == MediaFor.profile) {
        return AppTranslations.globalTranslations.msgCameraPermissionProfile;
      }
      return AppTranslations.globalTranslations.msgCameraPermission;
    }
    else {
      if (purpose == MediaFor.profile) {
        return AppTranslations.globalTranslations.msgPhotoPermissionProfile;
      }
      return AppTranslations.globalTranslations.msgPhotoPermission;
    }


  }

  //region Ask user for option
  void handleImagePickingOperation(BuildContext context, {@required MediaFor purpose, @required ImageSelectionCallBack callBack, bool isImageResize = true}) {
    final arrButton = [
      AppTranslations.globalTranslations.strTakePhoto,
      AppTranslations.globalTranslations.strChooseFromExisting
    ];
    final message = this._getMessageForTitle(purpose);
    if (Platform.isAndroid) {
      Utils.showAlert(context,
          message: message,
          arrButton: arrButton, callback: (int index) {
            ImageSource sourceType =
            (index == 0) ? ImageSource.camera : ImageSource.gallery;
            this._onImageButtonPressed(context, purpose: purpose, source: sourceType, callBack: callBack, isImageResize: isImageResize);
          });
    } else if (Platform.isIOS) {
      Utils.showBottomSheet(context,
          title: message,
          arrButton: arrButton, callback: (int index) {
            if (index == -1) { return; }
            ImageSource sourceType =
            (index == 0) ? ImageSource.camera : ImageSource.gallery;
            this._onImageButtonPressed(context, purpose: purpose, source: sourceType, callBack: callBack, isImageResize: isImageResize);
          });
    }
  }

  //endregion

  //region PickImagewith option
  Future _onImageButtonPressed(BuildContext context, {@required MediaFor purpose, @required ImageSource source, @required ImageSelectionCallBack callBack, @required bool isImageResize}) async {
    String messageDecline = this._getMessageForPermission(purpose, source);

    if (source == ImageSource.camera) {
      bool permissionAllowed = await PlatformChannel().checkForCameraPermission();
      if (!permissionAllowed) {
        Logger().w("Permission Declined for Camera");
        this._openSetting(context, message: messageDecline);
        if (callBack != null) {
          callBack(null);
        }
        return;
      }
    } else {
      bool permissionAllowed = await PlatformChannel().checkForPhotoPermission();
      if (!permissionAllowed) {
        Logger().w("Permission Declined for Photo");
        this._openSetting(context, message: messageDecline);
        if (callBack != null) {
          callBack(null);
        }
        return;
      }
    }

    File selectedFile;
    if (isImageResize) {
      selectedFile = await ImagePicker.pickImage(source: source, maxHeight: 1080, maxWidth: 768);
    } else {
      selectedFile = await ImagePicker.pickImage(source: source);
    }

    Logger().v("Path Galley :: ${selectedFile.path}");

//    if (isImageResize && (selectedFile != null) && (selectedFile.path != null)) {
//      Logger().v("Check for Image REsizing");
//      final dirPath = await getApplicationDocumentsDirectory();
//      var filename = "Img_" + DateTime.now().microsecondsSinceEpoch.toString() + ".png";
//      final targetPath = "${dirPath.path}/$filename";
//      selectedFile = await FlutterImageCompress.compressAndGetFile(selectedFile.absolute.path, targetPath, minHeight: 720, quality: 60);
//      Logger().v("Path Resize:: ${selectedFile.path}");
//    }

    if (selectedFile != null && selectedFile.path != null) {
      Logger().v("Check for Image Orientation");
//      selectedFile = await FlutterExifRotation.rotateImage(path: selectedFile.path);
      Logger().v("Path Fix Orientation:: ${selectedFile.path}");
    }


    if (callBack != null) {
      callBack(selectedFile);
    }
  }

  //endregion

  //region Open setting
  Future<void> _openSetting(@required BuildContext context,
      {@required String message}) async {
    Utils.showAlert(context, title: "", message: message, arrButton: [
      AppTranslations.globalTranslations.buttonCancel,
      AppTranslations.globalTranslations.buttonOk
    ], callback: (index) async {
      if (index == 1) {
        Future.delayed(Duration(seconds: 1), () async {
          await PlatformChannel().openAppSetting();
        });
      }
    });
  }
//endregion


}
