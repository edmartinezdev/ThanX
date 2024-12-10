import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:thankxdriver/api_provider/all_response.dart';
import 'package:thankxdriver/bloc/review_list_bloc.dart';
import 'package:thankxdriver/common_widgets/pull_to_refresh_list_view.dart';
import 'package:thankxdriver/localization/localization.dart';
import 'package:thankxdriver/utils/app_color.dart';
import 'package:thankxdriver/utils/app_font.dart';
import 'package:thankxdriver/utils/app_image.dart';
import 'package:thankxdriver/utils/ui_utils.dart';
import 'package:thankxdriver/utils/utils.dart';

class ReviewPage extends StatefulWidget {
  ReviewListBloc reviewListBloc;

  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  ReviewListBloc _reviewListBloc;
  StreamSubscription<ReviewResponse> _reviewListSubscription;
  double rating;
final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _reviewListBloc =
        ReviewListBloc.createWith(bloc: this.widget.reviewListBloc);
    this.widget.reviewListBloc = this._reviewListBloc;

    Future.delayed(
      Duration(milliseconds: UIUtills().apiCallHaltDurationInMilliSecond),
      () {
        if (mounted) {
          this.reviewListApi(offset: 0);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Image.asset(AppImage.backArrow),
        ),
        title: Text(
          AppTranslations.globalTranslations.reviewTitle,
          style: UIUtills().getTextStyle(
              color: AppColor.appBartextColor,
              fontsize: 17,
              fontName: AppFont.sfCompactSemiBold),
        ),
        centerTitle: true,
        backgroundColor: AppColor.whiteColor,
        elevation: 0.5,
      ),
      body: Container(
        child: listWithEmptyContainer()
      ),
    );
  }

  Widget listWithEmptyContainer() {
    if(this._reviewListBloc.isApiResponseReceived == false){
      return Container();
    }
    final listView = PullToRefreshListView(
      padding: EdgeInsets.only(top: UIUtills().getProportionalHeight(24)),
      itemCount: this._reviewListBloc.isLoadMore ? this._reviewListBloc.reviewList.length + 1 : this._reviewListBloc.reviewList.length,
      onRefresh: () async => this.reviewListApi(offset: 0),
      builder: (context, index) {
        if (index == this._reviewListBloc.reviewList.length) {
          Future.delayed(Duration(milliseconds: 100), () => this.reviewListApi(offset: this._reviewListBloc.reviewList.length),);
          return Utils.buildLoadMoreProgressIndicator();
        }
        return Container(
          margin: EdgeInsets.only(
              left: UIUtills().getProportionalWidth(20),
              right: UIUtills().getProportionalWidth(20),
              bottom: UIUtills().getProportionalHeight(40)),
          child: mainContainer(
            this._reviewListBloc.reviewList[index].name,
              this._reviewListBloc.reviewList[index].reviews,
              this._reviewListBloc.reviewList[index].rate),
        );
      },
    );

    if(this._reviewListBloc.reviewList.isNotEmpty){
      return listView;
    }
    else{
      return Stack(
        children: <Widget>[
          listView,
          Visibility(
            visible: this._reviewListBloc.isApiResponseReceived,
            child: Container(
              height: UIUtills().screenHeight,
              width: double.infinity,
              alignment: Alignment.center,
              child: Text("You don't have any reviews yet"),
            ),
          )
        ],
      );
//      return Container(height: double.infinity,width: double.infinity,alignment: Alignment.center,child: Text("Yet, You did not receive any review."),);
    }
  }

  Widget mainContainer(String name,String text, int rating) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          name,
          style: UIUtills().getTextStyle(
            fontName: AppFont.sfProDisplayMedium,
            characterSpacing: 0.24,
            fontsize: 12,
          ),
        ), SizedBox(
          height: UIUtills().getProportionalHeight(16),
        ),
        StarRating(
          rating: rating,
          onRatingChanged: (rating) => setState(() => this.rating = rating),
        ),
        SizedBox(
          height: UIUtills().getProportionalHeight(16),
        ),
        Text(
          text,
          maxLines: 3,
          style: UIUtills().getTextStyle(
            fontName: AppFont.sfProDisplayMedium,
            characterSpacing: 0.24,
            fontsize: 10,
          ),
        )
      ],
    );
  }

  void reviewListApi({@required int offset}) {
    final bool isNeedLoader = this._reviewListBloc.reviewList.length == 0;

    _reviewListSubscription =
        this._reviewListBloc.reviewListOptionStream.listen(
      (ReviewResponse response) {
        _reviewListSubscription.cancel();

        Future.delayed(
          Duration(milliseconds: UIUtills().apiCallHaltDurationInMilliSecond),
          () {
            this._reviewListBloc.isApiResponseReceived = true;
            if (isNeedLoader) {
              UIUtills().dismissProgressDialog(context);
            }
            if (!response.status) {
                  Utils.showSnakBarwithKey(_scaffoldKey, response.message);
              return;
            }
            setState(() {});
          },
        );
      },
    );
    this._reviewListBloc.callReviewListApi(offset: offset);
    if (isNeedLoader) {
      UIUtills().showProgressDialog(context);
    }
  }
}

typedef void RatingChangeCallback(double rating);

class StarRating extends StatelessWidget {
  final int starCount;
  final int rating;
  final RatingChangeCallback onRatingChanged;
  final Color color;

  StarRating({this.starCount = 5, this.rating = 0, this.onRatingChanged, this.color});

  Widget buildStar(BuildContext context, int index) {
    Container icon;
    if (index >= rating) {
      icon = Container(
        margin: EdgeInsets.only(right: UIUtills().getProportionalWidth(8)),
        child: Image.asset(
          AppImage.star,
          color: AppColor.dividerBackgroundColor,
          height: UIUtills().getProportionalWidth(12),
          width: UIUtills().getProportionalWidth(12),
          fit: BoxFit.cover,
        ),
      );
    } else if (index > rating - 1 && index < rating) {
      icon = Container(
        margin: EdgeInsets.only(right: UIUtills().getProportionalWidth(8)),
        child: Image.asset(
          AppImage.star,
          color: AppColor.dividerBackgroundColor,
          height: UIUtills().getProportionalWidth(12),
          width: UIUtills().getProportionalWidth(12),
          fit: BoxFit.cover,
        ),
      );
    } else {
      icon = Container(
        margin: EdgeInsets.only(right: UIUtills().getProportionalWidth(8)),
        child: Image.asset(
          AppImage.star,
          color: AppColor.primaryColor,
          height: UIUtills().getProportionalWidth(12),
          width: UIUtills().getProportionalWidth(12),
          fit: BoxFit.cover,
        ),
      );
    }
    return new InkResponse(
      onTap:
          onRatingChanged == null ? null : () => onRatingChanged(index + 1.0),
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Row(
        children: new List.generate(starCount, (index) => buildStar(context, index)));
  }
}
