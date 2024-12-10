import 'package:rxdart/rxdart.dart';
import 'package:thankxdriver/api_provider/all_request.dart';
import 'package:thankxdriver/api_provider/all_response.dart';
import 'package:thankxdriver/model/review_model.dart';

import 'base_bloc.dart';

class ReviewListBloc extends BaseBloc {

  ReviewListBloc.createWith({ReviewListBloc bloc}) {
    if (bloc != null) {
      this._reviewList = bloc.reviewList;
      this._isLoadMore = bloc.isLoadMore;
    }
  }


  final _reviewListBlocOptionSubject = PublishSubject<ReviewResponse>();
  Observable<ReviewResponse> get reviewListOptionStream => _reviewListBlocOptionSubject.stream;

  bool _isLoadMore = false;
  bool get isLoadMore => _isLoadMore;
  bool isApiResponseReceived = false;

  List<MyReview> _reviewList = [];
  List<MyReview> get reviewList => this._reviewList;



  @override
  dispose() {
    super.dispose();
    _reviewListBlocOptionSubject.close();
  }


  void callReviewListApi({int offset}) async {
    ReviewRequest request = ReviewRequest();
    request.limit = this.defaultFetchLimit;
    request.offset = offset;

    ReviewResponse response = await repository.getAllReviewListApi(params: request);
    if (offset == 0) {
      this._reviewList.clear();
    }
    this._reviewList.addAll(response.data.myReview);
    _isLoadMore = ((response.data.myReview.isNotEmpty) && (response.data.myReview.length % this.defaultFetchLimit) == 0);
    _reviewListBlocOptionSubject.sink.add(response);

  }

}