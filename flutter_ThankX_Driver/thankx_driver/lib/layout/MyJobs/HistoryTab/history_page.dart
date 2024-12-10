import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:thankxdriver/api_provider/all_response.dart';
import 'package:thankxdriver/bloc/order_list_bloc.dart';
import 'package:thankxdriver/common_widgets/pull_to_refresh_list_view.dart';
import 'package:thankxdriver/layout/MyJobs/comman/open_history_list_adapter.dart';
import 'package:thankxdriver/utils/app_color.dart';
import 'package:thankxdriver/utils/app_image.dart';
import 'package:thankxdriver/utils/ui_utils.dart';
import 'package:thankxdriver/utils/utils.dart';

import 'history_details_page.dart';

class HistoryPage extends StatefulWidget {
  MyJobsOrdersListBloc bloc;

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  MyJobsOrdersListBloc _bloc;
  StreamSubscription<MyJodsOrderListResponse> _myJobsOrdersListSubscription;

  @override
  void initState() {
    super.initState();
    _bloc =
        MyJobsOrdersListBloc.createWith(bloc: this.widget.bloc);
    this.widget.bloc = this._bloc;
    Future.delayed(
      Duration(milliseconds: UIUtills().apiCallHaltDurationInMilliSecond),
      () {
        if (mounted) {
          this.ordersListApi(offset: 0);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return listViewContainer();
  }

  Widget listViewContainer() {
    if (this._bloc.isApiResponseReceived == false) {
      return Container();
    }

    final listView = PullToRefreshListView(
      itemCount: this._bloc.isLoadMore ? this._bloc.myJobsOrdersList.length + 1 : this._bloc.myJobsOrdersList.length,
      padding: EdgeInsets.only(top:(Platform.isIOS)?0:UIUtills().getProportionalHeight(20)),
      onRefresh: () async => this.ordersListApi(offset: 0),
      builder: (context, index) {
        if (index == this._bloc.myJobsOrdersList.length) {
          Future.delayed(Duration(milliseconds: 100), () => this.ordersListApi(offset: this._bloc.myJobsOrdersList.length),);
          return Utils.buildLoadMoreProgressIndicator();
        }
        return GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return HistoryDetailsPage(
                order: this._bloc.myJobsOrdersList[index],
              );
            }));
          },
          child: CardWidget(
            order: this._bloc.myJobsOrdersList[index].orderName,
            pickUpAddress: this._bloc.myJobsOrdersList[index].pickupLocation.address,
            dropDownAddress: this._bloc.myJobsOrdersList[index].dropoffLocation.address,
            text: this._bloc.myJobsOrdersList[index].convertedDateForEdit,
//              "01/04/2010",
            color: AppColor.roundedButtonColor,
            padding: EdgeInsets.only(
                left: UIUtills().getProportionalWidth(40),
                right: UIUtills().getProportionalWidth(40)),
            dropPointImage: AppImage.dropHover,
            pickPointImage: AppImage.dropHover,
          ),
        );
      },

    );

    if(this._bloc.myJobsOrdersList.isNotEmpty){
      return listView;
    }
    else{
      return Stack(
        children: <Widget>[
          listView,
          Visibility(
            visible: this._bloc.isApiResponseReceived,
            child: Container(
              height: UIUtills().screenHeight,
              width: double.infinity,
              alignment: Alignment.center,
              child: Text("You haven't finished any jobs"),
            ),
          )
        ],
      );
//      return Container(
//        height: double.infinity,
//        width: double.infinity,
//        color: Colors.transparent,
//        alignment: Alignment.center,
//        child: Text("Yet, No History is avaliable."),
//      );
    }
  }

  void ordersListApi({@required int offset}) {
    final bool isNeedLoader =true;

    _myJobsOrdersListSubscription =
        this._bloc.myJobsOrdersListOptionStream.listen(
      (MyJodsOrderListResponse response) {
        _myJobsOrdersListSubscription.cancel();

        Future.delayed(
          Duration(milliseconds: UIUtills().apiCallHaltDurationInMilliSecond),
          () {
            this._bloc.isApiResponseReceived = true;
            if (isNeedLoader) {
              UIUtills().dismissProgressDialog(context);
            }
            if (!response.status) {
//                  UIUtills.showSnakBar(context, response.message);
              return;
            }
            setState(() {});
          },
        );
      },
    );
    this._bloc.callOrdersListApi(offset: offset, resultType: "past");
    if (isNeedLoader) {
      UIUtills().showProgressDialog(context);
    }
  }
}
