import 'package:flutter/material.dart';
import 'package:green2/Authentication/Pages/Login2.dart';
import 'package:green2/animation/components/GradientBackgroundButton.dart';

class NoUserAddItemPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Centered Button Page"),
      // ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.6,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Please Log In!",
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 20),
              GradientBackgroundButton(
                materialStatePropertyShape:
                    MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                )),
                icon: const Icon(Icons.login, color: Colors.white, size: 20),
                leftIcon: 20,
                child: Text('Log In',
                    style: TextStyle(fontSize: 18, color: Colors.white)),
                gradient: const LinearGradient(
                  colors: <Color>[
                    Color(0xff004d7a),
                    Color(0xff008793),
                    Color(0xff00bf72),
                    Color(0xffa8eb12),
                  ],
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const LoginPage();
                  }));
                  // Add your button's functionality here
                  print("Button pressed!");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
