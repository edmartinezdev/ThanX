// region signup Request
import 'dart:io';



// region signup Request

class SignupRequest {
  String email = '';
  String password = '';
  String confirmPassword = '';

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['password'] = this.password;
    data['password_confirmation'] = this.confirmPassword;

    return data;
  }
}
//endregion

