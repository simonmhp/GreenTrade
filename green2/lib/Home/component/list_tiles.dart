import 'package:flutter/material.dart';

class MyListTile extends StatelessWidget {
  final IconData icon;
  final void Function()? onTap;
  final String text;
  const MyListTile({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: ListTile(
          leading: Icon(
            icon,
            color: Colors.white,
          ),
          onTap: onTap,
          title: Text(
            text,
            style: TextStyle(color: Colors.white),
          )),
    );
  }
}
