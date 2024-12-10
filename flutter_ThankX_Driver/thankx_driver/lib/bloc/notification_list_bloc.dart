import 'package:rxdart/rxdart.dart';
import 'package:thankxdriver/api_provider/all_request.dart';
import 'package:thankxdriver/api_provider/all_response.dart';
import 'package:thankxdriver/bloc/base_bloc.dart';
import 'package:thankxdriver/model/notification_list_model.dart';

class NotificationListBloc extends BaseBloc {

  NotificationListBloc.createWith({NotificationListBloc bloc}) {
    if (bloc != null) {
      this._notificationList = bloc.notificationList;
      this._isLoadMoreNotification = bloc.isLoadMoreNotification;
    }
  }
  List<MyNotification> _notificationList = [];
  List<MyNotification> get notificationList => this._notificationList;

  bool _isLoadMoreNotification = false;
  bool get isLoadMoreNotification => _isLoadMoreNotification;
  bool isApiResponseReceived = false;

  @override
  dispose() {
    super.dispose();
    _notificationListOptionSubject.close();
    _deleteNotificationSubject.close();
//    _acceptOrRejectSubject.close();
//    _updateReadStatusSubject.close();
  }


  final _notificationListOptionSubject = PublishSubject<NotificationListResponse>();
  Observable<NotificationListResponse> get notificationListOptionStream => _notificationListOptionSubject.stream;
  Future getNotificationListApi(int offset) async {
    NotificationListRequest request= NotificationListRequest();
    request.limit = defaultFetchLimit;
    request.offset = 0;

    NotificationListResponse response = await repository.notificationListTypeApi(params: request);
    if (offset == 0) {
      this._notificationList.clear();
    }
    this._notificationList.addAll(response.notificationListModel.myNotification);
    _isLoadMoreNotification = ((response.notificationListModel.myNotification.length > 0) && ((response.notificationListModel.myNotification.length % this.defaultFetchLimit) == 0)) ? true : false;
    _notificationListOptionSubject.sink.add(response);

//    if (response.status) {
//      _notificationList.clear();
//      _notificationList.addAll(response.data);
//    }
//    _notificationListOptionSubject.sink.add(response);
  }


  final _deleteNotificationSubject = PublishSubject<BaseResponse>();
  Observable<BaseResponse> get deleteNotificationStream => _deleteNotificationSubject.stream;
  Future callDeleteNotifcationApi({MyNotification notification, String notificationId}) async {
    DeleteNotificationRequest request = DeleteNotificationRequest();
    request.notificationId = notificationId;

    BaseResponse response = await repository.deleteNotification(request: request);
    if (response.status) {
      _notificationList.remove(notification);
    }
    _deleteNotificationSubject.sink.add(response);
  }


  final _clearNotificationSubject = PublishSubject<BaseResponse>();
  Observable<BaseResponse> get clearNotificationStream => _clearNotificationSubject.stream;
  Future clearAllNotificationApi() async {
    BaseResponse response = await repository.clearAllNotification();
    if(response.status){
      _notificationList.clear();
    }
    _clearNotificationSubject.sink.add(response);
  }
//  final _updateReadStatusSubject = PublishSubject<BaseResponse>();
//  Observable<BaseResponse> get updateReadStatusStream => _updateReadStatusSubject.stream;
//  Future updateNotificationReadOperationApi({List<NotificationModel> notifications}) async {
//    ReadNotificationRequest request = ReadNotificationRequest();
//    request.notificationIds = notifications.map((n) => n.id).toList();
//    request.isRead = true;
//
//    BaseResponse response = await repository.updateReadNotificationStatusOperation(request: request);
//    _updateReadStatusSubject.sink.add(response);
//  }

//  final _acceptOrRejectSubject = PublishSubject<BaseResponse>();
//  Observable<BaseResponse> get acceptOrRejectStream => _acceptOrRejectSubject.stream;
//  Future acceptDeclineApi({MyNotification notification, bool isAccept, String orderId ,String notificationId, int respType}) async {
//    AcceptDeclineRequest request = AcceptDeclineRequest();
//    request.orderId = orderId;
//    request.notificationId = notificationId;
//    request.respType = respType;
////    request.eventId = notification.referenceId;
////    request.accept = isAccept;
//
//    BaseResponse response = await repository.acceptOrRejectApi(params: request);
//    _acceptOrRejectSubject.sink.add(response);
//  }

//  Future acceptDeclineDropOffApi({MyNotification notification, bool isAccept, String orderId ,String notificationId, int respType}) async {
//    AcceptDeclineRequest request = AcceptDeclineRequest();
//    request.orderId = orderId;
//    request.notificationId = notificationId;
//    request.respType = respType;
////    request.eventId = notification.referenceId;
////    request.accept = isAccept;
//
//    BaseResponse response = await repository.acceptOrRejectDropOffApi(params: request);
//    _acceptOrRejectSubject.sink.add(response);
//  }

}
