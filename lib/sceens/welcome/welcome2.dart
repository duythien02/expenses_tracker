import 'package:expenses_tracker_app/data/curencies_data.dart';
import 'package:expenses_tracker_app/helper/helper.dart';
import 'package:expenses_tracker_app/main.dart';
import 'package:expenses_tracker_app/models/currency.dart';
import 'package:expenses_tracker_app/sceens/welcome/welcome3.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WelcomScreen2 extends StatefulWidget {
  const WelcomScreen2 ({super.key});

  @override
  State<WelcomScreen2> createState() => _WelcomScreen2State();
}

class _WelcomScreen2State extends State<WelcomScreen2> {
  bool isSearching = false;
  final List<Currency> _searchList = [];
  bool pickCurrency = false;

  void _runFilter(String enteredKeyword) {
    _searchList.clear();
    for (var currency in currencies) {
      if (currency.name.toLowerCase().contains(enteredKeyword.toLowerCase()) || currency.code.toLowerCase().contains(enteredKeyword.toLowerCase())) {
      _searchList.add(currency);
      }
    }
    setState(() {
      isSearching = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion(
        value: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Theme.of(context).primaryColor
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
                children: [
                  const Text('Chọn đơn vị tiền tệ của bạn',style: TextStyle(color: Colors.black,fontSize: 24),),
                  searchBar(_runFilter),
                  const SizedBox(height: 14,),
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context,index) => isSearching 
                      ? Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          color: _searchList[index].picked  ? kColorScheme.primaryContainer : Colors.white,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              if(_searchList.indexWhere((e) => e.picked == true) >= 0){
                                _searchList[_searchList.indexWhere((e) => e.picked == true)].picked = false;
                              }
                              _searchList[index].picked = true;
                            });
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
                          color: currencies[index].picked  ? kColorScheme.primaryContainer : kColorScheme.background,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              if(currencies.indexWhere((e) => e.picked == true) >= 0){
                                currencies[currencies.indexWhere((e) => e.picked == true)].picked = false;
                              }
                              currencies[index].picked = true;
                            });
                          },
                          child: ListTile(
                            title: Text(currencies[index].name,),
                            trailing: Text(currencies[index].code),
                          ),
                        ),
                      ),
                      itemCount: isSearching ? _searchList.length :  currencies.length,
                    ),
                  ),
                  const SizedBox(height: 12,),
                  ElevatedButton (
                    onPressed: (){
                      if(isSearching){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => WelcomScreen3(currency: _searchList[_searchList.indexWhere((e) => e.picked == true)],)));
                      }
                      else{
                        Navigator.push(context, MaterialPageRoute(builder: (context) => WelcomScreen3(currency: currencies[currencies.indexWhere((e) => e.picked == true)],)));
                      }
                    },
                    child: const Text('Tiếp theo', style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.normal),),
                    
                  ),
                ],
            ),
          ),
        ),
      ),
    );
  }
}