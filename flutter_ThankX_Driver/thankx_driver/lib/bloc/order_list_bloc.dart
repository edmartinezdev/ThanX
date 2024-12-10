import 'package:rxdart/rxdart.dart';
import 'package:thankxdriver/api_provider/all_request.dart';
import 'package:thankxdriver/api_provider/all_response.dart';
import 'package:thankxdriver/layout/MyJobs/ClaimedOrders/ClaimedOrderDetails/claimed_order_details.dart';
import 'package:thankxdriver/model/order_detail_list_model.dart';
import 'package:thankxdriver/model/order_details_data.dart';

import 'base_bloc.dart';

class MyJobsOrdersListBloc extends BaseBloc {

  MyJobsOrdersListBloc.createWith({MyJobsOrdersListBloc bloc}) {
    if (bloc != null) {
      this._myJobsOrdersList = bloc._myJobsOrdersList;
      this._isLoadMore = bloc.isLoadMore;
    }
  }


  final _myJobsOrdersListBlocOptionSubject = PublishSubject<MyJodsOrderListResponse>();
  Observable<MyJodsOrderListResponse> get myJobsOrdersListOptionStream => _myJobsOrdersListBlocOptionSubject.stream;

  bool _isLoadMore = false;
  bool get isLoadMore => _isLoadMore;
  bool isApiResponseReceived = false;

  List<OrderDetailsData> _myJobsOrdersList = [];
  List<OrderDetailsData> get myJobsOrdersList => this._myJobsOrdersList;



  @override
  dispose() {
    super.dispose();
    _myJobsOrdersListBlocOptionSubject.close();
  }


  void callOrdersListApi({int offset, String resultType}) async {
    MyJodsOrderListRequest request = MyJodsOrderListRequest();
    request.limit = this.defaultFetchLimit;
    request.offset = offset;
    request.resultType = resultType;
    MyJodsOrderListResponse response = await repository.getAllMyJodsOrderListApi(params: request);
    if (response.status) {
      if (offset == 0) {
        this._myJobsOrdersList.clear();
      }
      this._myJobsOrdersList.addAll(response.myJodsOrderList.myClaimOrders);
      _isLoadMore = (response.myJodsOrderList.myClaimOrders.isNotEmpty) && ((response.myJodsOrderList.myClaimOrders ?? []).length % this.defaultFetchLimit) == 0;
    }
    _myJobsOrdersListBlocOptionSubject.sink.add(response);

  }

}