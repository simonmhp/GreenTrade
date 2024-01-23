import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:green2/Initial/auth_page.dart';
import 'package:green2/animation/components/GradientBackgroundButton.dart';

class UserviewItemPage extends StatefulWidget {
  final Map<String, dynamic> data;

  UserviewItemPage({required this.data});

  @override
  State<UserviewItemPage> createState() => _ItemDetailsPageState();
}

class _ItemDetailsPageState extends State<UserviewItemPage> {
  int _currentPage = 0;
  late CollectionReference<Map<String, dynamic>> iRef;
  final currentuser = FirebaseAuth.instance.currentUser!;
  List<Map<String, dynamic>> _Results = [];
  late DocumentReference userDocument, ProductDocument;
  int flag = 0;

  @override
  void initState() {
    super.initState();
    // iRef = FirebaseFirestore.instance.collection('Products');
    userDocument =
        FirebaseFirestore.instance.collection('users').doc(widget.data['uid']);
    ProductDocument = FirebaseFirestore.instance
        .collection('Products')
        .doc(widget.data['P_id']);
  }

  Future<void> deleteProduct(String productId) async {
    // Get a reference to the Firestore collection
    var collectionReference = FirebaseFirestore.instance.collection('Products');

    // Query for documents where the field 'productId' is equal to the specified ID
    var querySnapshot =
        await collectionReference.where('P_id', isEqualTo: productId).get();

    // Check if any documents match the query
    if (querySnapshot.docs.isNotEmpty) {
      // Delete each document that matches the query
      for (var document in querySnapshot.docs) {
        await collectionReference.doc(document.id).delete();
      }
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return AuthPage();
      }));
    }
  }

  void showToast(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2), // Adjust the duration as needed
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _PostRequest() async {
    int flag = 0;

    if (widget.data['uid'] == currentuser.uid) {
      showErrorMessage("You are the seller!");
    } else {
      QuerySnapshot querySnapshotProductsName = await FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: widget.data['uid'])
          .get();

      if (querySnapshotProductsName.docs.isNotEmpty) {
        _Results = querySnapshotProductsName.docs
            .map((doc) => {
                  'Request': doc['Request'] ?? {},
                  'Blocked': doc['Blocked'] ?? {},
                  'RequestCount': doc['RequestCount'],
                })
            .toList();
        // showErrorMessage(_Results.toString()); // for debug
      } else {
        // showErrorMessage("Error Occurred...Check Internet Connection.");
        showToast(context, "Error Occurred...Check Internet Connection.");
      }

      if (_Results.isNotEmpty) {
        Map<String, dynamic> blockedMap = _Results[0]['Blocked'];

        if (blockedMap.isNotEmpty) {
          for (var entry in blockedMap.entries) {
            if (entry.value == currentuser.uid) {
              flag++;
            }
          }
        }

        if (flag == 0) {
          Map<String, dynamic> requestMap =
              _Results[0]['Request'] != null ? _Results[0]['Request'] : {};

          print(requestMap);

          if (requestMap.isNotEmpty) {
            Map<String, dynamic> changes = {};

            for (var entry in requestMap.entries) {
              if (entry.value == currentuser.uid &&
                  entry.key == widget.data['P_id']) {
                showToast(context, "Already sent request.");
                flag++;
                print(flag.toString());
                break;
              }

              if (flag == 0) {
                String newField = widget.data['P_id'];
                String newKey = newField;
                dynamic newValue = currentuser.uid;
                changes[newKey] = newValue;
              }
              print(flag);
            }

            if (flag == 0) {
              int count =
                  int.tryParse(_Results[0]['RequestCount'].toString()) ?? 0;
              count++;

              if (_Results[0]['request'] == null) {
                _Results[0]['request'] = {};
              }

              // Apply the changes to the original requestMap
              requestMap.addAll(changes);

              print(requestMap);
              await userDocument.update({'Request': requestMap});
              await userDocument.update({'RequestCount': count.toString()});
            }
          } else {
            print(false);

            if (flag == 0) {
              String newField = widget.data['P_id'];
              String newKey = newField;
              dynamic newValue = currentuser.uid;
              requestMap[newKey] = newValue;

              int count =
                  int.tryParse(_Results[0]['RequestCount'].toString()) ?? 0;
              count++;

              if (_Results[0]['request'] == null) {
                _Results[0]['request'] = {};
              }

              print(requestMap);
              await userDocument.update({'Request': requestMap});
              await userDocument.update({'RequestCount': count.toString()});
            }
          }
        } else {
          // showErrorMessage("Seller is not Interested in Selling...");
          showToast(context, "Seller is not Interested in Selling...");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.data['Products_name'],
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                color: Colors.white,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 300,
                        width: double.infinity,
                        child: PageView.builder(
                          onPageChanged: (index) {
                            setState(() {
                              _currentPage = index;
                            });
                          },
                          itemCount: widget.data['image'].length,
                          itemBuilder: (BuildContext context, int index) {
                            String imageKey = index.toString();
                            return Image.network(
                              widget.data['image'][imageKey],
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 16.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          widget.data['image'].length,
                          (index) => _buildDot(index),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.only(right: 18.0, left: 10, top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Price',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 6.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          '₹${double.parse(widget.data['Price']).toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Divider(color: Colors.black),
                      const SizedBox(height: 10),
                      const Text(
                        'Category',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 6.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          '${widget.data['category']}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Divider(color: Colors.black),
                      const SizedBox(height: 10),
                      const Text(
                        'Descrption',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          '${widget.data['description']}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(
                        bottom: 8.0,
                        left: 8.0,
                      ),
                      child: Text(
                        'Delete the Post!',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 90),
                      child: GradientBackgroundButton(
                        materialStatePropertyShape:
                            MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        )),
                        icon: const Icon(Icons.delete,
                            color: Colors.white, size: 20),
                        leftIcon: 20,
                        child: Text('Delete',
                            style:
                                TextStyle(fontSize: 18, color: Colors.white)),
                        gradient: const LinearGradient(
                          colors: <Color>[
                            Color(0xff004d7a),
                            Color(0xff008793),
                            // Color(0xff00bf72),
                            // Color(0xffa8eb12),
                          ],
                        ),
                        onPressed: () async {
                          bool? result = await showYesNoDialog(
                            context,
                            'Delete the Post?',
                            'Confirm!',
                          );

                          if (result != null && result) {
                            deleteProduct(widget.data['P_id']);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Icon(Icons.arrow_back),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildDot(int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 6.0),
      width: 10.0,
      height: 10.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _currentPage == index ? Colors.blue : Colors.grey,
      ),
    );
  }

  void showErrorMessage(String message) {
    if (message.isEmpty) {
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              title: Center(
                  child: Text(
                "Server-Error!",
                style: TextStyle(color: Colors.black),
              )),
            );
          });
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Center(
                  child: Text(
                message,
                style: const TextStyle(color: Colors.black),
              )),
            );
          });
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
}



//........................................................
