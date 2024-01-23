class SignupModel {
  String? uid;
  String? fullname;
  String? location;
  String? email;
  String? profilepic;
  String? requestCount;
  String? accountType;
  Map<String, dynamic>? blocked;
  Map<String, dynamic>? request;
  Map<String, dynamic>? favorite;
  List<dynamic>? MyProducts;

  SignupModel({
    this.uid,
    this.fullname,
    this.location,
    this.email,
    this.profilepic,
    this.requestCount,
    this.request,
    this.blocked,
    this.favorite,
    this.MyProducts,
    this.accountType,
  });

  SignupModel.fromMap(Map<String, dynamic> map) {
    uid = map["uid"];
    fullname = map["fullname"];
    location = map["location"];
    email = map["email"];
    profilepic = map["profilepic"];
    blocked = map["blocked"];
    favorite = map["favorite"];
    MyProducts = map["MyProducts"];
    request = map["request"];
    requestCount = map["requestCount"];
    accountType = map["accountType"];
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "fullname": fullname,
      "location": location,
      "email": email,
      "profilepic": profilepic,
      "blocked": blocked,
      "request": request,
      "favorite": favorite,
      "requestCount": requestCount,
      "MyProducts": MyProducts,
      "accountType": accountType,
    };
  }
}
