class CMSModel {
  String sId;
  String aboutUs;
  String privacyPolicyUser;
  String privacyPolicyDriver;
  String termsConditionUser;
  String termsConditionDriver;
  String productGuidlines;
  String taxInformation;
  String w9Form;


  CMSModel(
      {this.sId,
        this.aboutUs,
        this.privacyPolicyUser,
        this.privacyPolicyDriver,
        this.termsConditionUser,
        this.termsConditionDriver,
        this.productGuidlines,
        this.taxInformation,
        this.w9Form});

//  static List<CMSModel> getListData(List<dynamic> json){
//    if (json != null) {
//      List<CMSModel> data = new List<CMSModel>();
//      json.forEach((v) {data.add(new CMSModel.fromJson(v));});
//      return data;
//    }else return [];
//  }
//  static List<CMSModel> fromData (List<dynamic> a){
//    List<CMSModel> list = new List<CMSModel>();
//    if (a != null) {
//      a.forEach((v) {
//        list.add(new CMSModel.fromJson((v)));
//      });
//    }
//    return list;
//  }

  CMSModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    aboutUs = json['aboutUs_driver'];
    privacyPolicyUser = json['privacyPolicyUser'];
    privacyPolicyDriver = json['privacyPolicyDriver'];
    termsConditionUser = json['termsConditionUser'];
    termsConditionDriver = json['termsConditionDriver'];
    productGuidlines = json['productGuidlines'];
    taxInformation = json['taxInformation'];
    w9Form = json['w9Form'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['aboutUs_driver'] = this.aboutUs;
    data['privacyPolicyUser'] = this.privacyPolicyUser;
    data['privacyPolicyDriver'] = this.privacyPolicyDriver;
    data['termsConditionUser'] = this.termsConditionUser;
    data['termsConditionDriver'] = this.termsConditionDriver;
    data['productGuidlines'] = this.productGuidlines;
    data['taxInformation'] = this.taxInformation;
    data['w9Form'] = this.w9Form;
    return data;
  }
}
