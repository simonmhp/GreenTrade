import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:green2/Initial/pages/HasNoUser.dart';
import 'package:green2/Initial/pages/HasUser.dart';
import 'package:green2/Initial/pages/adminHome.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  // void initState() {
  //   super.initState();
  //   getUser();
  // }
  // void

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            // User is logged in, check for 'admin' role or other attributes
            if (snapshot.data!.uid.isNotEmpty) {
              // Use a FutureBuilder to fetch additional information from Firestore
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(snapshot.data!.uid)
                    .get(),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    // Still waiting for data
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (userSnapshot.hasError) {
                    // Handle error
                    return Text('Error: ${userSnapshot.error}');
                  }

                  if (userSnapshot.hasData &&
                      userSnapshot.data!.exists &&
                      userSnapshot.data!['accountType'] == 'admin') {
                    // Navigate to admin home
                    return const AdminHome();
                  } else {
                    // Navigate to user home
                    return HasUserHome();
                  }
                },
              );
            } else {
              // User is not fully authenticated or doesn't have a UID
              return HasNoUserHome();
            }
          } else {
            // User is not logged in
            return HasNoUserHome();
          }
        },
      ),
    );
  }
}
