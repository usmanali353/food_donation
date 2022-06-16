import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:food_donation/Models/userData.dart';
import 'package:food_donation/Ui/Admin/AdminDashboard.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Ui/Auth/SplashScreen.dart';
import 'Ui/Donor/DonorHome.dart';
import 'Ui/Receiver/ReceiverHome.dart';
import 'Utils/Locator.dart';

void main() async{
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
 await Firebase.initializeApp();
 SetupLocator();
 runApp(MyApp());
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
 // SystemChrome.setEnabledSystemUIOverlays([]);
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int role=0;
 void initState(){
    super.initState();
    setState(() {
      initialization();
      AutoLogin();
    });
  }

  void initialization() async {
    print('ready in 3...');
    await Future.delayed(const Duration(seconds: 1));
    print('ready in 2...');
    await Future.delayed(const Duration(seconds: 1));
    print('ready in 1...');
    await Future.delayed(const Duration(seconds: 1));
    print('go!');
    FlutterNativeSplash.remove();
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Food Donation',
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.green
      ),
      theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.green
      ),
      debugShowCheckedModeBanner: false,
      home: role==1?DonorHome():role==2?ReceiverHome():role==3?AdminDashboard():SplashScreen(),
    );
  }

  void AutoLogin(){

     SharedPreferences.getInstance().then((prefs){
       setState(() {
         print((prefs.getString("user_data")!=null&&UserData.userFromJson(prefs.getString("user_data")!).role==1).toString());
         if(prefs.getString("user_data")!=null&&UserData.userFromJson(prefs.getString("user_data")!).role==1){
           role= 1;
         }else if(prefs.getString("user_data")!=null&&UserData.userFromJson(prefs.getString("user_data")!).role==2){
           role= 2;
         }else if(prefs.getString("user_data")!=null&&UserData.userFromJson(prefs.getString("user_data")!).role==3){
           role= 3;
         }else{
           role=0;
         }
         log(role.toString());
       });
     });
  }
}
