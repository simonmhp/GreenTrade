// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors

import 'package:flutter/material.dart';

//

class RecyclePage extends StatelessWidget {
  Widget bulletText(String text, double fontSize) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('• ', style: TextStyle(fontSize: fontSize)),
        Expanded(
          child: Text(text,
              style: TextStyle(
                fontSize: fontSize,
                //  color: Colors.white
              )),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AspectRatio(
                aspectRatio: 16 / 14,
                child: Image.asset(
                  'assets/ree.png',
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      // Colors.green,
                      // Colors.blue,
                      // Colors.orange,
                      // Colors.pink
                      Color(0xFFE0E0E0),
                      Color(0xFFE0E0E0),

                      // Colors.green.shade700,
                      // Colors.green.shade600,
                      // Colors.green.shade300
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'List of E-Waste Recyclers and Dismantlers',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    RecyclerCard(
                      name: 'TES-AMM Group',
                      location: 'Kancheepuram, Tamil Nadu',
                      website: 'www.recycler1.com',
                      imagePath: 'assets/1.png',
                      gradientColors: [Colors.white, Colors.white],
                    ),
                    RecyclerCard(
                      name: 'Gujarat Green Recycling',
                      location: 'Ahmedabad, Gujarat',
                      website: 'www.recycler2.com',
                      imagePath: 'assets/2.png',
                      gradientColors: [Colors.white, Colors.white],
                    ),
                    RecyclerCard(
                      name: 'Green IT Recycling Center Pvt. Ltd',
                      location: 'Pune, Maharashtra',
                      website: 'www.recycler2.com',
                      imagePath: 'assets/11.jpg',
                      gradientColors: [
                        Colors.white,
                        Colors.white
                      ], // Replace with image path
                    ),
                    RecyclerCard(
                      name: ' Cosmos Recycling',
                      location: 'Ludhiana, Punjab',
                      website: 'www.recycler2.com',
                      imagePath: 'assets/41.png',
                      gradientColors: [
                        Colors.white,
                        Colors.white
                      ], // Replace with image path
                    ),
                    RecyclerCard(
                      name: 'Recycling Villa',
                      location: 'Ludhiana, Punjab',
                      website: 'www.recycler2.com',
                      imagePath: 'assets/4.png',
                      gradientColors: [
                        Colors.white,
                        Colors.white
                      ], // Replace with image path
                    ),
                    // Add more RecyclerCard widgets for additional recyclers
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        // Colors.pink,
                        // Colors.orange,
                        // Colors.blue,
                        Colors.green.shade300,
                        Colors.green.shade600,
                        Colors.green.shade700
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight // New color gradient
                      ),
                ),
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Government Guidelines for E-Waste Recycling:',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      "The Government has taken a number of steps to formalise the e-waste recycling sector of the country. The E-Waste (Management) Rules, 2016 provide for compulsory authorisation of the dismantling and recycling units from the concerned State Pollution Control Boards (SPCBs)/ Pollution Control Committees (PCCs). CPCB has issued guidelines/SOP for processing of e-waste. The CPCB and SPCBs have been monitoring the units and necessary steps have been taken to mainstream and modernise the recycling industry with the help of Ministry of Electronics and Information Technology.",
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      "Following steps have been taken by the government in the direction of finding out solution to the problems related to E-Waste:",
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      " The management of e-waste is being carried out under the frame work of E-Waste (Management) Rules, 2016 and amendments there off. The Rules, are effective from 1st October, 2016. The rules provide for followings:",
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(height: 10.0),
                    bulletText(
                      "Applicable to every manufacturer, producer, consumer, bulk consumer, collection centres, dealers, e-retailer, refurbisher, dismantler and recycler.",
                      16.0,
                    ),
                    bulletText(
                      "Applicable to every manufacturer, producer, consumer, bulk consumer, collection centres, dealers, e-retailer, refurbisher, dismantler and recycler.",
                      16.0,
                    ),
                    bulletText(
                      "Notified EEE are twenty-one (21) and listed in Schedule – I of the above said Rules.",
                      16.0,
                    ),
                    bulletText(
                      "Under EPR regime, producers of notified EEE have been given annual E-Waste collection targets based on the generation from the previously sold EEE or based on sales of EEE as the case may be",
                      16.0,
                    ),
                    bulletText(
                      "Applicable to every manufacturer, producer, refurbisher, dismantler and recycler.",
                      16.0,
                    ),
                    bulletText(
                      "All the manufacturer, producer, refurbisher and recycler are required to register on portal developed by CPCB. ",
                      16.0,
                    ),
                    bulletText(
                      "No entity shall carry out any business without registration and also not deal with any unregistered entity. ",
                      16.0,
                    ),
                    bulletText(
                      "Authorization has now been replaced by Registration through online portal and only manufacturer, producer, refurbisher and recycler require Registration.",
                      16.0,
                    ),
                    bulletText(
                      "Schedule I expanded and now 106 EEE has been include under EPR regime.",
                      16.0,
                    ),
                    bulletText(
                      "Producers of notified EEE, have been given annual E-Waste Recycling targets based on the generation from the previously sold EEE or based on sales of EEE as the case may be. Target may be made stable for 2 years and starting from 60% for the year 2023-2024 and 2024-25; 70% for the year 2025-26 and 2026-27 and 80% for the year 2027-28 and 2028-29 and onwards.",
                      16.0,
                    ),
                    bulletText(
                      "Management of solar PV modules /panels/ cells added in new rules",
                      16.0,
                    ),
                    bulletText(
                      "The quantity recycled will be computed on the basis of end products, so as to avoid any false claim.",
                      16.0,
                    ),
                    bulletText(
                      "Provision for generation and transaction of EPR Certificate has been introduced",
                      16.0,
                    ),
                    bulletText(
                      "Provisions for environment compensation and verification & audit has been introduced.",
                      16.0,
                    ),
                    bulletText(
                      "Provision for constitution of Steering Committee to oversee the overall implementation of these rules",
                      16.0,
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      "Under the E-Waste Management Rules, provision for reduction of hazardous substances in manufacturing of Electrical and Electronic Equipment (EEE) has been provided. It mandates that every producer of EEE and their components shall ensure that their products do not contain lead, mercury and other hazardous substances beyond the maximum prescribed concentration. ",
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      "The E-Waste (Management) Rules also provide for recognition and registration, skill development, monitoring and ensuring safety and health, of workers involved in dismantling and recycling of e-waste.",
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RecyclerCard extends StatelessWidget {
  final String name;
  final String location;
  final String website;
  final String imagePath;
  final List<Color> gradientColors;

  const RecyclerCard({
    required this.name,
    required this.location,
    required this.website,
    required this.imagePath,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Image.asset(
              imagePath,
              height: 150, // Adjust image height
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            ListTile(
              title: Text(
                name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(location),
                  InkWell(
                    onTap: () {
                      // Implement website link redirection
                    },
                    child: Text(
                      website,
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
