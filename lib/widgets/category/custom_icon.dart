import 'package:expenses_tracker_app/models/custom_icon.dart';
import 'package:flutter/material.dart';

class CustomIconItem extends StatelessWidget {
  const CustomIconItem({super.key, required this.icon, required this.color});
  final CustomIcon? icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: icon != null
            ? icon!.picked
                ? Colors.white
                : null
            : null,
        boxShadow: icon != null
            ? icon!.picked
                ? [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3), 
                    ),
                  ]
                : null
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              height: icon != null ? MediaQuery.of(context).size.width / 6 : MediaQuery.of(context).size.width / 8,
              width: icon != null ? MediaQuery.of(context).size.width / 6 : MediaQuery.of(context).size.width / 8,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: icon != null ? icon!.picked ? color : Colors.grey : Colors.yellow[700]),
              child: Icon(
                icon != null ? icon!.iconData : Icons.more_horiz_outlined,
                size: MediaQuery.of(context).size.width / 11,
                color: Colors.white,
              )),
        ],
      ),
    );
  }
}
