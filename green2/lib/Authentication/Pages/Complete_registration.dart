import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:green2/Authentication/component/SignupModel.dart';
import 'package:green2/Initial/pages/HasUser.dart';
import 'package:green2/animation/FadeAnimation.dart';
// import 'package:green2/Authentication/login.dart';
import 'package:green2/animation/components/GradientBackgroundButton.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class CompleteProfile extends StatefulWidget {
  final SignupModel signupModel;
  final User firebaseUser;

  // BuildContext context = con
  static GlobalKey rootWidgetKey = GlobalKey();

  const CompleteProfile(
      {super.key, required this.signupModel, required this.firebaseUser});

  @override
  State<CompleteProfile> createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  final _Fullname = TextEditingController();
  final _location = TextEditingController();
  // final _passwordcontroller = TextEditingController();
  // final _repasswordcontroller = TextEditingController();

  File? imageFile;

  void selectImage(ImageSource source) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      cropImage(pickedFile);
    }
  }

  void cropImage(XFile file) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
        sourcePath: file.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 20);

    if (croppedImage != null) {
      setState(() {
        imageFile = File(croppedImage.path);
      });
    }
  }

  void showPhotoOption() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Upload Profile Picture"),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  selectImage(ImageSource.gallery);
                },
                leading: const Icon(Icons.photo_album),
                title: const Text("Select from Gallery."),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  selectImage(ImageSource.camera);
                },
                leading: Icon(Icons.camera_alt),
                title: Text("Take a photo!"),
              ),
            ]),
          );
        });
  }

  void checkValues() {
    showToast(context, "Signing you up!");
    String fullname = _Fullname.text.trim();
    String location = _location.text.trim();
    if (fullname == "" || imageFile == null || location == "") {
      print("fill Details");
      showToast(context, "fill Details");
    } else {
      uploadData();
    }
  }

  void showToast(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2), // Adjust the duration as needed
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void uploadData() async {
    UploadTask uploadTask = FirebaseStorage.instance
        .ref("Profilepicture")
        .child(widget.signupModel.uid.toString())
        .putFile(imageFile!);

    TaskSnapshot snapshot = await uploadTask;
    String imageUrl = await snapshot.ref.getDownloadURL();
    String fullname = _Fullname.text.trim();
    String location = _location.text.trim();

    widget.signupModel.fullname = fullname;
    widget.signupModel.location = location;
    widget.signupModel.profilepic = imageUrl;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.signupModel.uid)
        .set(widget.signupModel.toMap())
        .then((value) => {
              print("Profile created!"),
              showToast(context, "Profile created!"),
              Navigator.pop(context),
              Navigator.pop(context),
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return HasUserHome();
              }))
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 40,
          ),
          height: MediaQuery.of(context).size.height - 50,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(top: 120.0),
            child: Column(
              children: <Widget>[
                const FadeAnimation(
                    1,
                    Text(
                      "Complete Profile",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    )),
                const SizedBox(
                  height: 70,
                ),
                Column(
                  children: [
                    FadeAnimation(
                      1.2,
                      CupertinoButton(
                        onPressed: () {
                          showPhotoOption();
                        },
                        padding: EdgeInsets.all(0),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundImage: (imageFile != null)
                              ? FileImage(imageFile!)
                              : null,
                          child: (imageFile == null)
                              ? const Icon(
                                  Icons.person,
                                  size: 60,
                                )
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    FadeAnimation(1.2,
                        makeInput(label: "Full Name", controller: _Fullname)),
                    FadeAnimation(1.2,
                        makeInput2(label: "location", controller: _location)),
                    const SizedBox(
                      height: 16,
                    ),
                    FadeAnimation(
                      1.3,
                      Container(
                        padding: const EdgeInsets.only(top: 3, left: 3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: GradientBackgroundButton(
                          materialStatePropertyShape:
                              MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          )),
                          icon: const Icon(Icons.done,
                              color: Colors.white, size: 20),
                          leftIcon: 20,
                          gradient: const LinearGradient(
                            colors: <Color>[
                              Color(0xff004d7a),
                              Color(0xff008793),
                              Color(0xff00bf72),
                              Color(0xffa8eb12)
                            ],
                          ),
                          onPressed: () {
                            checkValues();
                          },
                          child: const Text('Submit',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget makeInput(
      {label, obscureText = false, required TextEditingController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
        ),
        const SizedBox(
          height: 5,
        ),
        TextField(
          controller: _Fullname,
          obscureText: obscureText,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromARGB(255, 86, 77, 77))),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromARGB(255, 86, 77, 77))),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
      ],
    );
  }

  Widget makeInput2(
      {label, obscureText = false, required TextEditingController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
        ),
        const SizedBox(
          height: 5,
        ),
        TextField(
          controller: _location,
          obscureText: obscureText,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromARGB(255, 86, 77, 77))),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromARGB(255, 86, 77, 77))),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
      ],
    );
  }
}
