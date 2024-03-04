import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ItemDrawer extends StatelessWidget {
  ItemDrawer({super.key, required this.destination, required this.icon, required this.title});

  Widget destination;
  IconData icon;
  String title;

  @override
  Widget build(BuildContext context) {
    return InkWell(
    onTap: () {
      Navigator.of(context).pop();
      Navigator.pushAndRemoveUntil(
          context, MaterialPageRoute(builder: (context) => destination),(route) => route.isFirst);
    },
    child: Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Icon(icon, color: Colors.white,),
          const SizedBox(width: 20,),
          Text(title)
        ],
      ),
    ),
  );
  }
}