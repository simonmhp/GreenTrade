import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:green2/Authentication/component/SignupModel.dart';
import 'package:green2/Chat/ChatPages/ChatPage.dart';
import 'package:green2/Chat/comopents/ChatRoomModel.dart';
import 'package:green2/Chat/comopents/UserModel.dart';
import 'package:green2/Chat/Userpages/UNotificationPage.dart';
import 'package:uuid/uuid.dart';
import 'package:green2/Chat/comopents/FirebaseHelper.dart';

var uuid = Uuid();

class ChatRoom extends StatefulWidget {
  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  late CollectionReference<Map<String, dynamic>> iRef;
  late DocumentReference userDocument;
  final currentuser = FirebaseAuth.instance.currentUser!;

  List<Map<String, dynamic>> _Results = [];
  late List<String> ProductNames = [];
  late List<String> ProductID = [];
  late List<String> UserUID = [];
  late List<String> Image = [];
  late List<String> Fname = [];
  late List<String> targetEmail = [];
  final User firebaseUser = FirebaseAuth.instance.currentUser!;

  late UserModel thisUserModel = UserModel(
    uid: currentUser!.uid,
    email: currentUser!.email,
    fullname: "",
    profilepic: "",
  );
  User? currentUser = FirebaseAuth.instance.currentUser;

