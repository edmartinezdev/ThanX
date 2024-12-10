class ReviewModel {
  int totalRecord;
  List<MyReview> myReview;

  ReviewModel({this.totalRecord, this.myReview});

  ReviewModel.fromJson(Map<String, dynamic> json) {
    totalRecord = json['totalRecord'];
    if (json['myReview'] != null) {
      myReview = new List<MyReview>();
      json['myReview'].forEach((v) {
        myReview.add(new MyReview.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalRecord'] = this.totalRecord;
    if (this.myReview != null) {
      data['myReview'] = this.myReview.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MyReview {
  String sId;
  String name;
  String userId;
  int rate;
  String reviews;

  MyReview({this.sId, this.name, this.userId, this.rate, this.reviews});

  MyReview.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    userId = json['userId'];
    rate = json['rate'];
    reviews = json['reviews'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['userId'] = this.userId;
    data['rate'] = this.rate;
    data['reviews'] = this.reviews;
    return data;
  }
}
