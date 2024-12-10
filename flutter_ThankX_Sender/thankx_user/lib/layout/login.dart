import 'package:thankx_user/layout/base_stateful.dart';
import 'package:thankx_user/utils/app_color.dart';

class LoginPage extends BaseStatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.whiteColor,
      child: Center(
        child: Text("Demo"),
      ),
    );
  }
}
