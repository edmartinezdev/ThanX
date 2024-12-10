import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';


class CustomNetworkImage extends StatefulWidget {
  String url;
  double height,width;
  Widget placeHolder;
  double radius;
  CustomNetworkImage({this.height,this.width,this.placeHolder,this.url,this.radius});

  @override
  _NetworkImageState createState() => _NetworkImageState();
}

class _NetworkImageState extends State<CustomNetworkImage> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(this.widget.radius)),
      child: ExtendedImage.network(
        this.widget.url,
        width: this.widget.width,
        height: this.widget.height,
        fit: BoxFit.cover,
        loadStateChanged: (ExtendedImageState state) {
          switch (state.extendedImageLoadState) {
            case LoadState.loading:
            // ignore: missing_return
              return this.widget.placeHolder;
              break;
            case LoadState.completed:
              return
                ExtendedRawImage(
                  image: state.extendedImageInfo?.image,
                  fit: BoxFit.cover,
                  width: this.widget.width,
                  height: this.widget.height,
                );
              break;
            case LoadState.failed:
              return this.widget.placeHolder;
              break;
            default:
              return Container();
          }
        },
      ),
    );
  }
}
