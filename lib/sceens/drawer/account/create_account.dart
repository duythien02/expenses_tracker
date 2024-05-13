import 'package:expenses_tracker_app/data/curencies_data.dart';
import 'package:expenses_tracker_app/data/custom_icon_data.dart';
import 'package:expenses_tracker_app/data/list_color_data.dart';
import 'package:expenses_tracker_app/firebase/firebase.dart';
import 'package:expenses_tracker_app/main.dart';
import 'package:expenses_tracker_app/models/account.dart';
import 'package:expenses_tracker_app/models/currency.dart';
import 'package:expenses_tracker_app/models/custom_icon.dart';
import 'package:expenses_tracker_app/models/my_color_picker.dart';
import 'package:expenses_tracker_app/models/transfer.dart';
import 'package:expenses_tracker_app/sceens/drawer/account/pick_currency.dart';
import 'package:expenses_tracker_app/widgets/category/custom_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

// ignore: must_be_immutable
class CreateAccountScreen extends StatefulWidget {
  CreateAccountScreen({super.key, required this.currency, required this.account});
  Currency currency;
  Account? account;

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  TextEditingController balance = TextEditingController();
  TextEditingController accountName = TextEditingController();
  final formKey = GlobalKey<FormState>();
  List<MyColorPicker> listColors = [];
  List<CustomIcon> listIconAccount = [];
  Color colorPicker = kColorScheme.primary;
  late Color tempColor;
  bool isSubmited = false;
  bool isIconPicked = false;

