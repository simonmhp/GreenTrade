// // ignore_for_file: use_build_context_synchronously

// // import 'dart:html';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:green2/Authentication/Pages/Complete_registration.dart';
// import 'package:green2/Authentication/component/SignupModel.dart';
// import 'package:green2/animation/FadeAnimation.dart';
// import 'package:green2/Authentication/login.dart';
// import 'package:green2/animation/components/GradientBackgroundButton.dart';

// class SignupPage extends StatefulWidget {
//   const SignupPage({super.key});

//   // BuildContext context = con
//   static GlobalKey rootWidgetKey = GlobalKey();

//   @override
//   State<SignupPage> createState() => _SignupPageState();
// }

// class _SignupPageState extends State<SignupPage> {
//   final _emailcontroller = TextEditingController();
//   final _passwordcontroller = TextEditingController();
//   final _repasswordcontroller = TextEditingController();

//   void checkValues() {
//     if (_passwordcontroller.text.isNotEmpty ||
//         _repasswordcontroller.text.isNotEmpty ||
//         _emailcontroller.text.isNotEmpty) {
//       _register();
//     } else {
//       showErrorMessage("Fill all Fields!");
//     }
//   }

//   // void _register() async {
//   //   // showDialog(
//   //   //   context: context,
//   //   //   builder: (context) {
//   //   //     return Center(
//   //   //       child: CircularProgressIndicator(),
//   //   //     );
//   //   //   },
//   //   // );

//   //   try {
//   //     if (_passwordcontroller.text == _repasswordcontroller.text) {
//   //       UserCredential userCredential = await FirebaseAuth.instance
//   //           .createUserWithEmailAndPassword(
//   //               email: _emailcontroller.text,
//   //               password: _passwordcontroller.text);

//   //       String uid = userCredential.user!.uid;
//   //       SignupModel newUser = SignupModel(
//   //         uid: uid,
//   //         fullname: _emailcontroller.text.split('@')[0],
//   //         email: _emailcontroller.text,
//   //         profilepic:
//   //             "https://firebasestorage.googleapis.com/v0/b/green2-ac285.appspot.com/o/images%2FScreenshot_20231110-175211743%20(1).jpg?alt=media&token=36734bdf-f74e-48f6-b8e6-494afd9fe3e5",
//   //         requestCount: '0',
//   //         request: {},
//   //         blocked: {},
//   //       );

//   //       await FirebaseFirestore.instance
//   //           .collection("users")
//   //           .doc(uid)
//   //           .set(newUser.toMap())
//   //           .then((value) {
//   //         print("New User Created!");
//   //         Navigator.push(
//   //           context,
//   //           MaterialPageRoute(builder: (context) {
//   //             return CompleteProfile(
//   //               signupModel: newUser,
//   //               firebaseUser: userCredential.user!,
//   //             );
//   //           }),
//   //         );
//   //       });
//   //     } else {
//   //       showErrorMessage("Passwords don't match!");
//   //     }
//   //   } on FirebaseAuthException catch (e) {
//   //     showErrorMessage(e.code);
//   //   } finally {
//   //     Navigator.pop(
//   //         context); // Close the loading dialog regardless of success or failure
//   //   }
//   // }

//   void _register() async {
//     // stdout.writeln(emailContoller.text); // not working... donno why?
//     //devLog.log(emailContoller.text.toString(), name: "Auth_logs1");

//     // showDialog(
//     //     context: context,
//     //     builder: (context) {
//     //       return const Center(
//     //         child: CircularProgressIndicator(),
//     //       );
//     //     });
//     try {
//       if (_passwordcontroller.text == _repasswordcontroller.text) {
//         UserCredential userCredential = await FirebaseAuth.instance
//             .createUserWithEmailAndPassword(
//                 email: _emailcontroller.text,
//                 password: _passwordcontroller.text);

