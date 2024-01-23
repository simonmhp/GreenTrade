import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:green2/Initial/auth_page.dart';
import 'package:green2/model/Item_details/NUItem_details.dart';
import 'package:green2/model/Item_details/UserProfileview.dart';

class ProfilePage extends StatefulWidget {
  final List<Map<String, dynamic>> myproducts;
  ProfilePage(this.myproducts, {super.key});

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  // User details
  final currentuser = FirebaseAuth.instance.currentUser!;

  void initState() {
    super.initState();
    getProductList();
  }

  void getProductList() {
    for (var product in widget.myproducts) {
      print(product['P_id']);
    }
  }

  Future<void> deleteUser(String u_id) async {
    FirebaseAuth.instance.signOut();
    // Get a reference to the Firestore collection
    var collectionReference = FirebaseFirestore.instance.collection('users');

    // Query for documents where the field 'productId' is equal to the specified ID
    var querySnapshot =
        await collectionReference.where('uid', isEqualTo: u_id).get();

    // Check if any documents match the query
    if (querySnapshot.docs.isNotEmpty) {
      // Delete each document that matches the query
      for (var document in querySnapshot.docs) {
        await collectionReference.doc(document.id).delete();
      }
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return AuthPage();
      }));
    }
  }

  Future<bool?> showYesNoDialog(
      BuildContext context, String title, String content) async {
    return await showDialog<bool?>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(title),
              content: Text(content),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pop(true); // Return true if "Yes" is pressed
                  },
                  child: Text('Yes'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pop(false); // Return false if "No" is pressed
                  },
                  child: Text('No'),
                ),
              ],
            );
          },
        ) ??
        false; // Provide a default value (false) if the result is null
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE0E0E0),
      appBar: AppBar(
        title: const Text("Profile Page"),
        backgroundColor: Color(0xFF085F63),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              bool? result = await showYesNoDialog(
                context,
                'Delete User?',
                'Confirm!',
              );

              if (result != null && result) {
                deleteUser(currentuser.uid);
              }
            },
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // get data
            final userdata = snapshot.data!.data() as Map<String, dynamic>;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 20),
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: userdata['profilepic'] != null
                        ? NetworkImage(userdata['profilepic'])
                        : const AssetImage(
                            'assets/profile.png',
                          ) as ImageProvider<Object>, // Default icon
                  ),
                  SizedBox(height: 20),
                  Text(
                    currentuser.email!,
                    textAlign: TextAlign.center,
                    style:
                        const TextStyle(color: Color.fromARGB(255, 77, 77, 77)),
                  ),
                  SizedBox(height: 20),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Full Name',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6.0),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            userdata['fullname'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Location',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            userdata['location'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'My Ads',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 8.0, right: 8.0, left: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: MediaQuery.of(context).size.height - 440,
                        child: ListView.builder(
                          itemCount: widget.myproducts.length,
                          itemBuilder: (context, index) {
                            final result = widget.myproducts[index];
                            return ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10.0)),
                              child: Card(
                                elevation: 5,
                                margin: const EdgeInsets.symmetric(vertical: 6),
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        // Navigate to a new page with item details
                                        if (FirebaseAuth.instance.currentUser !=
                                            null) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  UserviewItemPage(
                                                      data: result),
                                            ),
                                          );
                                        } else {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  NUItemDetailsPage(
                                                      data: result),
                                            ),
                                          );
                                        }
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
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10,
                                                            top: 8,
                                                            bottom: 6),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            Text(
                                                              result[
                                                                  'Products_name'],
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style:
                                                                  const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 22,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 4,
                                                            ),
                                                            Expanded(
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  Text(
                                                                    'Price Rs: ',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .grey
                                                                          .withOpacity(
                                                                              0.8),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    '${result['Price']}',
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Color.fromARGB(
                                                                              255,
                                                                              27,
                                                                              162,
                                                                              83)
                                                                          .withOpacity(
                                                                              0.80),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w900,
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
                                                            color: const Color
                                                                    .fromARGB(
                                                                    255,
                                                                    94,
                                                                    94,
                                                                    94)
                                                                .withOpacity(
                                                                    0.8),
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                        Text(
                                                          'Description: ${result['Price']}',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color: const Color
                                                                    .fromARGB(
                                                                    255,
                                                                    94,
                                                                    94,
                                                                    94)
                                                                .withOpacity(
                                                                    0.8),
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                      ],
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
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error${snapshot.error}'),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(currentuser.uid)
            .snapshots(),
      ),
    );
  }
}
