import 'package:flutter/material.dart';
import 'package:green2/Home/component/list_tiles.dart';

class Mydrawer extends StatelessWidget {
  final void Function()? onProfileTap;
  final void Function()? onSignout;
  const Mydrawer(
      {super.key, required this.onProfileTap, required this.onSignout});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.green[300],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const DrawerHeader(
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 64,
                ),
              ),
              MyListTile(
                icon: Icons.home,
                text: "H O M E",
                onTap: () => Navigator.pop(context),
              ),
              MyListTile(
                icon: Icons.person,
                text: "P R O F I L E",
                onTap: onProfileTap,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 25.0),
            child: MyListTile(
              icon: Icons.home,
              text: "L O G  O U T",
              onTap: onSignout,
            ),
          ),
        ],
      ),
    );
  }
}
