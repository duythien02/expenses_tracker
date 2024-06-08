import 'package:expenses_tracker_app/data/custom_icon_data.dart';
import 'package:expenses_tracker_app/main.dart';
import 'package:expenses_tracker_app/models/custom_icon.dart';
import 'package:expenses_tracker_app/widgets/category/custom_icon.dart';
import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

// ignore: must_be_immutable
class IconRepoScreen extends StatelessWidget {
  IconRepoScreen({super.key, required this.color});
  final Color color;

  late CustomIcon pickedIcon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kho biểu tượng'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: customIcon.length,
              itemBuilder: (context, index1) => StickyHeader(
                header: Container(
                  width: double.infinity,
                  color: kColorScheme.surface,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 20, top: 12, bottom: 10),
                    child: Text(
                      customIcon.keys.toList()[index1],
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                content: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 4,
                    children: List.generate(
                      customIcon[customIcon.keys.toList()[index1]]!.length,
                      (index) {
                        List<CustomIcon> listIcon =
                            customIcon[customIcon.keys.toList()[index1]]!;
                        return GestureDetector(
                          onTap: () {
                            customIcon.forEach((key, value) {
                              for (var icon in value) {
                                icon.picked = false;
                              }
                            });
                            listIcon[index].picked = true;
                            Navigator.pop(
                                context,
                                listIcon
                                    .firstWhere((icon) => icon.picked == true));
                          },
                          child: CustomIconItem(
                            icon: listIcon[index],
                            color: color,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
