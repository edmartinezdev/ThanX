import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';
import 'package:thankxdriver/api_provider/all_request.dart';
import 'package:thankxdriver/api_provider/all_response.dart';
import 'package:thankxdriver/model/my_current_order_model.dart';

import 'base_bloc.dart';

class MyCurrentOrderListBloc extends BaseBloc {

  LatLng latLng;

  final _myCurrentOrderListBlocOptionSubject = PublishSubject<MyCurrentOrderListResponse>();
  Observable<MyCurrentOrderListResponse> get myCurrentOrderListOptionStream => _myCurrentOrderListBlocOptionSubject.stream;


  List<LatLng> get latLngList{
    List<LatLng> list = List();
    for (int i =0;i<_orderList.length ; i++){
      list.add(LatLng(_orderList[i].pickupLocation.latitude, _orderList[i].pickupLocation.longitude));
    }
    return list;
  }

  @override
  dispose() {

    super.dispose();
    _myCurrentOrderListBlocOptionSubject.close();

  }

  MyCurrentOrderModel myCurrentOrderModel;
  List<MyOrders> _orderList = [];
  List<MyOrders> get orderList => this._orderList;
  bool isApiResponseReceived = false;
  bool _isLoadMoreList = false;
  bool get isLoadMoreList => this._isLoadMoreList;

  void callMyCurrentOrderListApi({int offset}) async {
    MyCurrentOrderListRequest request = MyCurrentOrderListRequest();
    request.limit = this.defaultFetchLimit;
    request.offset = offset;
    request.lat = this.latLng?.latitude ?? 40.0024137;
    request.long = this.latLng?.longitude ?? -75.2581112;

    MyCurrentOrderListResponse response = await repository.getAllMyCurrentOrderListApi(params: request);
    if (response.status) {
      myCurrentOrderModel = response.myCurrentOrderList;
      if (offset == 0) {
        _orderList.clear();
      }
      _orderList.addAll(response.myCurrentOrderList.myOrders);
      _isLoadMoreList = (response.myCurrentOrderList.myOrders.isNotEmpty) && ((response.myCurrentOrderList.myOrders ?? []).length % this.defaultFetchLimit) == 0;
    }
    _myCurrentOrderListBlocOptionSubject.sink.add(response);

  }

}