//         String uid = userCredential.user!.uid;
//         SignupModel newUser = SignupModel(
//           uid: uid,
//           fullname: "", // Set your desired default value
//           email: _emailcontroller.text,
//           profilepic: "", // Set your desired default value
//           request: {},
//           blocked: {},
//         );
//         await FirebaseFirestore.instance
//             .collection("users")
//             .doc(uid)
//             .set(newUser.toMap())
//             .then((value) {
//           print("New User Created!");
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) {
//               return CompleteProfile(
//                 signupModel: newUser,
//                 firebaseUser: userCredential.user!,
//               );
//             }),
//           );
//         });
//       } else {
//         showErrorMessage("Passwords don't match!");
//       }
//     } on FirebaseAuthException catch (e) {
//       showErrorMessage(e.code);
//     } finally {
//       Navigator.pop(context);
//     }
//   }

//   void showErrorMessage(String message) {
//     if (message.isEmpty) {
//       showDialog(
//           context: context,
//           builder: (context) {
//             return const AlertDialog(
//               title: Center(
//                   child: Text(
//                 "Server-Error!",
//                 style: TextStyle(color: Colors.black),
//               )),
//             );
//           });
//     } else {
//       showDialog(
//           context: context,
//           builder: (context) {
//             return AlertDialog(
//               title: Center(
//                   child: Text(
//                 message,
//                 style: const TextStyle(color: Colors.black),
//               )),
//             );
//           });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.white,
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: const Icon(
//             Icons.arrow_back_ios,
//             size: 20,
//             color: Colors.black,
//           ),
//         ),
//         systemOverlayStyle: SystemUiOverlayStyle.dark,
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 40),
//           height: MediaQuery.of(context).size.height - 50,
//           width: double.infinity,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: <Widget>[
//               const Column(
//                 children: <Widget>[
//                   FadeAnimation(
//                     1,
//                     Text(
//                       "Sign up",
//                       style: TextStyle(
//                         fontSize: 30,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   FadeAnimation(
//                     1.2,
//                     Text(
//                       "Create an account, It's free",
//                       style: TextStyle(fontSize: 15, color: Colors.grey),
//                     ),
//                   ),
//                 ],
//               ),
//               Column(
//                 children: <Widget>[
//                   FadeAnimation(1.2,
//                       makeInput(label: "Email", controller: _emailcontroller)),
//                   FadeAnimation(
//                       1.3,
//                       makeInput1(
//                           label: "Password",
//                           obscureText: true,
//                           controller: _passwordcontroller)),
//                   FadeAnimation(
//                       1.4,
//                       makeInput2(
//                           label: "Confirm Password",
//                           obscureText: true,
//                           controller: _repasswordcontroller)),
//                 ],
//               ),
//               FadeAnimation(
//                 1.5,
//                 Container(
//                   padding: const EdgeInsets.only(top: 3, left: 3),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(50),
//                     // border: const Border(
//                     //   bottom: BorderSide(color: Colors.black),
//                     //   top: BorderSide(color: Colors.black),
//                     //   left: BorderSide(color: Colors.black),
//                     //   right: BorderSide(color: Colors.black),
//                     // ),
//                   ),
//                   child: GradientBackgroundButton(
//                     materialStatePropertyShape:
//                         MaterialStateProperty.all(RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(18.0),
//                     )),
//                     icon: const Icon(Icons.login_rounded,
//                         color: Colors.white, size: 20),
//                     leftIcon: 20,
//                     child: Text('Sign up',
//                         style: TextStyle(fontSize: 18, color: Colors.white)),
//                     gradient: const LinearGradient(
//                       colors: <Color>[
//                         Color(0xff004d7a),
//                         Color(0xff008793),
//                         Color(0xff00bf72),
//                         Color(0xffa8eb12)
//                       ],
//                     ),
//                     onPressed: () {
//                       checkValues();
//                       // Navigator.push(
//                       //   context,
//                       //   MaterialPageRoute(builder: (context) {
//                       //     return CompleteProfile(signupModel: ,);
//                       //   }),
//                       // );
//                     },
//                   ),
//                 ),
//               ),
//               FadeAnimation(
//                   1.6,
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       const Text("Already have an account?"),
//                       InkWell(
//                         onTap: () {
//                           // Navigator.push(
//                           //     context,
//                           //     MaterialPageRoute(
//                           //         builder: (context) => LoginPage()));
//                           Navigator.pop(context);
//                         },
//                         child: const Text(
//                           " Login",
//                           style: TextStyle(
//                               fontWeight: FontWeight.w600, fontSize: 18),
//                         ),
//                       )
//                     ],
//                   )),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget makeInput1(
//       {label, obscureText = false, required TextEditingController controller}) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         Text(
//           label,
//           style: const TextStyle(
//               fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
//         ),
//         const SizedBox(
//           height: 5,
//         ),
//         TextField(
//           controller: _passwordcontroller,
//           obscureText: obscureText,
//           decoration: const InputDecoration(
//             contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
//             enabledBorder:
//                 OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
//             border:
//                 OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
//           ),
//         ),
//         const SizedBox(
//           height: 30,
//         ),
//       ],
//     );
//   }

//   Widget makeInput2(
//       {label, obscureText = false, required TextEditingController controller}) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         Text(
//           label,
//           style: const TextStyle(
//               fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
//         ),
//         const SizedBox(
//           height: 5,
//         ),
//         TextField(
//           controller: _repasswordcontroller,
//           obscureText: obscureText,
//           decoration: const InputDecoration(
//             contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
//             enabledBorder:
//                 OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
//             border:
//                 OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
//           ),
//         ),
//         const SizedBox(
//           height: 30,
//         ),
//       ],
//     );
//   }

//   Widget makeInput(
//       {label, obscureText = false, required TextEditingController controller}) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         Text(
//           label,
//           style: const TextStyle(
//               fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
//         ),
//         const SizedBox(
//           height: 5,
//         ),
//         TextField(
//           controller: _emailcontroller,
//           obscureText: obscureText,
//           decoration: const InputDecoration(
//             contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
//             enabledBorder: OutlineInputBorder(
//                 borderSide: BorderSide(color: Color.fromARGB(255, 86, 77, 77))),
//             border: OutlineInputBorder(
//                 borderSide: BorderSide(color: Color.fromARGB(255, 86, 77, 77))),
//           ),
//         ),
//         const SizedBox(
//           height: 30,
//         ),
//       ],
//     );
//   }
// }
