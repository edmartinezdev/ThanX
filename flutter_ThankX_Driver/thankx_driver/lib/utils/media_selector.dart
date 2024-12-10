import 'dart:io' show Platform, File;
import 'package:flutter/material.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:thankxdriver/channel/platform_channel.dart';
import 'package:thankxdriver/localization/localization.dart';
import 'package:thankxdriver/utils/enum.dart';
import 'package:thankxdriver/utils/logger.dart';
import 'package:thankxdriver/utils/utils.dart';

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
    else if (purpose == MediaFor.vehicle) {
      return AppTranslations.globalTranslations.msgVehiclePhotoSelection;
    }
//    else if (purpose == MediaFor.listing) {
//      return AppTranslations.globalTranslations.msgListingPhotoSelection;
//    }
    return "";
  }

  String _getMessageForPermission(MediaFor purpose, ImageSource source) {
    if (source == ImageSource.camera) {
      if (purpose == MediaFor.profile) {
        return AppTranslations.globalTranslations.msgCameraPermissionProfile;
      }
//      else if (purpose == MediaFor.chat) {
//        return AppTranslations.globalTranslations.msgCameraPermissionChat;
//      }
//      else if (purpose == MediaFor.listing) {
//        return AppTranslations.globalTranslations.msgCameraPermissionListing;
//      }
      return AppTranslations.globalTranslations.msgCameraPermission;
    }
    else {
      if (purpose == MediaFor.profile) {
        return AppTranslations.globalTranslations.msgPhotoPermissionProfile;
      }
//      else if (purpose == MediaFor.chat) {
//        return AppTranslations.globalTranslations.msgPhotoPermissionChat;
//      }
//      else if (purpose == MediaFor.listing) {
//        return AppTranslations.globalTranslations.msgPhotoPermissionListing;
//      }
      return AppTranslations.globalTranslations.msgPhotoPermission;
    }
  }

  //region Ask user for option
  void handleImagePickingOperation(BuildContext context,
      {@required MediaFor purpose, @required ImageSelectionCallBack callBack, bool isImageResize = true}) {
    final arrButton = [
      AppTranslations.globalTranslations.strCamera,
      AppTranslations.globalTranslations.strGallary
    ];
    final message = this._getMessageForTitle(purpose);
    if (Platform.isAndroid) {
      Utils.showAlert(context,
          message: message,
          arrButton: arrButton, callback: (int index) {
            ImageSource sourceType = (index == 0)
                ? ImageSource.camera
                : ImageSource.gallery;
            this._onImageButtonPressed(context, purpose: purpose,
                source: sourceType,
                callBack: callBack,
                isImageResize: isImageResize);
          });
    } else if (Platform.isIOS) {
      Utils.showBottomSheet(context,
          title: message,
          arrButton: arrButton, callback: (int index) {
            if (index == -1) {
              return;
            }
            ImageSource sourceType =
            (index == 0) ? ImageSource.camera : ImageSource.gallery;
            this._onImageButtonPressed(context, purpose: purpose,
                source: sourceType,
                callBack: callBack,
                isImageResize: isImageResize);
          });
    }
  }

  //endregion

  //region PickImagewith option
  Future _onImageButtonPressed(BuildContext context,
      {@required MediaFor purpose, @required ImageSource source, @required ImageSelectionCallBack callBack, @required bool isImageResize}) async {
    String messageDecline = this._getMessageForPermission(purpose, source);

    if (source == ImageSource.camera) {
      bool permissionAllowed = await PlatformChannel()
          .checkForCameraPermission();
      if (!permissionAllowed) {
        Logger().w("Permission Declined for Camera");
        this._openSetting(context, message: messageDecline);
        if (callBack != null) {
          callBack(null);
        }
        return;
      }
    } else {
      bool permissionAllowed = await PlatformChannel()
          .checkForPhotoPermission();
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
      selectedFile = await ImagePicker.pickImage(source: source, maxHeight: 720, maxWidth: 480);
    } else {
      selectedFile = await ImagePicker.pickImage(source: source, maxHeight: 1440, maxWidth: 960);
    }

    Logger().v("Path Galley :: ${selectedFile.path}");

//    if (isImageResize && (selectedFile != null) && (selectedFile.path != null)) {
//      Logger().v("Check for Image REsizing");
//      final dirPath = await getApplicationDocumentsDirectory();
//      var filename = "Img_" + DateTime.now().microsecondsSinceEpoch.toString() + selectedFile.path.substring(selectedFile.path.lastIndexOf("."));
//      final targetPath = "${dirPath.path}/$filename";
//      selectedFile = await FlutterImageCompress.compressAndGetFile(selectedFile.absolute.path, targetPath, minHeight: 480, quality: 60);
//      Logger().v("Path Resize:: ${selectedFile.path}");
//    }

    if (selectedFile != null && selectedFile.path != null) {
      Logger().v("Check for Image Orientation");
      var filename = "Img_" + DateTime.now().microsecondsSinceEpoch.toString() + selectedFile.path.substring(selectedFile.path.lastIndexOf("."));
      final dirPath = await getApplicationDocumentsDirectory();
      final targetPath = "${dirPath.path}/$filename";
      selectedFile = await FlutterExifRotation.rotateImage(path: selectedFile.path);
      selectedFile = await selectedFile.copy(targetPath);
      Logger().v("Path Fix Orientation:: ${selectedFile.path}");
    }


    if (callBack != null) {
      callBack(selectedFile);
    }
  }

  //endregion

  //region Open setting
  Future<void> _openSetting(@required BuildContext context, {@required String message}) async {
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