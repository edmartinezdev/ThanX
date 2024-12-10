
import 'package:rxdart/rxdart.dart';
import 'package:thankxdriver/api_provider/all_request.dart';
import 'package:thankxdriver/api_provider/all_response.dart';
import 'package:thankxdriver/bloc/base_bloc.dart';
import 'package:thankxdriver/validation/validation.dart';
import 'package:tuple/tuple.dart';

class LoginBloc extends BaseBloc {
  final _loginSubject = PublishSubject<LoginResponse>();

  Observable<LoginResponse> get loginOptionStream => _loginSubject.stream;


  final _email = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();

  // add data to stream
  Function(String) get email => _email.sink.add;
  Function(String) get password => _password.sink.add;

  @override
  dispose() {
    super.dispose();
    _email.close();
    _password.close();
    _loginSubject.close();
  }

  Tuple2<bool, String> isValidForm() {
    print('this'+ (this._email.value ?? ''));
    List< Tuple2<ValidationType, String> > arrList = [];
    arrList.add( Tuple2(ValidationType.email, this._email.value ?? ''));
    arrList.add(Tuple2(ValidationType.passWord,this._password.value ?? ''));

    final validationResult = Validation().checkValidationForTextFieldWithType(list: arrList);
    return Tuple2(validationResult.item1, validationResult.item2);
  }

  void callLoginApi() async {
    LoginRequest request = LoginRequest();
    request.email = this._email.value;
    request.password = this._password.value;

    LoginResponse response = await repository.loginApi(params: request);
    _loginSubject.sink.add(response);
  }
}