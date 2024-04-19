import 'package:expenses_tracker_app/data/custom_icon_data.dart';
import 'package:expenses_tracker_app/data/list_color_data.dart';
import 'package:expenses_tracker_app/firebase/firebase.dart';
import 'package:expenses_tracker_app/main.dart';
import 'package:expenses_tracker_app/models/category.dart';
import 'package:expenses_tracker_app/models/custom_icon.dart';
import 'package:expenses_tracker_app/models/my_color_picker.dart';
import 'package:expenses_tracker_app/sceens/drawer/category/icon_repository.dart';
import 'package:expenses_tracker_app/widgets/category/custom_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

// ignore: must_be_immutable
class CreateCategoryScreen extends StatefulWidget {
  CreateCategoryScreen({super.key, required this.isExpense, this.category});
  bool isExpense;
  Category? category;

  @override
  State<CreateCategoryScreen> createState() => _CreateCategoryState();
}

class _CreateCategoryState extends State<CreateCategoryScreen> {
  List<CustomIcon> listIcon = [];
  List<MyColorPicker> listColors = [];
  CustomIcon? icon;
  Color colorPicker = kColorScheme.primary;
  late Color tempColor;
  TextEditingController categoryName = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isSubmited = false;

  void createCategory() async {
    final isValidForm = formKey.currentState!.validate();
    if (!isValidForm) {
      return;
    }
    formKey.currentState!.save();
    setState(() {
      isSubmited = true;
    });
    return await FirebaseAPI.setCategory(
          widget.category?.categoryId,
          categoryName.text,
          colorPicker.value,
          icon!.iconData.codePoint.toString(),
          widget.isExpense,
          widget.category?.createAt,)
      .whenComplete(() => Navigator.pop(context,widget.isExpense));
  }

  List<CustomIcon> getIconFromRepo() {
    List<CustomIcon> listIcon = [];
    for (int i = 0; i < 15; i++) {
      var key = customIcon.keys.elementAt(i % customIcon.length);
      var value = customIcon[key];
      if (!listIcon.contains(value![0])) {
        listIcon.add(value[0]);
      } else {
        listIcon.add(value[1]);
      }
    }
    return listIcon;
  }

