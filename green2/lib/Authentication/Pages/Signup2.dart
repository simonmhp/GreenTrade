import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:green2/Authentication/Pages/Complete_registration.dart';
import 'package:green2/Authentication/component/SignupModel.dart';
import 'package:green2/animation/FadeAnimation.dart';
import 'package:green2/animation/components/GradientBackgroundButton.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController PasswordController = TextEditingController();
  TextEditingController CPasswordController = TextEditingController();

  void checkvalues() {
    String email = emailController.text.trim();
    String password = PasswordController.text.trim();
    String cpassword = CPasswordController.text.trim();
    if (email == "" || password == "" || cpassword == "") {
      showToast(context, "fill fields!");
      print("fill fields!");
    } else if (cpassword != password) {
      showToast(context, "passwords don't match!");
      print("passwords don't match!");
    } else {
      showToast(context, "Signing You Up!");
      signUp(email, password);
    }
  }

  void signUp(String email, String password) async {
    UserCredential? credential;
    try {
      credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (ex) {
      showToast(context, ex.code.toString());
      print(ex.code.toString());
    }

    if (credential != null) {
      String uid = credential.user!.uid;
      SignupModel newUser = SignupModel(
        uid: uid,
        fullname: "",
        email: email,
        profilepic: "",
        request: {},
        blocked: {},
        favorite: {},
        requestCount: "0",
        location: "",
        MyProducts: [],
        accountType: "user",
      );
      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .set(newUser.toMap())
          .then((value) => {
                print("New User Created"),
                showToast(context, "New User Created"),
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return CompleteProfile(
                      signupModel: newUser, firebaseUser: credential!.user!);
                }))
              });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.symmetric(horizontal: 40),
        child: Center(
          child: SingleChildScrollView(
              child: Column(
            children: <Widget>[
              const FadeAnimation(
                  1,
                  Text(
                    "SignUp",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  )),
              const SizedBox(
                height: 20,
              ),
              const FadeAnimation(
                1.2,
                Text(
                  "Create an account, It's free",
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Column(
                children: <Widget>[
                  FadeAnimation(1.2,
                      makeInput(label: "Email", controller: emailController)),
                  FadeAnimation(
                      1.3,
                      makeInput1(
                          label: "Password",
                          obscureText: true,
                          controller: PasswordController)),
                  FadeAnimation(
                      1.4,
                      makeInput2(
                          label: "Confirm Password",
                          obscureText: true,
                          controller: CPasswordController)),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              // CupertinoButton(
              //     color: Theme.of(context).colorScheme.secondary,
              //     onPressed: () {
              //       checkvalues();
              //     },
              //     child: const Text("Sign Up")),
              FadeAnimation(
                1.5,
                Container(
                  padding: const EdgeInsets.only(top: 3, left: 25, right: 25),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: GradientBackgroundButton(
                    materialStatePropertyShape:
                        MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    )),
                    icon: const Icon(Icons.login_rounded,
                        color: Colors.white, size: 20),
                    leftIcon: 20,
                    child: Text('Sign up',
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                    gradient: const LinearGradient(
                      colors: <Color>[
                        Color(0xff004d7a),
                        Color(0xff008793),
                        Color(0xff00bf72),
                        Color(0xffa8eb12)
                      ],
                    ),
                    onPressed: () {
                      checkvalues();
                    },
                  ),
                ),
              ),
            ],
          )),
        ),
      )),
      bottomNavigationBar: Container(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 25.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Already have a account?",
                style: TextStyle(fontSize: 16),
              ),
              CupertinoButton(
                child: const Text(
                  "Login!",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget makeInput1(
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
          controller: PasswordController,
          obscureText: obscureText,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
            border:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
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
          controller: CPasswordController,
          obscureText: obscureText,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
            border:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
      ],
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
          controller: emailController,
          obscureText: obscureText,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
            border:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
      ],
    );
  }

  void showToast(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2), // Adjust the duration as needed
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
