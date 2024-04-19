import 'package:expenses_tracker_app/data/curencies_data.dart';
import 'package:expenses_tracker_app/main.dart';
import 'package:expenses_tracker_app/models/currency.dart';
import 'package:flutter/material.dart';

class PickCurrencyScreen extends StatefulWidget {
  const PickCurrencyScreen({super.key, required this.currency});

  final Currency currency;

  @override
  State<PickCurrencyScreen> createState() => _PickCurrencyScreenState();
}

class _PickCurrencyScreenState extends State<PickCurrencyScreen> {
  final List<Currency> listCurrency = currencies;
  bool isSearching = false;
  List<Currency> _searchList = [];
  bool pickCurrency = false;

  @override
  void initState() {
    super.initState();
    for(var cur in listCurrency){
      cur.picked = false;
    }
    var index = listCurrency.indexWhere((element) => element.code == widget.currency.code);
    listCurrency.elementAt(index).picked = true;
  }

  void runFilter(String enteredKeyword) {
    _searchList.clear();
    for (var currency in listCurrency) {
      if (currency.name.toLowerCase().contains(enteredKeyword.toLowerCase()) || currency.code.toLowerCase().contains(enteredKeyword.toLowerCase())) {
      _searchList.add(currency);
      }
    }
    setState(() {
      _searchList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSearching 
          ? TextField(
            style: const TextStyle(
              color: Colors.white
            ),
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Tìm kiếm',
              hintStyle: TextStyle(
                color: Colors.grey[300],
                fontWeight: FontWeight.w400
              ),
            ),
            onChanged: (value) => runFilter(value),
          ) 
          : const Text('Tiền tệ'),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              setState(() {
                isSearching = !isSearching;
                _searchList = listCurrency.sublist(0,listCurrency.length);
              });
            },
            child: isSearching ? const Icon(Icons.clear) : const Icon(Icons.search),
          ),
          const SizedBox(width: 16,),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.builder(
          itemBuilder: (context,index) => isSearching 
          ? Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: _searchList[index].picked  ? kColorScheme.primaryContainer : Colors.white,
            ),
            child: GestureDetector(
              onTap: () {
                if(_searchList.indexWhere((e) => e.picked == true) >= 0){
                    _searchList[_searchList.indexWhere((e) => e.picked == true)].picked = false;
                  }
                _searchList[index].picked = true;
                Navigator.pop(context,_searchList[index]);
              },
              child: ListTile(
                title: Text(_searchList[index].name),
                trailing: Text(_searchList[index].code),
              ),
            ),
          )
          : Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: listCurrency[index].picked  ? kColorScheme.primaryContainer : kColorScheme.background,
            ),
            child: GestureDetector(
              onTap: () {
                if(listCurrency.indexWhere((e) => e.picked == true) >= 0){
                    listCurrency[listCurrency.indexWhere((e) => e.picked == true)].picked = false;
                  }
                listCurrency[index].picked = true;
                Navigator.pop(context,listCurrency[index]);
              },
              child: ListTile(
                title: Text(listCurrency[index].name,),
                trailing: Text(listCurrency[index].code),
              ),
            ),
          ),
          itemCount: isSearching ? _searchList.length :  listCurrency.length,
        ),
      ),
    );
  }
}