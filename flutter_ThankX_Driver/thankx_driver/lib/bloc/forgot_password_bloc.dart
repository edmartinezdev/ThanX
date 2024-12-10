
import 'package:rxdart/rxdart.dart';
import 'package:thankxdriver/bloc/base_bloc.dart';
import 'package:thankxdriver/validation/validation.dart';
import 'package:tuple/tuple.dart';

import '../api_provider/all_request.dart';
import '../api_provider/all_response.dart';

class ForgotPasswordBloc extends BaseBloc {

  final _getApiData = PublishSubject<BaseResponse>();
  Observable<BaseResponse> get forgotPasswordStream => _getApiData.stream;

  final _email = BehaviorSubject<String>();

  // add data to stream
  Function(String) get email => _email.sink.add;

  @override
  dispose() {
    super.dispose();
    _email.close();
    _getApiData.close();
  }

  Tuple2<bool, String> isValidForm() {
    print('this'+ (this._email.value ?? ''));
    List< Tuple2<ValidationType, String> > arrList = [];
    arrList.add( Tuple2(ValidationType.email, this._email.value ?? ''));

    final validationResult = Validation().checkValidationForTextFieldWithType(list: arrList);
    return Tuple2(validationResult.item1, validationResult.item2);
  }

  void callForgotPasswordApi() async {
    ForgotPasswordRequest request = ForgotPasswordRequest();
    request.email = this._email.value;

    BaseResponse response = await repository.forgotPasswordApi(params: request);
    _getApiData.sink.add(response);
  }
}
