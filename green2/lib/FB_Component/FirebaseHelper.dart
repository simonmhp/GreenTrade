import 'package:green2/Authentication/component/SignupModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseHelper {
  static Future<SignupModel?> getUserModelById(String uid) async {
    SignupModel? userModel;

    DocumentSnapshot docSnap =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();

    if (docSnap.data() != null) {
      userModel = SignupModel.fromMap(docSnap.data() as Map<String, dynamic>);
    }

    return userModel;
  }
}
