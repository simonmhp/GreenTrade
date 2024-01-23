import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:green2/Authentication/Pages/Login2.dart';
import 'package:green2/Chat/Userpages/NUNotificaton.dart';
import 'package:green2/Home/Home.dart';
// import 'package:green2/Home/ProfilePage.dart';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:green2/Home/aboutpage.dart';
import 'package:green2/Home/recyclepage.dart';
import 'package:green2/model/addItem/NUadditem.dart';

class HasNoUserHome extends StatefulWidget {
  const HasNoUserHome({super.key});

  @override
  State<HasNoUserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<HasNoUserHome> {
  int _currentIndex = 0;
  late PageController _pageController;
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("GreenTrade"),
        backgroundColor: Color(0xFF085F63),
        actions: [
          IconButton(
            icon: Icon(Icons.recycling),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return AboutUsPage();
              }));
              print("Button pressed!");
            },
          ),
        ],
        leading: IconButton(
          icon: Icon(Icons.login),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return LoginPage();
            }));
            print("Left button pressed!");
          },
        ),
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
              child: NoUserAddItemPage(),
              color: Colors.red,
            ),
            Container(
              child: NoUserNotification(),
              color: Colors.green,
            ),
            Container(
              child: RecyclePage(),
              color: Colors.blue,
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
            title:
                const Text('Home', style: TextStyle(color: Color(0xFF085F63))),
            icon: const Icon(Icons.home, color: Color(0xFF085F63)),
          ),
          BottomNavyBarItem(
            title:
                const Text('Sell', style: TextStyle(color: Color(0xFF085F63))),
            icon: const Icon(Icons.add_shopping_cart, color: Color(0xFF085F63)),
          ),
          BottomNavyBarItem(
            title:
                const Text('Chat', style: TextStyle(color: Color(0xFF085F63))),
            icon: const Icon(Icons.chat_bubble, color: Color(0xFF085F63)),
          ),
          BottomNavyBarItem(
            title: const Text('Recycle',
                style: TextStyle(color: Color(0xFF085F63))),
            icon: const Icon(Icons.eco, color: Color(0xFF085F63)),
          ),
        ],
      ),
    );
  }
}
