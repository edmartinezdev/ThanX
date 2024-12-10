import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:thankxdriver/api_provider/all_request.dart';
import 'package:thankxdriver/api_provider/all_response.dart';
import 'package:thankxdriver/model/order_details_data.dart';
import 'package:thankxdriver/model/user.dart';
import 'package:tuple/tuple.dart';

import 'base_bloc.dart';

class  OrderTrackingBloc extends BaseBloc {


  int orderTrackingStatus ;

  // get Order Details
  final _confirmOrderPickUp = PublishSubject<BaseResponse>();
  Observable<BaseResponse> get confirmOrderPickUpStream => _confirmOrderPickUp.stream;

  OrderDetailsData orderDetailsData ;

  void confirmOrderPickUp(String orderId) async {

    ClaimOrderRequest request = ClaimOrderRequest();
    request.orderId = orderId;

    BaseResponse response = await repository.confirmOrderPickUp(params: request);
    _confirmOrderPickUp.sink.add(response);

  }

  // get Order Details
  final _confirmOrderDropOff = PublishSubject<BaseResponse>();
  Observable<BaseResponse> get confirmOrderDropOffStream => _confirmOrderDropOff.stream;

  String pinText;
  String dropOffMessage= "";
  File dropOffImage;

  Tuple2<bool, String> isValidDropOffPin() {
    if(pinText.length < 4){
      return Tuple2(false, "please enter valid Pin");
    } else{
      return Tuple2(true, "");
    }
  }

  Tuple2<bool, String> isValidFormDropOffimage() {
       if (dropOffMessage == "" && !this.orderDetailsData.atHome){
        return Tuple2(false, "please enter Drop off Message");
      }else if (dropOffImage == null && !this.orderDetailsData.atHome){
        return Tuple2(false, "please select a Drop off Image");
      }
      else{
        return Tuple2(true, "");
      }
  }

  void confirmOrderDropOff(String orderId,) async {
    OrderDropOffRequest request = OrderDropOffRequest();
    request.orderId = orderId;
    request.confirmationCode = pinText;
    request.dropMessage = dropOffMessage;
    request.selectedFile = dropOffImage;

    BaseResponse response = await repository.confirmDropOff(params: request);
    _confirmOrderDropOff.sink.add(response);

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
    _confirmOrderPickUp.close();
    _confirmOrderDropOff.close();
    _claimOrderSubject.close();
  }

}