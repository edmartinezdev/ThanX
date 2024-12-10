import 'package:flutter/material.dart';
import 'package:thankxdriver/utils/app_color.dart';
import 'package:thankxdriver/utils/app_font.dart';
import 'package:thankxdriver/utils/ui_utils.dart';

// ignore: must_be_immutable
class RouteWidgets extends StatelessWidget {
  List<String> addresses;
  String pickUpImage;
  String dropImage;

  RouteWidgets({this.addresses, this.pickUpImage, this.dropImage});

  Widget getIconsColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          this.pickUpImage,
          height: UIUtills().getProportionalWidth(16),
          width: UIUtills().getProportionalWidth(16),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: UIUtills().getProportionalWidth(2)),
          width: 3,
          height: UIUtills().getProportionalWidth(38),
          color: AppColor.historyRouteLineColor,
        ),
        Image.asset(
          this.dropImage,
          height: UIUtills().getProportionalWidth(16),
          width: UIUtills().getProportionalWidth(16),
        ),
      ],
    );
  }

  Widget getAddressNameColumn(int i) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: UIUtills().screenWidth * 0.75,
          height: UIUtills().getProportionalWidth(24.0),
          child: Text(
            addresses[i],
            maxLines: 2,
            style: UIUtills().getTextStyleRegular(fontSize: 10, fontName: AppFont.sfProTextMedium, color: AppColor.textColor, characterSpacing: 0.24),
          ),
        ),
        SizedBox(
          height: UIUtills().getProportionalWidth((i == 0) ? 26 : 19),
        ),
      ],
    );
  }

  Widget getMainAddressColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: UIUtills().getProportionalWidth(2),
        ),
        getAddressNameColumn(0),
        SizedBox(
          height: UIUtills().getProportionalWidth(7),
        ),
        getAddressNameColumn(1),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        getIconsColumn(),
        SizedBox(
          width: UIUtills().getProportionalWidth(14),
        ),
        getMainAddressColumn()
      ],
    );
  }
}
