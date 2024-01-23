import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:green2/animation/components/GradientBackgroundButton.dart';
import 'package:green2/model/component/Dropdown.dart';
import 'package:green2/model/component/TextField.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart' as Path;
import 'package:image_cropper/image_cropper.dart';

class ProductEntryPage extends StatefulWidget {
  @override
  _ProductEntryPageState createState() => _ProductEntryPageState();
}

class _ProductEntryPageState extends State<ProductEntryPage> {
  late DatabaseReference dbRef;
  late DatabaseReference iRef;
  late DocumentReference userDocument;
  late CollectionReference<Map<String, dynamic>> imgRef;
  late firebase_storage.Reference ref;
  dynamic errorTextEmail;
  bool isSignup = false;
  bool clickLogin = false;
  Duration duration = const Duration(seconds: 1);
  // List<XFile> _selectedImages = [];
  PageController _pageController = PageController();
  TextEditingController _productTitleController = TextEditingController();
  String? selectedType;
  String? selectedYearOfManufacturing;
  TextEditingController _priceController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  bool isDividerVisible = false;
  String? selectedState;
  TextEditingController _cityController = TextEditingController();
  bool uploading = false;
  double val = 0;
  List<File> _image = [];
  File? imageFile;

  final picker = ImagePicker();
  final currentuser = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child("users");
    iRef = FirebaseDatabase.instance.ref().child("users");
    imgRef = FirebaseFirestore.instance.collection('Products');
    userDocument = FirebaseFirestore.instance.collection('users').doc('admin');
  }

  void selectImage(ImageSource source) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      cropImage(pickedFile);
    }
  }

  void cropImage(XFile file) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
        sourcePath: file.path,
        aspectRatio: CropAspectRatio(ratioX: 2.9, ratioY: 2),
        compressQuality: 20);

    if (croppedImage != null) {
      setState(() {
        // imageFile = File(croppedImage.path);
        _image.add(File(croppedImage.path));
      });
    }
  }

  void showPhotoOption() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Upload Profile Picture"),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  selectImage(ImageSource.gallery);
                },
                leading: const Icon(Icons.photo_album),
                title: const Text("Select from Gallery."),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  selectImage(ImageSource.camera);
                },
                leading: Icon(Icons.camera_alt),
                title: Text("Take a photo!"),
              ),
            ]),
          );
        });
  }

  String? _validateProductTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Product title is required';
    }
    return null;
  }

  String? _validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please fill the price';
    } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Please enter price in numbers';
    }
    return null;
  }

  String? _validateCity(String? value) {
    if (value == null || value.isEmpty) {
      return 'City is required';
    }
    return null;
  }

  String? _validateDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Description is required';
    }
    return null;
  }

  Future<void> chooseImage() async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image.add(File(pickedFile.path));
        });
      }
    } catch (e) {
      showErrorMessage("Failed to add");
    }
  }

  void _removeImage(int index) {
    setState(() {
      _image.removeAt(index);
      if (_image.isEmpty) {
        isDividerVisible = false;
      }
    });
  }

  Future<void> _submitProduct() async {
    // Validation code
    String productTitle = _productTitleController.text.trim();
    String price = _priceController.text.trim();
    String description = _descriptionController.text.trim();
    String city = _cityController.text.trim();
    int? P_count;

    if (productTitle.isEmpty ||
        price.isEmpty ||
        description.isEmpty ||
        city.isEmpty) {
      showErrorMessage("Fill all Fields");
      return;
    }
    DocumentSnapshot documentSnapshot =
        await FirebaseFirestore.instance.collection('users').doc('admin').get();

    if (documentSnapshot.exists) {
      var productCount = (documentSnapshot.data()
          as Map<String, dynamic>?)?['P_count'] as String?;
      P_count = int.parse(productCount!);
      P_count++;
    } else {
      showErrorMessage("Check Internet Connection...");
    }
    if (P_count != null) {
      // Define the data to be stored
      Map<String, dynamic> productData = {
        'product_title': productTitle,
        'type': selectedType ?? '', // You can handle null here
        'year_of_manufacturing':
            selectedYearOfManufacturing ?? '', // You can handle null here
        'price': price,
        'description': description,
        'state': selectedState ?? '', // You can handle null here
        'city': city,
        'email': currentuser.email,
        'uid': currentuser.uid,
        'P_id': 'P$P_count',
        // 'ImageURL': {},
      };

      Future uploadFile(
          String productTitle, Map<String, dynamic> productData) async {
        int i = 0;
        int k = 1;
        Map<String, dynamic> imageURLs = {}; // Map to store image URLs

        for (var img in _image) {
          setState(() {
            val = k / _image.length;
          });

          ref = firebase_storage.FirebaseStorage.instance
              .ref()
              .child('images/${Path.basename(img.path)}');

          await ref.putFile(img).whenComplete(() async {
            await ref.getDownloadURL().then((value) {
              imageURLs[i.toString()] = value; // Add imageURL to the map
              k++;
            });
          });

          i++;

          if (val == 1) {
            // Outside the loop, add the entire map to Firestore

            productData['ImageURLs'] = imageURLs;
            // dbRef.child(productTitle).set(productData);
            imgRef.add(productData);
            setState(() {
              uploading = false;
              showErrorMessage("Product Uploaded");
            });
          }
        }
        //....................................................update the user Item List
        List<Map<String, dynamic>> _Result = [];
        QuerySnapshot querySnapshotProductsName = await FirebaseFirestore
            .instance
            .collection('users')
            .where('uid', isEqualTo: currentuser.uid)
            .get();

        if (querySnapshotProductsName.docs.isNotEmpty) {
          _Result = querySnapshotProductsName.docs
              .map((doc) => {
                    'MyProducts': doc['MyProducts'] ?? [],
                  })
              .toList();
          if (_Result.isNotEmpty) {
            List<dynamic> existingMyProducts = _Result[0]['MyProducts'] ?? [];
            existingMyProducts.add(productData['P_id']);

            // Update the 'myproducts' array in Firestore
            await FirebaseFirestore.instance
                .collection('users')
                .doc(currentuser.uid)
                .update({'MyProducts': existingMyProducts});

            print('myproducts updated successfully by 1 ${existingMyProducts}');
          } else {
            List<String> myproducts = [];
            myproducts.add(productData['P_id']);
            await FirebaseFirestore.instance
                .collection('users')
                .doc(currentuser.uid)
                .update({'myproducts': myproducts});
            print('myproducts updated successfully by 2');
          }
        } else {
          showErrorMessage("Error Occurred...Check Internet Connection.");
        }

        print("am here!");
        await userDocument.update({'P_count': P_count.toString()});
      }

      uploadFile(productTitle, productData);
    } else {
      // showErrorMessage("failed to Post Item... try again latter");
      setState(() {
        uploading = false;
        showErrorMessage("failed to Post Item... try again latte");
      });
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE0E0E0),
      body: Stack(
        children: [
          Container(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                // Wrap the Container with ClipRRect
                borderRadius: BorderRadius.circular(10.0),
                child: Container(
                  constraints:
                      const BoxConstraints.expand(width: 380, height: 900),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      //set border radius more than 50% of height and width to make circle
                    ),
                    shadowColor: Color.fromARGB(233, 0, 0, 0),
                    margin: const EdgeInsets.all(2),
                    elevation: 90,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(
                          15), //...............................................
                      child: Column(
                        children: <Widget>[
                          if (_image.isNotEmpty)
                            Card(
                              elevation: 4.0,
                              child: Container(
                                height: 150.0,
                                child: PageView.builder(
                                  controller: _pageController,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _image.length,
                                  itemBuilder: (context, index) {
                                    return Center(
                                      child: Stack(
                                        alignment: Alignment.topRight,
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Image.file(
                                              File(_image[index].path),
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                          Positioned(
                                            top: 8.0,
                                            right: 8.0,
                                            child: IconButton(
                                              icon: Icon(Icons.close),
                                              onPressed: () {
                                                _removeImage(index);
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          if (isDividerVisible)
                            Container(
                              height: 2.0,
                              color: Colors.grey,
                            ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          SizedBox(
                            height: 45, // Height of the button
                            width: 100,
                            child: ElevatedButton(
                              // onPressed: _addImage,
                              onPressed: () =>
                                  // !uploading ? chooseImage() : null,
                                  !uploading ? showPhotoOption() : null,
                              child: Text('Add Image'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(
                                    0xFF085F63), // Set the button's background color to green
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Color.fromARGB(255, 62, 62, 62),
                                  width: 1.0,
                                ),
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                "Product Details",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 62, 62, 62),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          TextFieldWidget(
                            hintText: 'Product Title *',
                            obscureText: false,
                            prefixIconData: Icons.recycling,
                            textEditingController: _productTitleController,
                            validator: _validateProductTitle,
                          ),
                          const SizedBox(height: 10.0),
                          DropdownWidget(
                            width: double.infinity,
                            hintText: 'Product Type *',
                            prefixIconData: Icons.category,
                            dropdownItems: const [
                              'Circuit Boards',
                              'Large Appliances',
                              'Office Electronics',
                              'Small Appliances',
                              'Mobiles',
                            ],
                            selectedValue: selectedType,
                            onChanged: (value) {
                              // Handle dropdown value change
                              setState(() {
                                selectedType = value;
                              });
                            },
                          ),
                          const SizedBox(height: 10.0),
                          DropdownWidget(
                            width: double.infinity,
                            hintText: 'Product Year *',
                            prefixIconData: Icons.calendar_month,
                            dropdownItems: const [
                              '2023',
                              '2022',
                              '2021',
                              '2020',
                              '2019',
                              '2018',
                              '2017',
                              '2016',
                              '2015',
                              '2014',
                              '2013',
                              '2012',
                              '2011',
                              '2010',
                              '2009',
                              '2008',
                              '2007',
                              '2006',
                              '2005',
                              '2004',
                              '2003',
                              '2002',
                              '2001',
                              '2000',
                            ],
                            selectedValue: selectedYearOfManufacturing,
                            onChanged: (value) {
                              // Handle dropdown value change
                              setState(() {
                                selectedYearOfManufacturing = value;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          TextFieldWidget(
                            hintText: 'Expected Price *',
                            obscureText: false,
                            keyboardType: TextInputType.number,
                            prefixIconData: Icons.money_rounded,
                            textEditingController: _priceController,
                            validator: _validatePrice,
                          ),
                          const SizedBox(height: 10.0),
                          Container(
                            width: double.infinity,
                            child: DropdownWidget(
                              // width: 200,
                              hintText: 'State *',
                              prefixIconData: Icons.map_outlined,
                              dropdownItems: const [
                                'Andhra Pradesh',
                                'Arunachal Pradesh',
                                'Assam',
                                'Bihar',
                                'Chhattisgarh',
                                'Goa',
                                'Gujarat',
                                'Haryana',
                                'Himachal Pradesh',
                                'Jharkhand',
                                'Karnataka',
                                'Kerala',
                                'Madhya Pradesh',
                                'Maharashtra',
                                'Manipur',
                                'Meghalaya',
                                'Mizoram',
                                'Nagaland',
                                'Odisha',
                                'Punjab',
                                'Rajasthan',
                                'Sikkim',
                                'Tamil Nadu',
                                'Telangana',
                                'Tripura',
                                'Uttar Pradesh',
                                'Uttarakhand',
                                'West Bengal',
                                'Andaman and Nicobar Islands',
                                'Chandigarh',
                                'Dadra and Nagar Haveli and Daman and Diu',
                                'Lakshadweep',
                                'Delhi',
                                'Puducherry',
                              ],
                              selectedValue: selectedState,
                              onChanged: (value) {
                                // Handle dropdown value change
                                setState(() {
                                  selectedState = value;
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          TextFieldWidget(
                            hintText: 'City *',
                            obscureText: false,
                            prefixIconData: Icons.location_city,
                            textEditingController: _cityController,
                            validator: _validateCity,
                          ),
                          const SizedBox(height: 10.0),
                          TextFieldWidget(
                            hintText: 'Description *',
                            obscureText: false,
                            prefixIconData: Icons.location_city,
                            textEditingController: _descriptionController,
                            maxLines: 3,
                            validator: _validateDescription,
                          ),
                          const SizedBox(height: 10.0),
                          // SizedBox(
                          //   height: 45,
                          //   width: 145,
                          //   child: ElevatedButton(
                          //     onPressed: () {
                          //       if (uploading) {
                          //         null;
                          //       } else {
                          //         setState(() {
                          //           uploading = true;
                          //         });
                          //         _submitProduct();
                          //       }
                          //       uploading ? null : _submitProduct();
                          //     },
                          //     style: ElevatedButton.styleFrom(
                          //       backgroundColor: const Color(
                          //           0xFF085F63), // Set the button's background color to green
                          //       shape: RoundedRectangleBorder(
                          //         borderRadius: BorderRadius.circular(20),
                          //       ),
                          //     ),
                          //     child: const Text('Post Product'),
                          //   ),
                          // ),
                          GradientBackgroundButton(
                            materialStatePropertyShape:
                                MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            )),
                            icon: const Icon(Icons.add,
                                color: Colors.white, size: 20),
                            leftIcon: 20,
                            child: Text('Post Product',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white)),
                            gradient: const LinearGradient(
                              colors: <Color>[
                                Color(0xff004d7a),
                                Color(0xff008793),
                                Color(0xff00bf72),
                                Color(0xffa8eb12),
                              ],
                            ),
                            onPressed: () {
                              if (uploading) {
                                null;
                              } else {
                                setState(() {
                                  uploading = true;
                                });
                                _submitProduct();
                              }
                              uploading ? null : _submitProduct();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          uploading
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Uploading...',
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ), // Container
                      CircularProgressIndicator(
                        value: val,
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.green),
                      ), // CircularProgressIndicator
                    ],
                  ), // Column
                )
              : Container(),
        ],
      ),
    );
  }
}
