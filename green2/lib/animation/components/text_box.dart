import 'package:flutter/material.dart';

class MyTextBox extends StatelessWidget {
  final String text;
  //final void Function()? onPressed;
  final String sectionname;
  const MyTextBox({
    super.key,
    required this.sectionname,
    required this.text,
    // required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.only(
        left: 15,
        bottom: 15,
      ),
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              //username
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  sectionname,
                  style: TextStyle(color: Colors.grey[500]),
                ),
              ),
              // edit button
              // const IconButton(
              //     onPressed: onPressed,
              //     icon: Icon(Icons.settings),
              //     color: Colors.grey[400]),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 8.0),
            child: Text(text),
          ),
        ],
      ),
    );
  }
}
