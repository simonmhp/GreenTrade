// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:green2/Chat/ChatPages/ChatPage.dart';
import 'package:green2/Chat/comopents/ChatRoomModel.dart';
import 'package:green2/Chat/comopents/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class NotificationPage extends StatefulWidget {
  final List<String> productNames;
  final List<String> userUID;
  final List<String> image;
  final List<String> targetEmail;
  final List<String> Fname;
  final List<String> productID;
  final UserModel userModel;
  final User firebaseUser;
  final String? myuid;

  NotificationPage(
    this.productNames,
    this.userUID,
    this.image,
    this.userModel,
    this.firebaseUser,
    this.targetEmail,
    this.Fname,
    this.productID,
    this.myuid,
  );

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late DocumentReference userDocument;
  User? currentUser = FirebaseAuth.instance.currentUser;

  Future<ChatRoomModel?> getChatroomModel(
      UserModel targetUser, String productID) async {
    ChatRoomModel? chatRoom;

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .where("participants.${widget.userModel.uid}", isEqualTo: true)
        .where("participants.${targetUser.uid}", isEqualTo: true)
        .where('productid', isEqualTo: productID)
        .get();

    if (snapshot.docs.length > 0) {
      // Fetch the existing one
      var docData = snapshot.docs[0].data();
      ChatRoomModel existingChatroom =
          ChatRoomModel.fromMap(docData as Map<String, dynamic>);

      chatRoom = existingChatroom;
    } else {
      // Create a new one
      ChatRoomModel newChatroom = ChatRoomModel(
        chatroomid: uuid.v1(),
        lastMessage: "",
        participants: {
          widget.userModel.uid.toString(): true,
          targetUser.uid.toString(): true,
        },
        productid: productID,
      );

      await FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(newChatroom.chatroomid)
          .set(newChatroom.toMap());

      chatRoom = newChatroom;
    }

    return chatRoom;
  }

  Future<UserModel?> getUserByEmail(String email) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .where("email", isNotEqualTo: widget.userModel.email)
        .get();

    if (snapshot.docs.isNotEmpty) {
      Map<String, dynamic> userMap =
          snapshot.docs[0].data() as Map<String, dynamic>;

      return UserModel.fromMap(userMap);
    }

    return null;
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
        backgroundColor: Color(0xFF085F63),
        title: Text('Notifications'),
      ),
      body: ListView.builder(
        itemCount: widget.productNames.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 5,
            margin: EdgeInsets.all(8),
            child: ListTile(
              contentPadding: EdgeInsets.all(8),
              leading: CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(widget.image[index]),
              ),
              title: Text(widget.productNames[index]),
              subtitle: Text(widget.Fname[index]),
              onTap: () async {
                String Pname = widget.productNames[index];
                String Uname = widget.Fname[index];

                // Show confirmation dialog
                bool? result = await showYesNoDialog(
                  context,
                  'Chat Request for $Pname',
                  'Requested By: $Uname \nInterested in Selling!',
                );

                if (result != null && result) {
                  // User selected "Yes"
                  print('User is interested!');
                  showToast(context,
                      "Please wait... Creating your chat!"); // included the code... after final Submission

                  try {
                    UserModel? searchedUser =
                        await getUserByEmail(widget.targetEmail[index]);

                    if (searchedUser != null) {
                      ChatRoomModel? chatroomModel = await getChatroomModel(
                          searchedUser, widget.productID[index]);

                      if (chatroomModel != null) {
                        bool result = await _updateRequestList(
                            widget.targetEmail[index],
                            widget.productID,
                            widget.userUID,
                            index);
                        if (result) {
                          Navigator.pop(context);
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ChatRoomPage(
                              targetUser: searchedUser,
                              userModel: widget.userModel,
                              firebaseUser: widget.firebaseUser,
                              chatroom: chatroomModel,
                            );
                          }));
                          showToast(context,
                              "Chat Created Sucessfully!"); // included the code... after final submission
                          // Remove the item at the specified indexed value...
                          setState(() {
                            widget.productNames
                                .remove(widget.productNames[index]);
                            widget.userUID.remove(widget.userUID[index]);
                            widget.image.remove(widget.image[index]);
                            widget.Fname.remove(widget.Fname[index]);
                            widget.targetEmail
                                .remove(widget.targetEmail[index]);
                          });
                        } else {
                          Navigator.pop(context);
                        }
                      }
                    } else {
                      print("User not found!");
                    }
                  } catch (error) {
                    print('Error: $error');
                  }
                } else {
                  // User selected "No" or closed the dialog
                  print('User is not interested.');
                  // ignore: unused_local_variable
                  bool result = await _updateblockList(
                      widget.targetEmail[index],
                      widget.productID,
                      widget.userUID,
                      index);
                }
              },
            ),
          );
        },
      ),
    );
  }

  void showToast(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2), // Adjust the duration as needed
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<bool> _updateRequestList(
      String userUID, List<String> P_name, List<String> U_ID, int indx) async {
    Map<String, String> requestMap = {};

    if (P_name.isNotEmpty && U_ID.isNotEmpty && P_name.length == U_ID.length) {
      // print('P_name: $P_name');
      // print('U_ID: ${U_ID}');

      print('removed U_ID: ${U_ID[indx]}');
      print('removed P_name: ${P_name[indx]}');
      U_ID.remove(U_ID[indx]);
      P_name.remove(P_name[indx]);

      print('updated P_name: $P_name');
      print('updated U_ID: $U_ID');

      // print('U_ID: ${(U_ID.length).toString()}');

      for (var i = 0; i < U_ID.length; i++) {
        var x = U_ID[i];
        var y = P_name[i];
        requestMap[y] = x;
      }

      // Optionally, clear the original lists after populating requestMap
      // P_name.clear();
      // U_ID.clear();
    } else {
      print('Invalid or empty lists.');
    }

    print('requestMap: $requestMap');

    // return true;
    try {
      List<Map<String, dynamic>> _Results = [];
      QuerySnapshot querySnapshotProductsName = await FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: widget.myuid)
          .get();

      if (querySnapshotProductsName.docs.isNotEmpty) {
        _Results = querySnapshotProductsName.docs
            .map((doc) => {
                  'requestCount': doc['requestCount'],
                })
            .toList();
      } else {
        print("Error Occurred...Check Internet Connection.(Notification Page)");
      }

      if (_Results.isNotEmpty) {
        userDocument =
            FirebaseFirestore.instance.collection('users').doc(widget.myuid);

        int count = int.tryParse(_Results[0]['requestCount'].toString()) ?? 0;
        print('requestCount: $count');
        if (count >= 0) {
          count--;
        } else {
          count = 0;
        }

        await userDocument.update({'request': requestMap});
        await userDocument.update({'requestCount': count.toString()});

        return true; // Return true to indicate success
      } else {
        print("No results found in user data.");
        return false; // Return false to indicate failure
      }
    } catch (error) {
      print('Error updating request: $error');
      return false; // Return false to indicate failure
    }
  }

  Future<bool> _updateblockList(
      String userUID, List<String> P_name, List<String> U_ID, int indx) async {
    Map<String, dynamic> changes = {};
    var x = U_ID[indx];
    var y = P_name[indx];
    // BlockedMap[y] = x;
    try {
      List<Map<String, dynamic>> _Results = [];
      QuerySnapshot querySnapshotProductsName = await FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: widget.myuid)
          .get();

      if (querySnapshotProductsName.docs.isNotEmpty) {
        _Results = querySnapshotProductsName.docs
            .map((doc) => {
                  'blocked': doc['blocked'],
                  // 'requestCount': doc['requestCount'],
                })
            .toList();
      } else {
        print("Error Occurred...Check Internet Connection.(Notification Page)");
      }

      if (_Results.isNotEmpty) {
        userDocument =
            FirebaseFirestore.instance.collection('users').doc(widget.myuid);
        Map<String, dynamic> BlockedMap =
            _Results[0]['blocked'] != null ? _Results[0]['blocked'] : {};
        changes[y] = x;
        BlockedMap.addAll(changes);
        // int count = int.tryParse(_Results[0]['RequestCount'].toString()) ?? 0;
        // count--;

        if (_Results[0]['blocked'] == null) {
          _Results[0]['blocked'] = {};
        }

        // print(BlockedMap);
        // print(count.toString());

        await userDocument.update({'blocked': BlockedMap});
        // ignore: unused_local_variable
        bool result = await _updateRequestList(userUID, P_name, U_ID, indx);
        // await userDocument.update({'RequestCount': count.toString()});
        return true;
      } else {
        print("No results found in user data.");
        return false; // Return false to indicate failure
      }
    } catch (error) {
      print('Error updating request: $error');
      return false; // Return false to indicate failure
    }
  }
}
