import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:thankxdriver/common_widgets/pull_to_refresh_list_view.dart';
import 'package:thankxdriver/control/navigation_serviece.dart';
import 'package:thankxdriver/layout/MyJobs/comman/open_history_list_adapter.dart';
import 'package:thankxdriver/model/my_current_order_model.dart';
import 'package:thankxdriver/utils/app_color.dart';
import 'package:thankxdriver/utils/app_image.dart';
import 'package:thankxdriver/utils/ui_utils.dart';
import 'package:thankxdriver/utils/utils.dart';

import 'ClaimOrder/claim_order.dart';

class ListViewContainer extends StatefulWidget {
  List<MyOrders> arrList;
  final bool isApiCallPending;
  final bool isLoadMoreList;
  final VoidCallback pullToRefreshCallback;
  final VoidCallback loadMoreCallback;

  ListViewContainer({this.arrList, this.isApiCallPending, this.isLoadMoreList, this.pullToRefreshCallback, this.loadMoreCallback});

  @override
  _ListViewContainerState createState() => _ListViewContainerState();
}

class _ListViewContainerState extends State<ListViewContainer> {
  @override
  Widget build(BuildContext context) {
    return lsitWithEmptyContainer();
  }

  Future<void> _onRefreshList() async {
    this.widget.pullToRefreshCallback();
  }

  Widget lsitWithEmptyContainer() {
    if (this.widget.isApiCallPending) {
      return Container();
    }

    final listView = PullToRefreshListView(
      itemCount: this.widget.isLoadMoreList ? this.widget.arrList.length + 1 : this.widget.arrList.length,
      padding: EdgeInsets.only(top: (Platform.isIOS) ? 0 : UIUtills().getProportionalHeight(20)),
      builder: (context, index) {
        if (index == this.widget.arrList.length) {
          Future.delayed(
            Duration(milliseconds: 100),
            () => this.widget.loadMoreCallback(),
          );
          return Utils.buildLoadMoreProgressIndicator();
        }

        return GestureDetector(
          onTap: () async {
            NavigationService().push(MaterialPageRoute(builder: (context) {
              return ClaimOrder(order: this.widget.arrList[index]);
            })).then((r) {
              _onRefreshList();
            });
          },
          child: CardWidget(
            dropDownAddress: this.widget.arrList[index].dropoffLocation.address,
            pickUpAddress: this.widget.arrList[index].pickupLocation.address,
            order: this.widget.arrList[index].orderName,
            text: this.widget.arrList[index].distance,
            color: AppColor.primaryColor,
            padding: EdgeInsets.only(left: UIUtills().getProportionalWidth(12), right: UIUtills().getProportionalWidth(12)),
            dropPointImage: AppImage.circle,
            pickPointImage: AppImage.circle,
          ),
        );
      },
      onRefresh: _onRefreshList,
    );

    if (this.widget.arrList.length > 0) {
      return listView;
    } else {
      return Stack(
        children: <Widget>[
          listView,
          Visibility(
            visible: !this.widget.isApiCallPending,
            child: Container(
              height: UIUtills().screenHeight,
              width: double.infinity,
              alignment: Alignment.center,
              child: Text(
                "There are no orders available",
              ),
            ),
          ),
        ],
      );
    }
  }
}
