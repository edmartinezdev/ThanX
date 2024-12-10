
import 'package:rxdart/rxdart.dart';
import 'package:thankxdriver/api_provider/all_request.dart';
import 'package:thankxdriver/api_provider/all_response.dart';
import 'package:thankxdriver/bloc/base_bloc.dart';
import 'package:thankxdriver/model/order_details_data.dart';
import 'package:thankxdriver/model/user.dart';
import 'package:thankxdriver/validation/validation.dart';
import 'package:tuple/tuple.dart';

class FlagUserAddressBloc extends BaseBloc {

  // Flag User Subject
  final _flagUserSubject = PublishSubject<BaseResponse>();
  Observable<BaseResponse> get flagUserStream => _flagUserSubject.stream;

  // Flag Address Subject
  final _flagAddressSubject = PublishSubject<BaseResponse>();
  Observable<BaseResponse> get flagAddressStream => _flagAddressSubject.stream;


  void flagUserApi(String userID) async {
    FlagUserRequest request = FlagUserRequest();
    request.flaggedUserId = userID;

    BaseResponse response = await repository.flagUser(params: request);
    _flagUserSubject.sink.add(response);
  }

  void flagAddressApi(PickupLocation location) async {
    FlagAddressRequest request = FlagAddressRequest();
    request.latitude = location.latitude;
    request.longitude = location.longitude;
    request.address = location.address;

    BaseResponse response = await repository.flagAddress(params: request);
    _flagAddressSubject.sink.add(response);
  }


  @override
  dispose() {
    super.dispose();
    _flagUserSubject.close();
    _flagAddressSubject.close();
  }


}