  void createAccount() async {
    final isValidForm = formKey.currentState!.validate();
    if (!isValidForm) {
      return;
    }
    formKey.currentState!.save();
    setState(() {
      isSubmited = true;
    });
    if(widget.account != null && double.parse(balance.text) != widget.account!.accountBalance){
      double difference = double.parse(balance.text) - widget.account!.accountBalance;
      await FirebaseAPI.setTransfer(widget.account!, null, difference, DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day), null, TransferType.change.name);
    }
      return await FirebaseAPI.setAccount(
            widget.account?.accountId,
            accountName.text,
            double.parse(balance.text),
            widget.currency.code,
            widget.currency.name,
            widget.currency.locale,
            listIconAccount.firstWhere((element) => element.picked == true).iconData.codePoint.toString(),
            colorPicker.value,
            widget.account?.isMain,
            widget.account?.isActive,
            widget.account?.createAt
            )
        .whenComplete(() => Navigator.pop(context,false));
  }

  @override
  void initState() {
    super.initState();
    for (var icon in listIconForAccount) {
      icon.picked = false;
    }
    for (var color in colors) {
      color.isSelected = false;
    }
    listColors = colors.sublist(0,colors.length);
    listIconAccount = listIconForAccount;
    if(widget.account != null){
      widget.currency = currencies.firstWhere((element) => element.code == widget.account!.currencyCode);
      isIconPicked = true;
      if (!currenciesCodeHasDecimal.contains(widget.account!.currencyCode)) {
        balance.text = widget.account!.accountBalance.toStringAsFixed(0);
      }else{
        balance.text = widget.account!.accountBalance.toStringAsFixed(2);
      }
      colorPicker = Color(widget.account!.color);
      MyColorPicker categoryColor = MyColorPicker(color: colorPicker,isSelected: true);
      listIconAccount.elementAt(listIconAccount.indexWhere((element) => element.iconData.codePoint == int.parse(widget.account!.symbol))).picked = true;
      if(listColors.indexWhere((element) => element.color.value == categoryColor.color.value) > - 1){
        listColors[listColors.indexWhere((element) => element.color.value == categoryColor.color.value)].isSelected = true;
      }else{
        listColors.insert(0, categoryColor);
        listColors.removeLast();
      }
      accountName.text = widget.account!.accountName;
    }
  }

  @override
  void dispose() {
    super.dispose();
    balance.dispose();
    accountName.dispose();
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
                    if (colors.indexWhere((element) => element.isSelected == true) >=0) {
                      colors.elementAt(colors.indexWhere((element) => element.isSelected == true)).isSelected = false;
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.account != null ? const Text('Chỉnh sửa tài khoản') : const Text('Thêm tài khoản'),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        Container(
                          margin: const EdgeInsets.only(top: 5),
                          width: 120,
                          height: 70,
                          child: TextFormField(
                            controller: balance,
                            maxLength: 15,
                            autofocus: true,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 20),
                            decoration: InputDecoration(
                              counterText: '',
                              filled: true,
                              fillColor: kColorScheme.background,
                              hintStyle: const TextStyle(color: Colors.grey),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 0),
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp(',')),
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty){
                                return 'Vui lòng nhập số dư';
                              }else if(double.tryParse(value) == null ||  (value.contains('.') && value.split('.')[1].length > 2)){
                                return 'Số dư không hợp lệ';
                              }
                              return null;
                            },
                            onSaved: (value){
                              if(currenciesCodeHasDecimal.contains(widget.currency.code)){
                                  balance.text = value!.trim();
                                }else{
                                  balance.text = value!.split('.')[0];
                                }
                            },
                            onTapOutside: (event) => FocusScope.of(context).unfocus(),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: widget.account != null ? null : () async {
                              Currency? cur = await Navigator.push(context, MaterialPageRoute(builder: (context) => PickCurrencyScreen(currency: widget.currency,)));
                              if(cur != null){
                                setState(() {
                                  widget.currency = cur;
                                });
                              }
                            },
                            child: Text(widget.currency.code,
                              style: TextStyle(
                                color: widget.account != null ? Colors.black : kColorScheme.primary, fontSize: 20
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Tên tài khoản',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                    TextFormField(
                      controller: accountName,
                      maxLength: 50,
                      style: const TextStyle(fontSize: 18),
                      decoration: const InputDecoration(
                        errorStyle: TextStyle(fontSize: 14),
                        hintText: "Nhập tên tài khoản",
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
                        accountName.text = value!.trim();
                      },
                      onTapOutside: (event) => FocusScope.of(context).unfocus(),
                    ),
                  ],
                )
              ),
              const SizedBox(height: 24,),
              Text(
                'Biểu tượng',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              const SizedBox(height: 16,),
              SizedBox(
                height: 470,
                child: GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 4,
                  children: List.generate(
                    listIconAccount.length,
                    (index) {
                        return GestureDetector(
                          onTap: () {
                            if (listIconAccount[index].picked == false) {
                            setState(() {
                                for(var icon in listIconAccount){
                                  icon.picked = false;
                                }
                                listIconAccount[index].picked = true;
                                isIconPicked = true;
                            });
                            }
                          },
                          child: CustomIconItem(
                            icon: listIconAccount[index],
                            color: colorPicker,
                          ),
                        );
                    },
                  ),
                ),
              ),
              if(widget.account == null)
                Text(
                  'Chọn đơn vị tiền tệ',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              if(widget.account == null)
                InkWell(
                  onTap: () async {
                    Currency? cur = await Navigator.push(context, MaterialPageRoute(builder: (context) => PickCurrencyScreen(currency: widget.currency,)));
                    if(cur != null){
                      setState(() {
                        widget.currency = cur;
                      });
                    }
                  },
                  child: Text(widget.currency.code,
                    style: TextStyle(
                      color: kColorScheme.primary, fontSize: 20
                    ),
                  ),
                ),
              widget.account != null && !widget.account!.isMain ? Column(
                children: [
                  const SizedBox(height: 18,),
                  GestureDetector(
                    onTap: () async {
                      await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            contentPadding: const EdgeInsets.all(20),
                            actionsPadding: const EdgeInsets.only(right: 20),
                            content: const Text(
                              'Sau khi xoá tài khoản các giao dịch sẽ mất. Bạn có chắc chắn muốn xoá tài khoản này không?',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,),
                            ),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(context,false), child: const Text('Huỷ')),
                              TextButton(onPressed: () async {
                                Navigator.pop(context,true);
                                await FirebaseAPI.deleteAccount(widget.account!.accountId);
                              }, child: const Text('Xoá')),
                            ],
                          );
                        },
                      ).then((value) {
                        if(value){
                          Navigator.pop(context);
                        }
                      });
                    },
                    child: const Text('XOÁ',style: TextStyle(color: Colors.red,fontSize: 18),),
                  ),
                ],
              ) : Container(),
              const SizedBox(height: 16,),
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
                            for(var color in listColors){
                              color.isSelected = false;
                            }
                            setState(() {
                              colorPicker = listColors[index].color;
                              listColors[index].isSelected = true;
                            });
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
              const SizedBox(height: 18,),
              Center(
                child: ElevatedButton(
                  onPressed: isIconPicked == false
                      ? null
                      : colorPicker == kColorScheme.primary
                          ? null
                          : isSubmited
                              ? null
                              : createAccount,
                  child: isSubmited
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(),
                        )
                      : Text(
                          widget.account != null ? 'Lưu' : 'Thêm',
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