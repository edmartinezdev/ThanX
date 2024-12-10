import 'dart:convert';
import 'dart:io' show Platform;

import 'package:adhara_socket_io/manager.dart';
import 'package:adhara_socket_io/options.dart';
import 'package:adhara_socket_io/socket.dart';
import 'package:thankx_user/utils/logger.dart';
import 'package:thankx_user/utils/utils.dart';

import 'all_response.dart';
import 'api_constant.dart';

typedef void SocketConnectionStatusUpdateListener(bool status);

typedef void NotifyProductSoldListener(BaseResponse response);

class SocketProvider {

  //static String _auctionListEvent = 'getAuctionList';
  //static String _auctionItemListEvent = 'getAuctionItems';
  static String _getProductDetailsEvent = 'getProductDetails';
  static String _submitManualBidEvent = 'submitManualBid';
  static String _setAutoBiddingEvent = 'setAutoBidding';
  static String _notifyProductSold = 'notifyProductSold';
  static String _notWinningMessageEvent = 'notWinningMessage';



  SocketIOManager manager = SocketIOManager();
  SocketIO socket;
  static final SocketProvider _singleton = SocketProvider._internal();
  bool _isSocketConnected = false;

  bool get isSocketConnected => this._isSocketConnected;


  SocketConnectionStatusUpdateListener socketUpdateStatusListener ;
  NotifyProductSoldListener notifyProductSoldListener;


  factory SocketProvider() {
    return _singleton;
  }

  SocketProvider._internal() {
    print("Instance created ScoketProvider");
    this.setupSocket();
  }

  Future<void> setupSocket() async {
    final socketIOOption = SocketOptions(ApiConstant.socketBaseUrl, nameSpace: ApiConstant.socketNameSpace, enableLogging: false);
    socket = await manager.createInstance(socketIOOption);
    this._registerOnEvent();
  }

  void _registerOnEvent() {
    if (socket == null) { return; }

    /// Socket connection Event
    socket.onConnect((data) {
      Logger().v("============== socket onConnect =================");
      Logger().v("============== socket Data : $data =================");
      _isSocketConnected = true;

      if (socketUpdateStatusListener != null) {
        socketUpdateStatusListener(_isSocketConnected);
      }
    });

    /// Socket disConnection Event
    socket.onDisconnect((data) {
      _isSocketConnected = false;
      Logger().v("============== socket onDisconnect =================");
      Logger().v("============== socket Data : $data =================");

      if (socketUpdateStatusListener != null) {
        socketUpdateStatusListener(_isSocketConnected);
      }
    });

    /// Socket Event Notify Product sold
    Logger().v("============== Register Event :: ${SocketProvider._notifyProductSold} ==============");
    socket.on(SocketProvider._notifyProductSold, (dynamic data) {
      Logger().v("============== on For Event : ${SocketProvider._notifyProductSold} response : $data =================");


      dynamic response = data;
      if (Platform.isAndroid && (data is String)) {
        response = json.decode(data);
      }
      response = Utils.convertMap(response[0]);

      BaseResponse baseResponse = BaseResponse(status: response["status"],message: response["message"]);
      if(this.notifyProductSoldListener != null) this.notifyProductSoldListener(baseResponse);

    });


  }

  Future<void> connectToServer() async {
    if (socket == null) { return null; }
    Logger().v("Socket Connect ==========================");
    socket.connect();
  }

  Future<void> disconnectFromconnectToServer() {
    if (socket == null) { return null; }
    socket.disconnect();
  }

  void registerBidChange(){
    if(socket == null ) { return ;}


  }



/*
  //region Get Socket AuctionList
  Future<SilentAuctionSocketResponse> getAuctionList() async {
    if(socket == null || _isSocketConnected == null ) {return null;}

    String eventName = SocketProvider._auctionListEvent;

    Logger().v("============== Emit event :: $eventName =================");
    var response = await socket.emitWithAck(eventName, []);
    Logger().v("============== Response $eventName =================");
    Logger().v("Response :: $response");
    if (Platform.isAndroid && (response is String)) {
      response = json.decode(response);
    }
    Map<String, dynamic> mapResponse = Utils.convertMap(response[0]);
    SilentAuctionSocketResponse res = SilentAuctionSocketResponse.fromJson(mapResponse);
    return res;
  }
  //endregion


  //region Get Socket AuctionList
  Future getAuctionItemList({int auctionId, int userId}) async {
    if(socket == null || _isSocketConnected == null ) {return null;}

    String eventName = SocketProvider._auctionItemListEvent;

    Map<String, dynamic> params = Map<String, dynamic>();
    params['auctionId'] = 15; //auctionId;
    params['userId'] = userId;

    Logger().v("============== Emit event :: $eventName params :: $params =================");
    var response = await socket.emitWithAck(eventName, [params]);
    Logger().v("============== Response $eventName =================");
    Logger().v("Response :: $response");
    if (Platform.isAndroid && (response is String)) {
      response = json.decode(response);
    }
    Map<String, dynamic> mapResponse = Utils.convertMap(response[0]);

  }
  //endregion
*/
  //region getting Item Details
//  Future<ItemDetailsResponse> getItemDetailsEvent({int auctionId}) async {
//    if (!_isSocketConnected) { return null; }
//
//    Map<String, dynamic> params = Map<String, dynamic>();
//    params['auctionId'] = auctionId;
//    //params['userId'] = Login;
//
//    String eventName = SocketProvider._getProductDetailsEvent;
//
//
//
//    Logger().v("============== Emit event :: $eventName params :: $params =================");
//    var response = await socket.emitWithAck(eventName, [auctionId]);
//    Logger().v("============== Response $eventName =================");
//    Logger().v("Response :: $response");
//
//
//    if (Platform.isAndroid && (response is String)) {
//      response = json.decode(response);
//    }
//    var itemData = Utils.convertMap(response[0]);
//
//    ItemDetailsResponse itemDetailResponse = ItemDetailsResponse.fromSocketJson(itemData);
//    return itemDetailResponse;
//  }
  //endregion




}