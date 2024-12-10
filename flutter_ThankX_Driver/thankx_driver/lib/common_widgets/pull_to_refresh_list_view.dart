import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thankxdriver/utils/app_color.dart';

typedef Widget ListBuilderCallBack(BuildContext, int);

class PullToRefreshListView extends StatefulWidget {
  int itemCount;
  VoidCallback onRefresh;
  ScrollPhysics physics;
  ListBuilderCallBack builder;
  EdgeInsets padding = const EdgeInsets.only(bottom: 5.0);
  ScrollController controller;

  PullToRefreshListView(
      {this.itemCount,
      this.padding,
      this.controller,
      this.builder,
      this.onRefresh,
      this.physics});

  @override
  _PullToRefreshListViewState createState() => _PullToRefreshListViewState();
}

class _PullToRefreshListViewState extends State<PullToRefreshListView> {
  //region LoadMore Indictor
  Widget buildLoadMoreProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(15.0),
      child: new Center(
        child: new Opacity(
          opacity: 1.0,
          child: SizedBox(
            child: new CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColor.primaryColor),
              strokeWidth: 2.0,
            ),
            width: 20.0,
            height: 20.0,
          ),
        ),
      ),
    );
  }

  //endregion

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      final silverlistChildDelegate = SliverChildBuilderDelegate(
        this.widget.builder,
        childCount: this.widget.itemCount,
      );

      final scollView = CustomScrollView(
        controller: this.widget.controller,
        physics: this.widget.physics,
        slivers: <Widget>[
          CupertinoSliverRefreshControl(
            onRefresh: this.widget.onRefresh,
            refreshIndicatorExtent: 50.0,
            refreshTriggerPullDistance: 100.0,
          ),
          SliverPadding(
            padding: EdgeInsets.only(top:0),
            sliver: SliverSafeArea(
                sliver: SliverList(
              delegate: silverlistChildDelegate,
            )),
          ),
        ],
      );
      return scollView;
    } else {
      final listView = ListView.builder(
        physics: this.widget.physics,
        padding: this.widget.padding,
        scrollDirection: Axis.vertical,
        itemCount: this.widget.itemCount,
        itemBuilder: this.widget.builder,
        controller: this.widget.controller,
      );

      final refreshIndicator =
          RefreshIndicator(child: listView, onRefresh: this.widget.onRefresh);
      final listViewPullToRefresh = Container(
        child: refreshIndicator,
        alignment: Alignment.center,
      );

      return listViewPullToRefresh;
    }
  }
}
