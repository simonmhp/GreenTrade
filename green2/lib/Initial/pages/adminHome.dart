import 'dart:async';
// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:green2/Chat/ChatPages/ChatRoom.dart';
import 'package:green2/Home/Home.dart';
import 'package:green2/Home/ProfilePage.dart';
import 'package:green2/Home/aboutpage.dart';
import 'package:green2/Home/component/drawer.dart';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:green2/Home/recyclepage.dart';
import 'package:green2/Initial/auth_page.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  int _currentIndex = 0;
  late PageController _pageController;
  final currentUser = FirebaseAuth.instance.currentUser!;

  List<Map<String, dynamic>> _Result = [];
  List<Map<String, dynamic>> _Myproducts = [];
  // List<Map<String, dynamic>> _Myproduct = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    // Call getProductList immediately
    // ignore: unnecessary_null_comparison
    if (FirebaseFirestore.instance != null) {
      getProductList();
    }

    // Schedule getProductList to be called every 10 minutes
  }

  void showToast(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2), // Adjust the duration as needed
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> getProductList() async {
    _Myproducts = [];
    QuerySnapshot querySnapshotProductsName = await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: currentUser.uid) // Use currentUser here
        .get();

    if (querySnapshotProductsName.docs.isNotEmpty) {
      _Result = querySnapshotProductsName.docs
          .map((doc) => {
                'MyProducts': doc['MyProducts'] ?? [],
              })
          .toList();

      if (_Result.isNotEmpty) {
        List<dynamic> existingMyProducts = _Result[0]['MyProducts'] ?? [];

        for (var product in existingMyProducts) {
          await _getProduct(product);
        }
      }
      print(_Myproducts.toString());
    } else {
      // showErrorMessage("Error Occurred...Check Internet Connection.");
    }
  }

  Future<void> _getProduct(String query) async {
    query = query.trim();

    QuerySnapshot querySnapshotProductsName = await FirebaseFirestore.instance
        .collection('Products')
        .where('P_id', isEqualTo: query)
        .get();

    if (querySnapshotProductsName.docs.isNotEmpty) {
      for (var doc in querySnapshotProductsName.docs) {
        _Myproducts.add({
          'Products_name': doc['product_title'],
          'category': doc['type'],
          'Price': doc['price'],
          'image': doc['ImageURLs'] ?? {},
          'description': doc['description'],
          'email': doc['email'],
          'uid': doc['uid'],
          'P_id': doc['P_id'],
        });
      }
    } else {
      print('Failed');
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void signUserOut() {
    FirebaseAuth.instance.signOut();
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AuthPage();
    }));
  }

  void goToProfilePage() {
    Navigator.pop(context);

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePage(_Myproducts),
        ));
  }

  @override
  Widget build(Object context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("GreenTrade"),
        backgroundColor: Color(0xFF085F63),
        actions: [
          IconButton(
            icon: Icon(Icons.recycling),
            onPressed: () {
              Navigator.push(context as BuildContext,
                  MaterialPageRoute(builder: (BuildContext context) {
                return AboutUsPage();
              }));
              print("Button pressed!");
            },
          ),
        ],
      ),
      drawer: Mydrawer(
        onProfileTap: goToProfilePage,
        onSignout: signUserOut,
      ),
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[
            Container(
              child: MyHmPage(),
            ),
            Container(
              child: ChatRoom(),
            ),
            Container(
              child: RecyclePage(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          _pageController.jumpToPage(index);
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
              title: const Text(
                'Home',
                style: TextStyle(color: Color(0xFF085F63)),
              ),
              icon: const Icon(Icons.home, color: Color(0xFF085F63))),
          BottomNavyBarItem(
              title: const Text('Chat',
                  style: TextStyle(color: Color(0xFF085F63))),
              icon: const Icon(Icons.chat_bubble, color: Color(0xFF085F63))),
          BottomNavyBarItem(
              title: const Text('Recycle',
                  style: TextStyle(color: Color(0xFF085F63))),
              icon: const Icon(Icons.eco, color: Color(0xFF085F63))),
        ],
      ),
    );
  }
}
