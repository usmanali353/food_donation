import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_donation/Models/userData.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Ui/Auth/SplashScreen.dart';
import 'Ui/Donor/DonorHome.dart';
import 'Ui/Receiver/ReceiverHome.dart';
import 'Utils/Locator.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
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
      AutoLogin();
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return GetMaterialApp(
      title: 'Flutter Demo',
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.green
      ),
      theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.green
      ),
      debugShowCheckedModeBanner: false,
      home: role==1?DonorHome():role==2?ReceiverHome():SplashScreen(),
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
         }else{
           role=0;
         }
         log(role.toString());
       });
     });
  }
}