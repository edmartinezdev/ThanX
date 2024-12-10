import 'package:rxdart/rxdart.dart';
import 'package:thankxdriver/api_provider/all_request.dart';
import 'package:thankxdriver/api_provider/all_response.dart';
import 'package:thankxdriver/bloc/base_bloc.dart';
import 'package:thankxdriver/model/notification_setting%20model.dart';

class NotificationBloc extends BaseBloc {
  List<String> get notificationTypeList => ['Confirm order', 'Order status', 'New order', 'New review received'];

  final _getNotificaionSettingSubject = PublishSubject<  NotificationSettingResponse>();
  Observable<NotificationSettingResponse> get  getNotificaionSettingStream => _getNotificaionSettingSubject.stream;

  final _updateNoticationSettingSubject = PublishSubject< UpdateNotificationSettingResponse>();
  Observable<UpdateNotificationSettingResponse> get updateNoticationSettingStream => _updateNoticationSettingSubject.stream;

  NotificationSettingModel _notificationSettingModel;
  NotificationSettingModel get notificationSettingModel => this._notificationSettingModel;

  @override
  dispose() {
    super.dispose();
    _getNotificaionSettingSubject.close();
    _updateNoticationSettingSubject.close();
  }

  void getNotificationSettingApi() async {
    NotificationSettingResponse response = await repository.getNotificationSettingApi();
    if (response.status) {
      this._notificationSettingModel = response.data;
    }
    _getNotificaionSettingSubject.sink.add(response);
  }



  void updateNotificationSettingApi({  bool isAllowNewReviewReceived,bool  isAllowOrderStatus,bool  isAllowNewOrder}) async {
    UpdateNotificationSettingRequest request = UpdateNotificationSettingRequest();
    request.confirm_order = false;
    request.new_review_received = isAllowNewReviewReceived;
    request.order_status = isAllowOrderStatus;
    request.new_order = isAllowNewOrder;

    UpdateNotificationSettingResponse response = await repository.updateNotificationSettingApi(params: request);
    _updateNoticationSettingSubject.sink.add(response);

  }
}