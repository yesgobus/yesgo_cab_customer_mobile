import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:yesgo_cab_customer/screen/CAB/homeScreen/home_screen.dart';
import 'package:yesgo_cab_customer/screen/loginScreens/login_page.dart';

import 'utils/getStore/get_store.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Yesgo Cab',
      debugShowCheckedModeBanner: false,
      home: GetStoreData.getStore.read('access_token') == null
          ? LoginPage()
          : HomeScreen(),
      theme: ThemeData(useMaterial3: true),
    );
  }
}
