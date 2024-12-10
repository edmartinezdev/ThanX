class CheckStripeAccountModel {
  Requirements requirements;
  String status;

  CheckStripeAccountModel({this.requirements, this.status});

  CheckStripeAccountModel.fromJson(Map<String, dynamic> json) {
    requirements = json['requirements'] != null
        ? new Requirements.fromJson(json['requirements'])
        : null;
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.requirements != null) {
      data['requirements'] = this.requirements.toJson();
    }
    data['status'] = this.status;
    return data;
  }
}

class Requirements {
  List<String> currentlyDue;
  List<String> errors;
  List<String> eventuallyDue;
  List<String> pastDue;
  List<String> pendingVerification;

  Requirements(
      {this.currentlyDue,
      this.errors,
      this.eventuallyDue,
      this.pastDue,
      this.pendingVerification});

  Requirements.fromJson(Map<String, dynamic> json) {
    currentlyDue = json['currently_due'].cast<String>();
    errors = json['errors'].cast<String>();
    eventuallyDue = json['eventually_due'].cast<String>();
    pastDue = json['past_due'].cast<String>();
    pendingVerification = json['pending_verification'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['currently_due'] = this.currentlyDue;
    data['errors'] = this.errors;
    data['eventually_due'] = this.eventuallyDue;
    data['past_due'] = this.pastDue;
    data['pending_verification'] = this.pendingVerification;
    return data;
  }
}
