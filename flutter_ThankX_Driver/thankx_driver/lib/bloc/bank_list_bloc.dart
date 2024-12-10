import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:thankxdriver/api_provider/all_request.dart';
import 'package:thankxdriver/api_provider/all_response.dart';
import 'package:thankxdriver/bloc/base_bloc.dart';
import 'package:thankxdriver/model/bank_list_model.dart';
import 'package:thankxdriver/model/user.dart';

class BankListBloc extends BaseBloc {
  /// Bank List
  final _bankListOptionSubject = PublishSubject<BankListResponse>();

  Observable<BankListResponse> get bankListOptionStream => _bankListOptionSubject.stream;

//  List<BankListModel> bankListModels = [];
//  List<BankListModel> get bankListModel => this.bankListModels;

  bool isApiResponseReceived = false;

  List<BankListModel> aryOfBankList = [];

  int get bankCount => aryOfBankList.length + 1;


  /// For Delete
  int currentCardIndex = 0;
  DeleteBankRequest request = DeleteBankRequest();

  PublishSubject<BaseResponse> _deleteBankSubject = PublishSubject<BaseResponse>();

  Observable<BaseResponse> get deleteBankStream => _deleteBankSubject.stream;

  @override
  dispose() {
    super.dispose();
    _bankListOptionSubject.close();
    _deleteBankSubject.close();
  }

  /// Api Bank List
  void apiCallBankList() async {
    BankListRequest request = BankListRequest();
    request.userId = User.currentUser.sId;

    BankListResponse response = await repository.getAllBankList(params: request);
    if (response.status) {
      aryOfBankList.clear();
      aryOfBankList.addAll(response.data);
    }
    _bankListOptionSubject.sink.add(response);
  }

  /// Api Delete
  void apiCallDeleteBankDetails(String bankAccountId) async {
    request.bankAccountId = bankAccountId;
    BaseResponse response = await repository.deleteBank(params: request);
    _deleteBankSubject.sink.add(response);
  }
//endregion
}
