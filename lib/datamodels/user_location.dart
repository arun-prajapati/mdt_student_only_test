class UserLocation {
  final String latitude;
  final String longitude;

  UserLocation({required this.latitude, required this.longitude});
}

class UserModel {
  bool? success;
  String? token;
  String? userId;
  int? userType;
  String? userName;
  String? eMail;
  // String? planType;

  UserModel({
    this.success,
    this.token,
    this.userId,
    this.userType,
    this.userName,
    this.eMail,
    // this.planType
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    token = json['token'];
    userId = json['user_id'].toString();
    userType = json['user_type'];
    userName = json['user_name'];
    eMail = json['e_mail'];
    // planType = json['plan_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['token'] = this.token;
    data['user_id'] = this.userId;
    data['user_type'] = this.userType;
    data['user_name'] = this.userName;
    data['e_mail'] = this.eMail;
    // data['plan_type'] = this.planType;
    return data;
  }
}
