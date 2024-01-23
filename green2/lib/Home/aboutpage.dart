// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF5F5F5),
              Color(0xFFCCCCCC)
            ], // Shades of white/gray
            stops: [0.0, 0.7], //just colors as needed
          ),
        ),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 150.0,
              flexibleSpace: FlexibleSpaceBar(
                background: Image.asset(
                  'assets/gt.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: const [
                          Color(0xFFFFFFFF),
                          Color(0xFFFFFFFF)
                        ], // Shades of white/gray
                        // ignore: prefer_const_literals_to_create_immutables
                        stops: [0.0, 0.7], // Adjust stop values as needed
                      ),
                    ),
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'About Us',
                          style: TextStyle(
                            fontSize: 28.0,
                            fontWeight: FontWeight.bold,
                            // decoration: TextDecoration.underline,
                            // decorationColor: Colors.red,
                            // decorationThickness: 2.0,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          'Welcome to Green Trade, a revolutionary platform where environmental responsibility meets economic opportunity in the world of electronic waste.',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Text(
                          'Our Purpose',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            // decoration: TextDecoration.underline,
                            // decorationColor: Colors.red,
                            // decorationThickness: 2.0,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          'At Green Trade, our apps mission revolves around the fundamental principles of the 3Rs – Reduce, Reuse, Recycle. We strive to reduce the environmental impact of electronic waste by providing a platform where users can seamlessly participate in the reuse and recycling of electronic components. Through facilitating peer-to-peer commerce, promoting the reuse of electronics, and ensuring responsible recycling practices, we aim to redefine e-waste management and drive a sustainable future',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                                'assets/reduse.png'), // Replace with your image asset path
                            SizedBox(height: 10),
                            Text(
                              'Reduce',
                              style: TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 20),
                            Image.asset('assets/reuse.png'),
                            SizedBox(height: 10),
                            Text(
                              'Reuse',
                              style: TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 20),
                            Image.asset('assets/recycle.png'),
                            SizedBox(height: 20),
                            Text(
                              'Recycle',
                              style: TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            // SizedBox(height: 20),
                            // Image.asset('assets/recycle.png'),
                            // SizedBox(height: 20),
                            // Text(
                            //   '',
                            //   style: TextStyle(
                            //     fontSize: 22.0,
                            //     fontWeight: FontWeight.bold,
                            //     color: Colors.black,
                            //   ),
                            // ),
                          ],
                        ),
                        // Add the rest of your content here (Key Features, etc.)
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          // begin: Alignment.topcenter,
                          // end: Alignment.bottomcen,
                          colors: const [
                            Color.fromARGB(255, 10, 10, 10),
                            Color.fromARGB(255, 10, 10, 10)
                          ] // New color gradient
                          ),
                    ),
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'What Sets Us Apart',
                          style: TextStyle(
                            fontSize: 28.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 20.0),
                        KeyFeatureWidget(
                          title: 'Driving Positive Change',
                          description:
                              "At Green Trade, we're dedicated to transforming electronic waste management. Our focus on responsible disposal and recycling is integral to the innovation cycle. Our mission is to contribute to a cleaner planet by redefining how we handle e-waste.",
                          textColor: Colors.white,
                        ),
                        SizedBox(height: 20.0),
                        KeyFeatureWidget(
                          title: 'Sustainable Solutions',
                          description:
                              "At Green Trade, our platform integrates buying, selling, and recycling electronics. Reselling extends device lifecycles, reducing environmental impact. Our recycling meets top standards, ensuring responsible, ethical handling of every gadget.",
                          textColor: Colors.white,
                        ),
                        SizedBox(height: 20.0),
                        KeyFeatureWidget(
                          title: 'Empowering Consumers',
                          description:
                              "At Green Trade, we empower consumers to make eco-friendly choices. Selling, buying refurbished items, or recycling old gadgets with us contributes to a circular economy. Join us in minimizing electronic waste and maximizing resource efficiency.",
                          textColor: Colors.white,
                        ),
                        SizedBox(height: 20.0),
                        KeyFeatureWidget(
                          title: 'Innovation for a Better Future',
                          description:
                              "We're committed to constant innovation, seeking sustainable solutions in e-waste management. Our team drives advancements, setting new industry standards through tech and environmental stewardship.",
                          textColor: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        // begin: Alignment.topRight,
                        // end: Alignment.bottomLeft,
                        colors: const [
                          Color(0xFFF5F5F5),
                          Color(0xFFCCCCCC)
                        ], // New color gradient
                      ),
                    ),
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20.0),
                        // Add the image and text
                        Image.asset(
                          'assets/join.png',
                          height: 200,
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Your Role in Our Journey',
                          style: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'By being a part of Green Trade, you\'re not just using an app – you\'re actively participating in a movement toward sustainable and responsible e-waste management. Together, let\'s make a positive impact on the environment. Join us at Green Trade in reshaping the narrative around e-waste. Every transaction, whether buying, selling, or recycling, is a step towards a sustainable future. Thank you for choosing Green Trade where environmental stewardship and economic opportunity go hand in hand. Together, let\'s redefine the e-waste landscape.',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 20),
                        // Contact Us Section
                        Text(
                          'Contact Us',
                          style: TextStyle(
                            fontSize: 28.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 10),
                        ListTile(
                          leading: Icon(Icons.email),
                          title: Text('greentrade@gmail.com'),
                        ),
                        ListTile(
                          leading: Icon(Icons.phone),
                          title: Text('1683990097'),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Project Team',
                          style: TextStyle(
                            fontSize: 28.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 10),
                        ListTile(
                          leading: Icon(Icons.email),
                          title: Text('teamgreentrade@shuats.com'),
                        ),
                        SizedBox(height: 20),
                        // Add Social Media Section with icons
                        // Add Feedback Section with email icon
                        // Add Testimonials Section
                        SizedBox(height: 20),
                        Text(
                          'THANK YOU !!',
                          style: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ], // Closing bracket for the SliverChildListDelegate
              ),
            ), // Closing bracket for the SliverList
          ],
        ),
      ),
    );
  }
}

class KeyFeatureWidget extends StatelessWidget {
  final String title;
  final String description;
  final Color textColor;

  const KeyFeatureWidget({
    required this.title,
    required this.description,
    this.textColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          ' $title',
          style: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        SizedBox(height: 8.0),
        Text(
          description,
          style: TextStyle(
            fontSize: 15.0,
            color: textColor,
          ),
        ),
      ],
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AboutUsPage(),
  ));
}
