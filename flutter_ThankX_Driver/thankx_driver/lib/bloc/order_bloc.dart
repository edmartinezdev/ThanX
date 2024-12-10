import 'package:rxdart/rxdart.dart';
import 'package:thankxdriver/api_provider/all_request.dart';
import 'package:thankxdriver/api_provider/all_response.dart';
import 'package:thankxdriver/model/order_details_data.dart';
import 'package:thankxdriver/model/user.dart';

import 'base_bloc.dart';

class OrderDetailsBloc extends BaseBloc {

 int orderStatus = 5;

   // get Order Details
  PublishSubject<OrderDetailsResponse> _orderDetailsSubject = PublishSubject<OrderDetailsResponse>();
  Observable<OrderDetailsResponse> get orderDetailsStream => _orderDetailsSubject.stream;

  OrderDetailsData orderDetailsData = OrderDetailsData();
  String time= "0 mins";

  void getOrderDetails( String orderId) async {
    OrderDetailsRequest request = OrderDetailsRequest();
    request.orderId = orderId;

    OrderDetailsResponse response = await repository.getOrderDetails(params: request);

   _orderDetailsSubject.sink.add(response);
  }

  // get Order Details
  final _claimOrderSubject = PublishSubject<BaseResponse>();
  Observable<BaseResponse> get claimOrderStream => _claimOrderSubject.stream;

  bool isOrderClaimed = false;

  void claimOrder(String orderId) async {
    ClaimOrderRequest request = ClaimOrderRequest();
    request.orderId = orderId;
    request.userId = User.currentUser.sId;


    BaseResponse response = await repository.claimOrder(params: request);
    _claimOrderSubject.sink.add(response);
  }

  @override
  dispose() {
    super.dispose();
    _orderDetailsSubject.close();
    _claimOrderSubject.close();
  }

}