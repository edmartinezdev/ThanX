import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:thankxdriver/utils/app_color.dart';
import 'package:thankxdriver/utils/app_font.dart';
import 'package:thankxdriver/utils/app_image.dart';
import 'package:thankxdriver/utils/ui_utils.dart';

// ignore: must_be_immutable
class FullScreenImageViewer extends StatefulWidget {
  int position = 0;
  List<String> mediaList;

  FullScreenImageViewer({this.position, this.mediaList});

  @override
  State<StatefulWidget> createState() {
    return FullScreenImageState();
  }
}

class FullScreenImageState extends State<FullScreenImageViewer> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        alignment: Alignment.center,
        children: [
          imageWidget(),
          Positioned(
            top: UIUtills().getProportionalWidth(40.0),
            right: UIUtills().getProportionalWidth(10.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                color: AppColor.mePageTextColor,
                padding: EdgeInsets.all(UIUtills().getProportionalWidth(8.0)),
                width: UIUtills().getProportionalWidth(30.0),
                height: UIUtills().getProportionalWidth(30.0),
                child: Image.asset(
                  AppImage.close,
                  color: AppColor.whiteColor,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                widget.position == 0
                    ? Container()
                    : GestureDetector(
                      onTap: () {
                        if (widget.position >= 1) {
                          widget.position = widget.position - 1;
                          setState(() {});
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        child: Image.asset(
                          AppImage.leftSwipe,
                          width: UIUtills().getProportionalWidth(20.0),
                          height: UIUtills().getProportionalWidth(20.0),
                          color: AppColor.whiteColor,
                        ),
                      ),
                    ),
                Expanded(flex: 1, child: Container()),
                widget.position == widget.mediaList.length - 1
                    ? Container()
                    : GestureDetector(
                      onTap: () {
                        if (widget.position < widget.mediaList.length - 1) {
                          widget.position = widget.position + 1;
                          setState(() {});
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        child: Image.asset(
                          AppImage.rightSwipe,
                          width: UIUtills().getProportionalWidth(20.0),
                          height: UIUtills().getProportionalWidth(20.0),
                          color: AppColor.whiteColor,
                        ),
                      ),
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget imageWidget() {
    return this.widget.mediaList[widget.position] != null && this.widget.mediaList[widget.position].isNotEmpty ? pageViewImage() : emptyContainer();
  }

  Widget emptyContainer() {
    return Container(
      color: AppColor.mePageTextColor,
      child: Center(
        child: Text("Empty", style: UIUtills().getTextStyle(fontsize: 14, fontName: AppFont.sfProTextRegular, color: AppColor.whiteColor)),
      ),
    );
  }

  Widget pageViewImage() {
    return Container(
      margin: EdgeInsets.only(top: UIUtills().getProportionalHeight(0), bottom: UIUtills().getProportionalHeight(0)),
      width: double.infinity,
      color: AppColor.mePageTextColor,
      child: PhotoView(
        imageProvider: (this.widget.mediaList.length > 0 && widget.mediaList[widget.position].startsWith('http'))
            ? NetworkImage(
                this.widget.mediaList[widget.position] ?? '',
              )
            : FileImage(File(widget.mediaList[widget.position])),
        loadingBuilder: (context, event) => Center(
          child: Container(
            width: 35.0,
            height: 35.0,
            child: new CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColor.primaryColor),
            ),
          ),
        ),
        backgroundDecoration: BoxDecoration(
          color: AppColor.mePageTextColor,
//color: Colors.black,
        ),
      ),
    );
  }
}
