// ignore_for_file: use_build_context_synchronously, prefer_const_declarations, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:green2/Initial/pages/adminHome.dart';
import 'package:green2/chart/chart.dart';
import 'package:green2/model/Item_details/Admin_item_detail.dart';
import 'package:green2/model/Item_details/UItem_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:green2/model/Item_details/NUItem_details.dart';

class MyHmPage extends StatefulWidget {
  const MyHmPage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHmPage> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  List<Map<String, dynamic>> _searchResults = [];
  late List<charts.Series<EWasteData, String>> _seriesData;

  final CarouselController carouselController = CarouselController();
  int _currentIndex = 0;
  late AnimationController animationController;

  final List images = [
    {"id": 1, "image_path": 'assets/h5.png'},
    {"id": 2, "image_path": 'assets/h6.jpg'},
    {"id": 3, "image_path": 'assets/JJ.jpg'},
    {"id": 4, "image_path": 'assets/hh.png'},
    {"id": 5, "image_path": 'assets/image/hhh.jpg'},
  ];

  List<String> imagePaths = [
    'assets/image/ef6.jpg',
    'assets/image/ef4.png',
    'assets/image/ef7.jpg',
    'assets/image/ef10.jpg',
    // Add your other image paths here
  ];

  Future<Map<String, dynamic>> getUserData() async {
    try {
      // Assuming 'users' is the collection in Firestore where user data is stored
      // and 'uid' is the unique identifier for the current user
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot userSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userSnapshot.exists) {
        // Assuming 'AccountType' is a field in the user document
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;
        return userData;
      } else {
        // Handle the case where the user document does not exist
        print('User document does not exist for UID: $uid');
        return {};
      }
    } catch (e) {
      // Handle any errors that might occur during data retrieval
      print('Error retrieving user data: $e');
      throw e; // Rethrow the error to be caught by the caller
    }
  }

  void initState() {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    super.initState();
    _seriesData = _createSampleData();
  }

  List<charts.Series<EWasteData, String>> _createSampleData() {
    final data = [
      EWasteData('2017', 44700),
      EWasteData('2018', 49800),
      EWasteData('2019', 53600),
      EWasteData('2020', 53600),
      EWasteData('2021', 57000),
    ];

    return [
      charts.Series<EWasteData, String>(
        id: 'E-waste',
        domainFn: (EWasteData sales, _) => sales.year,
        measureFn: (EWasteData sales, _) => sales.value,
        data: data,
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(
            Colors.green.shade300), // Set the bar color to green
        fillColorFn: (_, __) => charts.ColorUtil.fromDartColor(Colors
            .greenAccent
            .shade700), // Set a slightly lighter shade for the bar fill color
        labelAccessorFn: (EWasteData sales, _) => '${sales.value}',
        insideLabelStyleAccessorFn: (_, __) {
          final color = charts.MaterialPalette.white;
          return charts.TextStyleSpec(color: color);
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0E0E0),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(
                  Radius.circular(38.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color:
                        const Color.fromARGB(255, 82, 82, 82).withOpacity(0.2),
                    spreadRadius: 10,
                    blurRadius: 8.0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  // _search(value);
                },
                onSubmitted: (value) {
                  _search(value);
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Search for e-waste...',
                  border: InputBorder.none,
                  suffixIcon: _isLoading
                      ? const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Conditional rendering based on search
            Expanded(
              child: _searchController.text.isEmpty || _isLoading
                  ? _buildSearchContent()
                  : _buildSearchResults(),
            ),
          ],
        ),
      ),
      floatingActionButton: _searchResults.isNotEmpty
          ? FloatingActionButton(
              onPressed: () {
                // Clear the search and go back to the initial state
                _searchController.clear();
                setState(() {
                  _searchResults.clear();
                });
              },
              child: const Icon(Icons.arrow_back),
            )
          : null,
    );
  }

  // @override
  Widget _buildSearchContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      );
    } else {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image to full width
            SizedBox(
              height: 80.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(8.0),
                children: [
                  CategoryIcon(
                    icon: Icons.local_laundry_service_sharp,
                    label: 'Large Appliances',
                    onTap: () {
                      _searchController.text = 'Large Appliances';
                      _search('Large Appliances');
                      print('Large Appliances');
                    },
                  ),
                  CategoryIcon(
                    icon: Icons.kitchen_outlined,
                    label: 'Small Appliances',
                    onTap: () {
                      _searchController.text = 'Small Appliances';
                      _search('Small Appliances');
                      // Handle the onTap event for 'Small Appliances'
                      print('Small Appliances tapped');
                      // You can navigate to a new screen or perform other actions here
                    },
                  ),
                  CategoryIcon(
                    icon: Icons.print,
                    label: 'Office Electronics',
                    onTap: () {
                      _searchController.text = 'Office Electronics';
                      _search('Office Electronics');
                      print('Office Electronics tapped');
                    },
                  ),
                  CategoryIcon(
                    icon: Icons.mobile_off,
                    label: 'Mobiles',
                    onTap: () {
                      _searchController.text = 'Mobiles';
                      _search('Mobiles');
                      print('Mobiles');
                    },
                  ),
                  CategoryIcon(
                    icon: Icons.electrical_services,
                    label: 'Circuit Boards',
                    onTap: () {
                      _searchController.text = 'Circuit Boards';
                      _search('Circuit Boards');
                      print('Circuit Boards');
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Stack for carousel
            Stack(
              children: [
                FractionallySizedBox(
                  widthFactor: 1.0, // This makes it take up the full width
                  child: CarouselSlider(
                    items: images
                        .map(
                          (item) => Image.asset(
                            item['image_path'],
                            fit: BoxFit.cover,
                          ),
                        )
                        .toList(),
                    carouselController: carouselController,
                    options: CarouselOptions(
                      scrollPhysics: const BouncingScrollPhysics(),
                      autoPlay: true,
                      aspectRatio: 2,
                      viewportFraction: 1,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: images.asMap().entries.map((entry) {
                      return GestureDetector(
                        onTap: () =>
                            carouselController.animateToPage(entry.key),
                        child: Container(
                          width: _currentIndex == entry.key ? 17 : 7,
                          height: 7.0,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 3.0,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: _currentIndex == entry.key
                                ? Colors.red
                                : Colors.teal,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),

            // Text paragraphs
            const SizedBox(height: 20),
            const SizedBox(height: 20),
            const Text(
              'About Green Trade - E-Waste App',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Text(
              'Green Trade is a revolutionary app dedicated to the proper management and recycling of electronic waste. It connects users with authorized recycling centers, making it easy to responsibly dispose of old electronics. Download Green Trade today and contribute to a sustainable future!',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Center(
              child: Container(
                height: 300.0,
                width: 500.0,
                margin: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: charts.BarChart(
                    _seriesData,
                    animate: true,
                    barGroupingType: charts.BarGroupingType.grouped,
                    behaviors: [
                      charts.SeriesLegend(),
                      charts.ChartTitle(
                        'Years',
                        behaviorPosition: charts.BehaviorPosition.bottom,
                      ),
                      charts.ChartTitle(
                        "E-waste (in 10k's metric tons)",
                        behaviorPosition: charts.BehaviorPosition.start,
                      ),
                      charts.SlidingViewport(),
                      charts.PanBehavior(),
                    ],
                    animationDuration: const Duration(seconds: 2),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Column(
                  children: [
                    Text(
                      'Let\'s Talk about E-waste',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 30), // Increased height to add spacing
                    Text(
                      'E-waste is an "urban mine", containing valuable metals that can be recycled. Green Trade, our app, aims to reduce e-waste by allowing users to trade their electronic items with others or sell them to certified recyclers. Through Green Trade, you can contribute to a sustainable environment by giving your electronic items a new life and reducing their impact on the planet.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[800],
                        wordSpacing:
                            3.0, // Adjust the value to increase/decrease word spacing
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 40),
            Center(
              child: Text(
                'Effects of E Waste in our Environment',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 300,
              child: PageView.builder(
                itemCount: imagePaths.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Card(
                      color:
                          index % 2 == 0 ? Colors.grey[200] : Colors.grey[300],
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          imagePaths[index],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),

            Center(
              child: Text(
                'What is the Solution?',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Text(
                    "GreenTrade is an innovative project aimed at addressing the growing issue of electronic waste (e-waste) in today's society. It seeks to revolutionize e-waste management through responsible disposal, communication, awareness, and links to recycling facilities.",
                    style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Divider(color: Colors.black),
                  const SizedBox(height: 10),
                  Text(
                    "At its core, GreenTrade provides a digital platform for buying and selling e-waste products, with a focus on responsible recycling and repurposing to reduce the ecological footprint of e-waste.",
                    style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Divider(color: Colors.black),
                  const SizedBox(height: 10),
                  Text(
                    "Real-time communication between users fosters trust within the e-waste community.",
                    style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Divider(color: Colors.black),
                  const SizedBox(height: 10),
                  Text(
                    "Moreover, the project emphasizes the importance of spreading awareness about the environmental and health implications of e-waste through informative resources and collaborative initiatives.",
                    style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Divider(color: Colors.black),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) {
      return Center(
        child: Positioned(
          bottom: 16.0, // Adjust the value as needed
          right: 16.0, // Adjust the value as needed
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'No Item Found',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              FloatingActionButton(
                onPressed: () {
                  // Clear the search and go back to the initial state
                  _searchController.clear();
                  setState(() {
                    _searchResults.clear();
                  });
                },
                child: const Icon(Icons.arrow_back),
              ),
            ],
          ),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          final result = _searchResults[index];
          return ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            child: Card(
              elevation: 5,
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      // Navigate to a new page with item details
                      Future<void> navigateToDetailsPage() async {
                        if (FirebaseAuth.instance.currentUser != null) {
                          try {
                            // Assuming getUserData() is a function that fetches user data from Firestore
                            Map<String, dynamic> userData = await getUserData();

                            if (userData['accountType'] == 'admin') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AdminItemPage(data: result),
                                ),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      UItemDetailsPage(data: result),
                                ),
                              );
                            }
                          } catch (e) {
                            // Handle error if user data retrieval fails
                            print('Error retrieving user data: $e');
                          }
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  NUItemDetailsPage(data: result),
                            ),
                          );
                        }
                      }

                      navigateToDetailsPage();
                    },
                    child: Image.network(
                      result['image']['0'] ?? '',
                      width: double.infinity,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  ListTile(
                    title: Column(
                      children: [
                        Container(
                          // color: HotelAppTheme.buildLightTheme()
                          //     .backgroundColor,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, top: 8, bottom: 6),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              result['Products_name'],
                                              textAlign: TextAlign.left,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 22,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 4,
                                            ),
                                            Expanded(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    'Price Rs: ',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey
                                                          .withOpacity(0.8),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                  Text(
                                                    '${result['Price']}',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Color.fromARGB(
                                                              255, 27, 162, 83)
                                                          .withOpacity(0.80),
                                                      fontWeight:
                                                          FontWeight.w900,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          'Type: ${result['category']}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: const Color.fromARGB(
                                                    255, 94, 94, 94)
                                                .withOpacity(0.8),
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Text(
                                          'Description: ${result['Price']}',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: const Color.fromARGB(
                                                    255, 94, 94, 94)
                                                .withOpacity(0.8),
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  Future<void> _search(String query) async {
    setState(() {
      _isLoading = true;
    });
    query = query.trim();

    // Simulate a delay to show loading indicator
    await Future.delayed(const Duration(seconds: 1));

    // Perform the first search by 'Products_name'
    QuerySnapshot querySnapshotProductsName = await FirebaseFirestore.instance
        .collection('Products')
        .where('product_title', isEqualTo: query)
        .get();

    // If 'Products_name' not found, perform the second search by 'Type'
    if (querySnapshotProductsName.docs.isEmpty) {
      QuerySnapshot querySnapshotType = await FirebaseFirestore.instance
          .collection('Products')
          .where('type', isEqualTo: query)
          .get();

      // Combine the results from both queries
      _searchResults = querySnapshotType.docs
          .map((doc) => {
                'Products_name': doc['product_title'],
                'category': doc['type'],
                'Price': doc['price'],
                'image': doc['ImageURLs'] ?? {},
                'description': doc['description'],
                'email': doc['email'],
                'uid': doc['uid'],
                'P_id': doc['P_id'],
              })
          .toList();
    } else {
      // Use the results from the first query
      _searchResults = querySnapshotProductsName.docs
          .map((doc) => {
                'Products_name': doc['product_title'],
                'category': doc['type'],
                'Price': doc['price'],
                'image': doc['ImageURLs'] ?? {},
                'description': doc['description'],
                'email': doc['email'],
                'uid': doc['uid'],
                'P_id': doc['P_id'],
              })
          .toList();
    }

    setState(() {
      _isLoading = false;
    });
  }
}

class CategoryIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const CategoryIcon({
    Key? key,
    required this.icon,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            Icon(icon, size: 30, color: Color(0xFF085F63)),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                  fontSize: 12, color: Color.fromARGB(179, 0, 0, 0)),
            ),
          ],
        ),
      ),
    );
  }
}