  Future<void> Intial() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      // Logged In
      thisUserModel = (await FirebaseHelper.getUserModelById(currentUser.uid))!;
    }
  }

  @override
  void initState() {
    super.initState();
    iRef = FirebaseFirestore.instance.collection('Products');
    // if(currentUser!.email != null){
    //   _getrequests();
    //   _getUserModel()
    // }
    _getrequests();
    _getUserModel();
    _getNotification();
  }

  Future<void> _getNotification() async {
    QuerySnapshot querySnapshotProductsName = await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: currentUser!.uid)
        .get();

    if (querySnapshotProductsName.docs.isNotEmpty) {
      _Results = querySnapshotProductsName.docs
          .map((doc) => {
                'requestCount': doc['requestCount'],
              })
          .toList();
    } else {
      print("Error Occurred...Check Internet Connection.(Notification Page)");
      showToast(context, "Notification: No Internet Connection!");
    }

    if (_Results.isNotEmpty) {
      userDocument =
          FirebaseFirestore.instance.collection('users').doc(currentUser!.uid);

      int count = int.tryParse(_Results[0]['requestCount'].toString()) ?? 0;
      print('requestCount: $count');
      if (count != 0) showToast(context, "Notification: $count");
    }
  }

  void showToast(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2), // Adjust the duration as needed
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _getUserModel() async {
    try {
      QuerySnapshot querySnapshotRequestName = await FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: currentUser!.uid)
          .get();

      if (querySnapshotRequestName.docs.isNotEmpty) {
        var userData = querySnapshotRequestName.docs[0].data();
        if (userData is Map<String, dynamic>) {
          thisUserModel.fullname = userData['fullname'] ?? "";
          thisUserModel.profilepic = userData['profilepic'] ?? "";
        } else {
          // Handle the case where userData is not a Map<String, dynamic>
          showErrorMessage("Invalid user data format");
        }

        // Do something with the populated thisUserModel if needed
      } else {
        showErrorMessage("User data not found. Check Internet Connection.");
      }
    } catch (error) {
      showErrorMessage("Error Occurred: $error");
    }
  }

  Future<void> _getrequests() async {
    QuerySnapshot querySnapshotRequestName = await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: currentuser.uid)
        .get();
    try {
      if (querySnapshotRequestName.docs.isNotEmpty) {
        _Results = querySnapshotRequestName.docs
            .map((doc) => {
                  'request': doc['request'] ?? {},
                })
            .toList();
      } else {
        showErrorMessage("Error Occurred...Check Internet Connection.");
      }
    } catch (ex) {
      showErrorMessage(ex.toString());
    }
    print(_Results);

    if (_Results.isNotEmpty) {
      String ProductName = "";
      String img = "";
      String targetMail = "";
      String P_id = "";
      String fullname = "";
      String UID = "";
      if (_Results[0]['request'] != null) {
        Map<String, dynamic> RequestMap = _Results[0]['request'];
        // Map<String, dynamic> RequestMap = _Results[0];
        for (var entry in RequestMap.entries) {
          P_id = entry.key;
          List<Map<String, dynamic>> _getProductName = [];
          List<Map<String, dynamic>> _getRequestedDetails = [];
          QuerySnapshot querySnapshotProductName = await FirebaseFirestore
              .instance
              .collection('Products')
              .where('P_id', isEqualTo: entry.key)
              .get();

          if (querySnapshotProductName.docs.isNotEmpty) {
            _getProductName = querySnapshotProductName.docs
                .map((doc) => {
                      'product_title': doc['product_title'] ?? {},
                    })
                .toList();
          }

          QuerySnapshot querySnapshotRequestEmail = await FirebaseFirestore
              .instance
              .collection('users')
              .where('uid', isEqualTo: entry.value)
              .get();
          if (querySnapshotRequestEmail.docs.isNotEmpty) {
            _getRequestedDetails = querySnapshotRequestEmail.docs
                .map((doc) => {
                      'uid': doc['uid'] ?? {},
                      'fullname': doc['fullname'] ?? {},
                      'ImageURL': doc['profilepic'] ?? {},
                      'email': doc['email'] ?? {},
                    })
                .toList();
          }

          if (_getRequestedDetails.isNotEmpty) {
            for (Map<String, dynamic> entry in _getRequestedDetails) {
              entry.forEach((key, value) {
                // Check if the value is a String
                if (value is String) {
                  if (key == 'uid') {
                    UID = value;

                    // print('Requester_name : $UID');
                  } else if (key == 'ImageURL') {
                    img = value;
                    // Handle the case when the value is not a String
                    // print('Value is not a String for key: $key');
                  } else if (key == 'email') {
                    targetMail = value;
                    // Handle the case when the value is not a String
                    // print('Value is not a String for key: $key');
                  } else {
                    fullname = value;
                  }
                }
              });
            }
          }
          // print(ProductName);
          // print(img);

          for (Map<String, dynamic> entry in _getProductName) {
            entry.forEach((key, value) {
              // Check if the value is a String
              if (value is String) {
                ProductName = value;

                // print('Product name: $ProductName');
              } else {
                // Handle the case when the value is not a String
                // print('Value is not a String for key: $key');
              }
            });
          }
          ProductNames.add(ProductName);
          UserUID.add(UID);
          Image.add(img);
          Fname.add(fullname);
          targetEmail.add(targetMail);
          ProductID.add(P_id);

          // print('ProductID $ProductID');
          // print('UserUID: $UserUID');
          // print('Image: $Image');
          // print('Fname: $fullname');
        }
      }
    } else {
      showErrorMessage("Error Occurred...Check Internet Connection.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 18, 127, 133),
        title: Text('ChatRoom'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              print(thisUserModel.email);
              // Navigate to the notification page when the icon is pressed
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NotificationPage(
                        ProductNames,
                        UserUID,
                        Image,
                        thisUserModel,
                        currentUser!,
                        targetEmail,
                        Fname,
                        ProductID,
                        thisUserModel.uid)),
              );
            },
          ),
        ],
      ),
      body:
          // Center(
          //   child: Text(
          //     'Hello',
          //     style: TextStyle(fontSize: 24),
          //   ),
          // ),
          SafeArea(
        child: Container(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("chatrooms")
                .where("participants.${thisUserModel.uid}", isEqualTo: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  QuerySnapshot chatRoomSnapshot =
                      snapshot.data as QuerySnapshot;

                  return ListView.builder(
                    itemCount: chatRoomSnapshot.docs.length,
                    itemBuilder: (context, index) {
                      ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(
                          chatRoomSnapshot.docs[index].data()
                              as Map<String, dynamic>);

                      Map<String, dynamic> participants =
                          chatRoomModel.participants!;

                      List<String> participantKeys = participants.keys.toList();
                      participantKeys.remove(thisUserModel.uid);

                      return FutureBuilder(
                        future:
                            FirebaseHelper.getUserModelById(participantKeys[0]),
                        builder: (context, userData) {
                          if (userData.connectionState ==
                              ConnectionState.done) {
                            if (userData.data != null) {
                              UserModel targetUser = userData.data as UserModel;

                              return ListTile(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) {
                                      return ChatRoomPage(
                                        chatroom: chatRoomModel,
                                        firebaseUser: firebaseUser,
                                        userModel: thisUserModel,
                                        targetUser: targetUser,
                                      );
                                    }),
                                  );
                                },
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      targetUser.profilepic.toString()),
                                ),
                                title: Row(
                                  children: [
                                    Text(targetUser.fullname.toString()),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Text(
                                          '(${chatRoomModel.productid.toString()})'),
                                    ),
                                  ],
                                ),
                                subtitle: (chatRoomModel.lastMessage
                                            .toString() !=
                                        "")
                                    ? Text(chatRoomModel.lastMessage.toString())
                                    : Text(
                                        "Say hi to your new friend!",
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                      ),
                              );
                            } else {
                              return Container();
                            }
                          } else {
                            return Container();
                          }
                        },
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                } else {
                  return Center(
                    child: Text("No Chats"),
                  );
                }
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
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
}
