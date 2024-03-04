import 'package:expenses_tracker_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SyncDataScreen extends StatefulWidget {
  const SyncDataScreen({super.key});

  @override
  State<SyncDataScreen> createState() => _SyncDataScreenState();
}

class _SyncDataScreenState extends State<SyncDataScreen>{
  // bool isStart = true;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle( SystemUiOverlayStyle(
         statusBarColor: kColorScheme.primary));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion(
        value: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Theme.of(context).primaryColor
        ),
        child: const SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                Text('Đang tải dữ liệu', style: TextStyle(color: Colors.black,fontSize: 16),)
              ],
            )
          ),
        ),
      ),
    );
  }
}
