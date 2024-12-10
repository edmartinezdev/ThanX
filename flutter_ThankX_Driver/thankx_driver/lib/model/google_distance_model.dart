class DistanceModel {
  String status;
  List<String> originAddresses;
  List<String> destinationAddresses;
  List<Rows> rows;

  DistanceModel(
      {this.status,
        this.originAddresses,
        this.destinationAddresses,
        this.rows});

  DistanceModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    originAddresses = json['origin_addresses'].cast<String>();
    destinationAddresses = json['destination_addresses'].cast<String>();
    if (json['rows'] != null) {
      rows = new List<Rows>();
      json['rows'].forEach((v) {
        rows.add(new Rows.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['origin_addresses'] = this.originAddresses;
    data['destination_addresses'] = this.destinationAddresses;
    if (this.rows != null) {
      data['rows'] = this.rows.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Rows {
  List<Elements> elements;

  Rows({this.elements});

  Rows.fromJson(Map<String, dynamic> json) {
    if (json['elements'] != null) {
      elements = new List<Elements>();
      json['elements'].forEach((v) {
        elements.add(new Elements.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.elements != null) {
      data['elements'] = this.elements.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Elements {
  String status;
  DeliveryDuration duration;
  Distance distance;

  Elements({this.status, this.duration, this.distance});

  Elements.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    duration = json['duration'] != null
        ? new DeliveryDuration.fromJson(json['duration'])
        : null;
    distance = json['distance'] != null
        ? new Distance.fromJson(json['distance'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.duration != null) {
      data['duration'] = this.duration.toJson();
    }
    if (this.distance != null) {
      data['distance'] = this.distance.toJson();
    }
    return data;
  }
}

class DeliveryDuration {
  int value;
  String text;

  DeliveryDuration({this.value, this.text});

  DeliveryDuration.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['text'] = this.text;
    return data;
  }
}
class Distance {
  int value;
  String text;

  Distance({this.value, this.text});

  Distance.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['text'] = this.text;
    return data;
  }
}