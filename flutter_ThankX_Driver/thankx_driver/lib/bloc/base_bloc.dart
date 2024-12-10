
import '../api_provider/api_repository.dart';

class BaseBloc extends Object {


  final repository = AppRepository();
  int get defaultFetchLimit => 10;

  void dispose() {

    print('------------------- ${this} Dispose ------------------- ');
  }

}