  showPickerColor() {
    return showDialog(
      context: context,
      builder: (context) => SizedBox(
        height: 100,
        child: AlertDialog(
          title: const Text('Chọn màu'),
          content: ColorPicker(
            enableAlpha: false,
            pickerColor: colorPicker,
            onColorChanged: (value) {
              tempColor = value;
            },
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Huỷ")),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    if (colors.indexWhere(
                            (element) => element.isSelected == true) >=
                        0) {
                      colors
                          .elementAt(colors.indexWhere(
                              (element) => element.isSelected == true))
                          .isSelected = false;
                    }
                    colorPicker = tempColor;
                    colors[0].color = colorPicker;
                    colors[0].isSelected = true;
                  });
                },
                child: const Text("OK")),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    customIcon.forEach((key, value) {
      for (var icon in value) {
        icon.picked = false;
      }
    });
    for (var color in colors) {
      color.isSelected = false;
    }
    listIcon = getIconFromRepo();
    listColors = colors.sublist(0,colors.length);
    if(widget.category != null){
      icon = CustomIcon(iconData: IconData(int.parse(widget.category!.symbol),fontFamily: "MyIcon"),picked: true);
      colorPicker = Color(widget.category!.color);
      widget.isExpense = widget.category!.type;
      MyColorPicker categoryColor = MyColorPicker(color: colorPicker,isSelected: true);
      if(listColors.indexWhere((element) => element.color.value == categoryColor.color.value) > - 1){
        listColors[listColors.indexWhere((element) => element.color.value == categoryColor.color.value)].isSelected = true;
      }else{
        listColors.insert(0, categoryColor);
        listColors.removeLast();
      }
      if(listIcon.indexWhere((element) => element.iconData.codePoint == icon!.iconData.codePoint) > - 1){
        listIcon[listIcon.indexWhere((element) => element.iconData.codePoint == icon!.iconData.codePoint)].picked = true;
      }else{
        listIcon.insert(0, icon!);
        listIcon.removeLast();
      }
      categoryName.text = widget.category!.categoryName;
    }
  }

  @override
  void dispose(){
    super.dispose();
    categoryName.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category != null ? 'Chỉnh sửa danh mục' : 'Tạo danh mục'),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: icon != null ? colorPicker : null),
                    child: icon != null
                        ? Icon(
                            icon!.iconData,
                            color: Colors.white,
                          )
                        : const Icon(Icons.block),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Form(
                      key: formKey,
                      child: TextFormField(
                        controller: categoryName,
                        maxLength: 50,
                        style: const TextStyle(fontSize: 18),
                        decoration: const InputDecoration(
                          errorStyle: TextStyle(fontSize: 14),
                          hintText: "Tên danh mục",
                          counterText: '',
                        ),
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.none,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Chưa nhập tên danh mục';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          categoryName.text = value!.trim();
                        },
                        onTapOutside: (event) => FocusScope.of(context).unfocus(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 3 / 5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      child: Row(
                        children: [
                          Radio(
                            visualDensity: const VisualDensity(
                              horizontal: VisualDensity.minimumDensity,
                            ),
                            value: true,
                            groupValue: widget.isExpense,
                            onChanged: (value) {
                              setState(() {
                                widget.isExpense = value!;
                              });
                            },
                          ),
                          const Text(
                            'Chi phí',
                            style: TextStyle(color: Colors.black),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      child: Row(
                        children: [
                          Radio(
                            visualDensity: const VisualDensity(
                              horizontal: VisualDensity.minimumDensity,
                            ),
                            value: false,
                            groupValue: widget.isExpense,
                            onChanged: (value) {
                              setState(() {
                                widget.isExpense = value!;
                              });
                            },
                          ),
                          const Text(
                            'Thu nhập',
                            style: TextStyle(color: Colors.black),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                'Biểu tượng',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: SizedBox(
                  height: 370,
                  child: GridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 4,
                    children: List.generate(
                      listIcon.length + 1,
                      (index) {
                        if (index < listIcon.length) {
                          return GestureDetector(
                            onTap: () {
                                if (listIcon[index].picked == false) {
                                  setState(() {
                                    for(var icon in listIcon){
                                    icon.picked = false;
                                  }
                                  listIcon[index].picked = true;
                                  icon = listIcon[index];
                                  });
                                }
                            },
                            child: CustomIconItem(
                              icon: listIcon[index],
                              color: colorPicker,
                            ),
                          );
                        } else {
                          return GestureDetector(
                            onTap: () async {
                              icon = await Navigator.push(context,MaterialPageRoute(builder: (context) => IconRepo(color: colorPicker,)));
                              if (icon != null) {
                                setState(() {
                                  if (!listIcon.contains(icon)) {
                                    for(var icon in listIcon){
                                      icon.picked = false;
                                    }
                                    listIcon.removeLast();
                                    listIcon.insert(0, icon!);
                                  }
                                });
                              }
                            },
                            child: CustomIconItem(
                              icon: null,
                              color: colorPicker,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                'Màu sắc',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              const SizedBox(
                height: 8,
              ),
              Center(
                child: Wrap(
                  direction: Axis.horizontal,
                  children: List.generate(
                    8,
                    (index) {
                      if (index < 7) {
                        return GestureDetector(
                          onTap: () {
                            if(listColors[index].isSelected == false){
                              for(var color in listColors){
                                color.isSelected = false;
                              }
                              setState(() {
                                colorPicker = listColors[index].color;
                                listColors[index].isSelected = true;
                              });
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: listColors[index].color,
                              child: listColors[index].isSelected
                                  ? const Icon(Icons.check, color: Colors.white)
                                  : null,
                            ),
                          ),
                        );
                      } else {
                        return GestureDetector(
                          onTap: showPickerColor,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.grey[500],
                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 32,),
              Center(
                child: ElevatedButton(
                  onPressed: icon == null
                      ? null
                      : colorPicker == kColorScheme.primary
                          ? null
                          : isSubmited
                              ? null
                              : createCategory,
                  child: isSubmited
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(),
                        )
                      : Text(
                          widget.category != null ? 'Lưu' : 'Thêm',
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.normal),
                        ),
                ),
              ),
              const SizedBox(height: 16,)
            ],
          ),
        ),
      ),
    );
  }
}
