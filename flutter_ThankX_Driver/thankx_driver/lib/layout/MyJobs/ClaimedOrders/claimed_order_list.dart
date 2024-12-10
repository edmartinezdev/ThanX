import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:thankxdriver/api_provider/all_response.dart';
import 'package:thankxdriver/bloc/order_list_bloc.dart';
import 'package:thankxdriver/common_widgets/pull_to_refresh_list_view.dart';
import 'package:thankxdriver/control/navigation_serviece.dart';
import 'package:thankxdriver/layout/MyJobs/comman/open_history_list_adapter.dart';
import 'package:thankxdriver/localization/localization.dart';
import 'package:thankxdriver/utils/app_color.dart';
import 'package:thankxdriver/utils/app_image.dart';
import 'package:thankxdriver/utils/ui_utils.dart';
import 'package:thankxdriver/utils/utils.dart';

import 'ClaimedOrderDetails/claimed_order_details.dart';

class ClaimedOrdersList extends StatefulWidget {
  MyJobsOrdersListBloc bloc;

  @override
  _ClaimedOrdersListState createState() => _ClaimedOrdersListState();
}

class _ClaimedOrdersListState extends State<ClaimedOrdersList> {
  MyJobsOrdersListBloc _bloc;
  StreamSubscription<MyJodsOrderListResponse> _myJobsOrdersListSubscription;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {

    super.initState();
    _bloc = MyJobsOrdersListBloc.createWith(bloc: this.widget.bloc);
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
  void dispose() {
    this._bloc.dispose();
    super.dispose();
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
      itemCount: this._bloc.isLoadMore ? (this._bloc.myJobsOrdersList.length + 1) : this._bloc.myJobsOrdersList.length,
      padding: EdgeInsets.only(top:(Platform.isIOS)?0:UIUtills().getProportionalHeight(20)),
      onRefresh: () async => this.ordersListApi(offset: 0),
      builder: (context, index) {
        if (index == this._bloc.myJobsOrdersList.length) {
          Future.delayed(Duration(milliseconds: 100), () => this.ordersListApi(offset: this._bloc.myJobsOrdersList.length),);
          return Utils.buildLoadMoreProgressIndicator();
        }

        return GestureDetector(
          onTap: () {
            final claimedOrderDetail = ClaimedOrderDetails(orders: this._bloc.myJobsOrdersList[index],);
            NavigationService()
                .push(MaterialPageRoute(
                  builder: (context) => claimedOrderDetail)
                ).then((r) {
              ordersListApi(offset: 0);
            });
          },
          child: CardWidget(
            order: this._bloc.myJobsOrdersList[index].orderName,
            text: this._bloc.myJobsOrdersList[index].distance.toString(),
            pickUpAddress: this._bloc.myJobsOrdersList[index].pickupLocation.address,
            dropDownAddress: this._bloc.myJobsOrdersList[index].dropoffLocation.address,
            color: AppColor.primaryColor,
            padding: EdgeInsets.only(
                left: UIUtills().getProportionalWidth(12),
                right: UIUtills().getProportionalWidth(12)),
            dropPointImage: AppImage.circle,
            pickPointImage: AppImage.circle,
          ),
        );
      },
    );
    if(this._bloc.myJobsOrdersList.length != 0){
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
              child: Text("You haven't claimed any jobs yet"),
            ),
          )
        ],
      );
    }
  }

  void ordersListApi({@required int offset}) {
    final bool isNeedLoader =true;

    _myJobsOrdersListSubscription = this._bloc.myJobsOrdersListOptionStream.listen((MyJodsOrderListResponse response) {
        _myJobsOrdersListSubscription.cancel();

        Future.delayed(
          Duration(milliseconds: UIUtills().apiCallHaltDurationInMilliSecond),
          () {
            this._bloc.isApiResponseReceived = true;
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
    this._bloc.callOrdersListApi(
        offset: offset, resultType: AppTranslations.globalTranslations.current);
    if (isNeedLoader) {
      UIUtills().showProgressDialog(context);
    }
  }
}
