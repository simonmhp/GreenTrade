import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
//import widgets

// ignore: must_be_immutable
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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

  void signUserOut() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GreenTrade"),
        actions: [IconButton(onPressed: signUserOut, icon: Icon(Icons.logout))],
      ),
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              // color: Colors.blueGrey,
              child: const Text("Buying",
                  style: TextStyle(fontFamily: "Aptos", fontSize: 20)),
            ),
            Container(
              color: Colors.red,
            ),
            Container(
              color: Colors.green,
            ),
            Container(
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
              title: Text('Buying'), icon: Icon(Icons.shopping_bag)),
          BottomNavyBarItem(
              title: Text('Selling'), icon: Icon(Icons.add_shopping_cart)),
          BottomNavyBarItem(title: Text('Chat'), icon: Icon(Icons.chat_bubble)),
          BottomNavyBarItem(title: Text('Awareness'), icon: Icon(Icons.eco)),
        ],
      ),
    );
  }
}
